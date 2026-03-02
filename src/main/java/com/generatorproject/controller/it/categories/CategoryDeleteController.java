package com.generatorproject.controller.it.categories;

import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.model.Category;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/it/categories/delete"})
public class CategoryDeleteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("USERMODEL") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=invalid_id");
            return;
        }

        CategoryDAO dao = new CategoryDAO();

        Category category = dao.findById(id);
        if (category == null) {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=not_found");
            return;
        }

        // Check đang được dùng bởi product_models
        int usedCount = dao.countProductModelsUsingCategory(id);
        if (usedCount > 0) {
            resp.sendRedirect(req.getContextPath()
                    + "/it/categories/list?msg=cannot_delete&used=" + usedCount);
            return;
        }

        boolean ok = dao.delete(id);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=delete_error");
        }
    }

    // (tuỳ chọn) cho phép delete bằng POST cho đúng REST hơn
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}