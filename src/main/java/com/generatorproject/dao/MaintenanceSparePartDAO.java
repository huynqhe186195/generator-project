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
            conn.setAutoCommit(false); // 🔥 BẮT ĐẦU TRANSACTION

            // 1️⃣ Lấy giá + tồn kho
            String getPartSQL = """
                SELECT price, quantity_in_stock
                FROM spare_parts
                WHERE id = ?
                FOR UPDATE
            """;
            PreparedStatement ps1 = conn.prepareStatement(getPartSQL);
            ps1.setInt(1, sparePartId);
            ResultSet rs = ps1.executeQuery();

            if (!rs.next()) {
                throw new Exception("Không tìm thấy vật tư");
            }

            double price = rs.getDouble("price");
            int stock = rs.getInt("quantity_in_stock");

            if (stock < quantityUsed) {
                throw new Exception("Không đủ tồn kho");
            }

            double costAtTime = price * quantityUsed;

            // 2️⃣ Insert maintenance_spare_parts
            String insertSQL = """
                INSERT INTO maintenance_spare_parts
                (maintenance_id, spare_part_id, quantity_used, cost_at_time)
                VALUES (?, ?, ?, ?)
            """;
            PreparedStatement ps2 = conn.prepareStatement(insertSQL);
            ps2.setInt(1, maintenanceId);
            ps2.setInt(2, sparePartId);
            ps2.setInt(3, quantityUsed);
            ps2.setDouble(4, costAtTime);
            ps2.executeUpdate();

            // 3️⃣ Trừ kho
            String updateStockSQL = """
                UPDATE spare_parts
                SET quantity_in_stock = quantity_in_stock - ?
                WHERE id = ?
            """;
            PreparedStatement ps3 = conn.prepareStatement(updateStockSQL);
            ps3.setInt(1, quantityUsed);
            ps3.setInt(2, sparePartId);
            ps3.executeUpdate();

            // 4️⃣ Cộng tiền maintenance
            String updateMaintenanceSQL = """
                UPDATE maintenances
                SET total_cost = total_cost + ?
                WHERE id = ?
            """;
            PreparedStatement ps4 = conn.prepareStatement(updateMaintenanceSQL);
            ps4.setDouble(1, costAtTime);
            ps4.setInt(2, maintenanceId);
            ps4.executeUpdate();

            conn.commit(); // ✅ OK TẤT CẢ

        } catch (Exception e) {
            if (conn != null) conn.rollback(); // 💥 FAIL → ROLLBACK
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
        SELECT maintenance_id,
               spare_part_id,
               quantity_used,
               cost_at_time
        FROM maintenance_spare_parts
        WHERE maintenance_id = ?
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
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


}
