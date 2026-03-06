package com.generatorproject.controller.web;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductImageDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
import com.generatorproject.model.ProductImageItem;
import com.generatorproject.model.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/products/detail")
public class ProductDetailController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductImageDAO productImageDAO = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Integer id = parseIntOrNull(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        ProductModel pm = productModelDAO.findById(id);
        if (pm == null) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        if (pm.getStatus() == null || !"ACTIVE".equalsIgnoreCase(pm.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        String ctx = req.getContextPath();

        List<ProductImageItem> images = productImageDAO.findByModelId(id);
        List<String> imageUrls = new ArrayList<>();

        if (images != null) {
            for (ProductImageItem item : images) {
                if (item != null && item.getImageUrl() != null && !item.getImageUrl().trim().isEmpty()) {
                    imageUrls.add(buildImageUrl(item.getImageUrl(), ctx));
                }
            }
        }

        String mainImage = null;

        if (!imageUrls.isEmpty()) {
            mainImage = imageUrls.get(0);
        } else if (pm.getImageUrl() != null && !pm.getImageUrl().trim().isEmpty()) {
            mainImage = buildImageUrl(pm.getImageUrl(), ctx);
        } else {
            mainImage = ctx + "/template/images/img.png";
        }

        String brandName = "";
        String categoryName = "";

        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        for (Brand b : brands) {
            if (b.getId() == pm.getBrandId()) {
                brandName = b.getName();
                break;
            }
        }

        for (Category c : categories) {
            if (c.getId() == pm.getCategoryId()) {
                categoryName = c.getName();
                break;
            }
        }

        req.setAttribute("pm", pm);
        req.setAttribute("brandName", brandName);
        req.setAttribute("categoryName", categoryName);
        req.setAttribute("mainImage", mainImage);
        req.setAttribute("imageUrls", imageUrls);

        req.getRequestDispatcher("/views/home/product-detail.jsp").forward(req, resp);
    }

    private String buildImageUrl(String rawUrl, String contextPath) {
        if (rawUrl == null) return "";

        String url = rawUrl.trim();
        if (url.isEmpty()) return "";

        // ảnh ngoài
        if (url.startsWith("http://") || url.startsWith("https://")) {
            return url;
        }

        // nếu thiếu dấu /
        if (!url.startsWith("/")) {
            url = "/" + url;
        }

        // đã có contextPath rồi thì giữ nguyên
        if (!contextPath.isEmpty() && url.startsWith(contextPath + "/")) {
            return url;
        }

        return contextPath + url;
    }

    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }
}