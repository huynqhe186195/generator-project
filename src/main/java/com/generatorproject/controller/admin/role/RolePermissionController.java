package com.generatorproject.controller.admin.role;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Permission;
import com.generatorproject.model.Role;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/role-permission"})
public class RolePermissionController extends HttpServlet {

    private RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/role");
                return;
            }
            int roleId = Integer.parseInt(idStr);

            Role role = roleDAO.getById(roleId);

            List<Permission> allPermissions = roleDAO.getAllSystemPermissions();

            List<Integer> currentPermIds = roleDAO.getPermissionIdsByRole(roleId);

            req.setAttribute("role", role);
            req.setAttribute("allPermissions", allPermissions);
            req.setAttribute("currentPermIds", currentPermIds);

            req.getRequestDispatcher("/views/admin/role/role-permission.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role?mess=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setCharacterEncoding("UTF-8");

            int roleId = Integer.parseInt(req.getParameter("roleId"));

            String[] selectedPermIds = req.getParameterValues("permissionIds");

            roleDAO.updateRolePermissions(roleId, selectedPermIds);

            resp.sendRedirect(req.getContextPath() + "/admin/role-list?mess=update_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role-list?mess=error");
        }
    }
}