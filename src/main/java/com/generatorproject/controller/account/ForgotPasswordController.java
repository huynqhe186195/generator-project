package com.generatorproject.controller.account;

import com.generatorproject.dao.UserDao;
import com.generatorproject.dao.TokenDao;
import com.generatorproject.model.Users;
import com.generatorproject.utils.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet(urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    // 1. Hiển thị trang nhập Email
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/account/forgot-password.jsp").forward(req, resp);
    }

    // 2. Xử lý khi người dùng nhấn nút "Gửi yêu cầu"
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");

        UserDao userDao = new UserDao();
        Users user = userDao.findByEmail(email);

        if (user != null) {
            // Bước A: Tạo Token ngẫu nhiên (Duy nhất)
            String token = UUID.randomUUID().toString();

            // Bước B: Lưu Token vào bảng password_reset_tokens
            TokenDao tokenDao = new TokenDao();
            tokenDao.saveToken(user.getId(), token);

            // Bước C: Tạo đường dẫn Reset (Link khách sẽ click trong mail)
            String resetLink = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                    + req.getContextPath() + "/reset-password?token=" + token;

            // Bước D: Nội dung Email (HTML)
            String subject = "Đặt lại mật khẩu cho tài khoản CMS Máy Phát Điện";
            String content = "<h3>Yêu cầu thay đổi mật khẩu</h3>"
                    + "<p>Chào " + user.getFullName() + ",</p>"
                    + "<p>Bạn đã yêu cầu đặt lại mật khẩu. Vui lòng nhấn vào link bên dưới để thực hiện:</p>"
                    + "<a href='" + resetLink + "'>ĐẶT LẠI MẬT KHẨU NGAY</a>"
                    + "<p>Lưu ý: Liên kết này sẽ hết hạn sau 15 phút.</p>";

            // Bước E: Gửi mail qua EmailUtil
            EmailUtil.sendEmail(email, subject, content);

            req.setAttribute("message", "Một liên kết đặt lại mật khẩu đã được gửi đến email của bạn.");
            req.setAttribute("alert", "success");
        } else {
            req.setAttribute("message", "Email này không tồn tại trong hệ thống!");
            req.setAttribute("alert", "danger");
        }

        // Quay lại trang forgot-password để hiện thông báo
        req.getRequestDispatcher("/views/account/forgot-password.jsp").forward(req, resp);
    }
}