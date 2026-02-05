package com.generatorproject.controller.admin.user;

import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.RoleServices;
import com.generatorproject.services.UserServices;
import com.generatorproject.validation.UserValidate;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet(urlPatterns = {"/admin/user-list/user-add"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddUserController extends HttpServlet {
    private final IUserServices userServices;
    private final UserValidate userValidate;
    private final RoleServices roleServices;

    public AddUserController() {
        this.userServices = new UserServices();
        this.userValidate = new UserValidate();
        this.roleServices = new RoleServices();
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String fullName = "";
        String email = "";
        String phone = "";
        String roleIdStr = "";
        String statusStr = "";

        try {
            fullName = req.getParameter("fullName").trim();
            email = req.getParameter("email").trim();
            String password = req.getParameter("password");
            phone = req.getParameter("phone").trim();
            roleIdStr = req.getParameter("roleId");
            statusStr = req.getParameter("status");

            int roleId = Integer.parseInt(roleIdStr);
            int status = Integer.parseInt(statusStr);

            String errorMessage = null;

            if (!userValidate.checkPhoneFormat(phone)) {
                errorMessage = "Số điện thoại không đúng định dạng!";
            } else if (userValidate.checkEmailExist(email)) {
                errorMessage = "Email " + email + " đã tồn tại trong hệ thống!";
            } else if (userValidate.checkPhoneExist(phone)) {
                errorMessage = "Số điện thoại " + phone + " đã tồn tại!";
            }

            if (errorMessage != null) {
                forwardWithError(req, resp, errorMessage, fullName, email, phone, roleIdStr, statusStr);
                return;
            }

            Part filePart = req.getPart("avatarFile");
            String avatarUrl = "";

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                String uploadPath = getServletContext().getRealPath("/uploads");

                File dir = new File(uploadPath);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                File destinationFile = new File(uploadPath, fileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, destinationFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                avatarUrl = "uploads/" + fileName;
            } else {
                avatarUrl = "https://ui-avatars.com/api/?name=" + fullName.replaceAll(" ", "+");
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(10));

            Users newUser = new Users.Builder()
                    .setFullName(fullName)
                    .setEmail(email)
                    .setPassword(hashedPassword)
                    .setPhone(phone)
                    .setRoleId(roleId)
                    .setStatus(status)
                    .setAvatarUrl(avatarUrl)
                    .build();

            userServices.createUser(newUser);

            resp.sendRedirect(req.getContextPath() + "/admin/user/user-list?msg=add_success");

        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null || msg.isEmpty()) msg = "Đã xảy ra lỗi hệ thống!";

            forwardWithError(req, resp, msg, fullName, email, phone, roleIdStr, statusStr);
        }
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String error,
                                  String name, String email, String phone, String roleId, String status)
            throws ServletException, IOException {

        req.setAttribute("error", error);

        req.setAttribute("oldFullName", name);
        req.setAttribute("oldEmail", email);
        req.setAttribute("oldPhone", phone);
        req.setAttribute("oldRoleId", roleId);
        req.setAttribute("oldStatus", status);

        req.setAttribute("listRoles", roleServices.getAllRoles());

        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-add.jsp");
        rd.forward(req, resp);
    }
}