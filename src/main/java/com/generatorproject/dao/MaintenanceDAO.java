package com.generatorproject.dao;

import com.generatorproject.model.Maintenance;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
        SELECT m.*, pm.name AS product_name,
               p.serial_number AS product_serial_number
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

        m.setCreatedAt(rs.getTimestamp("created_at"));
        m.setCreatedBy((Integer) rs.getObject("created_by"));
        m.setActualDescription(rs.getString("actual_description"));
        m.setAssignmentStatus(rs.getString("assignment_status"));
        m.setApprovedBy((Integer) rs.getObject("approved_by"));


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

//    public void assignTechnician(Maintenance maintenance){
//        String sql = "INSERT INTO maintenances(product_id, technician_id, incident_id, type, description,create_at,create_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
//
//        try (Connection conn = getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt();
//
//            int rowsAffected = ps.executeUpdate();
//
//            return rowsAffected > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }


}
