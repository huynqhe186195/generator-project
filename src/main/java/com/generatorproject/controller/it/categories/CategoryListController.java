package com.generatorproject.controller.it.categories;

import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.model.Category;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/it/categories/list"})
public class CategoryListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("USERMODEL") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        CategoryDAO dao = new CategoryDAO();

        // Lấy keyword từ form filter
        String keyword = req.getParameter("keyword");
        List<Category> categories;

        if (keyword != null && !keyword.trim().isEmpty()) {
            categories = dao.filter(keyword.trim());   // dùng hàm filter bạn đã thêm
        } else {
            categories = dao.list(); // hoặc getAllCategories()
        }

        // Gửi dữ liệu sang JSP
        req.setAttribute("categories", categories);
        req.setAttribute("keyword", keyword);
        req.setAttribute("activeMenu", "categories");

        req.getRequestDispatcher("/views/it/categories/list.jsp")
                .forward(req, resp);
    }
}