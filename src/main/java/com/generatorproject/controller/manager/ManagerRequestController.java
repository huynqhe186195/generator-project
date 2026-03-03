package com.generatorproject.controller.manager;

import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.RequestServices;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.UserServices;
import com.google.gson.Gson;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet(urlPatterns = {"/manager/requests"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 50 * 1024 * 1024,
        maxRequestSize = 80 * 1024 * 1024
)
public class ManagerRequestController extends HttpServlet {

    private final IRequestServices requestService;
    private final IUserServices userService;

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

            List<SystemRequest> inbox = requestService.findByReceiverRole("Manager", status);
            req.setAttribute("requests", inbox);
            req.setAttribute("box", "inbox");

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

        if ("create_request".equals(action)) {
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

            long requestId = Long.parseLong(idStr);

            Users currentUser = (Users) req.getSession().getAttribute("USERMODEL");
            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            long approverId = currentUser.getId();

            // Approve request
            requestService.approve(requestId, approverId, "STAFF", "Đã duyệt");

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

    private void handleCreateRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

                case "NEW_PRODUCT":
                    receiverRole = "IT"; // Luồng nghiệp vụ: Manager gửi yêu cầu tạo product mới cho IT

                    String excelFileUrl = saveUploadFile(req, "productExcelFile", "/uploads/product-excels",
                            new String[]{".xlsx", ".xls"});
                    if (excelFileUrl == null) {
                        resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=invalid_file");
                        return;
                    }

                    data.put("excelFileUrl", excelFileUrl);
                    data.put("excelFileName", req.getPart("productExcelFile").getSubmittedFileName());
                    break;

                case "NEW_USER":
                    receiverRole = "ADMIN"; // Luồng nghiệp vụ: Manager gửi yêu cầu import user cho Admin

                    String userExcelFileUrl = saveUploadFile(req, "userExcelFile", "/uploads/user-excels",
                            new String[]{".xlsx", ".xls"});
                    if (userExcelFileUrl == null) {
                        resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=invalid_file");
                        return;
                    }

                    data.put("excelFileUrl", userExcelFileUrl);
                    data.put("excelFileName", req.getPart("userExcelFile").getSubmittedFileName());
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


    private String saveUploadFile(HttpServletRequest req, String partName, String folder, String[] allowedExt)
            throws IOException, ServletException {

        Part part = req.getPart(partName);
        if (part == null || part.getSize() == 0) return null;

        String original = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0) ext = original.substring(dot).toLowerCase();

        boolean allowed = false;
        for (String item : allowedExt) {
            if (item.equals(ext)) {
                allowed = true;
                break;
            }
        }
        if (!allowed) return null;

        String newName = UUID.randomUUID() + ext;

        String uploadDir = req.getServletContext().getRealPath(folder);
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        part.write(uploadDir + File.separator + newName);
        return folder.substring(1) + "/" + newName;
    }




    private void handleCreateAccountRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");

            String receiverRole = req.getParameter("receiverRole");
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
