package com.generatorproject.controller.admin.user;

import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;
import com.generatorproject.validation.UserValidate;

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
import java.nio.file.Paths;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet(urlPatterns = "/admin/user-list/handleEditUser")
public class EditUserController extends HttpServlet {
    private IUserServices userServices;
    private UserValidate userValidate;

    public EditUserController() {
        userServices = new UserServices();
        userValidate = new UserValidate();
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // Lấy ID và Ảnh cũ (được giấu trong thẻ input hidden)
            int id = Integer.parseInt(req.getParameter("id"));
            String currentAvatar = req.getParameter("currentAvatar");

            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            int status = Integer.parseInt(req.getParameter("status"));

            // XỬ LÝ ẢNH:
            String avatarUrl = currentAvatar; // Mặc định là giữ ảnh cũ

            Part filePart = req.getPart("avatarFile");
            // Nếu người dùng có chọn file mới (size > 0)
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                filePart.write(uploadPath + File.separator + fileName);
                avatarUrl = "uploads/" + fileName; // Cập nhật đường dẫn mới
            }
            String errorMessage ="";

            if(!userValidate.checkPhoneNumber(phone)){
                errorMessage = "Phone number is invalid! Please enter again";
            }


            if(!errorMessage.isEmpty()){
                req.setAttribute("error", errorMessage);
                // resend data user entered
                req.setAttribute("oldFullName", fullName);
                req.setAttribute("oldPhone", phone);

                RequestDispatcher rd = req.getRequestDispatcher("/views/admin/user/user-add.jsp");
                rd.forward(req, resp);
                return;
            }

            // Dùng Builder tạo object (Không set Password vì không đổi)
            Users userToUpdate = new Users.Builder()
                    .setId(id)
                    .setFullName(fullName)
                    .setPhone(phone)
                    .setRoleId(roleId)
                    .setStatus(status)
                    .setAvatarUrl(avatarUrl)
                    .build();

            userServices.updateUser(userToUpdate);

            resp.sendRedirect(req.getContextPath() + "/admin/user-list");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user-list?error=update_failed");
        }
    }
}
