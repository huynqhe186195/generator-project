package com.generatorproject.controller.admin.role;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Permission;
import com.generatorproject.model.Role;
import com.generatorproject.services.IRoleServices;
import com.generatorproject.services.RoleServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/hanldePermissonRole"})
public class RolePermissionController extends HttpServlet {

    private final IRoleServices roleServices;

    public RolePermissionController() {
        roleServices = new RoleServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setCharacterEncoding("UTF-8");

            int roleId = Integer.parseInt(req.getParameter("roleId"));

            String[] selectedPermIds = req.getParameterValues("permissionIds");

            roleServices.updateRolePermissions(roleId, selectedPermIds);

            resp.sendRedirect(req.getContextPath() + "/admin/role/role-list?mess=update_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role/role-list?mess=error");
        }
    }
}