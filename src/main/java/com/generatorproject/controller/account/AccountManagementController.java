package com.generatorproject.controller.account;

import com.generatorproject.model.Users;
import com.generatorproject.services.AccountServices;
import com.generatorproject.services.IAccountServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/account/*"})
public class AccountManagementController extends HttpServlet {

    private final IUserServices userServices;

    public AccountManagementController() {
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();

        if (path == null || path.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        switch (path) {
            case "/login":
                hanldeLogic(req, resp);
                break;
            case "/logout":
                hanldeLogout(req, resp);
                break;
            case "/user-profile":
                hanldeUserProfile(req, resp);
                break;
            case "/change-password":
                handleChangePassword(req, resp);
                break;
            case "/forgot-password":
                hanldeForgotPassword(req, resp);
                break;
            case "/reset-password":
                hanldeResetPassword(req, resp);
                break;
        }
    }

    private void hanldeResetPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String token = req.getParameter("token");

        if (token != null && userServices.getUserIdByValidToken(token) != null) {
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login?message=token_invalid");
        }
    }

    private void hanldeForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.getRequestDispatcher("/views/account/forgot-password.jsp").forward(req, resp);
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("USERMODEL") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/views/account/change-password.jsp").forward(req, resp);
    }

    private void hanldeLogic(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.getRequestDispatcher("/views/account/login.jsp").forward(req, resp);
    }

    private void hanldeLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession session = req.getSession();

        session.removeAttribute("USERMODEL");

        session.invalidate();

        resp.sendRedirect(req.getContextPath() + "/login");
    }

    private void hanldeUserProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();

        Users sessionUser = (Users) session.getAttribute("USERMODEL");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=login_required");
            return;
        }

        Users currentUser = userServices.findUserById(sessionUser.getId());


        if (currentUser.getRoleName() == null) {
            currentUser.setRoleName(sessionUser.getRoleName());
        }

        req.setAttribute("myProfile", currentUser);

        req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
    }
}
