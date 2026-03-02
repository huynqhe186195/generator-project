package com.generatorproject.controller.it.categories;

import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.model.Category;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/it/categories/edit"})
public class CategoryEditController extends HttpServlet {

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

        req.setAttribute("category", category);
        req.setAttribute("activeMenu", "categories");
        req.getRequestDispatcher("/views/it/categories/edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("USERMODEL") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=invalid_id");
            return;
        }

        String name = req.getParameter("name");
        String n = (name == null) ? "" : name.trim();

        CategoryDAO dao = new CategoryDAO();
        Category category = dao.findById(id);
        if (category == null) {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=not_found");
            return;
        }

        // validate rỗng
        if (n.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập tên danh mục.");
            category.setName(n);
            req.setAttribute("category", category);
            req.setAttribute("activeMenu", "categories");
            req.getRequestDispatcher("/views/it/categories/edit.jsp").forward(req, resp);
            return;
        }

        // validate trùng tên (loại trừ chính nó)
        Category existed = dao.findByNameExceptId(n, id);
        if (existed != null) {
            req.setAttribute("error", "Tên danh mục đã tồn tại.");
            category.setName(n);
            req.setAttribute("category", category);
            req.setAttribute("activeMenu", "categories");
            req.getRequestDispatcher("/views/it/categories/edit.jsp").forward(req, resp);
            return;
        }

        boolean ok = dao.update(id, n);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=updated");
        } else {
            req.setAttribute("error", "Không thể cập nhật danh mục. Vui lòng thử lại.");
            category.setName(n);
            req.setAttribute("category", category);
            req.setAttribute("activeMenu", "categories");
            req.getRequestDispatcher("/views/it/categories/edit.jsp").forward(req, resp);
        }
    }
}