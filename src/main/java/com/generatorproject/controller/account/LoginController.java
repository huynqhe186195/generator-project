package com.generatorproject.controller.account;

import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

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

    private IUserServices userServices = new  UserServices();

    // 1. doGet: Dùng để hiển thị trang JSP
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/account/login.jsp").forward(req, resp);
    }
    // 2. doPost: Dùng để xử lý dữ liệu Form gửi lên
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        String emailForm = req.getParameter("username");
        String passForm = req.getParameter("password");

        // Gọi Service kiểm tra đăng nhập
        Users userInDb = userServices.findByEmailAndPassword(emailForm, passForm);

        if (userInDb != null) {
            HttpSession session = req.getSession();
            session.setAttribute("USERMODEL", userInDb);

            // Xử lý chuyển hướng cho 5 Roles
            int roleId = userInDb.getRoleId();
            String url = "";

            switch (roleId) {
                case 1: // ADMIN
                    url = "/admin";
                    break;
                case 2: // MANAGER
                    url = "/manager/dashboard";
                    break;
                case 3: // STAFF
                    url = "/staff/tasks";
                    break;
                case 4: // CUSTOMER
                    url = "/home";
                    break;
                case 5: // TECHNICIAN
                    url = "/technician/products";
                    break;
                default:
                    url = "/login?message=access_denied";
                    break;
            }

            resp.sendRedirect(req.getContextPath() + url);

        } else {
            // Đăng nhập thất bại
            req.setAttribute("message", "Email hoặc mật khẩu không đúng!");
            req.setAttribute("alert", "danger");
            req.getRequestDispatcher("/views/account/login.jsp").forward(req, resp);
        }
    }

    }



