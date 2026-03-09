package com.generatorproject.controller.web;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
import com.generatorproject.model.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductShowcaseController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String keyword = trim(req.getParameter("keyword"));
        Integer brandId = parseIntOrNull(req.getParameter("brandId"));
        Integer categoryId = parseIntOrNull(req.getParameter("categoryId"));
        String fuelType = trim(req.getParameter("fuelType"));

        Integer powerMin = parseIntOrNull(req.getParameter("powerMin"));
        Integer powerMax = parseIntOrNull(req.getParameter("powerMax"));

        if (powerMin != null && powerMax != null && powerMin > powerMax) {
            int temp = powerMin;
            powerMin = powerMax;
            powerMax = temp;
        }

        String status = "ACTIVE";

        int pageSize = 9;
        int page = parseIntOrDefault(req.getParameter("page"), 1);
        if (page < 1) page = 1;

        int offset = (page - 1) * pageSize;

        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        int totalItems = productModelDAO.countFilteredProductModels(
                brandId, categoryId, fuelType, powerMin, powerMax, status, keyword
        );

        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        if (page > totalPages) {
            page = totalPages;
            offset = (page - 1) * pageSize;
        }

        List<ProductModel> listModels = productModelDAO.filterProductModelsPaged(
                brandId, categoryId, fuelType, powerMin, powerMax, status, keyword, pageSize, offset
        );

        req.setAttribute("listModels", listModels);
        req.setAttribute("brands", brands);
        req.setAttribute("categories", categories);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalItems", totalItems);

        req.getRequestDispatcher("/views/home/list.jsp").forward(req, resp);
    }

    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }
}