package com.generatorproject.controller.account;

import com.generatorproject.services.AccountServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// Sửa lại URL cho đúng chính tả: handleResetPassword
@WebServlet(urlPatterns = { "/handleResetPassword" })
public class ResetPasswordController extends HttpServlet {

    private IUserServices userServices;
    private final AccountServices accountServices;

    public ResetPasswordController() {
        userServices = new UserServices();
        accountServices = new AccountServices();
    }

    // Thêm doGet để hiển thị form nhập (nếu user truy cập trực tiếp link này)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String token = req.getParameter("token").trim();
        String newPass = req.getParameter("password");
        String confirmPass = req.getParameter("re_password"); // Lấy thêm confirm password

        // 1. Kiểm tra mật khẩu nhập lại
        if (newPass == null || !newPass.equals(confirmPass)) {
            req.setAttribute("message", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("alert", "danger");
            req.setAttribute("token", token); // Giữ lại token để user không phải nhập lại
            req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra Token có hợp lệ không (Gọi Service)
        Integer userId = userServices.getUserIdByValidToken(token);

        if (userId != null) {
            // --- HỢP LỆ ---

            // Lưu ý: Bên trong accountServices.changePassword nhớ phải mã hóa BCrypt nhé!
            boolean isChanged = accountServices.changePassword(userId, newPass);

            if (isChanged) {
                // Đánh dấu token đã dùng
                userServices.markTokenAsUsed(token);

                // Redirect về Login kèm thông báo
                resp.sendRedirect(req.getContextPath() + "/login?message=reset_success");
            } else {
                req.setAttribute("message", "Lỗi khi cập nhật mật khẩu, vui lòng thử lại.");
                req.setAttribute("alert", "danger");
                req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
            }

        } else {
            // --- KHÔNG HỢP LỆ (Token sai hoặc hết hạn) ---
            req.setAttribute("message", "Mã Token không hợp lệ hoặc đã hết hạn!");
            req.setAttribute("alert", "danger");
            req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
        }
    }
}