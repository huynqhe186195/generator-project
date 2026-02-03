package com.generatorproject.Filter;

import com.generatorproject.model.Users;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Chặn tất cả request vào thư mục /admin/
@WebFilter(urlPatterns = { "/admin/*","/technical/*","/staff/*" })
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        Users user = (Users) session.getAttribute("USERMODEL");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login?message=not_login");
            return;
        }

        String url = req.getRequestURI();
        String contextPath = req.getContextPath();

        if (url.startsWith(contextPath + "/admin/user")) {

            boolean isGlobalAdmin = (user.getRoleId() == 1);
            boolean hasViewRight = user.hasPermission("USER_VIEW");
            boolean hasManageRight = user.hasPermission("USER_MANAGE");

            if (!isGlobalAdmin && !hasViewRight && !hasManageRight) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        if (url.startsWith(contextPath + "/manager")) {
            if (user.getRoleId() != 2 && user.getRoleId() != 1 && !user.hasPermission("REPORT_VIEW")) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        if (url.startsWith(contextPath + "/technical")) {
            if (user.getRoleId() != 4) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }
        if (url.startsWith(contextPath + "/staff")) {
            if (user.getRoleId() != 3) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }


        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}