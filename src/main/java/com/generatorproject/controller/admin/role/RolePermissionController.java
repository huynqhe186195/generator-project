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
            // 1. Lấy ID của Role cần phân quyền
            String idStr = req.getParameter("id");
            if (idStr == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/role");
                return;
            }
            int roleId = Integer.parseInt(idStr);

            // 2. Lấy thông tin Role (để hiện tên lên tiêu đề)
            Role role = roleDAO.getById(roleId);

            // 3. Lấy TẤT CẢ quyền trong hệ thống (để vẽ checkbox)
            List<Permission> allPermissions = roleDAO.getAllSystemPermissions();

            // 4. Lấy danh sách ID quyền MÀ ROLE ĐANG CÓ (để tích sẵn)
            List<Integer> currentPermIds = roleDAO.getPermissionIdsByRole(roleId);

            // 5. Đẩy sang JSP
            req.setAttribute("role", role);
            req.setAttribute("allPermissions", allPermissions);
            req.setAttribute("currentPermIds", currentPermIds); // List<Integer>

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

            // 1. Lấy Role ID
            int roleId = Integer.parseInt(req.getParameter("roleId"));

            // 2. Lấy danh sách các ô checkbox ĐƯỢC TÍCH
            // (Nếu không tích ô nào thì biến này sẽ null)
            String[] selectedPermIds = req.getParameterValues("permissionIds");

            // 3. Gọi DAO để update (Xóa cũ -> Thêm mới)
            roleDAO.updateRolePermissions(roleId, selectedPermIds);

            // 4. Thành công -> Quay về danh sách Role
            resp.sendRedirect(req.getContextPath() + "/admin/role?mess=update_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/role?mess=error");
        }
    }
}