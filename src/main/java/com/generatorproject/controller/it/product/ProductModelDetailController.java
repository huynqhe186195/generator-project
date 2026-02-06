package com.generatorproject.controller.it.product;

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

@WebServlet("/it/products/detail")
public class ProductModelDetailController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductImageDAO productImageDAO = new ProductImageDAO(); // ✅ thêm

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Integer id = parseIntOrNull(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/it/products");
            return;
        }

        ProductModel pm = productModelDAO.findById(id);
        if (pm == null) {
            resp.sendRedirect(req.getContextPath() + "/it/products");
            return;
        }

        // ✅ lấy list ảnh từ product_images (DAO của bạn đang dùng findByModelId)
        List<ProductImageItem> images = productImageDAO.findByModelId(id);

        // ✅ convert sang List<String> để JSP detail dùng imageUrls
        List<String> imageUrls = new ArrayList<>();
        if (images != null) {
            for (ProductImageItem it : images) {
                if (it != null && it.getImageUrl() != null) {
                    imageUrls.add(it.getImageUrl());
                }
            }
        }

        // lookup brand/category name
        String brandName = "";
        String categoryName = "";
        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        for (Brand b : brands) {
            if (b.getId() == pm.getBrandId()) { brandName = b.getName(); break; }
        }
        for (Category c : categories) {
            if (c.getId() == pm.getCategoryId()) { categoryName = c.getName(); break; }
        }

        req.setAttribute("pm", pm);
        req.setAttribute("brandName", brandName);
        req.setAttribute("categoryName", categoryName);

        // ✅ truyền gallery sang JSP
        req.setAttribute("imageUrls", imageUrls);

        req.getRequestDispatcher("/views/it/product/detail.jsp").forward(req, resp);
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
