package com.generatorproject.controller.admin;

import com.generatorproject.dao.RoleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/role-toggle")
public class RoleToggleController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int roleId = Integer.parseInt(req.getParameter("id"));

        RoleDAO roleDAO = new RoleDAO();
        roleDAO.toggleStatus(roleId);

        resp.sendRedirect(req.getContextPath() + "/role-list");
    }
}

