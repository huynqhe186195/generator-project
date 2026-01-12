package com.generatorproject.controller.account;

import com.generatorproject.dao.TokenDao;
import com.generatorproject.dao.UserDao;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {
    private IUserServices userServices = new UserServices();

    // Hiển thị form nhập mật khẩu mới
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");

        // Kiểm tra token qua Service
        if (token != null && userServices.getUserIdByValidToken(token) != null) {
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login?message=token_invalid");
        }
    }

    // Xử lý lưu mật khẩu mới
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPass = req.getParameter("password");

        Integer userId = userServices.getUserIdByValidToken(token);

        if (userId != null) {
            // 1. Cập nhật mật khẩu
            userServices.updatePassword(userId, newPass);
            // 2. Hủy token để không dùng lại được lần 2
            userServices.markTokenAsUsed(token);

            resp.sendRedirect(req.getContextPath() + "/login?message=reset_success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/login?message=error");
        }
    }
}