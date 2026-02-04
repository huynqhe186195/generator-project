package com.generatorproject.controller.manager;

import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.RequestServices;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/manager/requests"})
public class ManagerRequestController extends HttpServlet {

    private IRequestServices requestService;

    public ManagerRequestController() {
        requestService = new RequestServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");

        // 1. Lấy danh sách yêu cầu mà Manager này từng gửi
        List<SystemRequest> myRequests = requestService.findBySenderId((long) manager.getId());

        req.setAttribute("requests", myRequests);
        req.getRequestDispatcher("/views/manager/request/request-history.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("create_account".equals(action)) {
            handleCreateAccountRequest(req, resp);
        }
    }

    private void handleCreateAccountRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");

            // Lấy dữ liệu từ Form Modal
            String email = req.getParameter("email");
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");

            // Check trùng request đang chờ
            if (requestService.isRequestPending(email)) {
                resp.sendRedirect("requests?msg=duplicate");
                return;
            }

            // Đóng gói JSON
            Map<String, String> data = new HashMap<>();
            data.put("email", email);
            data.put("fullName", fullName);
            data.put("phone", phone);

            String jsonData = new Gson().toJson(data);

            // Tạo Request
            SystemRequest request = SystemRequest.builder()
                    .senderId((long) manager.getId())
                    .receiverRole("ADMIN")
                    .requestType("CREATE_USER")
                    .requestData(jsonData)
                    .status("PENDING")
                    .build();

            requestService.save(request);
            resp.sendRedirect("requests?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("requests?msg=error");
        }
    }
}