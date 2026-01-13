package com.generatorproject.controller.account;

import com.generatorproject.dao.TokenDao;
import com.generatorproject.dao.UserDao;
import com.generatorproject.services.AccountServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = { "/hanldeResetPassword" })
public class ResetPasswordController extends HttpServlet {
    private IUserServices userServices;
    private final AccountServices accountServices;
    public ResetPasswordController() {
        userServices = new UserServices();
        accountServices = new AccountServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPass = req.getParameter("password");

        Integer userId = userServices.getUserIdByValidToken(token);

        if (userId != null) {
            accountServices.changePassword(userId, newPass);
            userServices.markTokenAsUsed(token);

            resp.sendRedirect(req.getContextPath() + "/login?message=reset_success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/login?message=error");
        }
    }
}