package com.generatorproject.dao;

import com.generatorproject.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.generatorproject.model.Product;

public class ProductDAO extends DbContext {
    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public double sumRunningHours() {
        String sql = "SELECT SUM(total_running_hours) FROM products";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        // Thử query đơn giản nhất để đảm bảo kết nối DB thông suốt
        String sql = "SELECT * FROM products";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setSerialNumber(rs.getString("serial_number"));
                p.setName(rs.getString("name"));
                p.setModel(rs.getString("model"));
                p.setStatus(rs.getString("status"));
                p.setImageUrl(rs.getString("image_url"));
                p.setPowerPrime(rs.getDouble("power_prime"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}