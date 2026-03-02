package com.generatorproject.controller.it.brand;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.model.Brand;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/it/brands/detail")
public class BrandDetailController extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        int id = parseInt(req.getParameter("id"), -1);
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=invalid_id");
            return;
        }

        var brand = brandDAO.findById(id);
        if (brand == null) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=not_found");
            return;
        }

        req.setAttribute("brand", brand);
        req.getRequestDispatcher("/views/it/brand/detail.jsp").forward(req, resp);
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}