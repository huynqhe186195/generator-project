package com.generatorproject.controller.admin.user;

import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;

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
// Cấu hình để nhận file (Max size khoảng 10MB)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddUserController extends HttpServlet {

    private final IUserServices userServices;

    public AddUserController() {
        this.userServices = new UserServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // 1. Nhận các trường Text bình thường
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String phone = req.getParameter("phone");
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            int status = Integer.parseInt(req.getParameter("status"));

            // 2. Xử lý FILE ẢNH
            Part filePart = req.getPart("avatarFile"); // Lấy file từ input name="avatarFile"
            String avatarUrl = "";

            // Kiểm tra xem người dùng có chọn file không
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // --- ĐỊNH NGHĨA NƠI LƯU FILE ---
                // Lưu vào thư mục 'uploads' trong dự án
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir(); // Tạo thư mục nếu chưa có

                // Ghi file vào ổ cứng server
                filePart.write(uploadPath + File.separator + fileName);

                // Lưu đường dẫn tương đối vào DB (để sau này hiển thị trên web)
                // Ví dụ: "uploads/anh-cua-huy.jpg"
                avatarUrl = "uploads/" + fileName;
            } else {
                avatarUrl = "https://ui-avatars.com/api/?name=" + fullName.replaceAll(" ", "+");
            }

            // 3. Tạo User và Lưu vào DB (Giống bài trước)
            Users newUser = new Users.Builder()
                    .setFullName(fullName)
                    .setEmail(email)
                    .setPassword(password)
                    .setPhone(phone)
                    .setRoleId(roleId)
                    .setStatus(status)
                    .setAvatarUrl(avatarUrl)
                    .build();

            userServices.createUser(newUser);

            resp.sendRedirect(req.getContextPath() + "/admin/user-list");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user-list/user-add?error=1");
        }
    }
}