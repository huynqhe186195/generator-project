package com.generatorproject.controller.admin.product;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = "/admin/product/*")
public class ProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo(); // /product-list

        if (path == null || "/".equals(path) || "/product-list".equals(path)) {

            // ===== FILTER PARAMS =====
            String q = trim(req.getParameter("q"));
            String fuel = trim(req.getParameter("fuel"));
            Integer brandId = parseIntNullable(req.getParameter("brandId"));
            Double minKva = parseDoubleNullable(req.getParameter("minKva"));
            Double maxKva = parseDoubleNullable(req.getParameter("maxKva"));

            // ===== PAGINATION =====
            int page = parseInt(req.getParameter("page"), 1);
            int pageSize = 10;
            if (page < 1) page = 1;

            int offset = (page - 1) * pageSize;

            // ===== COUNT =====
            int totalItems = productDAO.countFilteredProductsAdmin(
                    brandId, minKva, maxKva, fuel, q
            );
            int totalPages = (int) Math.ceil(totalItems * 1.0 / pageSize);

            if (totalPages > 0 && page > totalPages) {
                page = totalPages;
                offset = (page - 1) * pageSize;
            }

            // ===== LIST =====
            List<Product> products = productDAO.filterProductsPagedAdmin(
                    brandId, minKva, maxKva, fuel, q, pageSize, offset
            );

            // ===== DROPDOWN DATA =====
            req.setAttribute("brands", brandDAO.getAllBrands());
            req.setAttribute("fuels", productDAO.getAllFuelTypes());

            // ===== JSP ATTR =====
            req.setAttribute("products", products);
            req.setAttribute("page", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("/views/admin/Product/product-list.jsp")
                    .forward(req, resp);
            return;
        }

        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }

    private int parseInt(String v, int def) {
        try {
            if (v == null || v.trim().isEmpty()) return def;
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private Integer parseIntNullable(String v) {
        try {
            if (v == null || v.trim().isEmpty()) return null;
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDoubleNullable(String v) {
        try {
            if (v == null || v.trim().isEmpty()) return null;
            return Double.parseDouble(v.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
