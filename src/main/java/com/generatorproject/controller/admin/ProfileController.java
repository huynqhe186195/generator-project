package com.generatorproject.controller.admin;

import com.generatorproject.dao.UserDao; // Chú ý tên class DAO của bạn là UserDao hay UserDAO
import com.generatorproject.model.Users;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/admin-profile"})
public class ProfileController extends HttpServlet {

    private final UserServices userServices;

    public ProfileController() {
        userServices = new UserServices();
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // 1. Lấy User từ session (để lấy ID)
        Users sessionUser = (Users) session.getAttribute("USERMODEL");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Query lại DB để lấy thông tin mới nhất (tránh trường hợp session cũ)
        // Lưu ý: Hàm findUserById cần trả về đầy đủ cả roleName nhé (nếu chưa có thì dùng sessionUser tạm)
        Users currentUser = userServices.findUserById(sessionUser.getId());

        // Nếu hàm findUserById của bạn chưa join bảng Role để lấy tên Role,
        // bạn có thể set tạm roleName từ session vào để hiển thị
        if (currentUser.getRoleName() == null) {
            currentUser.setRoleName(sessionUser.getRoleName());
        }

        // 3. Đẩy sang JSP
        req.setAttribute("myProfile", currentUser);

        req.getRequestDispatcher("/views/admin/profile.jsp").forward(req, resp);
    }
}