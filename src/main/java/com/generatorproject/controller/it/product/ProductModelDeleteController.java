package com.generatorproject.controller.it.product;

import com.generatorproject.dao.ProductModelDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/it/products/delete")
public class ProductModelDeleteController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                productModelDAO.deleteById(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // quay về list
        resp.sendRedirect(req.getContextPath() + "/it/products");
    }
}
