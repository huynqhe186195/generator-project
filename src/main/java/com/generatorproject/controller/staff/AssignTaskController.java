package com.generatorproject.controller.staff;

import com.generatorproject.dao.IncidentPlanDAO;
import com.generatorproject.dao.MaintenanceAssignmentDAO;
import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.model.Incident;
import com.generatorproject.model.IncidentPlan;
import com.generatorproject.model.Maintenance;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IIncidentServices;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.IncidentServices;
import com.generatorproject.services.RequestServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet(urlPatterns = {"/staff/assign-task"})
public class AssignTaskController extends HttpServlet {

    private final IRequestServices requestServices;
    private final IIncidentServices incidentServices;
    private final IncidentPlanDAO incidentPlanDAO;
    private final MaintenanceDAO maintenanceDAO;
    private final MaintenanceAssignmentDAO maintenanceAssignmentDAO;

    public AssignTaskController() {
        requestServices = new RequestServices();
        incidentServices = new IncidentServices();
        incidentPlanDAO = new IncidentPlanDAO();
        maintenanceDAO = new MaintenanceDAO();
        maintenanceAssignmentDAO = new MaintenanceAssignmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("USERMODEL");



        try {
            String idStr = req.getParameter("id");
            String technicianIdRaw = req.getParameter("technicianId");
            String scheduledStartRaw = req.getParameter("scheduledStart");
            String scheduledEndRaw = req.getParameter("scheduledEnd");
            long requestId = Long.parseLong(idStr);
            int technicianId = Integer.parseInt(technicianIdRaw);

            SystemRequest sysReq = requestServices.findById(requestId);
            if (sysReq == null || sysReq.getInfo() == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }

            Long incidentId = parseLongValue(sysReq.getInfo().get("incidentId"));
            Long incidentPlanId = parseLongValue(sysReq.getInfo().get("incidentPlanId"));
            if (incidentId == null || incidentPlanId == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }
            Incident incident = incidentServices.findById(incidentId);
            IncidentPlan plan = incidentPlanDAO.findById(incidentPlanId);
            if (incident == null || plan == null || !"APPROVED".equalsIgnoreCase(plan.getManagerReviewStatus())) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }

            Timestamp scheduledStart = Timestamp.valueOf(scheduledStartRaw.replace("T", " ") + ":00");
            Timestamp scheduledEnd = Timestamp.valueOf(scheduledEndRaw.replace("T", " ") + ":00");

            Maintenance taskData = new Maintenance();
            taskData.setProductId(incident.getProductId());
            taskData.setTechnicianId(technicianId);
            taskData.setIncidentId(incidentId.intValue());
            taskData.setIncidentPlanId(incidentPlanId.intValue());
            taskData.setMaintenanceDate(new Date(scheduledStart.getTime()));
            taskData.setScheduledStart(scheduledStart);
            taskData.setScheduledEnd(scheduledEnd);
            taskData.setType(plan.getWorkType());
            taskData.setDescription(incident.getTitle() + " - " + (plan.getStaffNote() == null ? incident.getDescription() : plan.getStaffNote()));
            taskData.setScheduleStatus("MANAGER_APPROVED");
            taskData.setExecutionStatus("PENDING");
            taskData.setCreatedBy(user == null ? null : user.getId());

            Integer maintenanceId = maintenanceDAO.insertScheduledMaintenance(taskData);
            if (maintenanceId == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=insert_error");
                return;
            }

            maintenanceAssignmentDAO.insertPrimaryAssignment(maintenanceId, technicianId, user == null ? null : user.getId(),
                    "Assigned after manager-approved incident plan");

            sysReq.setStatus("TASK_CREATED");
            requestServices.update(sysReq);
            incidentServices.updateStatus(incidentId, "TASK_CREATED");

            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=task_created_success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=system_error");
        }
    }

    // Nếu bạn vẫn muốn dùng thẻ <a> (GET), bạn nên copy logic sang doGet hoặc gọi doPost trong doGet
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
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
