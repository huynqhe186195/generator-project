package com.generatorproject.controller.account;

import com.generatorproject.dao.UserDao;
import com.generatorproject.dao.TokenDao;
import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;
import com.generatorproject.utils.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet(urlPatterns = { "/handleForgotPassword" })
public class ForgotPasswordController extends HttpServlet {

    private IUserServices userServices = new UserServices();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        Users user = userServices.findByEmail(email);

        if (user != null) {

            String token = userServices.generatePasswordResetToken(email);

            if (token != null) {

                req.setAttribute("message", "Yêu cầu đã được gửi đến Ban quản trị. Vui lòng chờ Admin xử lý và cấp lại mật khẩu.");
                req.setAttribute("alert", "success");
            } else {
                req.setAttribute("message", "Đã có lỗi xảy ra, vui lòng thử lại sau.");
                req.setAttribute("alert", "danger");
            }
        } else {

            req.setAttribute("message", "Email này không tồn tại trong hệ thống!");
            req.setAttribute("alert", "danger");
        }

        req.getRequestDispatcher("/views/account/forgot-password.jsp").forward(req, resp);
    }
}