package com.generatorproject.controller.admin.role;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Role;
import com.generatorproject.services.IRoleServices;
import com.generatorproject.services.RoleServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/role-create")
public class RoleCreateController extends HttpServlet {

    private final IRoleServices roleServices;

    public RoleCreateController() {
        roleServices = new RoleServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        req.getRequestDispatcher("/views/admin/role/Role-create.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            String redirectUrl = req.getParameter("redirectUrl");

            String statusStr = req.getParameter("status");
            int status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : 1;

            Role newRole = new Role.Builder()
                    .name(name)
                    .description(description)
                    .redirectUrl(redirectUrl)
                    .status(status)
                    .build();

            boolean isSuccess = roleServices.createRole(newRole);

            if (isSuccess) {
                resp.sendRedirect(req.getContextPath() + "/admin/role-list");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/role-create?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role-create?msg=exception");
        }
    }
}