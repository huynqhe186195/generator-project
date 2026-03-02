package com.generatorproject.controller.it.categories;

import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.model.Category;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CategoryCreateController", urlPatterns = {"/it/categories/create"})
public class CategoryCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("USERMODEL") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        req.setAttribute("activeMenu", "categories");
        req.getRequestDispatcher("/views/it/categories/create.jsp").forward(req, resp);
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

        String name = req.getParameter("name");
        String n = (name == null) ? "" : name.trim();

        if (n.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập tên danh mục.");
            req.setAttribute("name", n);
            req.setAttribute("activeMenu", "categories");
            req.getRequestDispatcher("/views/it/categories/create.jsp").forward(req, resp);
            return;
        }

        CategoryDAO dao = new CategoryDAO();
        Category existed = dao.findByName(n);
        if (existed != null) {
            req.setAttribute("error", "Tên danh mục đã tồn tại.");
            req.setAttribute("name", n);
            req.setAttribute("activeMenu", "categories");
            req.getRequestDispatcher("/views/it/categories/create.jsp").forward(req, resp);
            return;
        }

        boolean ok = dao.insert(n);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/it/categories/list?msg=created");
        } else {
            req.setAttribute("error", "Không thể thêm danh mục. Vui lòng thử lại.");
            req.setAttribute("name", n);
            req.setAttribute("activeMenu", "categories");
            req.getRequestDispatcher("/views/it/categories/create.jsp").forward(req, resp);
        }
    }
}