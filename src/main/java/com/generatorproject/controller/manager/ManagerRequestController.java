package com.generatorproject.controller.manager;

import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.IProductServices;
import com.generatorproject.services.IIncidentPlanService;
import com.generatorproject.services.IIncidentServices;
import com.generatorproject.services.RequestServices;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Product;
import com.generatorproject.model.Users;
import com.generatorproject.model.Incident;
import com.generatorproject.services.UserServices;
import com.generatorproject.services.ProductServices;
import com.generatorproject.services.IncidentPlanService;
import com.generatorproject.services.IncidentServices;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

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
    private final IProductServices productService;
    private final IIncidentPlanService incidentPlanService;
    private final IIncidentServices incidentService;
    private final Gson gson;

    public ManagerRequestController() {
        requestService = new RequestServices();
        userService = new UserServices();
        productService = new ProductServices();
        incidentPlanService = new IncidentPlanService();
        incidentService = new IncidentServices();
        gson = new Gson();
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

        List<SystemRequest> currentRequests;

        if ("inbox".equalsIgnoreCase(box)) {
            String status = req.getParameter("status");
            if (status == null || status.isBlank()) status = "WAITING_MANAGER";

            List<SystemRequest> inbox = requestService.findByReceiverRole("Manager", status);
            currentRequests = inbox;
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
            req.setAttribute("listTechnicians", userService.findUserByRoleId(4));

        } else {
            List<SystemRequest> myRequests = requestService.findBySenderId((long) manager.getId());
            currentRequests = myRequests;
            req.setAttribute("requests", myRequests);
            req.setAttribute("box", "sent");
            req.setAttribute("listTechnicians", userService.findUserByRoleId(4));
        }

        attachReferenceDisplayData(req, currentRequests);

        req.getRequestDispatcher("/views/manager/request/request-history.jsp").forward(req, resp);
    }

    private void attachReferenceDisplayData(HttpServletRequest req, List<SystemRequest> requests) {
        Map<Long, String> technicianDisplayById = new HashMap<>();
        Map<Long, String> productDisplayById = new HashMap<>();
        Map<Long, String> incidentStatusById = new HashMap<>();

        if (requests != null) {
            for (SystemRequest item : requests) {
                if (item == null || item.getRequestData() == null || item.getRequestData().trim().isEmpty()) continue;

                Map<String, Object> data;
                try {
                    data = gson.fromJson(item.getRequestData(), new TypeToken<Map<String, Object>>() {}.getType());
                } catch (Exception ignored) {
                    continue;
                }
                if (data == null) continue;

                Long technicianId = asLong(data.get("technicianId"));
                if (technicianId != null && !technicianDisplayById.containsKey(technicianId)) {
                    Users technician = userService.findUserById(technicianId.intValue());
                    String technicianName = (technician != null && technician.getFullName() != null
                            && !technician.getFullName().trim().isEmpty())
                            ? technician.getFullName().trim()
                            : "Không rõ";
                    technicianDisplayById.put(technicianId, technicianId + " - " + technicianName);
                }

                Long productId = asLong(data.get("productId"));
                if (productId != null && !productDisplayById.containsKey(productId)) {
                    Product product = productService.getProductById(productId.intValue());

                    String modelName = (product != null && product.getModelName() != null
                            && !product.getModelName().trim().isEmpty())
                            ? product.getModelName().trim()
                            : "Sản phẩm #" + productId;

                    String serial = (product != null && product.getSerialNumber() != null
                            && !product.getSerialNumber().trim().isEmpty())
                            ? product.getSerialNumber().trim()
                            : "N/A";

                    productDisplayById.put(productId, modelName + " - " + serial);
                }

                Long incidentId = asLong(data.get("incidentId"));
                if (incidentId != null && !incidentStatusById.containsKey(incidentId)) {
                    Incident incident = incidentService.findById(incidentId);
                    if (incident != null) {
                        incidentStatusById.put(incidentId, incident.getStatus());
                    }
                }
            }
        }

        req.setAttribute("technicianDisplayMap", technicianDisplayById);
        req.setAttribute("productDisplayMap", productDisplayById);
        req.setAttribute("incidentStatusMap", incidentStatusById);
        req.setAttribute("technicianDisplayJson", gson.toJson(technicianDisplayById));
        req.setAttribute("productDisplayJson", gson.toJson(productDisplayById));
    }

    private Long asLong(Object raw) {
        if (raw == null) return null;
        if (raw instanceof Number) return ((Number) raw).longValue();
        try {
            String s = String.valueOf(raw).trim();
            if (s.isEmpty()) return null;
            if (s.contains(".")) {
                return (long) Double.parseDouble(s);
            }
            return Long.parseLong(s);
        } catch (Exception e) {
            return null;
        }
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

        if ("assign_technician".equals(action)) {
            handleAssignTechnician(req, resp);
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
            SystemRequest request = requestService.findById(requestId);
            if (request != null && request.getInfo() != null) {
                Map<String, Object> info = request.getInfo();
                Long overrideTechnicianId = asLong(req.getParameter("technicianId"));
                if ("INCIDENT_REPORT".equalsIgnoreCase(request.getRequestType()) && overrideTechnicianId != null) {
                    info.put("technicianId", overrideTechnicianId);
                    Users overrideTechnician = userService.findUserById(overrideTechnicianId.intValue());
                    String technicianName = (overrideTechnician != null && overrideTechnician.getFullName() != null
                            && !overrideTechnician.getFullName().trim().isEmpty())
                            ? overrideTechnician.getFullName().trim()
                            : "Kỹ thuật viên #" + overrideTechnicianId;
                    info.put("technicianName", technicianName);
                    request.setRequestData(gson.toJson(info));
                    requestService.update(request);
                }

                Long incidentPlanId = asLong(info.get("incidentPlanId"));
                Long incidentId = asLong(info.get("incidentId"));
                if (incidentPlanId != null) {
                    incidentPlanService.approve(incidentPlanId, (int) approverId);
                }
                if (incidentId != null) {
                    incidentService.updateStatus(incidentId, "APPROVED");
                }
            }

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
            SystemRequest request = requestService.findById(id);
            if (request != null && request.getInfo() != null) {
                Long incidentPlanId = asLong(request.getInfo().get("incidentPlanId"));
                Long incidentId = asLong(request.getInfo().get("incidentId"));
                if (incidentPlanId != null) {
                    incidentPlanService.reject(incidentPlanId, reason);
                }
                if (incidentId != null) {
                    incidentService.updateStatus(incidentId, "VERIFIED");
                }
            }

            requestService.reject(id, reason);

            resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
        }
    }

    private void handleAssignTechnician(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idStr = req.getParameter("id");
            String technicianIdRaw = req.getParameter("technicianId");
            if (idStr == null || idStr.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
                return;
            }

            if (technicianIdRaw == null || technicianIdRaw.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=technician_updated");
                return;
            }

            long requestId = Long.parseLong(idStr);
            Long technicianId = asLong(technicianIdRaw);
            if (technicianId == null) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
                return;
            }

            SystemRequest request = requestService.findById(requestId);
            if (request == null || request.getInfo() == null
                    || !"INCIDENT_REPORT".equalsIgnoreCase(request.getRequestType())) {
                resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=error");
                return;
            }

            Map<String, Object> info = request.getInfo();
            info.put("technicianId", technicianId);
            Users technician = userService.findUserById(technicianId.intValue());
            String technicianName = (technician != null && technician.getFullName() != null
                    && !technician.getFullName().trim().isEmpty())
                    ? technician.getFullName().trim()
                    : "Kỹ thuật viên #" + technicianId;
            info.put("technicianName", technicianName);

            request.setRequestData(gson.toJson(info));
            requestService.update(request);

            resp.sendRedirect(req.getContextPath() + "/manager/requests?box=inbox&msg=technician_updated");
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
