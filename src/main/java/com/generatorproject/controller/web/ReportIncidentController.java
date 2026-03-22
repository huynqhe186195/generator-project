package com.generatorproject.controller.web;

import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.Incident;
import com.generatorproject.model.Product;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IIncidentServices;
import com.generatorproject.services.IProductServices;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.IncidentServices;
import com.generatorproject.services.ProductServices;
import com.generatorproject.services.RequestServices;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// URL này phải khớp với action trong form báo sự cố của customer.
@WebServlet(urlPatterns = {"/report-incident", "/customer/incident/create"})
public class ReportIncidentController extends HttpServlet {

    private final IRequestServices requestServices;
    private final IProductServices productServices;
    private final IIncidentServices incidentServices;

    public ReportIncidentController() {
        this.requestServices = new RequestServices();
        productServices = new ProductServices();
        incidentServices = new IncidentServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // 1. Kiểm tra đăng nhập
            HttpSession session = req.getSession();
            Users user = (Users) session.getAttribute("USERMODEL");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            // 2. Lấy dữ liệu từ Form Modal
            ProductDAO productDAO = new ProductDAO();
            Product product = resolveReportedProduct(req, user, productDAO);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list?message=unauthorized_product");
                return;
            }

            int parsedProductId = product.getId().intValue();
            String issueType = normalizeIssueType(req.getParameter("issueType"));
            String productId = String.valueOf(parsedProductId);
            String preferredDate = req.getParameter("preferredDate");
            String preferredScheduleSlot = req.getParameter("preferredTimeSlot");
            String title = req.getParameter("title");
            String description = req.getParameter("description");

            // 3. Validate server-side: product thuộc user login + contract còn cho phép dịch vụ
            String contractStatus = product.getContractStatus();
            boolean serviceAllowed = "ACTIVE".equalsIgnoreCase(contractStatus) || "EXPIRED".equalsIgnoreCase(contractStatus);
            if (!serviceAllowed) {
                resp.sendRedirect(req.getContextPath() + "/product-list?message=contract_terminated");
                return;
            }

            String normalizedTimeSlot = "ANYTIME";
            Time preferredTimeFrom = null;
            Time preferredTimeTo = null;
            Integer preferredDurationMinutes = null;
            if (preferredScheduleSlot != null && !preferredScheduleSlot.isBlank()) {
                String[] slotParts = preferredScheduleSlot.split("\\|");
                if (slotParts.length == 3) {
                    preferredTimeFrom = Time.valueOf(slotParts[0] + ":00");
                    preferredTimeTo = Time.valueOf(slotParts[1] + ":00");
                    normalizedTimeSlot = slotParts[2];
                    preferredDurationMinutes = 120;
                }
            }

            Incident incident = new Incident();
            incident.setProductId(parsedProductId);
            incident.setReportedBy(user.getId());
            incident.setTitle(title);
            incident.setDescription(description);
            incident.setPriority("MEDIUM");
            incident.setStatus("NEW");
            incident.setPreferredDate(preferredDate == null || preferredDate.isBlank() ? null : Date.valueOf(preferredDate));
            incident.setPreferredTimeFrom(preferredTimeFrom);
            incident.setPreferredTimeTo(preferredTimeTo);
            incident.setPreferredTimeSlot(normalizedTimeSlot);
            incident.setFlexibleTime(false);
            incident.setUrgencyLevel("MEDIUM");
            incident.setCustomerNote(null);
            incident.setLocationSnapshot(product.getCurrentLocation());
            incident.setPreferredDurationMinutes(preferredDurationMinutes);
            incident.setContractId(product.getContractId() == null ? 0 : product.getContractId().intValue());
            incident.setInputSerialNumber(product.getSerialNumber());

            Long incidentId = incidentServices.createIncident(incident);
            if (incidentId == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list?message=error");
                return;
            }

