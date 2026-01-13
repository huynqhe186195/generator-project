package com.generatorproject.dao;


import java.sql.*;

public class TokenDao extends DbContext {
    public void saveToken(int userId, String token) {
        String sql = "INSERT INTO password_reset_tokens (user_id, token, expiry_date, is_used) " +
                "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 15 MINUTE), 0)";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public Integer getUserIdByValidToken(String token) {
        String sql = "SELECT user_id FROM password_reset_tokens " +
                "WHERE token = ? AND expiry_date > NOW() AND is_used = 0";
        try{
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("user_id");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void markAsUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET is_used = 1 WHERE token = ?";
        try{
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}