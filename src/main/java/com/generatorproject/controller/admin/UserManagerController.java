package com.generatorproject.controller.admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// 1. Định nghĩa đường dẫn URL mà JSP đang gọi
@WebServlet(urlPatterns = {"/User-manager"})
public class UserManagerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // (Tùy chọn) Gọi DB lấy danh sách user
        // List<User> list = dao.getAllUsers();
        // req.setAttribute("listUsers", list);

        // 2. Forward về JSP
        req.getRequestDispatcher("/views/Admin/User-manager.jsp")
                .forward(req, resp);
    }
}
