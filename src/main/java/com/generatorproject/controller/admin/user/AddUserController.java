package com.generatorproject.controller.admin.user;

import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.RoleServices;
import com.generatorproject.services.UserServices;
import com.generatorproject.validation.UserValidate;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // <-- Import cái này
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet(urlPatterns = {"/admin/user-list/user-add"})
// Cấu hình để nhận file
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
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

        try {
            String fullName = req.getParameter("fullName").trim();
            String email = req.getParameter("email").trim();
            String password = req.getParameter("password");
            String phone = req.getParameter("phone").trim();
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            int status = Integer.parseInt(req.getParameter("status"));

            Part filePart = req.getPart("avatarFile"); // Lấy file từ input name="avatarFile"
            String avatarUrl = "";

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // Lưu vào thư mục 'uploads' trong dự án
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir(); // Tạo thư mục nếu chưa có

                // Ghi file vào ổ cứng server
                filePart.write(uploadPath + File.separator + fileName);

                // Lưu đường dẫn tương đối vào DB
                avatarUrl = "uploads/" + fileName;
            } else {
                avatarUrl = "https://ui-avatars.com/api/?name=" + fullName.replaceAll(" ", "+");
            }

            String errorMessage = "";

            if(!userValidate.checkPhoneFormat(phone)){
                errorMessage = "Phone number is invalid! Please enter again";
            }

            if(userValidate.checkEmailExist(email)){
                errorMessage = "Email" + email + " already exists!";
            }

            if(userValidate.checkPhoneExist(phone)){
                errorMessage = "Phone number " + phone + " already exists!";
            }

            if(!errorMessage.isEmpty()){
                req.setAttribute("error", errorMessage);
                req.setAttribute("oldFullName", fullName);
                req.setAttribute("oldEmail", email);
                req.setAttribute("oldPhone", phone);
                req.setAttribute("listRoles", roleServices.getAllRoles());

                RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-add.jsp");
                rd.forward(req, resp);
                return;
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

            resp.sendRedirect(req.getContextPath() + "/admin/user/user-list");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user-list/user-add?error=1");
        }
    }
}