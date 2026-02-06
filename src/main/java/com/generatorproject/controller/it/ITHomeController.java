package com.generatorproject.controller.it;

import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/it", "/it/home"})
public class ITHomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Users user = (session != null)
                ? (Users) session.getAttribute("USERMODEL")
                : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        // Load dữ liệu dashboard (nếu có)
        req.setAttribute("totalProducts", 0);
        req.setAttribute("totalCategories", 0);
        req.setAttribute("totalUsers", 0);

        // Forward tới trang IT Home
        req.getRequestDispatcher("/views/it/home.jsp").forward(req, resp);
    }
}
