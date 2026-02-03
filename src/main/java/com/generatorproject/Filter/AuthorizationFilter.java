package com.generatorproject.Filter;

import com.generatorproject.model.Users;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// 1. CẬP NHẬT URL PATTERNS: Phải bao gồm tất cả các prefix cần bảo vệ
@WebFilter(urlPatterns = {
        "/admin/*",
        "/manager/*",
        "/technical/*",
        "/staff/*",
        "/it/*"
})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        // 2. CHECK ĐĂNG NHẬP
        Users user = (Users) session.getAttribute("USERMODEL");
        if (user == null) {
            // Lưu lại trang user đang định vào để redirect lại sau khi login xong (Optional)
            resp.sendRedirect(req.getContextPath() + "/login?message=not_login");
            return;
        }

        String url = req.getRequestURI();
        String contextPath = req.getContextPath();
        int roleId = user.getRoleId();

        // --- PHÂN QUYỀN THEO TỪNG KHU VỰC ---

        // A. KHU VỰC ADMIN (Quản lý User, Cấu hình hệ thống)
        if (url.startsWith(contextPath + "/admin")) {
            // Role 1 (Admin) có quyền tối thượng
            if (roleId == 1) {
                chain.doFilter(request, response);
                return;
            }

            // Role 6 (IT) được vào quản lý nội dung/Giao diện (Catalog)
            // Giả sử đường dẫn IT làm việc là /admin/catalog hoặc /admin/products-model
            if (roleId == 6 && (url.contains("/catalog") || url.contains("/product-models"))) {
                chain.doFilter(request, response);
                return;
            }

            // Nếu không phải Admin (1) và không phải IT (6) đang vào đúng chỗ -> Chặn
            // (Đoạn check Permission USER_VIEW cũ của bạn giữ lại nếu muốn Admin con)
            boolean hasUserRight = user.hasPermission("USER_VIEW") || user.hasPermission("USER_MANAGE");
            if (!hasUserRight) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // B. KHU VỰC MANAGER (Hợp đồng, Báo cáo) -> QUAN TRỌNG CHO MODULE CONTRACT
        else if (url.startsWith(contextPath + "/manager")) {
            // Chỉ Role 2 (Manager) và Role 1 (Admin) được vào
            if (roleId != 2 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // C. KHU VỰC TECHNICAL (Bảo trì, Sửa chữa)
        else if (url.startsWith(contextPath + "/technical")) {
            // Chỉ Role 4 (Technical) và Admin được vào
            if (roleId != 4 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // D. KHU VỰC STAFF (CSKH, Máy của khách)
        else if (url.startsWith(contextPath + "/staff")) {
            // Chỉ Role 3 (Staff) và Admin/Manager được vào
            if (roleId != 3 && roleId != 2 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // E. KHU VỰC IT RIÊNG (Nếu bạn tách url /it/...)
        else if (url.startsWith(contextPath + "/it")) {
            if (roleId != 6 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // Nếu vượt qua tất cả các chốt chặn -> Cho đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}