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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/user/*"})
public class UserManagementController extends HttpServlet {

    private final IUserServices userServices;
    private final IRoleServices roleServices;

    public UserManagementController() {
        userServices = new UserServices();
        roleServices = new RoleServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        switch (path) {
            case "/user-list":
                handleUserList(resp, req);
                break;
            case "/user-detail":
                handleUserDetail(req, resp);
                break;
            case "/addNewUser":
                handleAddUser(req, resp);
                break;
            case "/updateUser":
                handleEditUser(req, resp);
                break;
            case "/approve-reset":
                handldeApproveReset(req, resp);
                break;
            case "/deleteUser":
                handleDeleteUser(req, resp);
                break;
        }
    }

    private void handleDeleteUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        Users actor = (Users) req.getSession().getAttribute("USERMODEL");
        try {
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                userServices.deleteUser(id, actor);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/user/user-list?message=delete_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user/user-list?message=error");
        }
    }

    private void handldeApproveReset(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Map<String, Object>> list = userServices.getPendingRequests();
        req.setAttribute("list", list);
        req.getRequestDispatcher("/views/admin/user/user-reset-password.jsp").forward(req, resp);
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
                    resp.sendRedirect(req.getContextPath() + "/admin/user/user-list");
                }
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/user/user-list");
        }
    }

    private void handleUserList(HttpServletResponse resp, HttpServletRequest req) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String roleParam = req.getParameter("role");
        String statusParam = req.getParameter("status");

        Integer roleId = (roleParam != null && !roleParam.isEmpty()) ? Integer.parseInt(roleParam) : null;
        Integer status = (statusParam != null && !statusParam.isEmpty()) ? Integer.parseInt(statusParam) : null;

        int page = 1;
        int pageSize = 5;

        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1; // Nếu nhập bậy bạ thì về trang 1
            }
        }


        int totalUsers = userServices.countUsersByFilter(keyword, roleId, status);

        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        List<Users> listUsers = userServices.getUsersByFilter(keyword, roleId, status, page, pageSize);

        req.setAttribute("listUsers", listUsers);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);

        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-list.jsp");
        rd.forward(req, resp);
    }

    private void handleUserDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Users currentUser = (Users) session.getAttribute("USERMODEL");

        try {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/user/user-list");
                return;
            }

            int id = Integer.parseInt(idParam);

            Users user = userServices.findUserById(id);
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/user/user-list?message=not_found");
                return;
            }

            boolean canDelete = false;
            if (currentUser != null) {
                boolean hasPermission = (currentUser.getRoleId() == 1 || currentUser.hasPermission("USER_MANAGE"));
                boolean targetIsAdmin = user.getRoleId() == 1;
                boolean targetIsSelf  = user.getId() == currentUser.getId();

                canDelete = hasPermission && !targetIsAdmin && !targetIsSelf;
            }

            req.setAttribute("user", user);
            req.setAttribute("canDelete", canDelete);

            req.getRequestDispatcher("/views/admin/user/user-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user/user-list?message=error");
        }
    }


    private void handleAddUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Role> listRoles = roleServices.getAllRoles();
        req.setAttribute("listRoles", listRoles);
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-add.jsp");
        rd.forward(req, resp);
    }
}
