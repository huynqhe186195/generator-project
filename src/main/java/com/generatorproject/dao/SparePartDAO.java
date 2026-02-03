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
    // Lấy vật tư theo ID
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
