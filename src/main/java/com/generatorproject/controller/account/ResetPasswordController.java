package com.generatorproject.controller.account;

import com.generatorproject.dao.TokenDao;
import com.generatorproject.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {
    // Hiển thị form nhập mật khẩu mới
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (new TokenDao().getUserIdByValidToken(token) != null) {
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("login?message=token_invalid");
        }
    }

    // Xử lý lưu mật khẩu mới
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPass = req.getParameter("password");
        TokenDao tokenDao = new TokenDao();
        Integer userId = tokenDao.getUserIdByValidToken(token);

        if (userId != null) {
            // 1. Cập nhật password trong bảng users (Cần viết thêm hàm updatePassword trong UserDao)
            new UserDao().updatePassword(userId, newPass);
            // 2. Hủy token
            tokenDao.markAsUsed(token);
            resp.sendRedirect("login?message=reset_success");
        } else {
            resp.sendRedirect("login?message=error");
        }
    }
}