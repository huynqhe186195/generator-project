package com.generatorproject.Filter;

import com.generatorproject.model.Users;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

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

        Users user = (Users) session.getAttribute("USERMODEL");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=not_login");
            return;
        }

        String url = req.getRequestURI();
        String contextPath = req.getContextPath();

        if (url.startsWith(contextPath + "/admin")) {
            if (user.getRoleId() != 1 && !user.hasPermission("ADMIN_ACCESS")) {
                resp.sendRedirect(contextPath + "/login?message=no_permission");
                return;
            }
        }

        if (url.startsWith(contextPath + "/manager")) {
            if (user.getRoleId() != 2 && user.getRoleId() != 1 && !user.hasPermission("REPORT_VIEW")) {
                resp.sendRedirect(contextPath + "/login?message=no_permission");
                return;
            }
        }

        if (url.startsWith(contextPath + "/technician")) {
            if (!user.hasPermission("ASSET_MAINTAIN") && !user.hasPermission("INVENTORY_MANAGE")) {
                resp.sendRedirect(contextPath + "/login?message=no_permission");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}