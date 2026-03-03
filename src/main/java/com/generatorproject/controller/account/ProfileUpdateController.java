package com.generatorproject.controller.account;

import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet(urlPatterns = {"/account/profile/update"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class ProfileUpdateController extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("myProfile") == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        Users current = (Users) session.getAttribute("myProfile");

        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("error", "Họ tên không được để trống!");
            req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
            return;
        }

        // Upload avatar nếu có
        Part avatarPart = req.getPart("avatar");
        String newAvatarPath = null;

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String submitted = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
            String ext = "";
            int dot = submitted.lastIndexOf(".");
            if (dot >= 0) ext = submitted.substring(dot).toLowerCase();

            if (!ext.matches("\\.(png|jpg|jpeg|webp|gif)")) {
                req.setAttribute("error", "Avatar chỉ nhận png/jpg/jpeg/webp/gif!");
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

        Users updated = new Users.Builder()
                .setId(current.getId())
                .setRoleId(current.getRoleId())
                .setEmail(current.getEmail())
                .setPassword(current.getPassword())
                .setStatus(current.getStatus())
                .setCreatedAt(current.getCreatedAt())
                .setFullName(fullName.trim())
                .setPhone(phone != null ? phone.trim() : null)
                .setAvatarUrl(newAvatarPath != null ? newAvatarPath : current.getAvatarUrl())
                .setRoleName(current.getRoleName())
                .setRoleUrl(current.getRoleUrl())
                .setPermissions(current.getPermissions())
                .build();

        try {
            // bạn thêm hàm updateProfile như mình hướng dẫn trước
            userDao.updateProfile(updated);

            session.setAttribute("myProfile", updated);
            resp.sendRedirect(req.getContextPath() + "/account/profile"); // quay lại trang profile
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/views/account/profile.jsp").forward(req, resp);
        }
    }
}