package com.generatorproject.controller.it.brand;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.model.Brand;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.Normalizer;
import java.util.Locale;

@WebServlet("/it/brands/add")
public class BrandAddController extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String name = trim(req.getParameter("name"));
        String slug = trim(req.getParameter("slug"));
        String logoUrl = trim(req.getParameter("logoUrl"));
        String returnUrl = trim(req.getParameter("returnUrl"));

        if (returnUrl == null) returnUrl = req.getContextPath() + "/it/products/add";

        if (name == null) {
            resp.sendRedirect(returnUrl + "?brandError=NameRequired");
            return;
        }
        if (slug == null) slug = toSlug(name);

        Brand b = new Brand();
        b.setName(name);
        b.setSlug(slug);
        b.setLogoUrl(logoUrl);

        int newId = brandDAO.insert(b);
        if (newId <= 0) {
            resp.sendRedirect(returnUrl + "?brandError=InsertFailed");
            return;
        }

        resp.sendRedirect(returnUrl + "?brandAdded=1&brandId=" + newId);
    }

    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private String toSlug(String input) {
        String nowhitespace = input.trim().replaceAll("\\s+", "-");
        String normalized = Normalizer.normalize(nowhitespace, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9\\-]", "");
    }
}
