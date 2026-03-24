package com.generatorproject.dao;

import com.generatorproject.model.IncidentPlan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class IncidentPlanDAO extends DbContext {

    public Long insert(IncidentPlan plan) {
        String sql = """
                INSERT INTO incident_plans (
                    incident_id, planned_by, previous_plan_id, plan_version, is_current,
                    work_type, estimated_duration_minutes, required_technician_count,
                    requires_parts_preparation, parts_note, service_location,
                    priority_override, staff_note, manager_review_status
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, plan.getIncidentId());
            ps.setInt(2, plan.getPlannedBy());
            if (plan.getPreviousPlanId() != null) ps.setLong(3, plan.getPreviousPlanId()); else ps.setNull(3, java.sql.Types.BIGINT);
            ps.setInt(4, plan.getPlanVersion());
            ps.setBoolean(5, plan.isCurrent());
            ps.setString(6, plan.getWorkType());
            ps.setInt(7, plan.getEstimatedDurationMinutes());
            ps.setInt(8, plan.getRequiredTechnicianCount());
            ps.setBoolean(9, plan.isRequiresPartsPreparation());
            ps.setString(10, plan.getPartsNote());
            ps.setString(11, plan.getServiceLocation());
            ps.setString(12, plan.getPriorityOverride());
            ps.setString(13, plan.getStaffNote());
            ps.setString(14, plan.getManagerReviewStatus());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public IncidentPlan findById(Long id) {
        String sql = "SELECT * FROM incident_plans WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public IncidentPlan findLatestByIncidentId(int incidentId) {
        String sql = "SELECT * FROM incident_plans WHERE incident_id = ? AND is_current = 1 ORDER BY plan_version DESC, id DESC LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getNextVersion(int incidentId) {
        String sql = "SELECT COALESCE(MAX(plan_version), 0) + 1 FROM incident_plans WHERE incident_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1;
    }

    public void markNonCurrentByIncidentId(int incidentId) {
        String sql = "UPDATE incident_plans SET is_current = 0 WHERE incident_id = ? AND is_current = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateApproval(Long id, String status, Integer approvedBy, String rejectionReason) {
        String sql = """
                UPDATE incident_plans
                SET manager_review_status = ?,
                    approved_by = ?,
                    approved_at = ?,
                    rejection_reason = ?
                WHERE id = ?
                """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (approvedBy != null) ps.setInt(2, approvedBy); else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setTimestamp(3, "APPROVED".equalsIgnoreCase(status) ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setString(4, rejectionReason);
            ps.setLong(5, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private IncidentPlan map(ResultSet rs) throws Exception {
        IncidentPlan plan = new IncidentPlan();
        plan.setId(rs.getLong("id"));
        plan.setIncidentId(rs.getInt("incident_id"));
        plan.setPlannedBy(rs.getInt("planned_by"));
        Object previousPlanId = rs.getObject("previous_plan_id");
        plan.setPreviousPlanId(previousPlanId == null ? null : rs.getLong("previous_plan_id"));
        plan.setPlanVersion(rs.getInt("plan_version"));
        plan.setCurrent(rs.getBoolean("is_current"));
        plan.setWorkType(rs.getString("work_type"));
        plan.setEstimatedDurationMinutes(rs.getInt("estimated_duration_minutes"));
        plan.setRequiredTechnicianCount(rs.getInt("required_technician_count"));
        plan.setRequiresPartsPreparation(rs.getBoolean("requires_parts_preparation"));
        plan.setPartsNote(rs.getString("parts_note"));
        plan.setServiceLocation(rs.getString("service_location"));
        plan.setPriorityOverride(rs.getString("priority_override"));
        plan.setStaffNote(rs.getString("staff_note"));
        plan.setManagerReviewStatus(rs.getString("manager_review_status"));
        Object approvedBy = rs.getObject("approved_by");
        plan.setApprovedBy(approvedBy == null ? null : rs.getInt("approved_by"));
        plan.setApprovedAt(rs.getTimestamp("approved_at"));
        plan.setRejectionReason(rs.getString("rejection_reason"));
        plan.setCreatedAt(rs.getTimestamp("created_at"));
        plan.setUpdatedAt(rs.getTimestamp("updated_at"));
        return plan;
    }
}
