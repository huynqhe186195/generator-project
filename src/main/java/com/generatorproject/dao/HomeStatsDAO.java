package com.generatorproject.dao;

import com.generatorproject.model.HomeStats;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class HomeStatsDAO extends GenericDAO<Object> {

    public HomeStats getStatsForHome() {
        HomeStats stats = new HomeStats();

        String sql =
                "SELECT " +
                        "   COUNT(*) AS total_products, " +
                        "   COALESCE(SUM(total_running_hours), 0) AS total_hours " +
                        "FROM products";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.setTotalProducts(rs.getInt("total_products"));
                stats.setTotalHours((int) Math.round(rs.getDouble("total_hours")));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return stats;
    }
}
