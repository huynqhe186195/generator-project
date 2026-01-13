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

        String token = userServices.generatePasswordResetToken(email);

        if (token != null) {
            Users user = userServices.findByEmail(email);

            String resetLink = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                    + req.getContextPath() + "/reset-password?token=" + token;

            String subject = "Đặt lại mật khẩu cho tài khoản CMS Máy Phát Điện";
            String content = "<h3>Yêu cầu thay đổi mật khẩu</h3>"
                    + "<p>Chào " + user.getFullName() + ",</p>"
                    + "<p>Vui lòng nhấn vào link bên dưới để thực hiện đặt lại mật khẩu:</p>"
                    + "<a href='" + resetLink + "'>ĐẶT LẠI MẬT KHẨU NGAY</a>"
                    + "<p>Lưu ý: Liên kết này sẽ hết hạn sau 15 phút.</p>";

            EmailUtil.sendEmail(email, subject, content);

            req.setAttribute("message", "Một liên kết đặt lại mật khẩu đã được gửi đến email của bạn.");
            req.setAttribute("alert", "success");
        } else {
            req.setAttribute("message", "Email này không tồn tại trong hệ thống!");
            req.setAttribute("alert", "danger");
        }

        req.getRequestDispatcher("/views/account/forgot-password.jsp").forward(req, resp);
    }
}