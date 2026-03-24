package com.generatorproject.services;

import com.generatorproject.dao.TechnicianCapabilityDAO;
import com.generatorproject.model.SkillCatalog;
import com.generatorproject.model.TechnicianProfile;
import com.generatorproject.model.TechnicianSkill;
import com.generatorproject.model.TechnicianUnavailability;
import com.generatorproject.model.Users;

import java.sql.Time;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;

public class TechnicianCapabilityManagementService {
    private final TechnicianCapabilityDAO technicianCapabilityDAO;
    private final IUserServices userServices;

    public TechnicianCapabilityManagementService() {
        this.technicianCapabilityDAO = new TechnicianCapabilityDAO();
        this.userServices = new UserServices();
    }

    public List<Users> getTechnicians() {
        return userServices.findUserByRoleId(4);
    }

    public TechnicianProfile getProfile(int technicianId) {
        TechnicianProfile profile = technicianCapabilityDAO.findProfileByTechnicianId(technicianId);
        if (profile != null) {
            return profile;
        }

        TechnicianProfile fallback = new TechnicianProfile();
        fallback.setTechnicianId(technicianId);
        fallback.setWorkingHoursStart(Time.valueOf("08:00:00"));
        fallback.setWorkingHoursEnd(Time.valueOf("17:00:00"));
        fallback.setMaxTasksPerDay(3);
        fallback.setActiveStatus(true);
        fallback.setTimezoneName("Asia/Ho_Chi_Minh");
        return fallback;
    }

    public boolean saveProfile(int technicianId,
                               String serviceArea,
                               String homeBase,
                               String workingHoursStart,
                               String workingHoursEnd,
                               Integer maxTasksPerDay,
                               boolean activeStatus,
                               String timezoneName) {
        if (technicianId <= 0 || workingHoursStart == null || workingHoursEnd == null) {
            return false;
        }

        TechnicianProfile profile = new TechnicianProfile();
        profile.setTechnicianId(technicianId);
        profile.setServiceArea(blankToNull(serviceArea));
        profile.setHomeBase(blankToNull(homeBase));
        profile.setWorkingHoursStart(Time.valueOf(workingHoursStart.trim() + ":00"));
        profile.setWorkingHoursEnd(Time.valueOf(workingHoursEnd.trim() + ":00"));
        profile.setMaxTasksPerDay(maxTasksPerDay);
        profile.setActiveStatus(activeStatus);
        profile.setTimezoneName(blankToNull(timezoneName));
        return technicianCapabilityDAO.upsertProfile(profile);
    }

    public List<TechnicianSkill> getTechnicianSkills(int technicianId) {
        return technicianCapabilityDAO.findSkillsByTechnicianId(technicianId);
    }

    public boolean assignSkill(int technicianId, String skillCode, String expiresAtRaw) {
        if (technicianId <= 0 || skillCode == null || skillCode.trim().isEmpty()) {
            return false;
        }
        if (technicianCapabilityDAO.hasSkillAssignment(technicianId, skillCode.trim())) {
            return false;
        }
        Timestamp expiresAt = parseDateTimeLocal(expiresAtRaw);
        return technicianCapabilityDAO.assignSkill(technicianId, skillCode.trim(), expiresAt);
    }

    public boolean removeSkill(int technicianId, String skillCode) {
        if (technicianId <= 0 || skillCode == null || skillCode.trim().isEmpty()) {
            return false;
        }
        return technicianCapabilityDAO.removeSkill(technicianId, skillCode.trim());
    }

    public List<SkillCatalog> getSkillCatalog() {
        return technicianCapabilityDAO.findAllSkillCatalog();
    }

    public boolean saveSkillCatalog(String code, String name, boolean activeStatus) {
        if (code == null || code.trim().isEmpty() || name == null || name.trim().isEmpty()) {
            return false;
        }
        SkillCatalog item = new SkillCatalog();
        item.setCode(code.trim().toUpperCase());
        item.setName(name.trim());
        item.setActiveStatus(activeStatus);
        if (technicianCapabilityDAO.findSkillCatalogByCode(item.getCode()) == null) {
            return technicianCapabilityDAO.insertSkillCatalog(item);
        }
        return technicianCapabilityDAO.updateSkillCatalog(item);
    }

    public List<TechnicianUnavailability> getUnavailability(int technicianId) {
        if (technicianId <= 0) {
            return Collections.emptyList();
        }
        return technicianCapabilityDAO.findUnavailabilityByTechnicianId(technicianId);
    }

    public boolean addUnavailability(int technicianId, String startRaw, String endRaw) {
        Timestamp start = parseDateTimeLocal(startRaw);
        Timestamp end = parseDateTimeLocal(endRaw);
        if (technicianId <= 0 || start == null || end == null || !end.after(start)) {
            return false;
        }
        if (technicianCapabilityDAO.hasUnavailabilityOverlap(technicianId, start, end)) {
            return false;
        }
        TechnicianUnavailability item = new TechnicianUnavailability();
        item.setTechnicianId(technicianId);
        item.setUnavailableStart(start);
        item.setUnavailableEnd(end);
        return technicianCapabilityDAO.addUnavailability(item);
    }

    public Users getTechnician(int technicianId) {
        return userServices.findUserById(technicianId);
    }

    private Timestamp parseDateTimeLocal(String rawValue) {
        try {
            if (rawValue == null || rawValue.trim().isEmpty()) {
                return null;
            }
            return Timestamp.valueOf(rawValue.trim().replace("T", " ") + ":00");
        } catch (Exception e) {
            return null;
        }
    }

    private String blankToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
