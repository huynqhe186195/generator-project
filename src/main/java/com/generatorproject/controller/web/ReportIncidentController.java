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

@WebServlet(urlPatterns = {"/report-incident", "/customer/incident/create"})
public class ReportIncidentController extends HttpServlet {

    private static final String DEFAULT_INCIDENT_PRIORITY = "MEDIUM";
    private static final String DEFAULT_INCIDENT_STATUS = "NEW";
    private static final String DEFAULT_TIME_SLOT = "ANYTIME";
    private static final int FIXED_SLOT_DURATION_MINUTES = 120;

    private final IRequestServices requestServices;
    private final IProductServices productServices;
    private final IIncidentServices incidentServices;

    public ReportIncidentController() {
        this.requestServices = new RequestServices();
        this.productServices = new ProductServices();
        this.incidentServices = new IncidentServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            Users user = getLoggedInUser(req);
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            Product product = resolveReportedProduct(req, user, productDAO);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list?message=unauthorized_product");
                return;
            }

            if (!isServiceAllowed(product)) {
                resp.sendRedirect(req.getContextPath() + "/product-list?message=contract_terminated");
                return;
            }

            String issueType = normalizeIssueType(req.getParameter("issueType"));
            String preferredDate = req.getParameter("preferredDate");
            String preferredTimeSlot = req.getParameter("preferredTimeSlot");
            String title = req.getParameter("title");
            String description = req.getParameter("description");

            PreferredSchedule preferredSchedule = PreferredSchedule.from(preferredTimeSlot);
            Incident incident = buildIncident(product, user, preferredDate, title, description, preferredSchedule);

            Long incidentId = incidentServices.createIncident(incident);
            if (incidentId == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list?message=error");
                return;
            }

            SystemRequest request = buildIncidentRequest(
                    user,
                    product.getId(),
                    incidentId,
                    issueType,
                    preferredDate,
                    title,
                    description,
                    preferredSchedule
            );
            requestServices.save(request);

            Product productToUpdate = productServices.getProductById(product.getId());
            if (productToUpdate != null) {
                productToUpdate.setStatus("MAINTENANCE");
                productServices.update(productToUpdate);
            }

            resp.sendRedirect(req.getContextPath() + "/product-list?message=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/product-list?message=error");
        }
    }

    private Users getLoggedInUser(HttpServletRequest req) {
        HttpSession session = req.getSession();
        return (Users) session.getAttribute("USERMODEL");
    }

    private boolean isServiceAllowed(Product product) {
        String contractStatus = product.getContractStatus();
        return "ACTIVE".equalsIgnoreCase(contractStatus) || "EXPIRED".equalsIgnoreCase(contractStatus);
    }

    private Incident buildIncident(Product product,
                                   Users user,
                                   String preferredDate,
                                   String title,
                                   String description,
                                   PreferredSchedule preferredSchedule) {
        Incident incident = new Incident();
        incident.setProductId(product.getId());
        incident.setReportedBy(user.getId());
        incident.setTitle(title);
        incident.setDescription(description);
        incident.setPriority(DEFAULT_INCIDENT_PRIORITY);
        incident.setStatus(DEFAULT_INCIDENT_STATUS);
        incident.setPreferredDate(preferredDate == null || preferredDate.isBlank() ? null : Date.valueOf(preferredDate));
        incident.setPreferredTimeFrom(preferredSchedule.timeFrom());
        incident.setPreferredTimeTo(preferredSchedule.timeTo());
        incident.setPreferredTimeSlot(preferredSchedule.slotLabel());
        incident.setFlexibleTime(false);
        incident.setUrgencyLevel(DEFAULT_INCIDENT_PRIORITY);
        incident.setCustomerNote(null);
        incident.setLocationSnapshot(product.getCurrentLocation());
        incident.setPreferredDurationMinutes(preferredSchedule.durationMinutes());
        incident.setContractId(product.getContractId() == null ? 0 : product.getContractId().intValue());
        incident.setInputSerialNumber(product.getSerialNumber());
        return incident;
    }

    private SystemRequest buildIncidentRequest(Users user,
                                               int productId,
                                               Long incidentId,
                                               String issueType,
                                               String preferredDate,
                                               String title,
                                               String description,
                                               PreferredSchedule preferredSchedule) {
        Map<String, String> requestDataMap = new HashMap<>();
        requestDataMap.put("incidentId", String.valueOf(incidentId));
        requestDataMap.put("productId", String.valueOf(productId));
        requestDataMap.put("issueType", issueType);
        requestDataMap.put("preferredDate", preferredDate);
        requestDataMap.put("preferredTimeSlot", preferredSchedule.slotLabel());
        requestDataMap.put("preferredTimeFrom", preferredSchedule.timeFrom() == null ? "" : preferredSchedule.timeFrom().toString());
        requestDataMap.put("preferredTimeTo", preferredSchedule.timeTo() == null ? "" : preferredSchedule.timeTo().toString());
        requestDataMap.put("preferredDurationMinutes", preferredSchedule.durationMinutes() == null ? "" : String.valueOf(preferredSchedule.durationMinutes()));
        requestDataMap.put("title", title);
        requestDataMap.put("description", description);
        requestDataMap.put("reporterName", user.getFullName());
        requestDataMap.put("reporterPhone", user.getPhone());
        requestDataMap.put("reporterEmail", user.getEmail());

        SystemRequest request = new SystemRequest();
        request.setSenderId((long) user.getId());
        request.setReceiverRole("STAFF");
        request.setRequestType("INCIDENT_REPORT");
        request.setRequestData(new Gson().toJson(requestDataMap));
        request.setStatus(DEFAULT_INCIDENT_STATUS);
        return request;
    }

    private Product resolveReportedProduct(HttpServletRequest req, Users user, ProductDAO productDAO) {
        Integer productId = parseInteger(req.getParameter("productId"));
        if (productId != null) {
            return productDAO.findCustomerProductWithContract(productId, user.getId());
        }

        Long contractId = parseLong(req.getParameter("contractId"));
        if (contractId == null) {
            return null;
        }

        List<Product> products = productServices.findByContractId(contractId);
        if (products == null || products.isEmpty()) {
            return null;
        }

        for (Product candidate : products) {
            Product authorizedProduct = productDAO.findCustomerProductWithContract(candidate.getId(), user.getId());
            if (authorizedProduct != null) {
                return authorizedProduct;
            }
        }
        return null;
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.parseInt(value.trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private Long parseLong(String value) {
        try {
            return value == null || value.isBlank() ? null : Long.parseLong(value.trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
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

    private record PreferredSchedule(Time timeFrom, Time timeTo, String slotLabel, Integer durationMinutes) {
        private static PreferredSchedule from(String rawSlot) {
            if (rawSlot == null || rawSlot.isBlank()) {
                return new PreferredSchedule(null, null, DEFAULT_TIME_SLOT, null);
            }

            String[] slotParts = rawSlot.split("\\|");
            if (slotParts.length != 3) {
                return new PreferredSchedule(null, null, DEFAULT_TIME_SLOT, null);
            }

            try {
                Time timeFrom = Time.valueOf(slotParts[0] + ":00");
                Time timeTo = Time.valueOf(slotParts[1] + ":00");
                return new PreferredSchedule(timeFrom, timeTo, slotParts[2], FIXED_SLOT_DURATION_MINUTES);
            } catch (IllegalArgumentException ex) {
                return new PreferredSchedule(null, null, DEFAULT_TIME_SLOT, null);
            }
        }
    }
}
