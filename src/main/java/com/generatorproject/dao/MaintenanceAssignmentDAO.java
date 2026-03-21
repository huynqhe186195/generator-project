package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

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
}
