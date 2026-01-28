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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("USERMODEL");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ✅ customerId: nếu hệ bạn customer = user
        int customerId = user.getId();
        // Nếu có field riêng: int customerId = user.getCustomerId();

        // ✅ đọc query params filter
        Integer brandId = parseIntOrNull(request.getParameter("brandId"));
        Double minPower = parseDoubleOrNull(request.getParameter("minPower"));
        Double maxPower = parseDoubleOrNull(request.getParameter("maxPower"));
        String fuelType = trimToNull(request.getParameter("fuelType"));
        String keyword = trimToNull(request.getParameter("keyword"));

        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.filterProducts(customerId, brandId, minPower, maxPower, fuelType, keyword);

        // ✅ brands cho dropdown
        BrandDAO brandDAO = new BrandDAO();
        List<Brand> brands = brandDAO.getAllBrands(); // hoặc brandDAO.getAll()

        // ✅ set data
        request.setAttribute("products", products);
        request.setAttribute("brands", brands);

        // ✅ giữ lại giá trị filter trên UI
        request.setAttribute("brandId", brandId);
        request.setAttribute("minPower", minPower);
        request.setAttribute("maxPower", maxPower);
        request.setAttribute("fuelType", fuelType);
        request.setAttribute("keyword", keyword);

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
}
