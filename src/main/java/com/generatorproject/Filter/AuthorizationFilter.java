package com.generatorproject.Filter;

import com.generatorproject.model.Users;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
        "/admin/*",
        "/manager/*",
        "/technical/*",
        "/staff/*",
        "/it/*"
})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String url = req.getRequestURI();
        String contextPath = req.getContextPath();

        // =======================
        // 1️⃣ BỎ QUA STATIC FILE
        // =======================
        if (
                url.startsWith(contextPath + "/uploads/")
                        || url.startsWith(contextPath + "/assets/")
                        || url.endsWith(".css")
                        || url.endsWith(".js")
                        || url.endsWith(".png")
                        || url.endsWith(".jpg")
                        || url.endsWith(".jpeg")
                        || url.endsWith(".webp")
                        || url.endsWith(".svg")
        ) {
            chain.doFilter(request, response);
            return;
        }

        // =======================
        // 2️⃣ CHECK LOGIN
        // =======================
        HttpSession session = req.getSession(false);
        Users user = (session != null)
                ? (Users) session.getAttribute("USERMODEL")
                : null;

        if (user == null) {
            resp.sendRedirect(contextPath + "/account/login?message=not_login");
            return;
        }

        int roleId = user.getRoleId();

        // =======================
        // 3️⃣ PHÂN QUYỀN
        // =======================

        // ADMIN
        if (url.startsWith(contextPath + "/admin")) {

            if (roleId == 1) {
                chain.doFilter(request, response);
                return;
            }

            if (roleId == 6 && (url.contains("/catalog") || url.contains("/product-models"))) {
                chain.doFilter(request, response);
                return;
            }

            boolean hasUserRight =
                    user.hasPermission("USER_VIEW") ||
                            user.hasPermission("USER_MANAGE");

            if (!hasUserRight) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // MANAGER
        else if (url.startsWith(contextPath + "/manager")) {
            if (roleId != 2 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // TECHNICAL
        else if (url.startsWith(contextPath + "/technical")) {
            if (roleId != 4 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // STAFF
        else if (url.startsWith(contextPath + "/staff")) {
            if (roleId != 3 && roleId != 2 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }

        // IT
        else if (url.startsWith(contextPath + "/it")) {
            if (roleId != 6 && roleId != 1) {
                req.getRequestDispatcher("/views/error/403.jsp").forward(req, resp);
                return;
            }
        }


        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void destroy() {}
}
