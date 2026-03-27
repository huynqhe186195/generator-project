package com.generatorproject.controller.admin.user;

import com.generatorproject.services.UserServices;
import com.generatorproject.utils.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = { "/admin/user/handleApproveReset" })
public class AdminResetPasswordController extends HttpServlet {

    private final UserServices userServices;

    public AdminResetPasswordController() {
        userServices = new UserServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");
            String tokenKey = req.getParameter("token");
            String userEmail = req.getParameter("email");

            if (tokenKey != null && userEmail != null) {

                if ("approve".equals(action)) {
                    // 1. Kích hoạt token (is_used = 2, gia hạn 24h)
                    userServices.activateToken(tokenKey);

                    // 2. Tạo đường dẫn đến trang NHẬP MÃ (Không kèm token trên URL nữa)
                    // Ví dụ: http://localhost:8080/project/reset-password
                    String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
                    String resetPageUrl = baseUrl + "/account/reset-password";

                    // 3. Soạn nội dung email: Hiển thị mã Token rõ ràng để user copy
                    String subject = "Mã xác nhận đặt lại mật khẩu";
                    String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd;'>"
                            + "<h3 style='color:green;'>Yêu cầu của bạn đã được duyệt</h3>"
                            + "<p>Chào bạn,</p>"
                            + "<p>Vui lòng sử dụng mã xác nhận dưới đây để đặt lại mật khẩu:</p>"
                            + "<div style='background: #f4f4f4; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 2px; margin: 20px 0; border-radius: 5px;'>"
                            + tokenKey
                            + "</div>"
                            + "<p>Truy cập trang đặt lại mật khẩu tại đây: <a href='" + resetPageUrl + "'>BẤM VÀO ĐÂY</a></p>"
                            + "<p><i>Mã này có hiệu lực trong vòng 10 phút.</i></p>"
                            + "</div>";

                    EmailUtil.sendEmail(userEmail, subject, content);

                    req.getSession().setAttribute("message", "Đã DUYỆT và gửi mã token qua email!");
                    req.getSession().setAttribute("alertType", "success");

                } else if ("reject".equals(action)) {
                    // Xóa token
                    userServices.deleteToken(tokenKey);

                    // Gửi mail từ chối
                    String subject = "Yêu cầu đặt lại mật khẩu bị từ chối";
                    String content = "<p>Chào bạn,</p><p>Yêu cầu của bạn đã bị từ chối. Vui lòng liên hệ Admin.</p>";
                    EmailUtil.sendEmail(userEmail, subject, content);

                    req.getSession().setAttribute("message", "Đã TỪ CHỐI và xóa yêu cầu!");
                    req.getSession().setAttribute("alertType", "warning");
                }

            } else {
                req.getSession().setAttribute("message", "Dữ liệu không hợp lệ!");
                req.getSession().setAttribute("alertType", "danger");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("message", "Lỗi hệ thống!");
            req.getSession().setAttribute("alertType", "danger");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/user/approve-reset");
    }
}