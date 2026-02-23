package com.generatorproject.controller.manager;

import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.RequestServices;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.UserServices;
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
    private IUserServices userService;

    public ManagerRequestController() {
        requestService = new RequestServices();
        userService = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        if (manager == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        String box = req.getParameter("box");
        if (box == null || box.isBlank()) box = "sent";

        if ("inbox".equalsIgnoreCase(box)) {
            String status = req.getParameter("status");
            if (status == null || status.isBlank()) status = "WAITING_MANAGER";

            // Lấy inbox theo role + status (bạn đang dùng findInboxByRole ở local, nhưng trong repo có sẵn findByReceiverRole)
            List<SystemRequest> inbox = requestService.findByReceiverRole("Manager", status);
            req.setAttribute("requests", inbox);
            req.setAttribute("box", "inbox");

            // ✅ Map senderId -> fullName
            Map<Long, String> senderNames = new HashMap<>();
            for (SystemRequest r : inbox) {
                if (r.getSenderId() != null && !senderNames.containsKey(r.getSenderId())) {
                    Users u = userService.findUserById(r.getSenderId().intValue());
                    senderNames.put(r.getSenderId(), u != null ? u.getFullName() : ("#" + r.getSenderId()));
                }
            }
            req.setAttribute("senderNames", senderNames);

        } else {
            List<SystemRequest> myRequests = requestService.findBySenderId((long) manager.getId());
            req.setAttribute("requests", myRequests);
            req.setAttribute("box", "sent");
        }

        req.getRequestDispatcher("/views/manager/request/request-history.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("create_account".equals(action)) {
            handleCreateRequest(req, resp);
            return;
        }

        if ("approve".equals(action)) {
            handleApprove(req, resp);
            return;
        }

        if ("reject".equals(action)) {
            handleReject(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
    }

    private void handleApprove(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
                return;
            }

            long id = Long.parseLong(idStr);

            // cập nhật: WAITING_MANAGER -> APPROVED
            requestService.approve(id, "Đã duyệt");

            resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
        }
    }

    private void handleReject(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idStr = req.getParameter("id");
            String reason = req.getParameter("responseMessage");
            if (reason == null || reason.isBlank()) reason = "Từ chối";

            if (idStr == null || idStr.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
                return;
            }

            long id = Long.parseLong(idStr);

            requestService.reject(id, reason);

            resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
        }
    }

    private void handleCreateRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Users sender = (Users) req.getSession().getAttribute("USERMODEL");

            String receiverRole = req.getParameter("receiverRole");
            if (receiverRole == null || receiverRole.isBlank()) receiverRole = "ADMIN";
            receiverRole = receiverRole.trim().toUpperCase();

            String requestType = req.getParameter("requestType");
            if (requestType == null || requestType.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=error");
                return;
            }
            requestType = requestType.trim().toUpperCase();

            Map<String, Object> data = new HashMap<>();

            switch (requestType) {
                case "CREATE_USER":
                    data.put("email", req.getParameter("email"));
                    data.put("fullName", req.getParameter("fullName"));
                    data.put("phone", req.getParameter("phone"));

                    // nếu bạn vẫn muốn check duplicate theo email
                    if (requestService.isRequestPending((String) data.get("email"))) {
                        resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=duplicate");
                        return;
                    }
                    break;

                case "INCIDENT_REPORT":
                    data.put("productId", req.getParameter("productId"));
                    data.put("issueType", req.getParameter("issueType"));
                    data.put("title", req.getParameter("title"));
                    data.put("description", req.getParameter("description"));
                    data.put("priority", req.getParameter("priority"));
                    data.put("preferredDate", req.getParameter("preferredDate"));
                    break;

                case "CUSTOMER_REMINDER":
                    data.put("customerId", req.getParameter("customerId"));
                    data.put("content", req.getParameter("content"));
                    data.put("dueDate", req.getParameter("dueDate"));
                    break;

                default:
                    // loại request mới chưa support
                    resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=error");
                    return;
            }

            String jsonData = new Gson().toJson(data);

            SystemRequest request = SystemRequest.builder()
                    .senderId((long) sender.getId())
                    .receiverRole(receiverRole)
                    .requestType(requestType)
                    .requestData(jsonData)
                    // manager inbox bạn đang dùng WAITING_MANAGER, còn create_user đang dùng PENDING
                    // nên: thống nhất theo type:
                    .status("PENDING")
                    .build();

            requestService.save(request);
            resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=error");
        }
    }



    private void handleCreateAccountRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");

            String receiverRole = req.getParameter("receiverRole"); // ADMIN / IT / ...
            if (receiverRole == null || receiverRole.isBlank()) receiverRole = "ADMIN";
            receiverRole = receiverRole.trim().toUpperCase();

            // Lấy dữ liệu từ Form Modal
            String email = req.getParameter("email");
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");

            // Check trùng request đang chờ
            if (requestService.isRequestPending(email)) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=duplicate");
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
                    .receiverRole(receiverRole)
                    .requestType("CREATE_USER")
                    .requestData(jsonData)
                    .status("PENDING")
                    .build();

            requestService.save(request);
            resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=error");
        }
    }
}