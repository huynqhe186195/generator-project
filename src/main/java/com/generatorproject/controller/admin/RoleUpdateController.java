package com.generatorproject.controller.admin;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Role;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/role-update")
public class RoleUpdateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        RoleDAO dao = new RoleDAO();
        Role role = dao.getById(id);

        req.setAttribute("role", role);

        req.getRequestDispatcher("views/admin/Role-update.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        int status = Integer.parseInt(req.getParameter("status"));

        RoleDAO dao = new RoleDAO();
        dao.update(id, name, description, status);

        // sau khi update xong → quay về list
        resp.sendRedirect(req.getContextPath() + "/role-list");
    }
}

