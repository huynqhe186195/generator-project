package com.generatorproject.controller.admin.role;

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

@WebServlet(urlPatterns = {"/admin/*"})
public class RoleManagementController extends HttpServlet {

    private final IRoleServices roleServices;

    public RoleManagementController() {
        roleServices = new RoleServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();

        String path = requestURI.substring(contextPath.length());
        switch (path) {
            case "/admin/role-list":
                handleRoleList(req, resp);
                break;
            case "/admin/role-create":
                handleRoleAdd(req, resp);
                break;
            case "/admin/role-update":
                hanldEditRole(req, resp);
                break;
            case "/admin/role-delete":
                handleDeleteRole(req, resp);
                break;
            case "/admin/role-toggle":
                handleToggleRole(req, resp);
                break;
            case "/admin/role-permission":
                handlePermissonRole(req, resp);
                break;
            case "/admin/role-detail":
                handleRoleDetail(req, resp);
                break;
        }
    }

    private void handleRoleDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int id = Integer.parseInt(req.getParameter("id"));

        req.setAttribute("role", roleServices.getById(id));

        req.getRequestDispatcher("/views/admin/role/role-detail.jsp")
                .forward(req, resp);
    }

    private void handleRoleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("roles", roleServices.getAllRoles());
        req.getRequestDispatcher("/views/admin/role/Role-list.jsp")
                .forward(req, resp);
    }

    private void handleRoleAdd(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        req.getRequestDispatcher("/views/admin/role/Role-create.jsp")
                .forward(req, resp);
    }

    private void hanldEditRole(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

    private void handleDeleteRole(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));

        roleServices.deleteRoleById(id);
        resp.sendRedirect(req.getContextPath() + "/admin/role-list");
    }

    private void handleToggleRole(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));

        roleServices.toggleStatus(id);

        resp.sendRedirect(req.getContextPath() + "/admin/role-list");
    }

    private void handlePermissonRole(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/role");
                return;
            }
            int roleId = Integer.parseInt(idStr);

            Role role = roleServices.getById(roleId);

            List<Permission> allPermissions = roleServices.getAllSystemPermissions();

            List<Integer> currentPermIds = roleServices.getPermissionIdsByRole(roleId);

            req.setAttribute("role", role);
            req.setAttribute("allPermissions", allPermissions);
            req.setAttribute("currentPermIds", currentPermIds);

            req.getRequestDispatcher("/views/admin/role/role-permission.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role?mess=error");
        }
    }
}

