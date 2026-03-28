package com.generatorproject.dao;

import com.generatorproject.model.IncidentPlan;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Timestamp;

public class IncidentPlanDAO extends DbContext {

    public Long insert(IncidentPlan plan) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(buildInsertSql(hasPreviousPlanColumn(conn)), PreparedStatement.RETURN_GENERATED_KEYS)) {

            boolean usePreviousPlanColumn = hasPreviousPlanColumn(conn);
            ps.setInt(1, plan.getIncidentId());
            ps.setInt(2, plan.getPlannedBy());

            int index = 3;
            if (usePreviousPlanColumn) {
                if (plan.getPreviousPlanId() != null) {
                    ps.setLong(index, plan.getPreviousPlanId());
                } else {
                    ps.setNull(index, java.sql.Types.BIGINT);
                }
                index++;
            }

            ps.setInt(index++, plan.getPlanVersion());
            ps.setBoolean(index++, plan.isCurrent());
            ps.setString(index++, plan.getWorkType());
            ps.setInt(index++, plan.getEstimatedDurationMinutes());
            ps.setInt(index++, plan.getRequiredTechnicianCount());
            ps.setBoolean(index++, plan.isRequiresPartsPreparation());
            ps.setString(index++, plan.getPartsNote());
            ps.setString(index++, plan.getServiceLocation());
            ps.setString(index++, plan.getPriorityOverride());
            ps.setString(index++, plan.getStaffNote());
            ps.setString(index, plan.getManagerReviewStatus());
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
        if (hasColumn(rs, "previous_plan_id")) {
            Object previousPlanId = rs.getObject("previous_plan_id");
            plan.setPreviousPlanId(previousPlanId == null ? null : rs.getLong("previous_plan_id"));
        } else {
            plan.setPreviousPlanId(null);
        }
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
        if (hasColumn(rs, "approved_by")) {
            Object approvedBy = rs.getObject("approved_by");
            plan.setApprovedBy(approvedBy == null ? null : rs.getInt("approved_by"));
        }
        if (hasColumn(rs, "approved_at")) {
            plan.setApprovedAt(rs.getTimestamp("approved_at"));
        }
        if (hasColumn(rs, "rejection_reason")) {
            plan.setRejectionReason(rs.getString("rejection_reason"));
        }
        if (hasColumn(rs, "created_at")) {
            plan.setCreatedAt(rs.getTimestamp("created_at"));
        }
        if (hasColumn(rs, "updated_at")) {
            plan.setUpdatedAt(rs.getTimestamp("updated_at"));
        }
        return plan;
    }

    private String buildInsertSql(boolean usePreviousPlanColumn) {
        if (usePreviousPlanColumn) {
            return """
                    INSERT INTO incident_plans (
                        incident_id, planned_by, previous_plan_id, plan_version, is_current,
                        work_type, estimated_duration_minutes, required_technician_count,
                        requires_parts_preparation, parts_note, service_location,
                        priority_override, staff_note, manager_review_status
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """;
        }
        return """
                INSERT INTO incident_plans (
                    incident_id, planned_by, plan_version, is_current,
                    work_type, estimated_duration_minutes, required_technician_count,
                    requires_parts_preparation, parts_note, service_location,
                    priority_override, staff_note, manager_review_status
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
    }

    private boolean hasPreviousPlanColumn(Connection conn) {
        try {
            DatabaseMetaData metaData = conn.getMetaData();
            try (ResultSet columns = metaData.getColumns(conn.getCatalog(), null, "incident_plans", "previous_plan_id")) {
                if (columns.next()) {
                    return true;
                }
            }
            try (ResultSet columns = metaData.getColumns(conn.getCatalog(), null, "INCIDENT_PLANS", "PREVIOUS_PLAN_ID")) {
                return columns.next();
            }
        } catch (Exception ignored) {
            return false;
        }
    }

    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            for (int i = 1; i <= columnCount; i++) {
                if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i))
                        || columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                    return true;
                }
            }
        } catch (Exception ignored) {
            return false;
        }
        return false;
    }
}
