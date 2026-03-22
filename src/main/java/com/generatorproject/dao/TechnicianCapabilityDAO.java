package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class TechnicianCapabilityDAO extends DbContext {

    public Map<Integer, TechnicianProfileSnapshot> findProfiles(List<Integer> technicianIds) {
        Map<Integer, TechnicianProfileSnapshot> profiles = new HashMap<>();
        if (technicianIds == null || technicianIds.isEmpty()) {
            return profiles;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(technicianIds.size(), "?"));
        String sql = "SELECT technician_id, service_area, home_base, working_hours_start, working_hours_end, max_tasks_per_day, active_status, timezone_name " +
                "FROM technician_profiles WHERE technician_id IN (" + placeholders + ")";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            for (Integer technicianId : technicianIds) {
                ps.setInt(index++, technicianId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    profiles.put(rs.getInt("technician_id"), new TechnicianProfileSnapshot(
                            rs.getString("service_area"),
                            rs.getString("home_base"),
                            rs.getTime("working_hours_start"),
                            rs.getTime("working_hours_end"),
                            rs.getInt("max_tasks_per_day"),
                            rs.getBoolean("active_status"),
                            rs.getString("timezone_name")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return profiles;
    }

    public Map<Integer, Set<String>> findTechnicianSkillCodes(List<Integer> technicianIds) {
        Map<Integer, Set<String>> skillMap = new HashMap<>();
        if (technicianIds == null || technicianIds.isEmpty()) {
            return skillMap;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(technicianIds.size(), "?"));
        String sql = "SELECT technician_id, skill_code FROM technician_skills WHERE technician_id IN (" + placeholders + ") " +
                "AND (expires_at IS NULL OR expires_at >= NOW())";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            for (Integer technicianId : technicianIds) {
                ps.setInt(index++, technicianId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skillMap.computeIfAbsent(rs.getInt("technician_id"), key -> new HashSet<>())
                            .add(rs.getString("skill_code"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return skillMap;
    }

    public Map<String, String> findSkillNames(List<String> skillCodes) {
        Map<String, String> skillNames = new HashMap<>();
        if (skillCodes == null || skillCodes.isEmpty()) {
            return skillNames;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(skillCodes.size(), "?"));
        String sql = "SELECT code, name FROM skill_catalog WHERE code IN (" + placeholders + ") AND active_status = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            for (String skillCode : skillCodes) {
                ps.setString(index++, skillCode);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skillNames.put(rs.getString("code"), rs.getString("name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return skillNames;
    }

    public Map<Integer, Boolean> findUnavailability(List<Integer> technicianIds, Timestamp from, Timestamp to) {
        Map<Integer, Boolean> unavailable = new HashMap<>();
        if (technicianIds == null || technicianIds.isEmpty() || from == null || to == null) {
            return unavailable;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(technicianIds.size(), "?"));
        String sql = "SELECT DISTINCT technician_id FROM technician_unavailability WHERE technician_id IN (" + placeholders + ") " +
                "AND unavailable_start < ? AND unavailable_end > ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            for (Integer technicianId : technicianIds) {
                ps.setInt(index++, technicianId);
            }
            ps.setTimestamp(index++, to);
            ps.setTimestamp(index, from);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    unavailable.put(rs.getInt("technician_id"), Boolean.TRUE);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return unavailable;
    }

    public Map<Integer, Integer> countTasksPerDay(List<Integer> technicianIds, java.sql.Date targetDate) {
        Map<Integer, Integer> counts = new HashMap<>();
        if (technicianIds == null || technicianIds.isEmpty() || targetDate == null) {
            return counts;
        }
        String placeholders = String.join(",", java.util.Collections.nCopies(technicianIds.size(), "?"));
        String sql = "SELECT technician_id, COUNT(*) total_tasks FROM maintenances WHERE technician_id IN (" + placeholders + ") " +
                "AND DATE(scheduled_start) = ? AND COALESCE(execution_status, 'PENDING') <> 'CANCELLED' GROUP BY technician_id";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            for (Integer technicianId : technicianIds) {
                ps.setInt(index++, technicianId);
            }
            ps.setDate(index, targetDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    counts.put(rs.getInt("technician_id"), rs.getInt("total_tasks"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    public static class TechnicianProfileSnapshot {
        private final String serviceArea;
        private final String homeBase;
        private final Time workingHoursStart;
        private final Time workingHoursEnd;
        private final Integer maxTasksPerDay;
        private final boolean active;
        private final String timezoneName;

        public TechnicianProfileSnapshot(String serviceArea, String homeBase, Time workingHoursStart, Time workingHoursEnd, Integer maxTasksPerDay, boolean active, String timezoneName) {
            this.serviceArea = serviceArea;
            this.homeBase = homeBase;
            this.workingHoursStart = workingHoursStart;
            this.workingHoursEnd = workingHoursEnd;
            this.maxTasksPerDay = maxTasksPerDay;
            this.active = active;
            this.timezoneName = timezoneName;
        }

        public String getServiceArea() { return serviceArea; }
        public String getHomeBase() { return homeBase; }
        public Time getWorkingHoursStart() { return workingHoursStart; }
        public Time getWorkingHoursEnd() { return workingHoursEnd; }
        public Integer getMaxTasksPerDay() { return maxTasksPerDay; }
        public boolean isActive() { return active; }
        public String getTimezoneName() { return timezoneName; }
    }
}
