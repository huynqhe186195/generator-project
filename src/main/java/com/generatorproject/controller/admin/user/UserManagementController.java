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

        try {
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                userServices.deleteUser(id);
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
        req.setAttribute("listUsers", userServices.getAllUsers());
        int page = 1;
        int pageSize = 5;

        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;// nếu nhập bậy bạ cook về trang 1
            }
        }

        int totalUsers = userServices.getTotalUsers();
        // 11 user / 5 = 2.2 -> Lên thành 3 trang
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        List<Users> listUsers = userServices.getUsersPaging(page, pageSize);

        req.setAttribute("listUsers", listUsers);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);

        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-list.jsp");
        rd.forward(req, resp);
    }

    private void handleUserDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Users currentUser = (Users) session.getAttribute("USERMODEL");

        boolean canDelete = false;
        if (currentUser != null) {
            if (currentUser.getRoleId() == 1 || currentUser.hasPermission("USER_MANAGE")) {
                canDelete = true;
            }
        }

        req.setAttribute("canDelete", canDelete);
        try {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                Users user = userServices.findUserById(id);
                if (user != null) {
                    req.setAttribute("user", user);
                    RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-detail.jsp");
                    rd.forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/user-list");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user/user-list");
        }
    }

    private void handleAddUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Role> listRoles = roleServices.getAllRoles();
        req.setAttribute("listRoles", listRoles);
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-add.jsp");
        rd.forward(req, resp);
    }
}
