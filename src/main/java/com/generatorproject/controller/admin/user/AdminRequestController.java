package com.generatorproject.controller.admin.user;

import com.generatorproject.dao.RequestDAO; // Bổ sung DAO này
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;
import com.generatorproject.utils.EmailServices;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/requests"}) // Định nghĩa URL cho controller
public class AdminRequestController extends HttpServlet {

    private IUserServices userServices;
    private RequestDAO requestDAO;

    public AdminRequestController() {
        userServices = new UserServices();
        requestDAO = new RequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<SystemRequest> pendingRequests = requestDAO.findByReceiverRole("ADMIN", "PENDING");

        req.setAttribute("requests", pendingRequests);
        req.getRequestDispatcher("/views/admin/request/request-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action"); // "approve" hoặc "reject"
            Long requestId = Long.parseLong(req.getParameter("requestId"));
            String adminNote = req.getParameter("adminNote"); // Lý do từ chối (nếu có)

            // Tìm request trong DB
            SystemRequest request = requestDAO.findById(requestId);
            if (request == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=not_found");
                return;
            }

            if ("approve".equals(action)) {
                handleApprove(request);

                request.setStatus("APPROVED");
                request.setResponseMessage("Đã duyệt tự động.");

            } else if ("reject".equals(action)) {
                request.setStatus("REJECTED");
                request.setResponseMessage(adminNote); // Lưu lý do từ chối vào DB
            }

            requestDAO.update(request);

            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=error&detail=" + e.getMessage());
        }
    }

    private void handleApprove(SystemRequest request) throws Exception {
        // Chỉ xử lý nếu đây là yêu cầu TẠO USER
        if ("CREATE_USER".equals(request.getRequestType())) {

            // LẤY THÔNG TIN TỪ CHUỖI JSON
            Gson gson = new Gson();
            Type type = new TypeToken<Map<String, String>>() {}.getType();
            Map<String, String> data = gson.fromJson(request.getRequestData(), type);

            String email = data.get("email");
            String fullName = data.get("fullName");
            String phone = data.get("phone");

            // Nếu email này đã tồn tại rồi thì không tạo nữa
            if (userServices.findByEmail(email) != null) {
                return;
            }

            // SINH MẬT KHẨU NGẪU NHIÊN
            String randomPassword = EmailServices.generateRandomPassword();
            String hashedPassword = BCrypt.hashpw(randomPassword, BCrypt.gensalt(12));

            // TẠO USER MỚI
            Users newUser = new Users();
            newUser.setEmail(email);
            newUser.setFullName(fullName);
            newUser.setPassword(hashedPassword);
            newUser.setRoleId(5);
            newUser.setStatus(1);
            newUser.setPhone(phone);

            userServices.createUser(newUser);

            // GỬI MAIL THÔNG BÁO (Chạy ngầm)
            new Thread(() -> {
                try {
                    EmailServices.sendWelcomeEmail(email, fullName, randomPassword);
                    System.out.println(">> AdminRequestController: Đã gửi mail cho " + email);
                } catch (Exception e) {
                    System.err.println(">> AdminRequestController: Lỗi gửi mail - " + e.getMessage());
                }
            }).start();
        }
    }
}