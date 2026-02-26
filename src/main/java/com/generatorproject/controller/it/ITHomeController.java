package com.generatorproject.controller.it;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/it", "/it/home"})
public class ITHomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Users user = (session != null)
                ? (Users) session.getAttribute("USERMODEL")
                : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        // product = product_models
        int totalProducts = 0;
        int totalCategories = 0;
        int totalBrands = 0;

        try {
            totalProducts = new ProductModelDAO().countAll();      // COUNT(*) FROM product_models
            totalCategories = new CategoryDAO().countCategories(); // COUNT(*) FROM categories
            totalBrands = new BrandDAO().countBrands();            // COUNT(*) FROM brands
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalCategories", totalCategories);
        req.setAttribute("totalBrands", totalBrands);

        req.getRequestDispatcher("/views/it/home.jsp").forward(req, resp);
    }
}