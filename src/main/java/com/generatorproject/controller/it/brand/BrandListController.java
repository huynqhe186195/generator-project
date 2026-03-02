package com.generatorproject.controller.it.brand;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.model.Brand;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/it/brands")
public class BrandListController extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String q = trim(req.getParameter("q"));
        String sort = trim(req.getParameter("sort"));
        int page = parseInt(req.getParameter("page"), 1);
        int size = parseInt(req.getParameter("size"), 10);

        int total = brandDAO.countBrands(q);
        int totalPages = (int) Math.ceil(total / (double) size);
        if (totalPages <= 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Brand> brands = brandDAO.listBrands(q, page, size, sort);

        req.setAttribute("brands", brands);
        req.setAttribute("q", q);
        req.setAttribute("sort", sort);
        req.setAttribute("page", page);
        req.setAttribute("size", size);
        req.setAttribute("total", total);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/views/it/brand/list.jsp").forward(req, resp);
    }

    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}