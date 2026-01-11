package com.generatorproject.controller.admin;

import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/user-list", "/admin/user-list/user-detail", "/admin/user-list/user-add"})
public class UserController extends HttpServlet {

    private IUserServices userServices;

    public UserController() {
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/admin/user-list":
                handleUserList(resp, req);
                break;
            case "/admin/user-list/user-detail":
                handleUserDetail(req, resp);
                break;
            case "/admin/user-list/user-add":
                handleAddUser(req, resp);
                break;
        }
    }

    private void handleUserList(HttpServletResponse resp, HttpServletRequest req) throws ServletException, IOException {
        req.setAttribute("listUsers", userServices.getAllUsers());
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-list.jsp");
        rd.forward(req, resp);
    }

    private void handleUserDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-detail.jsp");
        rd.forward(req, resp);
    }

    private void handleAddUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-add.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
