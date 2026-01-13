package com.generatorproject.controller.account;

import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = { "/hanldeLogin" })
public class LoginController extends HttpServlet {

    private IUserServices userServices = new UserServices();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String emailForm = req.getParameter("username");
        String passForm = req.getParameter("password");

        Users userInDb = userServices.findByEmailAndPassword(emailForm, passForm);

        if (userInDb != null) {
            HttpSession session = req.getSession();
            session.setAttribute("USERMODEL", userInDb);

            String destUrl = userInDb.getRoleUrl();

            if (destUrl == null || destUrl.trim().isEmpty()) {
                destUrl = "/home";
            }

            resp.sendRedirect(req.getContextPath() + destUrl);

        } else {
            req.setAttribute("message", "Email hoặc mật khẩu không đúng!");
            req.setAttribute("alert", "danger");
            req.getRequestDispatcher("/views/account/login.jsp").forward(req, resp);
        }
    }
}