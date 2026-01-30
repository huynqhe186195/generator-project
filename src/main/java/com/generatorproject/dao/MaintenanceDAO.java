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
        String sql = "SELECT * FROM maintenances WHERE id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Maintenance m = mapRow(rs);
                rs.close();
                ps.close();
                conn.close();
                return m;
            }

            rs.close();
            ps.close();
            conn.close();

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
        SELECT m.*, p.name AS product_name,p.serial_number AS product_serial_number
        FROM maintenances m
        JOIN products p ON m.product_id = p.id
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
    // Ghi báo cáo kỹ thuật
    // =========================
    public boolean updateDescription(int id, String description) {
        String sql = """
        UPDATE maintenances
        SET description = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, description);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateReport(int id, String report) {
        String sql = """
        UPDATE maintenances
        SET description = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, report);
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




}
