package com.generatorproject.controller.admin.user;

import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/user-status")
public class UserStatusController extends HttpServlet {
    private final IUserServices userServices;

    public UserStatusController() {
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Lấy ID và Status hiện tại từ URL
            int id = Integer.parseInt(req.getParameter("id"));
            int currentStatus = Integer.parseInt(req.getParameter("status"));

            // 2. Tính toán trạng thái mới (Đảo ngược: 1->0, 0->1)
            int newStatus = (currentStatus == 1) ? 0 : 1;

            // 3. Gọi DAO để cập nhật
            userServices.changeStatus(id, newStatus);
            // 4. Redirect về danh sách kèm thông báo
            String msg = (newStatus == 1) ? "unlocked" : "locked";
            resp.sendRedirect(req.getContextPath() + "/admin/user-list?message=" + msg);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user-list?message=error");
        }
    }
}