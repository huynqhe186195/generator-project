package com.generatorproject.Filter;

import com.generatorproject.model.Users;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Chặn tất cả request vào thư mục /admin/
@WebFilter(urlPatterns = { "/admin/*" })
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo nếu cần (thường để trống)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        Users user = (Users) session.getAttribute("USERMODEL");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=not_login");
            return;
        }

        // check admin
        if (user.getRoleId() == 1) {
            chain.doFilter(request, response);
            return;
        }

        // permission detail
        String path = req.getServletPath();
        boolean isAllowed = false; // Mặc định là CHẶN

        if (path.equals("/admin/dashboard") || path.equals("/admin/home")) {
            isAllowed = true;
        }

        // --- NHÓM 2: QUẢN LÝ USER ---

        // 1. ƯU TIÊN CAO NHẤT: Check hành động Thêm/Sửa/Xóa trước
        // (Phải đặt lên đầu để chặn ngay nếu URL chứa các từ khóa này)
        if (path.contains("/addNewUser") || path.contains("/updateUser") || path.contains("/user-delete")) {

            // Nếu user CÓ quyền MANAGE -> Thì CHO PHÉP (isAllowed = true)
            // Code cũ của bạn đang để là false (sai logic)
            if (user.hasPermission("USER_MANAGE")) {
                isAllowed = true;
            }
        }

        else if (path.contains("/user-list") || path.contains("/user-view")) {

            if (user.hasPermission("USER_VIEW")) {
                isAllowed = true;
            }
        }

        else if (path.contains("/role-")) {
            if (user.hasPermission("ROLE_MANAGE"))
                isAllowed = true;
        }

        else if (path.contains("/asset-list")) {
            if (user.hasPermission("ASSET_VIEW"))
                isAllowed = true;
        } else if (path.contains("/asset-create") || path.contains("/asset-update") || path.contains("/asset-delete")) {
            if (user.hasPermission("ASSET_MANAGE"))
                isAllowed = true;
        }

        else if (path.contains("/report")) {
            if (user.hasPermission("REPORT_VIEW"))
                isAllowed = true;
        }

        if (isAllowed) {
            // Có quyền thì cho đi tiếp
            chain.doFilter(request, response);
        } else {
            // Không có quyền cook về trang thông báo lỗi 403
            resp.sendRedirect(req.getContextPath() + "/views/error/403.jsp");
        }
    }

    @Override
    public void destroy() {
    }
}