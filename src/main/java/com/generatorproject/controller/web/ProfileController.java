package com.generatorproject.controller.web;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("fullName", "Nguyễn Quang Huy");
        req.setAttribute("username", "admin_huy");
        req.setAttribute("email", "huy@fpt.edu.vn");
        req.setAttribute("phone", "0987.654.321");
        req.setAttribute("role", "Quản trị viên (Admin)");
        req.setAttribute("department", "Kỹ thuật vận hành");
        req.setAttribute("joinDate", "01/01/2026");

        RequestDispatcher rd = req.getRequestDispatcher("/views/Account/profile.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}