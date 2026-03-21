package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class MaintenanceAssignmentDAO extends DbContext {
    public boolean insertPrimaryAssignment(int maintenanceId, int technicianId, Integer assignedBy, String note) {
        String sql = """
                INSERT INTO maintenance_assignments
                (maintenance_id, technician_id, assignment_role, assigned_status, assigned_at, assigned_by, note)
                VALUES (?, ?, 'PRIMARY', 'ASSIGNED', NOW(), ?, ?)
                """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ps.setInt(2, technicianId);
            if (assignedBy != null) ps.setInt(3, assignedBy); else ps.setNull(3, java.sql.Types.INTEGER);
            ps.setString(4, note);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasScheduleConflict(int technicianId, Timestamp scheduledStart, Timestamp scheduledEnd) {
        String sql = """
                SELECT COUNT(DISTINCT m.id)
                FROM maintenances m
                LEFT JOIN maintenance_assignments ma
                    ON ma.maintenance_id = m.id
                   AND ma.assigned_status NOT IN ('CANCELLED', 'DECLINED')
                WHERE (
                        m.technician_id = ?
                        OR ma.technician_id = ?
                      )
                  AND m.scheduled_start IS NOT NULL
                  AND m.scheduled_end IS NOT NULL
                  AND COALESCE(m.execution_status, 'PENDING') <> 'CANCELLED'
                  AND COALESCE(m.schedule_status, 'DRAFT') <> 'REJECTED'
                  AND ? < m.scheduled_end
                  AND ? > m.scheduled_start
                """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setInt(2, technicianId);
            ps.setTimestamp(3, scheduledStart);
            ps.setTimestamp(4, scheduledEnd);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
