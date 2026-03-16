package com.generatorproject.controller.staff;

import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.model.Maintenance;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.RequestServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Map;

@WebServlet(urlPatterns = {"/staff/assign-task"})
public class AssignTaskController extends HttpServlet {

    private final IRequestServices requestServices;

    public AssignTaskController() {
        requestServices = new RequestServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            String idStr = req.getParameter("id");
            long requestId = Long.parseLong(idStr);

            SystemRequest sysReq = requestServices.findById(requestId);

            if (sysReq != null && sysReq.getRequestData() != null) {
                Maintenance taskData = buildMaintenanceFromRequestData(sysReq.getInfo());

                if (taskData != null) {
                    MaintenanceDAO maintenanceDAO = new MaintenanceDAO();

                    if (taskData.getMaintenanceDate() != null
                            && taskData.getStartTime() != null
                            && taskData.getEndTime() != null
                            && maintenanceDAO.hasScheduleConflict(taskData.getTechnicianId(), taskData.getMaintenanceDate(), taskData.getStartTime(), taskData.getEndTime())) {
                        resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=schedule_conflict");
                        return;
                    }

                    boolean isSuccess = maintenanceDAO.insertMaintenance(taskData);

                    if (isSuccess) {
                        sysReq.setStatus("TASK_CREATED");
                        requestServices.update(sysReq);

                        resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=task_created_success");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=insert_error");
                    }
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=system_error");
        }
    }

    private Maintenance buildMaintenanceFromRequestData(Map<String, Object> data) {
        if (data == null) return null;

        Integer productId = toInteger(data.get("productId"));
        Integer technicianId = toInteger(data.get("technicianId"));

        if (productId == null || technicianId == null) {
            return null;
        }

        Maintenance maintenance = new Maintenance();
        maintenance.setProductId(productId);
        maintenance.setTechnicianId(technicianId);
        maintenance.setType(toString(data.get("maintenanceType"), "REPAIR"));
        maintenance.setDescription(toString(data.get("description"), null));

        Date maintenanceDate = parseDate(data.get("preferredDate"));
        maintenance.setMaintenanceDate(maintenanceDate != null ? maintenanceDate : Date.valueOf(LocalDate.now()));

        maintenance.setStartTime(parseTime(data.get("startTime")));
        maintenance.setEndTime(parseTime(data.get("endTime")));

        return maintenance;
    }

    private Integer toInteger(Object raw) {
        if (raw == null) return null;
        if (raw instanceof Number) return ((Number) raw).intValue();
        try {
            String str = String.valueOf(raw).trim();
            if (str.isEmpty()) return null;
            return Integer.parseInt(str);
        } catch (Exception ignored) {
            return null;
        }
    }

    private String toString(Object raw, String defaultValue) {
        if (raw == null) return defaultValue;
        String str = String.valueOf(raw).trim();
        return str.isEmpty() ? defaultValue : str;
    }

    private Date parseDate(Object raw) {
        try {
            String str = toString(raw, null);
            if (str == null) return null;
            return Date.valueOf(str);
        } catch (Exception ignored) {
            return null;
        }
    }

    private Time parseTime(Object raw) {
        try {
            String str = toString(raw, null);
            if (str == null) return null;
            if (str.length() == 5) {
                str = str + ":00";
            }
            return Time.valueOf(LocalTime.parse(str));
        } catch (Exception ignored) {
            return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
