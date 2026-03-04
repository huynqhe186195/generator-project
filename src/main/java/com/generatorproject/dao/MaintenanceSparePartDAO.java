package com.generatorproject.dao;

import com.generatorproject.model.MaintenanceSparePart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceSparePartDAO extends DbContext {

    public void insert(int maintenanceId, int sparePartId, int quantityUsed) throws Exception {

        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // 1) Lock spare_part để lấy giá + tồn
            String getPartSQL = """
            SELECT price, quantity_in_stock
            FROM spare_parts
            WHERE id = ?
            FOR UPDATE
        """;
            PreparedStatement ps1 = conn.prepareStatement(getPartSQL);
            ps1.setInt(1, sparePartId);
            ResultSet rs1 = ps1.executeQuery();

            if (!rs1.next()) throw new Exception("Không tìm thấy vật tư");

            double price = rs1.getDouble("price");
            int stock = rs1.getInt("quantity_in_stock");

            if (stock < quantityUsed) throw new Exception("Không đủ tồn kho");

            double addCost = price * quantityUsed;

            // 2) Check đã có trong maintenance_spare_parts chưa (lock dòng đó)
            String checkSQL = """
            SELECT quantity_used, cost_at_time
            FROM maintenance_spare_parts
            WHERE maintenance_id = ? AND spare_part_id = ?
            FOR UPDATE
        """;
            PreparedStatement ps2 = conn.prepareStatement(checkSQL);
            ps2.setInt(1, maintenanceId);
            ps2.setInt(2, sparePartId);
            ResultSet rs2 = ps2.executeQuery();

            if (rs2.next()) {
                // 2a) Có rồi -> UPDATE cộng dồn
                String updateSQL = """
                UPDATE maintenance_spare_parts
                SET quantity_used = quantity_used + ?,
                    cost_at_time   = cost_at_time + ?
                WHERE maintenance_id = ? AND spare_part_id = ?
            """;
                PreparedStatement psUp = conn.prepareStatement(updateSQL);
                psUp.setInt(1, quantityUsed);
                psUp.setDouble(2, addCost);
                psUp.setInt(3, maintenanceId);
                psUp.setInt(4, sparePartId);
                psUp.executeUpdate();

            } else {
                // 2b) Chưa có -> INSERT mới
                String insertSQL = """
                INSERT INTO maintenance_spare_parts
                (maintenance_id, spare_part_id, quantity_used, cost_at_time)
                VALUES (?, ?, ?, ?)
            """;
                PreparedStatement psIns = conn.prepareStatement(insertSQL);
                psIns.setInt(1, maintenanceId);
                psIns.setInt(2, sparePartId);
                psIns.setInt(3, quantityUsed);
                psIns.setDouble(4, addCost);
                psIns.executeUpdate();
            }

            // 3) Trừ kho
            String updateStockSQL = """
            UPDATE spare_parts
            SET quantity_in_stock = quantity_in_stock - ?
            WHERE id = ?
        """;
            PreparedStatement ps3 = conn.prepareStatement(updateStockSQL);
            ps3.setInt(1, quantityUsed);
            ps3.setInt(2, sparePartId);
            ps3.executeUpdate();

            // 4) Recalc total_cost = SUM(cost_at_time)
            String recalcSQL = """
            UPDATE maintenances
            SET total_cost = (
                SELECT IFNULL(SUM(cost_at_time),0)
                FROM maintenance_spare_parts
                WHERE maintenance_id = ?
            )
            WHERE id = ?
        """;
            PreparedStatement ps4 = conn.prepareStatement(recalcSQL);
            ps4.setInt(1, maintenanceId);
            ps4.setInt(2, maintenanceId);
            ps4.executeUpdate();

            conn.commit();

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.setAutoCommit(true);
            if (conn != null) conn.close();
        }
    }

    public void deleteMaterial(int maintenanceId, int sparePartId) throws Exception {
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // 1) Lock dòng vật tư trong maintenance_spare_parts để lấy quantity_used
            String getSQL = """
            SELECT quantity_used
            FROM maintenance_spare_parts
            WHERE maintenance_id = ? AND spare_part_id = ?
            FOR UPDATE
        """;
            PreparedStatement ps1 = conn.prepareStatement(getSQL);
            ps1.setInt(1, maintenanceId);
            ps1.setInt(2, sparePartId);
            ResultSet rs = ps1.executeQuery();

            if (!rs.next()) throw new Exception("Không tìm thấy vật tư để xóa");

            int qty = rs.getInt("quantity_used");

            // 2) Xoá dòng
            String delSQL = """
            DELETE FROM maintenance_spare_parts
            WHERE maintenance_id = ? AND spare_part_id = ?
        """;
            PreparedStatement ps2 = conn.prepareStatement(delSQL);
            ps2.setInt(1, maintenanceId);
            ps2.setInt(2, sparePartId);
            ps2.executeUpdate();

            // 3) Hoàn kho
            String restoreSQL = """
            UPDATE spare_parts
            SET quantity_in_stock = quantity_in_stock + ?
            WHERE id = ?
        """;
            PreparedStatement ps3 = conn.prepareStatement(restoreSQL);
            ps3.setInt(1, qty);
            ps3.setInt(2, sparePartId);
            ps3.executeUpdate();

            // 4) Recalc total_cost
            String recalcSQL = """
            UPDATE maintenances
            SET total_cost = (
                SELECT IFNULL(SUM(cost_at_time),0)
                FROM maintenance_spare_parts
                WHERE maintenance_id = ?
            )
            WHERE id = ?
        """;
            PreparedStatement ps4 = conn.prepareStatement(recalcSQL);
            ps4.setInt(1, maintenanceId);
            ps4.setInt(2, maintenanceId);
            ps4.executeUpdate();

            conn.commit();

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.setAutoCommit(true);
            if (conn != null) conn.close();
        }
    }

    public boolean hasMaterials(int maintenanceId) {
        String sql = """
        SELECT 1
        FROM maintenance_spare_parts
        WHERE maintenance_id = ?
        LIMIT 1
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<MaintenanceSparePart> getByMaintenanceId(int maintenanceId) {

        List<MaintenanceSparePart> list = new ArrayList<>();

        String sql = """
        SELECT msp.maintenance_id,
               msp.spare_part_id,
               msp.quantity_used,
               msp.cost_at_time,
               sp.name AS spare_part_name,
               sp.part_code AS part_code,
               sp.unit AS unit
        FROM maintenance_spare_parts msp
        JOIN spare_parts sp ON msp.spare_part_id = sp.id
        WHERE msp.maintenance_id = ?
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceSparePart m = new MaintenanceSparePart(
                        rs.getInt("maintenance_id"),
                        rs.getInt("spare_part_id"),
                        rs.getInt("quantity_used"),
                        rs.getDouble("cost_at_time")
                );

                // NEW fields
                m.setSparePartName(rs.getString("spare_part_name"));
                m.setPartCode(rs.getString("part_code"));
                m.setUnit(rs.getString("unit"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


}
