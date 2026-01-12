package com.generatorproject.controller.admin.role;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Role;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/role-list")
public class RoleController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RoleDAO roleDAO = new RoleDAO();
        req.setAttribute("roles", roleDAO.getAll());

        req.getRequestDispatcher("/views/admin/role/Role-list.jsp")
                .forward(req, resp);
    }
}
