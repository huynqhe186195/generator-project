package com.generatorproject.Filter;

import com.generatorproject.model.Users;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Dấu /* nghĩa là chặn tất cả file con bên trong
@WebFilter(urlPatterns = { "/admin/*", "/manager/*", "/staff/*", "/technician/*", "/views/admin/*" })
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        // 1. Lấy User từ Session
        // Lưu ý: Key "USERMODEL" phải khớp với bên LoginController
        Users user = (Users) session.getAttribute("USERMODEL");

        // 2. Kiểm tra Đăng nhập: Chưa đăng nhập -> Đuổi về Login
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=not_login");
            return;
        }

        // 3. Phân quyền (Logic cốt lõi)
        String url = req.getRequestURI();
        String contextPath = req.getContextPath(); // /GeneratorCMS

        // --- RULE 1: CHẶN TRANG ADMIN ---
        if (url.startsWith(contextPath + "/admin")) {
            // Admin (Role ID 1) HOẶC có quyền truy cập Admin
            if (user.getRoleId() != 1 && !user.hasPermission("ADMIN_ACCESS")) {
                resp.sendRedirect(contextPath + "/login?message=no_permission");
                return;
            }
        }

        // --- RULE 2: CHẶN TRANG MANAGER ---
        if (url.startsWith(contextPath + "/manager")) {
            // Phải là Manager (Role 2) hoặc Admin (Role 1)
            // Hoặc kiểm tra quyền cụ thể: REPORT_VIEW
            if (user.getRoleId() != 2 && user.getRoleId() != 1 && !user.hasPermission("REPORT_VIEW")) {
                resp.sendRedirect(contextPath + "/login?message=no_permission");
                return;
            }
        }

        // --- RULE 3: CHẶN TRANG TECHNICIAN ---
        if (url.startsWith(contextPath + "/technician")) {
            // Phải có quyền Sửa chữa hoặc Quản lý kho
            if (!user.hasPermission("ASSET_MAINTAIN") && !user.hasPermission("INVENTORY_MANAGE")) {
                resp.sendRedirect(contextPath + "/login?message=no_permission");
                return;
            }
        }

        // Nếu qua được hết các chốt chặn -> Cho đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}