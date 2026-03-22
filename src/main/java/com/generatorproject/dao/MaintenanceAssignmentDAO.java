package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

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
            if (assignedBy != null) ps.setInt(3, assignedBy); else ps.setNull(3, Types.INTEGER);
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

    public List<TechnicianScheduleItem> findSchedulesForTechnician(int technicianId, Timestamp windowStart, Timestamp windowEnd) {
        List<TechnicianScheduleItem> schedules = new ArrayList<>();
        if (windowStart == null || windowEnd == null) {
            return schedules;
        }

        String sql = "SELECT schedule_view.technician_id, schedule_view.maintenance_id, schedule_view.scheduled_start, " +
                "schedule_view.scheduled_end, schedule_view.description, schedule_view.type, p.serial_number " +
                "FROM (" +
                "    SELECT m.technician_id AS technician_id, m.id AS maintenance_id, m.scheduled_start, m.scheduled_end, m.description, m.type, m.product_id " +
                "    FROM maintenances m " +
                "    WHERE m.technician_id = ? " +
                "      AND m.scheduled_start IS NOT NULL " +
                "      AND m.scheduled_end IS NOT NULL " +
                "      AND COALESCE(m.execution_status, 'PENDING') <> 'CANCELLED' " +
                "      AND COALESCE(m.schedule_status, 'DRAFT') <> 'REJECTED' " +
                "      AND m.scheduled_end >= ? AND m.scheduled_start <= ? " +
                "    UNION ALL " +
                "    SELECT ma.technician_id AS technician_id, m.id AS maintenance_id, m.scheduled_start, m.scheduled_end, m.description, m.type, m.product_id " +
                "    FROM maintenances m " +
                "    JOIN maintenance_assignments ma ON ma.maintenance_id = m.id " +
                "    WHERE ma.technician_id = ? " +
                "      AND ma.assigned_status NOT IN ('CANCELLED', 'DECLINED') " +
                "      AND (m.technician_id IS NULL OR m.technician_id <> ma.technician_id) " +
                "      AND m.scheduled_start IS NOT NULL " +
                "      AND m.scheduled_end IS NOT NULL " +
                "      AND COALESCE(m.execution_status, 'PENDING') <> 'CANCELLED' " +
                "      AND COALESCE(m.schedule_status, 'DRAFT') <> 'REJECTED' " +
                "      AND m.scheduled_end >= ? AND m.scheduled_start <= ? " +
                ") schedule_view " +
                "LEFT JOIN products p ON p.id = schedule_view.product_id " +
                "ORDER BY schedule_view.scheduled_start";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ps.setTimestamp(2, windowStart);
            ps.setTimestamp(3, windowEnd);
            ps.setInt(4, technicianId);
            ps.setTimestamp(5, windowStart);
            ps.setTimestamp(6, windowEnd);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    schedules.add(new TechnicianScheduleItem(
                            rs.getInt("maintenance_id"),
                            rs.getTimestamp("scheduled_start"),
                            rs.getTimestamp("scheduled_end"),
                            rs.getString("description"),
                            rs.getString("type"),
                            rs.getString("serial_number")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return schedules;
    }

    public static class TechnicianScheduleItem {
        private final int maintenanceId;
        private final Timestamp scheduledStart;
        private final Timestamp scheduledEnd;
        private final String description;
        private final String type;
        private final String productSerialNumber;

        public TechnicianScheduleItem(int maintenanceId, Timestamp scheduledStart, Timestamp scheduledEnd, String description, String type, String productSerialNumber) {
            this.maintenanceId = maintenanceId;
            this.scheduledStart = scheduledStart;
            this.scheduledEnd = scheduledEnd;
            this.description = description;
            this.type = type;
            this.productSerialNumber = productSerialNumber;
        }

        public int getMaintenanceId() {
            return maintenanceId;
        }

        public Timestamp getScheduledStart() {
            return scheduledStart;
        }

        public Timestamp getScheduledEnd() {
            return scheduledEnd;
        }

        public String getDescription() {
            return description;
        }

        public String getType() {
            return type;
        }

        public String getProductSerialNumber() {
            return productSerialNumber;
        }
    }

}
