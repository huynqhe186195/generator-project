package com.generatorproject.controller.admin;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Role;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/role-list"})
public class RoleController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        if (!hasPermission(req, "ROLE_VIEW")) {
//            resp.sendRedirect("403.jsp");
//            return;
//        }
        RoleDAO roleDAO = new RoleDAO();
        List<Role> roles = roleDAO.getAll();
        req.setAttribute("roles", roles);
        req.getRequestDispatcher("/views/admin/Role-list.jsp")
                .forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
