package com.generatorproject.controller.account;

import com.generatorproject.dao.AccountDao;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/change-password"})
public class ChangePasswordController extends HttpServlet {

    private final AccountDao accountDao;
    private final UserDao userDao;

    public ChangePasswordController() {
        accountDao = new AccountDao();
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra session (giữ nguyên)
        HttpSession session = req.getSession();
        if (session.getAttribute("USERMODEL") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/views/account/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Xử lý tiếng Việt nếu có
        HttpSession session = req.getSession();
        Users sessionUser = (Users) session.getAttribute("USERMODEL");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");

        // Lấy thông tin User mới nhất từ DB (chứa mật khẩu đã mã hóa)
        Users currentUser = userDao.findUserById(sessionUser.getId());

        // Không dùng: currentUser.getPassword().equals(oldPass) -> SAI
        if (!BCrypt.checkpw(oldPass, currentUser.getPassword())) {
            req.setAttribute("mess", "Mật khẩu cũ không đúng!");
            req.setAttribute("alert", "danger");
            req.getRequestDispatcher("/views/account/change-password.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra xác nhận mật khẩu (Cái này so sánh chuỗi bình thường OK)
        if (!newPass.equals(confirmPass)) {
            req.setAttribute("mess", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("alert", "danger");
            req.getRequestDispatcher("/views/account/change-password.jsp").forward(req, resp);
            return;
        }

        // 4. Gọi DAO để đổi mật khẩu
        boolean isSuccess = accountDao.changePassword(currentUser.getId(), newPass);

        if (isSuccess) {
            req.setAttribute("mess", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
            req.setAttribute("alert", "success");

            // Optional: Xóa session bắt đăng nhập lại cho an toàn
            session.invalidate();
        } else {
            req.setAttribute("mess", "Có lỗi xảy ra, vui lòng thử lại!");
            req.setAttribute("alert", "danger");
        }

        req.getRequestDispatcher("/views/account/change-password.jsp").forward(req, resp);
    }
}