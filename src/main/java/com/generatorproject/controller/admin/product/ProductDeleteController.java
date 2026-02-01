package com.generatorproject.controller.admin.product;

import com.generatorproject.dao.ProductDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = "/admin/product-delete")
public class ProductDeleteController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer id = parseIntNullable(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/product-list");
            return;
        }

        // nếu muốn check tồn tại trước khi xóa thì mở dòng dưới
        // if (productDAO.findByIdAdmin(id) == null) { resp.sendError(404); return; }

        productDAO.deleteById(id);

        resp.sendRedirect(req.getContextPath() + "/admin/product/product-list");
    }

    private Integer parseIntNullable(String v) {
        try {
            if (v == null || v.trim().isEmpty()) return null;
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
