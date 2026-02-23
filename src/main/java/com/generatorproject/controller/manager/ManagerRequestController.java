package com.generatorproject.controller.manager;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
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
        maxFileSize = 20 * 1024 * 1024,
        maxRequestSize = 30 * 1024 * 1024
)
public class ManagerRequestController extends HttpServlet {

    private IRequestServices requestService;
    private IUserServices userService;
    private BrandDAO brandDAO;
    private CategoryDAO categoryDAO;

    public ManagerRequestController() {
        requestService = new RequestServices();
        userService = new UserServices();
        brandDAO = new BrandDAO();
        categoryDAO = new CategoryDAO();
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

        req.setAttribute("brands", brandDAO.getAllBrands());
        req.setAttribute("categories", categoryDAO.getAllCategories());

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

                    String name = req.getParameter("name");
                    String brandName = req.getParameter("brandName");
                    String categoryName = req.getParameter("categoryName");
                    String fuelType = req.getParameter("fuelType");

                    if (name == null || name.isBlank() || brandName == null || brandName.isBlank()
                            || categoryName == null || categoryName.isBlank() || fuelType == null || fuelType.isBlank()) {
                        resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=error");
                        return;
                    }

                    Brand brand = brandDAO.findByName(brandName);
                    Category category = categoryDAO.findByName(categoryName);
                    if (brand == null || category == null) {
                        resp.sendRedirect(req.getContextPath() + "/manager/requests?msg=error");
                        return;
                    }

                    String manualFileUrl = saveUploadFile(req, "manualFile", "/uploads/product-manuals",
                            new String[]{".pdf"});
                    String imageFileUrl = saveUploadFile(req, "imageFile", "/uploads/product-models",
                            new String[]{".png", ".jpg", ".jpeg", ".webp"});

                    data.put("name", name.trim());
                    data.put("brandId", brand.getId());
                    data.put("brandName", brand.getName());
                    data.put("categoryId", category.getId());
                    data.put("categoryName", category.getName());
                    data.put("origin", req.getParameter("origin"));
                    data.put("fuelType", fuelType.trim().toUpperCase());
                    data.put("power", req.getParameter("power"));
                    data.put("description", req.getParameter("description"));
                    data.put("specifications", req.getParameter("specifications"));
                    data.put("manualUrl", manualFileUrl);
                    data.put("imageUrl", imageFileUrl);
                    data.put("status", req.getParameter("productStatus"));
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
