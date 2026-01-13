package com.generatorproject.controller.account;

import com.generatorproject.dao.UserDao;
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

@WebServlet(urlPatterns = {"/user-profile"})
public class ProfileUserController extends HttpServlet {

    private final IUserServices userServices;

    public ProfileUserController() {
        userServices = new UserServices();
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();

        Users sessionUser = (Users) session.getAttribute("USERMODEL");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=login_required");
            return;
        }

        Users currentUser = userServices.findUserById(sessionUser.getId());


        if (currentUser.getRoleName() == null) {
            currentUser.setRoleName(sessionUser.getRoleName());
        }

        req.setAttribute("myProfile", currentUser);

        req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
    }
}