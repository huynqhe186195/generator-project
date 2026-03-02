package com.generatorproject.dao;

import com.generatorproject.model.SparePart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SparePartDAO extends DbContext {

    // =========================
    // Lấy toàn bộ vật tư
    // =========================
    public List<SparePart> getAll() {
        List<SparePart> list = new ArrayList<>();
        String sql = "SELECT * FROM spare_parts ORDER BY name";

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
    // Lấy tên và mã vật tư theo ID (Dùng cho Form Báo giá)
    // =========================
    public String getPartNameById(int id) {
        // Sử dụng hàm CONCAT của SQL để nối chuỗi luôn ở dưới DB
        String sql = "SELECT CONCAT(name, ' (', part_code, ')') AS full_name FROM spare_parts WHERE id = ?";
        String partName = "Vật tư không xác định";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                partName = rs.getString("full_name");
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return partName;
    }
    // =========================
    // Tìm theo tên / mã
    // =========================
    public List<SparePart> search(String keyword) {
        List<SparePart> list = new ArrayList<>();
        String sql = """
            SELECT * FROM spare_parts
            WHERE name LIKE ? OR part_code LIKE ?
            ORDER BY name
        """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

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
    // Lấy theo ID
    // =========================
    public SparePart getById(int id) {
        String sql = "SELECT * FROM spare_parts WHERE id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SparePart p = mapRow(rs);
                rs.close();
                ps.close();
                conn.close();
                return p;
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // INSERT
    // =========================
    public boolean insert(SparePart p) {
        String sql = """
            INSERT INTO spare_parts
            (name, part_code, unit, quantity_in_stock, min_stock_alert, price, description)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, p.getName());
            ps.setString(2, p.getPartCode());
            ps.setString(3, p.getUnit());
            ps.setInt(4, p.getQuantityInStock());
            ps.setInt(5, p.getMinStockAlert());
            ps.setDouble(6, p.getPrice());
            ps.setString(7, p.getDescription());

            boolean result = ps.executeUpdate() > 0;

            ps.close();
            conn.close();

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // UPDATE
    // =========================
    public boolean update(SparePart p) {
        String sql = """
            UPDATE spare_parts
            SET name=?,
                part_code=?,
                unit=?,
                quantity_in_stock=?,
                min_stock_alert=?,
                price=?,
                description=?
            WHERE id=?
        """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, p.getName());
            ps.setString(2, p.getPartCode());
            ps.setString(3, p.getUnit());
            ps.setInt(4, p.getQuantityInStock());
            ps.setInt(5, p.getMinStockAlert());
            ps.setDouble(6, p.getPrice());
            ps.setString(7, p.getDescription());
            ps.setInt(8, p.getId());

            boolean result = ps.executeUpdate() > 0;

            ps.close();
            conn.close();

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // DELETE
    // =========================
    public boolean delete(int id) {
        String sql = "DELETE FROM spare_parts WHERE id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, id);
            boolean result = ps.executeUpdate() > 0;

            ps.close();
            conn.close();

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // Mapper ResultSet → Model
    // =========================
    private SparePart mapRow(ResultSet rs) throws Exception {
        SparePart p = new SparePart();

        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPartCode(rs.getString("part_code"));
        p.setUnit(rs.getString("unit"));
        p.setQuantityInStock(rs.getInt("quantity_in_stock"));
        p.setMinStockAlert(rs.getInt("min_stock_alert"));
        p.setPrice(rs.getDouble("price"));
        p.setDescription(rs.getString("description"));

        return p;
    }
}
