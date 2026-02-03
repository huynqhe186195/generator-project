package com.generatorproject.controller.web;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/product-list")
public class ProductController extends HttpServlet {

    private static final int PAGE_SIZE = 10; // số sản phẩm mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("USERMODEL");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        long customerId = user.getId();

        Integer brandId = parseIntOrNull(request.getParameter("brandId"));
        String keyword = trimToNull(request.getParameter("keyword"));

        int page = parsePositiveInt(request.getParameter("page"), 1);

        ProductDAO productDAO = new ProductDAO();

        int totalRecords = productDAO.countFilteredProducts(customerId, brandId, keyword);

        int totalPages = (int) Math.ceil(totalRecords / (double) PAGE_SIZE);
        if (totalPages <= 0) totalPages = 1;

        if (page > totalPages) page = totalPages;
        if (page < 1) page = 1;

        int offset = (page - 1) * PAGE_SIZE;

        List<Product> products = productDAO.filterProductsPaged(
                customerId, brandId, keyword,
                PAGE_SIZE, offset
        );

        BrandDAO brandDAO = new BrandDAO();
        List<Brand> brands = brandDAO.getAllBrands();

        request.setAttribute("products", products);
        request.setAttribute("brands", brands);

        request.setAttribute("brandId", brandId);
        request.setAttribute("keyword", keyword);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/views/home/product-list.jsp").forward(request, response);
    }


    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDoubleOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Double.parseDouble(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private int parsePositiveInt(String s, int defaultValue) {
        try {
            if (s == null || s.trim().isEmpty()) return defaultValue;
            int v = Integer.parseInt(s.trim());
            return v <= 0 ? defaultValue : v;
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
