package com.generatorproject.controller.manager;

import com.generatorproject.model.SkillCatalog;
import com.generatorproject.model.TechnicianProfile;
import com.generatorproject.model.TechnicianSkill;
import com.generatorproject.model.TechnicianUnavailability;
import com.generatorproject.model.Users;
import com.generatorproject.services.TechnicianCapabilityManagementService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/manager/technician-capability"})
public class TechnicianCapabilityManagementController extends HttpServlet {
    private final TechnicianCapabilityManagementService capabilityService;

    public TechnicianCapabilityManagementController() {
        this.capabilityService = new TechnicianCapabilityManagementService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users manager = requireManager(req, resp);
        if (manager == null) {
            return;
        }
        populateViewModel(req);
        req.getRequestDispatcher("/views/manager/technician-capability.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Users manager = requireManager(req, resp);
        if (manager == null) {
            return;
        }

        String action = req.getParameter("action");
        int technicianId = parseInt(req.getParameter("technicianId"), 0);
        String message = "saved";

        if ("save_profile".equals(action)) {
            boolean success = capabilityService.saveProfile(
                    technicianId,
                    req.getParameter("serviceArea"),
                    req.getParameter("homeBase"),
                    req.getParameter("workingHoursStart"),
                    req.getParameter("workingHoursEnd"),
                    parseIntegerObject(req.getParameter("maxTasksPerDay")),
                    "1".equals(req.getParameter("activeStatus")) || "on".equalsIgnoreCase(req.getParameter("activeStatus")),
                    req.getParameter("timezoneName")
            );
            message = success ? "profile_saved" : "profile_error";
        } else if ("assign_skill".equals(action)) {
            boolean success = capabilityService.assignSkill(technicianId, req.getParameter("skillCode"), req.getParameter("expiresAt"));
            message = success ? "skill_assigned" : "skill_error";
        } else if ("remove_skill".equals(action)) {
            boolean success = capabilityService.removeSkill(technicianId, req.getParameter("skillCode"));
            message = success ? "skill_removed" : "skill_remove_error";
        } else if ("add_unavailability".equals(action)) {
            boolean success = capabilityService.addUnavailability(technicianId, req.getParameter("unavailableStart"), req.getParameter("unavailableEnd"));
            message = success ? "unavailability_added" : "unavailability_error";
        } else if ("save_catalog".equals(action)) {
            boolean success = capabilityService.saveSkillCatalog(
                    req.getParameter("catalogCode"),
                    req.getParameter("catalogName"),
                    "1".equals(req.getParameter("catalogActive")) || "on".equalsIgnoreCase(req.getParameter("catalogActive"))
            );
            message = success ? "catalog_saved" : "catalog_error";
        }

        resp.sendRedirect(req.getContextPath() + "/manager/technician-capability?technicianId=" + technicianId + "&msg=" + message);
    }

    private void populateViewModel(HttpServletRequest req) {
        int selectedTechnicianId = parseInt(req.getParameter("technicianId"), 0);
        List<Users> technicians = capabilityService.getTechnicians();
        if (selectedTechnicianId <= 0 && !technicians.isEmpty()) {
            selectedTechnicianId = technicians.get(0).getId();
        }

        Users selectedTechnician = selectedTechnicianId > 0 ? capabilityService.getTechnician(selectedTechnicianId) : null;
        TechnicianProfile profile = selectedTechnicianId > 0 ? capabilityService.getProfile(selectedTechnicianId) : null;
        List<TechnicianSkill> assignedSkills = selectedTechnicianId > 0 ? capabilityService.getTechnicianSkills(selectedTechnicianId) : java.util.Collections.emptyList();
        List<TechnicianUnavailability> unavailability = selectedTechnicianId > 0 ? capabilityService.getUnavailability(selectedTechnicianId) : java.util.Collections.emptyList();
        List<SkillCatalog> skillCatalog = capabilityService.getSkillCatalog();

        req.setAttribute("technicians", technicians);
        req.setAttribute("selectedTechnicianId", selectedTechnicianId);
        req.setAttribute("selectedTechnician", selectedTechnician);
        req.setAttribute("profile", profile);
        req.setAttribute("workingHoursStartValue", profile != null && profile.getWorkingHoursStart() != null ? profile.getWorkingHoursStart().toString().substring(0, 5) : "");
        req.setAttribute("workingHoursEndValue", profile != null && profile.getWorkingHoursEnd() != null ? profile.getWorkingHoursEnd().toString().substring(0, 5) : "");
        req.setAttribute("assignedSkills", assignedSkills);
        req.setAttribute("unavailabilityList", unavailability);
        req.setAttribute("skillCatalog", skillCatalog);
        req.setAttribute("messageKey", req.getParameter("msg"));
    }

    private Users requireManager(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Users manager = session == null ? null : (Users) session.getAttribute("USERMODEL");
        if (manager == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return null;
        }
        return manager;
    }

    private int parseInt(String rawValue, int defaultValue) {
        try {
            return rawValue == null || rawValue.trim().isEmpty() ? defaultValue : Integer.parseInt(rawValue.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private Integer parseIntegerObject(String rawValue) {
        try {
            return rawValue == null || rawValue.trim().isEmpty() ? null : Integer.valueOf(rawValue.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
