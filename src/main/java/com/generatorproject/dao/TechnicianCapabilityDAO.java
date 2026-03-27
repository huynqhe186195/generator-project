package com.generatorproject.dao;

import com.generatorproject.model.SkillCatalog;
import com.generatorproject.model.TechnicianProfile;
import com.generatorproject.model.TechnicianSkill;
import com.generatorproject.model.TechnicianUnavailability;

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
    private volatile Boolean hasServiceAreaColumn;

    public Map<Integer, TechnicianProfileSnapshot> findProfiles(List<Integer> technicianIds) {
        Map<Integer, TechnicianProfileSnapshot> profiles = new HashMap<>();
        if (technicianIds == null || technicianIds.isEmpty()) {
            return profiles;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(technicianIds.size(), "?"));
        String sql = "SELECT technician_id, " + serviceAreaSelectSql() + ", home_base, working_hours_start, working_hours_end, max_tasks_per_day, active_status, timezone_name " +
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

    public TechnicianProfile findProfileByTechnicianId(int technicianId) {
        String sql = "SELECT technician_id, " + serviceAreaSelectSql() + ", home_base, working_hours_start, working_hours_end, max_tasks_per_day, active_status, timezone_name " +
                "FROM technician_profiles WHERE technician_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TechnicianProfile profile = new TechnicianProfile();
                    profile.setTechnicianId(rs.getInt("technician_id"));
                    profile.setServiceArea(rs.getString("service_area"));
                    profile.setHomeBase(rs.getString("home_base"));
                    profile.setWorkingHoursStart(rs.getTime("working_hours_start"));
                    profile.setWorkingHoursEnd(rs.getTime("working_hours_end"));
                    profile.setMaxTasksPerDay(rs.getInt("max_tasks_per_day"));
                    profile.setActiveStatus(rs.getBoolean("active_status"));
                    profile.setTimezoneName(rs.getString("timezone_name"));
                    return profile;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean upsertProfile(TechnicianProfile profile) {
        if (profile == null) {
            return false;
        }

        if (findProfileByTechnicianId(profile.getTechnicianId()) == null) {
            String insertSql = hasServiceAreaColumn()
                    ? "INSERT INTO technician_profiles (technician_id, service_area, home_base, working_hours_start, working_hours_end, max_tasks_per_day, active_status, timezone_name) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                    : "INSERT INTO technician_profiles (technician_id, home_base, working_hours_start, working_hours_end, max_tasks_per_day, active_status, timezone_name) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, profile.getTechnicianId());
                if (hasServiceAreaColumn()) {
                    ps.setString(2, profile.getServiceArea());
                    ps.setString(3, profile.getHomeBase());
                    ps.setTime(4, profile.getWorkingHoursStart());
                    ps.setTime(5, profile.getWorkingHoursEnd());
                    if (profile.getMaxTasksPerDay() == null) {
                        ps.setNull(6, java.sql.Types.INTEGER);
                    } else {
                        ps.setInt(6, profile.getMaxTasksPerDay());
                    }
                    ps.setBoolean(7, profile.isActiveStatus());
                    ps.setString(8, profile.getTimezoneName());
                } else {
                    ps.setString(2, profile.getHomeBase());
                    ps.setTime(3, profile.getWorkingHoursStart());
                    ps.setTime(4, profile.getWorkingHoursEnd());
                    if (profile.getMaxTasksPerDay() == null) {
                        ps.setNull(5, java.sql.Types.INTEGER);
                    } else {
                        ps.setInt(5, profile.getMaxTasksPerDay());
                    }
                    ps.setBoolean(6, profile.isActiveStatus());
                    ps.setString(7, profile.getTimezoneName());
                }
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }

        String updateSql = hasServiceAreaColumn()
                ? "UPDATE technician_profiles SET service_area = ?, home_base = ?, working_hours_start = ?, working_hours_end = ?, max_tasks_per_day = ?, active_status = ?, timezone_name = ? WHERE technician_id = ?"
                : "UPDATE technician_profiles SET home_base = ?, working_hours_start = ?, working_hours_end = ?, max_tasks_per_day = ?, active_status = ?, timezone_name = ? WHERE technician_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(updateSql)) {
            if (hasServiceAreaColumn()) {
                ps.setString(1, profile.getServiceArea());
                ps.setString(2, profile.getHomeBase());
                ps.setTime(3, profile.getWorkingHoursStart());
                ps.setTime(4, profile.getWorkingHoursEnd());
                if (profile.getMaxTasksPerDay() == null) {
                    ps.setNull(5, java.sql.Types.INTEGER);
                } else {
                    ps.setInt(5, profile.getMaxTasksPerDay());
                }
                ps.setBoolean(6, profile.isActiveStatus());
                ps.setString(7, profile.getTimezoneName());
                ps.setInt(8, profile.getTechnicianId());
            } else {
                ps.setString(1, profile.getHomeBase());
                ps.setTime(2, profile.getWorkingHoursStart());
                ps.setTime(3, profile.getWorkingHoursEnd());
                if (profile.getMaxTasksPerDay() == null) {
                    ps.setNull(4, java.sql.Types.INTEGER);
                } else {
                    ps.setInt(4, profile.getMaxTasksPerDay());
                }
                ps.setBoolean(5, profile.isActiveStatus());
                ps.setString(6, profile.getTimezoneName());
                ps.setInt(7, profile.getTechnicianId());
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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

    public List<TechnicianSkill> findSkillsByTechnicianId(int technicianId) {
        List<TechnicianSkill> result = new ArrayList<>();
        String sql = "SELECT ts.technician_id, ts.skill_code, ts.expires_at, sc.name, sc.active_status " +
                "FROM technician_skills ts LEFT JOIN skill_catalog sc ON sc.code = ts.skill_code " +
                "WHERE ts.technician_id = ? ORDER BY ts.skill_code ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TechnicianSkill skill = new TechnicianSkill();
                    skill.setTechnicianId(rs.getInt("technician_id"));
                    skill.setSkillCode(rs.getString("skill_code"));
                    skill.setSkillName(rs.getString("name"));
                    skill.setExpiresAt(rs.getTimestamp("expires_at"));
                    skill.setCatalogActive(rs.getBoolean("active_status"));
                    result.add(skill);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean assignSkill(int technicianId, String skillCode, Timestamp expiresAt) {
        String sql = "INSERT INTO technician_skills (technician_id, skill_code, expires_at) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setString(2, skillCode);
            if (expiresAt == null) {
                ps.setNull(3, java.sql.Types.TIMESTAMP);
            } else {
                ps.setTimestamp(3, expiresAt);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeSkill(int technicianId, String skillCode) {
        String sql = "DELETE FROM technician_skills WHERE technician_id = ? AND skill_code = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setString(2, skillCode);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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

    public List<SkillCatalog> findAllSkillCatalog() {
        List<SkillCatalog> result = new ArrayList<>();
        String sql = "SELECT code, name, active_status FROM skill_catalog ORDER BY active_status DESC, code ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SkillCatalog skill = new SkillCatalog();
                skill.setCode(rs.getString("code"));
                skill.setName(rs.getString("name"));
                skill.setActiveStatus(rs.getBoolean("active_status"));
                result.add(skill);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public SkillCatalog findSkillCatalogByCode(String code) {
        String sql = "SELECT code, name, active_status FROM skill_catalog WHERE code = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SkillCatalog skill = new SkillCatalog();
                    skill.setCode(rs.getString("code"));
                    skill.setName(rs.getString("name"));
                    skill.setActiveStatus(rs.getBoolean("active_status"));
                    return skill;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertSkillCatalog(SkillCatalog skill) {
        String sql = "INSERT INTO skill_catalog (code, name, active_status) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, skill.getCode());
            ps.setString(2, skill.getName());
            ps.setBoolean(3, skill.isActiveStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSkillCatalog(SkillCatalog skill) {
        String sql = "UPDATE skill_catalog SET name = ?, active_status = ? WHERE code = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, skill.getName());
            ps.setBoolean(2, skill.isActiveStatus());
            ps.setString(3, skill.getCode());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSkillCatalog(String code) {
        String sql = "DELETE FROM skill_catalog WHERE code = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasSkillAssignmentsByCode(String code) {
        String sql = "SELECT 1 FROM technician_skills WHERE skill_code = ? LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return true;
        }
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

    public List<TechnicianUnavailability> findUnavailabilityByTechnicianId(int technicianId) {
        List<TechnicianUnavailability> result = new ArrayList<>();
        String sql = "SELECT technician_id, unavailable_start, unavailable_end FROM technician_unavailability WHERE technician_id = ? ORDER BY unavailable_start DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TechnicianUnavailability item = new TechnicianUnavailability();
                    item.setTechnicianId(rs.getInt("technician_id"));
                    item.setUnavailableStart(rs.getTimestamp("unavailable_start"));
                    item.setUnavailableEnd(rs.getTimestamp("unavailable_end"));
                    result.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean addUnavailability(TechnicianUnavailability item) {
        String sql = "INSERT INTO technician_unavailability (technician_id, unavailable_start, unavailable_end) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getTechnicianId());
            ps.setTimestamp(2, item.getUnavailableStart());
            ps.setTimestamp(3, item.getUnavailableEnd());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasSkillAssignment(int technicianId, String skillCode) {
        String sql = "SELECT 1 FROM technician_skills WHERE technician_id = ? AND skill_code = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setString(2, skillCode);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasUnavailabilityOverlap(int technicianId, Timestamp start, Timestamp end) {
        String sql = "SELECT 1 FROM technician_unavailability WHERE technician_id = ? AND unavailable_start < ? AND unavailable_end > ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setTimestamp(2, end);
            ps.setTimestamp(3, start);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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

    private String serviceAreaSelectSql() {
        return hasServiceAreaColumn() ? "service_area" : "NULL AS service_area";
    }

    private boolean hasServiceAreaColumn() {
        if (hasServiceAreaColumn != null) {
            return hasServiceAreaColumn;
        }
        synchronized (this) {
            if (hasServiceAreaColumn != null) {
                return hasServiceAreaColumn;
            }
            String sql = "SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'technician_profiles' AND COLUMN_NAME = 'service_area'";
            try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                hasServiceAreaColumn = rs.next();
            } catch (Exception e) {
                e.printStackTrace();
                hasServiceAreaColumn = Boolean.FALSE;
            }
            return hasServiceAreaColumn;
        }
    }
}
