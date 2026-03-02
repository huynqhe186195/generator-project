package com.generatorproject.controller.account;

import com.generatorproject.model.Users;
import com.generatorproject.services.AccountServices;
import com.generatorproject.services.IAccountServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
@WebServlet(urlPatterns = { "/account/*" })
public class AccountManagementController extends HttpServlet {

    private final IUserServices userServices;

    public AccountManagementController() {
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();

        if (path == null || path.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        switch (path) {
            case "/login":
                hanldeLogic(req, resp);
                break;
            case "/logout":
                hanldeLogout(req, resp);
                break;
            case "/user-profile":
                hanldeUserProfile(req, resp);
                break;
            case "/change-password":
                handleChangePassword(req, resp);
                break;
            case "/forgot-password":
                hanldeForgotPassword(req, resp);
                break;
            case "/reset-password":
                hanldeResetPassword(req, resp);
                break;
        }
    }

    private void hanldeResetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        req.getRequestDispatcher("/views/account/reset-password.jsp").forward(req, resp);
    }

    private void hanldeForgotPassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        req.getRequestDispatcher("/views/account/forgot-password.jsp").forward(req, resp);
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("USERMODEL") == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }
        req.getRequestDispatcher("/views/account/change-password.jsp").forward(req, resp);
    }

    private void hanldeLogic(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.getRequestDispatcher("/views/account/login.jsp").forward(req, resp);
    }

    private void hanldeLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession session = req.getSession();

        session.removeAttribute("USERMODEL");

        session.invalidate();

        resp.sendRedirect(req.getContextPath() + "/account/login");
    }

    private void hanldeUserProfile(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();

        Users sessionUser = (Users) session.getAttribute("USERMODEL");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login?message=login_required");
            return;
        }

        Users currentUser = userServices.findUserById(sessionUser.getId());

        if (currentUser.getRoleName() == null) {
            currentUser.setRoleName(sessionUser.getRoleName());
        }

        req.setAttribute("myProfile", currentUser);

        req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
    }

        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            resp.setContentType("text/html; charset=UTF-8");
            req.setCharacterEncoding("UTF-8");

            String path = req.getPathInfo();
            if (path == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            switch (path) {
                case "/user-profile":
                    handleUpdateUserProfile(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }

        private void handleUpdateUserProfile(HttpServletRequest req, HttpServletResponse resp)
                throws ServletException, IOException {

            HttpSession session = req.getSession();
            Users sessionUser = (Users) session.getAttribute("USERMODEL");

            if (sessionUser == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login?message=login_required");
                return;
            }

            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");

            if (fullName == null || fullName.trim().isEmpty()) {
                req.setAttribute("error", "Họ tên không được để trống!");
                // load lại profile để render
                Users currentUser = userServices.findUserById(sessionUser.getId());
                if (currentUser.getRoleName() == null) currentUser.setRoleName(sessionUser.getRoleName());
                req.setAttribute("myProfile", currentUser);
                req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
                return;
            }

            // Lấy user hiện tại từ DB
            Users currentUser = userServices.findUserById(sessionUser.getId());
            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login?message=login_required");
                return;
            }

            // Upload avatar (nếu có)
            Part avatarPart = req.getPart("avatar");
            String newAvatarPath = null;

            if (avatarPart != null && avatarPart.getSize() > 0) {
                String submitted = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
                String ext = "";
                int dot = submitted.lastIndexOf(".");
                if (dot >= 0) ext = submitted.substring(dot).toLowerCase();

                if (!ext.matches("\\.(png|jpg|jpeg|webp|gif)")) {
                    req.setAttribute("error", "Avatar chỉ nhận png/jpg/jpeg/webp/gif!");
                    if (currentUser.getRoleName() == null) currentUser.setRoleName(sessionUser.getRoleName());
                    req.setAttribute("myProfile", currentUser);
                    req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
                    return;
                }

                String uploadDir = getServletContext().getRealPath("/uploads/avatars");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                String fileName = UUID.randomUUID() + ext;
                avatarPart.write(uploadDir + File.separator + fileName);

                newAvatarPath = "uploads/avatars/" + fileName;
            }

            // Set lại dữ liệu cần update
            currentUser.setFullName(fullName.trim());
            currentUser.setPhone(phone != null ? phone.trim() : null);
            if (newAvatarPath != null) currentUser.setAvatarUrl(newAvatarPath);

            try {
                // ✅ CẦN có hàm updateProfile ở service/dao (mình hướng dẫn ở dưới)
                userServices.updateProfile(currentUser);

                // cập nhật session USERMODEL để navbar/avatar update ngay
                sessionUser.setFullName(currentUser.getFullName());
                sessionUser.setPhone(currentUser.getPhone());
                if (newAvatarPath != null) sessionUser.setAvatarUrl(newAvatarPath);
                session.setAttribute("USERMODEL", sessionUser);

                resp.sendRedirect(req.getContextPath() + "/account/user-profile?success=1");
            } catch (Exception e) {
                req.setAttribute("error", e.getMessage());
                if (currentUser.getRoleName() == null) currentUser.setRoleName(sessionUser.getRoleName());
                req.setAttribute("myProfile", currentUser);
                req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
            }
        }
    }

