package com.generatorproject.dao;

import com.generatorproject.model.HomeStats;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class HomeStatsDAO extends GenericDAO<Object> {

    public HomeStats getStatsForHome() {
        HomeStats stats = new HomeStats();

        // 1) Tổng máy + tổng giờ chạy (từ bảng products)
        String sqlProducts =
                "SELECT " +
                        "   COUNT(*) AS total_products, " +
                        "   COALESCE(SUM(total_running_hours), 0) AS total_hours " +
                        "FROM products";

        // 2) Tổng model (từ bảng product_models)
        String sqlModels =
                "SELECT COUNT(*) AS total_models " +
                        "FROM product_models";

        try (Connection conn = getConnection()) {

            // Query products
            try (PreparedStatement ps = conn.prepareStatement(sqlProducts);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    stats.setTotalProducts(rs.getInt("total_products"));
                    stats.setTotalHours((int) Math.round(rs.getDouble("total_hours")));
                }
            }

            // Query product_models
            try (PreparedStatement ps2 = conn.prepareStatement(sqlModels);
                 ResultSet rs2 = ps2.executeQuery()) {

                if (rs2.next()) {
                    stats.setTotalProductModels(rs2.getInt("total_models"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return stats;
    }
}