package com.generatorproject.controller.admin.user;

import com.generatorproject.model.Role;
import com.generatorproject.model.Users;
import com.generatorproject.services.IRoleServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.RoleServices;
import com.generatorproject.services.UserServices;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/user-list", "/admin/user-list/user-detail", "/admin/user-list/addNewUser", "/admin/user-list/updateUser"})
public class UserManagementController extends HttpServlet {

    private final IUserServices userServices;
    private final IRoleServices roleServices;

    public UserManagementController() {
        userServices = new UserServices();
        roleServices = new RoleServices();
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
            case "/admin/user-list/addNewUser":
                handleAddUser(req, resp);
                break;
            case "/admin/user-list/updateUser":
                handleEditUser(req, resp);
                break;
        }
    }

    private void handleEditUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Role> listRoles = roleServices.getAllRoles();
        req.setAttribute("listRoles", listRoles);
        try {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                Users user = userServices.findUserById(id);
                if (user != null) {
                    req.setAttribute("user", user);
                    RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-edit.jsp");
                    rd.forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/user-list");
                }
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/user-list");
        }
    }

    private void handleUserList(HttpServletResponse resp, HttpServletRequest req) throws ServletException, IOException {
        req.setAttribute("listUsers", userServices.getAllUsers());
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-list.jsp");
        rd.forward(req, resp);
    }

    private void handleUserDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                Users user = userServices.findUserById(id);
                if (user != null) {
                    req.setAttribute("user", user);
                    RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-detail.jsp");
                    rd.forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/user-list");
                }
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/user-list");
        }
    }

    private void handleAddUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Role> listRoles = roleServices.getAllRoles();
        req.setAttribute("listRoles", listRoles);
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-add.jsp");
        rd.forward(req, resp);
    }
}
