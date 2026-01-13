package com.generatorproject.controller.admin.role;

import com.generatorproject.model.Role;
import com.generatorproject.services.IRoleServices;
import com.generatorproject.services.RoleServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/role-update")
public class RoleUpdateController extends HttpServlet {
    private final IRoleServices roleServices;

    public RoleUpdateController() {
        roleServices = new RoleServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        try {
            String idStr = req.getParameter("id");

            if (idStr == null || idStr.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/role-list");
                return;
            }

            int id = Integer.parseInt(idStr);

            Role role = roleServices.getRoleById(id);

            req.setAttribute("role", role);

            req.getRequestDispatcher("/views/admin/role/Role-update.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            String redirectUrl = req.getParameter("redirectUrl");
            int status = Integer.parseInt(req.getParameter("status"));

            Role roleToUpdate = new Role.Builder()
                    .id(id)
                    .name(name)
                    .description(description)
                    .redirectUrl(redirectUrl)
                    .status(status)
                    .build();


            boolean isSuccess = roleServices.updateRole(roleToUpdate);

            if (isSuccess) {
                resp.sendRedirect(req.getContextPath() + "/admin/role-list");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/role-list?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role-list?msg=exception");
        }
    }
}