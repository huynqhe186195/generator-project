package com.generatorproject.controller.web;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Brand;
import com.generatorproject.model.HomeStats;
import com.generatorproject.model.Product;
import com.generatorproject.model.Users;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
@WebServlet("/product-list")
public class ProductController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();
        request.setAttribute("products", dao.getAll());
        request.getRequestDispatcher("/views/home/product-list.jsp").forward(request, response);
    }
}
