package com.generatorproject.controller.account;

import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login"})
public class LoginController extends HttpServlet {
    // 1. doGet: Dùng để hiển thị trang JSP
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("/views/account/login.jsp");
        rd.forward(req, resp);
    }
    // 2. doPost: Dùng để xử lý dữ liệu Form gửi lên
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String emailForm = req.getParameter("username");
        String passForm = req.getParameter("password");

        UserDao userDAO = new UserDao();
        Users userInDb = userDAO.findByEmail(emailForm);

        boolean isLoginSuccess = false;

        // Logic kiểm tra
        if (userInDb != null && userInDb.getPassword().equals(passForm)) {
            // 1. Lưu thông tin vào Session
            HttpSession session = req.getSession();
            session.setAttribute("USERMODEL", userInDb);

            // 2. KIỂM TRA ROLE ĐỂ CHUYỂN HƯỚNG
            if (userInDb.getRoleId() == 1) {
                // Nếu là ADMIN -> Chuyển sang trang quản trị
                resp.sendRedirect(req.getContextPath() + "/home");
            } else if (userInDb.getRoleId() == 2) {
                // Nếu là USER -> Chuyển sang trang chủ bán hàng
                resp.sendRedirect(req.getContextPath() + "/home");
            } else {
                // Role lạ -> Chuyển về trang mặc định hoặc báo lỗi
                resp.sendRedirect(req.getContextPath() + "/login?message=role_invalid");
            }
        } else {
            // Đăng nhập thất bại
            req.setAttribute("message", "Email hoặc mật khẩu không đúng!");
            req.setAttribute("alert", "danger");
            req.getRequestDispatcher("/views/account/login.jsp").forward(req, resp);        }


    }


}
