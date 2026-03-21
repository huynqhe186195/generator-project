package com.generatorproject.dao;

import com.generatorproject.model.Maintenance;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceDAO extends DbContext {

    // =========================
    // Lấy tất cả maintenance
    // =========================
    public List<Maintenance> getAll() {
        List<Maintenance> list = new ArrayList<>();
        String sql = "SELECT * FROM maintenances";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markCompleted(int id) {
        String sql = """
        UPDATE maintenances
        SET status = 'COMPLETED',
            completed_at = NOW()
        WHERE id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // Lấy maintenance theo ID
    // =========================
    public Maintenance getById(int id) {
        String sql = """
        SELECT m.*,
               pm.name AS product_name,
               p.serial_number AS product_serial_number
        FROM maintenances m
        JOIN products p ON m.product_id = p.id
        JOIN product_models pm ON p.model_id = pm.id
        WHERE m.id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public List<Maintenance> getByTechnicianFiltered(
            int technicianId,
            String status,
            String type) {

        List<Maintenance> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        	SELECT m.*, pm.name AS product_name,p.serial_number AS product_serial_number
                             FROM maintenances m
                             JOIN products p ON m.product_id = p.id
                             JOIN product_models pm ON m.product_id = pm.id
                             WHERE m.technician_id = ?
    """);

        if (status != null && !status.isEmpty()) {
            sql.append(" AND m.status = ? ");
        }

        if (type != null && !type.isEmpty()) {
            sql.append(" AND m.type = ? ");
        }

        sql.append(" ORDER BY m.maintenance_date DESC ");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, technicianId);

            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            if (type != null && !type.isEmpty()) {
                ps.setString(index++, type);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public int countByTechnicianFiltered(
            int technicianId,
            String status,
            String type
    ) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM maintenances
        WHERE technician_id = ?
    """);

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ? ");
        }

        if (type != null && !type.isEmpty()) {
            sql.append(" AND type = ? ");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, technicianId);

            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            if (type != null && !type.isEmpty()) {
                ps.setString(index++, type);
            }

            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    public List<Maintenance> getByTechnicianFilteredPaging(
            int technicianId,
            String status,
            String type,
            int page,
            int pageSize
    ) {
        List<Maintenance> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
    SELECT m.*, 
           pm.name AS product_name,
           p.serial_number AS product_serial_number
    FROM maintenances m
    JOIN products p ON m.product_id = p.id
    JOIN product_models pm ON p.model_id = pm.id
    WHERE m.technician_id = ?
""");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND m.status = ? ");
        }

        if (type != null && !type.isEmpty()) {
            sql.append(" AND m.type = ? ");
        }

        sql.append("""
        ORDER BY m.maintenance_date DESC
        LIMIT ? OFFSET ?
    """);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, technicianId);

            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            if (type != null && !type.isEmpty()) {
                ps.setString(index++, type);
            }

            ps.setInt(index++, pageSize);
            ps.setInt(index++, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public boolean updateAssignmentStatus(int id, String assignmentStatus) {
        String sql = """
        UPDATE maintenances
        SET assignment_status = ?
        WHERE id = ?
    """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, assignmentStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateActualReport(int id, String actualReport) {
        String sql = """
        UPDATE maintenances
        SET actual_description = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, actualReport);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



    // =========================
    // Cập nhật trạng thái
    // =========================
    public boolean updateStatus(int id, String status) {
        String sql = """
        UPDATE maintenances
        SET status = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateLaborCost(int id, double laborCost) {
        String sql = """
        UPDATE maintenances
        SET labor_cost = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, laborCost);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateTotalCost(int id, double totalCost) {
        String sql = """
        UPDATE maintenances
        SET total_cost = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, totalCost);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }




    // =========================
    // Mapper ResultSet → Model
    // =========================
    private Maintenance mapRow(ResultSet rs) throws Exception {
        Maintenance m = new Maintenance();

        m.setId(rs.getInt("id"));
        m.setProductId(rs.getInt("product_id"));
        m.setTechnicianId(rs.getInt("technician_id"));

        m.setIncidentId((Integer) rs.getObject("incident_id"));
        m.setMaintenanceDate(rs.getDate("maintenance_date"));
        m.setType(rs.getString("type"));
        m.setDescription(rs.getString("description"));
        m.setTotalCost(rs.getDouble("total_cost"));
        m.setStatus(rs.getString("status"));
        m.setLaborCost(rs.getDouble("labor_cost"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        m.setCreatedBy((Integer) rs.getObject("created_by"));
        m.setIncidentPlanId((Integer) rs.getObject("incident_plan_id"));
        m.setScheduledStart(rs.getTimestamp("scheduled_start"));
        m.setScheduledEnd(rs.getTimestamp("scheduled_end"));
        m.setScheduleStatus(rs.getString("schedule_status"));
        m.setExecutionStatus(rs.getString("execution_status"));
        m.setActualDescription(rs.getString("actual_description"));
        m.setAssignmentStatus(rs.getString("assignment_status"));
        m.setApprovedBy((Integer) rs.getObject("approved_by"));
        m.setCompletedAt(rs.getTimestamp("completed_at"));

        try {
            m.setProductName(rs.getString("product_name"));
        } catch (Exception ignored) {}
        try {
            m.setProductSerialNumber(
                    rs.getString("product_serial_number")
            );
        } catch (Exception ignored) {}



        return m;
    }

    public boolean insertMaintenance(Maintenance req) {
        // Lệnh SQL chỉ chọn các cột có trong bảng
        String sql = "INSERT INTO maintenances " +
                "(product_id, technician_id, maintenance_date, type, description, status) " +
                "VALUES (?, ?, CURRENT_DATE, ?, ?, 'SCHEDULED')";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {


            ps.setInt(1, req.getProductId());
            ps.setInt(2, req.getTechnicianId());
            // Bỏ dòng set preferredDate đi vì SQL đã tự lấy CURRENT_DATE rồi
            ps.setString(3, req.getType());
            ps.setString(4, req.getDescription());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Integer insertScheduledMaintenance(Maintenance req) {
        String sql = """
                INSERT INTO maintenances
                (product_id, technician_id, incident_id, incident_plan_id, maintenance_date,
                 scheduled_start, scheduled_end, estimated_duration_minutes, type, description,
                 status, schedule_status, execution_status, required_technician_count,
                 requires_parts_preparation, location, created_by)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'SCHEDULED', ?, ?, ?, ?, ?, ?)
                """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, req.getProductId());
            ps.setInt(2, req.getTechnicianId());
            if (req.getIncidentId() != null) ps.setInt(3, req.getIncidentId()); else ps.setNull(3, Types.INTEGER);
            if (req.getIncidentPlanId() != null) ps.setInt(4, req.getIncidentPlanId()); else ps.setNull(4, Types.INTEGER);
            ps.setDate(5, req.getMaintenanceDate());
            ps.setTimestamp(6, req.getScheduledStart());
            ps.setTimestamp(7, req.getScheduledEnd());
            int durationMinutes = 120;
            if (req.getScheduledStart() != null && req.getScheduledEnd() != null) {
                long diffMs = req.getScheduledEnd().getTime() - req.getScheduledStart().getTime();
                durationMinutes = (int) Math.max(30, diffMs / 60000);
            }
            ps.setInt(8, durationMinutes);
            ps.setString(9, req.getType());
            ps.setString(10, req.getDescription());
            ps.setString(11, req.getScheduleStatus() == null ? "MANAGER_APPROVED" : req.getScheduleStatus());
            ps.setString(12, req.getExecutionStatus() == null ? "PENDING" : req.getExecutionStatus());
            ps.setInt(13, 1);
            ps.setBoolean(14, false);
            ps.setString(15, req.getProductSerialNumber());
            if (req.getCreatedBy() != null) ps.setInt(16, req.getCreatedBy()); else ps.setNull(16, Types.INTEGER);

            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Maintenance> getHistoryCompletedPaging(
            int technicianId,
            String serial,
            String customer,
            String dateFrom,
            String dateTo,
            int page,
            int pageSize
    ) {
        List<Maintenance> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT m.*,
               p.serial_number AS product_serial_number,
               pm.name AS product_name,
               cu.full_name AS customer_name,
               cu.phone AS customer_phone
        FROM maintenances m
        JOIN products p ON m.product_id = p.id
        LEFT JOIN product_models pm ON p.model_id = pm.id
        LEFT JOIN users cu ON p.customer_id = cu.id
        WHERE m.technician_id = ?
          AND m.status = 'COMPLETED'
    """);

        if (serial != null && !serial.trim().isEmpty()) {
            sql.append(" AND p.serial_number LIKE ? ");
        }

        if (customer != null && !customer.trim().isEmpty()) {
            sql.append(" AND (cu.full_name LIKE ? OR cu.phone LIKE ?) ");
        }

        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND m.maintenance_date >= ? ");
        }

        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND m.maintenance_date <= ? ");
        }

        sql.append("""
        ORDER BY m.maintenance_date DESC
        LIMIT ? OFFSET ?
    """);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setInt(idx++, technicianId);

            if (serial != null && !serial.trim().isEmpty()) {
                ps.setString(idx++, "%" + serial.trim() + "%");
            }

            if (customer != null && !customer.trim().isEmpty()) {
                String kw = "%" + customer.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            if (dateFrom != null && !dateFrom.isEmpty()) {
                ps.setString(idx++, dateFrom);
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                ps.setString(idx++, dateTo);
            }

            ps.setInt(idx++, pageSize);
            ps.setInt(idx++, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Maintenance m = mapRow(rs);

                // các field show ra list
                m.setProductSerialNumber(rs.getString("product_serial_number"));
                m.setProductName(rs.getString("product_name"));

                // nếu mày đã thêm 2 field này trong Maintenance model:
                m.setCustomerName(rs.getString("customer_name"));
                m.setCustomerPhone(rs.getString("customer_phone"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countHistoryCompleted(
            int technicianId,
            String serial,
            String customer,
            String dateFrom,
            String dateTo
    ) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM maintenances m
        JOIN products p ON m.product_id = p.id
        LEFT JOIN users cu ON p.customer_id = cu.id
        WHERE m.technician_id = ?
          AND m.status = 'COMPLETED'
    """);

        if (serial != null && !serial.trim().isEmpty()) {
            sql.append(" AND p.serial_number LIKE ? ");
        }

        if (customer != null && !customer.trim().isEmpty()) {
            sql.append(" AND (cu.full_name LIKE ? OR cu.phone LIKE ?) ");
        }

        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND m.maintenance_date >= ? ");
        }

        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND m.maintenance_date <= ? ");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setInt(idx++, technicianId);

            if (serial != null && !serial.trim().isEmpty()) {
                ps.setString(idx++, "%" + serial.trim() + "%");
            }

            if (customer != null && !customer.trim().isEmpty()) {
                String kw = "%" + customer.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            if (dateFrom != null && !dateFrom.isEmpty()) {
                ps.setString(idx++, dateFrom);
            }

            if (dateTo != null && !dateTo.isEmpty()) {
                ps.setString(idx++, dateTo);
            }

            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }


}