            // 4. Đóng gói dữ liệu tối thiểu cho workflow request
            Map<String, String> requestDataMap = new HashMap<>();
            requestDataMap.put("incidentId", String.valueOf(incidentId));
            requestDataMap.put("productId", productId);
            requestDataMap.put("issueType", issueType);
            requestDataMap.put("preferredDate", preferredDate);
            requestDataMap.put("preferredTimeSlot", normalizedTimeSlot);
            requestDataMap.put("preferredTimeFrom", preferredTimeFrom == null ? "" : preferredTimeFrom.toString());
            requestDataMap.put("preferredTimeTo", preferredTimeTo == null ? "" : preferredTimeTo.toString());
            requestDataMap.put("preferredDurationMinutes", preferredDurationMinutes == null ? "" : String.valueOf(preferredDurationMinutes));
            requestDataMap.put("title", title);
            requestDataMap.put("description", description);

            // Lưu thêm thông tin người báo để tiện tra cứu nhanh
            requestDataMap.put("reporterName", user.getFullName());
            requestDataMap.put("reporterPhone", user.getPhone());
            requestDataMap.put("reporterEmail", user.getEmail());

            // Chuyển Map thành chuỗi JSON
            String jsonData = new Gson().toJson(requestDataMap);

            // 5. Tạo đối tượng SystemRequest
            SystemRequest request = new SystemRequest();
            request.setSenderId((long) user.getId());     // Người gửi là khách hàng
            request.setReceiverRole("STAFF");         // Người nhận là bộ phận Kỹ thuật (hoặc STAFF)
            request.setRequestType("INCIDENT_REPORT");    // Loại yêu cầu
            request.setRequestData(jsonData);             // Dữ liệu JSON
            request.setStatus("NEW");                 // Trạng thái ban đầu

            // 6. Lưu vào Database
            requestServices.save(request);
            Product productToUpdate = productServices.getProductById(parsedProductId);
            if (productToUpdate != null) {
                productToUpdate.setStatus("MAINTENANCE");
                productServices.update(productToUpdate);
            }
            // 7. Chuyển hướng về trang danh sách với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/product-list?message=success");

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi thì chuyển hướng về trang cũ kèm thông báo lỗi
            resp.sendRedirect(req.getContextPath() + "/product-list?message=error");
        }
    }

    private Product resolveReportedProduct(HttpServletRequest req, Users user, ProductDAO productDAO) {
        String productIdParam = req.getParameter("productId");
        if (productIdParam != null && !productIdParam.isBlank()) {
            try {
                int parsedProductId = Integer.parseInt(productIdParam);
                return productDAO.findCustomerProductWithContract(parsedProductId, user.getId());
            } catch (NumberFormatException ignored) {
                return null;
            }
        }

        String contractIdParam = req.getParameter("contractId");
        if (contractIdParam == null || contractIdParam.isBlank()) {
            return null;
        }

        try {
            List<Product> products = productServices.findByContractId(Long.parseLong(contractIdParam));
            if (products == null) {
                return null;
            }
            for (Product candidate : products) {
                if (candidate == null || candidate.getId() == null) {
                    continue;
                }
                Product authorizedProduct = productDAO.findCustomerProductWithContract(candidate.getId().intValue(), user.getId());
                if (authorizedProduct != null) {
                    return authorizedProduct;
                }
            }
        } catch (NumberFormatException ignored) {
            return null;
        }
        return null;
    }

    private String normalizeIssueType(String rawIssueType) {
        if (rawIssueType == null || rawIssueType.isBlank()) {
            return "OTHER";
        }
        return switch (rawIssueType.trim().toUpperCase()) {
            case "PERIODIC", "MAINTENANCE" -> "MAINTENANCE";
            case "REPAIR", "REPLACEMENT" -> "REPLACEMENT";
            case "INSPECTION", "BROKEN" -> "BROKEN";
            default -> "OTHER";
        };
    }

}
