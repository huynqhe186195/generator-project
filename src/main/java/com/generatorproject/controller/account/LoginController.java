package com.generatorproject.controller.account;

import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = { "/hanldeLogin" })
public class LoginController extends HttpServlet {

    private final IUserServices userServices = new UserServices();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String emailForm = req.getParameter("username");
        String passForm = req.getParameter("password");

        Users userInDb = userServices.findByEmailAndPassword(emailForm, passForm);

        if (userInDb != null) {
            HttpSession session = req.getSession();
            session.setAttribute("USERMODEL", userInDb);

            String destUrl = userInDb.getRoleUrl();

            if (destUrl == null || destUrl.trim().isEmpty()) {
                destUrl = resolveFallbackUrl(userInDb);
            } else if (!canAccessUrl(userInDb, destUrl)) {
                destUrl = resolveFallbackUrl(userInDb);
            }

            resp.sendRedirect(req.getContextPath() + destUrl);

        } else {
            req.setAttribute("message", "Email hoặc mật khẩu không đúng!");
            req.setAttribute("alert", "danger");
            req.getRequestDispatcher("/views/account/login.jsp").forward(req, resp);
        }
    }

    private boolean canAccessUrl(Users user, String url) {
        if (url == null || url.trim().isEmpty()) {
            return false;
        }

        if (!url.startsWith("/")) {
            return false;
        }

        if (url.startsWith("/admin")) {
            return user.getRoleId() == 1 || user.hasPermission("USER_VIEW") || user.hasPermission("USER_MANAGE");
        }
        if (url.startsWith("/manager")) {
            return user.getRoleId() == 1 || user.getRoleId() == 2;
        }
        if (url.startsWith("/technical")) {
            return user.getRoleId() == 1 || user.getRoleId() == 4;
        }
        if (url.startsWith("/staff")) {
            return user.getRoleId() == 1 || user.getRoleId() == 2 || user.getRoleId() == 3;
        }
        if (url.startsWith("/it")) {
            return user.getRoleId() == 1 || user.getRoleId() == 6;
        }

        return true;
    }

    private String resolveFallbackUrl(Users user) {
        if (user == null) {
            return "/home";
        }

        int roleId = user.getRoleId();
        if (roleId == 1) {
            return "/admin/user/user-list";
        }
        if (roleId == 2) {
            return "/manager";
        }
        if (roleId == 3) {
            return "/staff/incident-list";
        }
        if (roleId == 4) {
            return "/technical/home";
        }
        if (roleId == 6) {
            return "/it/home";
        }

        return "/home";
    }
}
