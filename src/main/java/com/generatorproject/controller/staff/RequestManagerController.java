package com.generatorproject.controller.staff;

import com.generatorproject.model.Incident;
import com.generatorproject.model.IncidentPlan;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IIncidentPlanService;
import com.generatorproject.services.IIncidentServices;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.IncidentPlanService;
import com.generatorproject.services.IncidentServices;
import com.generatorproject.services.RequestServices;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

// Khớp với action: <form action="/staff/request-manager" ...>
@WebServlet(urlPatterns = { "/staff/request-manager" })
public class RequestManagerController extends HttpServlet {

    private final IRequestServices requestServices;
    private final IIncidentServices incidentServices;
    private final IIncidentPlanService incidentPlanService;

    public RequestManagerController() {
        requestServices = new RequestServices();
        incidentServices = new IncidentServices();
        incidentPlanService = new IncidentPlanService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Để đọc được tiếng Việt trong Ghi chú
        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("USERMODEL");
        if (user == null || user.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }
        try {
            // 1. Lấy dữ liệu từ Form
            String idStr = req.getParameter("incident_id");
            String priority = req.getParameter("priority");
            String type = req.getParameter("type");
            String staffNote = req.getParameter("staff_note");
            String estimatedDuration = req.getParameter("estimated_duration_minutes");
            String technicianCount = req.getParameter("required_technician_count");
            String serviceLocation = req.getParameter("service_location");
            String partsNote = req.getParameter("parts_note");
            String requiresPartsPreparation = req.getParameter("requires_parts_preparation");
            String selectedRecommendationCode = req.getParameter("selected_recommendation_code");
            String selectedRecommendationTitle = req.getParameter("selected_recommendation_title");
            String selectedSuggestedTechnicianIds = req.getParameter("selected_suggested_technician_ids");
            String selectedRequiredSkillCodes = req.getParameter("selected_required_skill_codes");

            long requestId = Long.parseLong(idStr);

            // 2. Lấy Request cũ từ DB để cập nhật thêm thông tin vào JSON
            SystemRequest sysReq = requestServices.findById(requestId);
            Map<String, Object> info = sysReq.getInfo();
            Long incidentId = parseLongValue(info.get("incidentId"));
            if (incidentId == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
                return;
            }
            Incident incident = incidentServices.findById(incidentId);
            if (incident == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }

            IncidentPlan plan = new IncidentPlan();
            plan.setIncidentId(incidentId.intValue());
            plan.setPlannedBy(user.getId());
            plan.setWorkType(type);
            plan.setEstimatedDurationMinutes(parseIntOrDefault(estimatedDuration, 120));
            plan.setRequiredTechnicianCount(parseIntOrDefault(technicianCount, 1));
            plan.setRequiresPartsPreparation("1".equals(requiresPartsPreparation) || "on".equalsIgnoreCase(requiresPartsPreparation));
            plan.setPartsNote(partsNote);
            plan.setServiceLocation(serviceLocation == null || serviceLocation.isBlank() ? incident.getLocationSnapshot() : serviceLocation);
            plan.setPriorityOverride(priority);
            plan.setStaffNote(staffNote);
            plan.setManagerReviewStatus("PENDING_APPROVAL");

            Long incidentPlanId = incidentPlanService.createDraft(plan);
            if (incidentPlanId == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
                return;
            }

            // Chèn thêm thông tin xử lý của Staff vào Map workflow
            info.put("incidentPlanId", incidentPlanId);
            info.put("priority", priority);
            info.put("maintenanceType", type);
            info.put("staffNote", staffNote);
            info.put("estimatedDurationMinutes", plan.getEstimatedDurationMinutes());
            info.put("requiredTechnicianCount", plan.getRequiredTechnicianCount());
            info.put("serviceLocation", plan.getServiceLocation());
            info.put("workflowKind", "INCIDENT_PLAN_APPROVAL");
            if (selectedRecommendationCode != null && !selectedRecommendationCode.trim().isEmpty()) {
                info.put("selectedRecommendationCode", selectedRecommendationCode);
                info.put("selectedRecommendationTitle", selectedRecommendationTitle);
                info.put("selectedSuggestedTechnicianIds", selectedSuggestedTechnicianIds);
                info.put("selectedRequiredSkillCodes", selectedRequiredSkillCodes);
            }


            // Đóng gói lại thành JSON
            String updatedJsonData = new Gson().toJson(info);

            // 3. Cập nhật vào DB
            sysReq.setRequestData(updatedJsonData);
            sysReq.setStatus("WAITING_MANAGER"); // Chuyển trạng thái sang Chờ Manager duyệt
            sysReq.setReceiverRole("MANAGER");
            sysReq.setSenderId((long)user.getId());




            // Gọi hàm update toàn bộ đối tượng (bao gồm data mới và status mới)
            requestServices.update(sysReq);

            // 4. Redirect về danh sách
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=escalated_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return value == null || value.isBlank() ? defaultValue : Integer.parseInt(value);
        } catch (Exception ignored) {
            return defaultValue;
        }
    }

    private Long parseLongValue(Object raw) {
        if (raw == null) return null;
        if (raw instanceof Number) return ((Number) raw).longValue();
        try {
            String s = String.valueOf(raw).trim();
            if (s.isEmpty()) return null;
            if (s.contains(".")) {
                return (long) Double.parseDouble(s);
            }
            return Long.parseLong(s);
        } catch (Exception ignored) {
            return null;
        }
    }
}
