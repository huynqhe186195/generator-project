package com.generatorproject.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TokenDao extends DbContext {

    // 1. User gửi yêu cầu:
    // Ta lưu expiry_date là NOW().
    // Lúc này expiry_date đóng vai trò là "Thời gian tạo yêu cầu".
    public void saveToken(int userId, String token) {
        String sql = "INSERT INTO password_reset_tokens (user_id, token, expiry_date, is_used) VALUES (?, ?, NOW(), 0)";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }


    public List<Map<String, Object>> getPendingRequests() {
        List<Map<String, Object>> list = new ArrayList<>();

        // CÂU SQL NÀY CHẠY CHÍNH XÁC VỚI BẢNG CỦA BẠN
        String sql = "SELECT t.token, u.email, u.full_name, t.expiry_date " +
                "FROM password_reset_tokens t " +
                "JOIN users u ON t.user_id = u.id " +
                "WHERE t.is_used = 0 " +
                "ORDER BY t.expiry_date DESC";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("token", rs.getString("token"));
                map.put("email", rs.getString("email"));
                map.put("fullName", rs.getString("full_name"));

                // Lấy giá trị cột expiry_date để hiển thị là "Thời gian yêu cầu"
                map.put("requestedTime", rs.getTimestamp("expiry_date"));

                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. Admin Duyệt:
    // Lúc này ta mới cập nhật expiry_date thành tương lai (24h sau)
    public void activateToken(String token) {
        String sql = "UPDATE password_reset_tokens " +
                "SET expiry_date = DATE_ADD(NOW(), INTERVAL 10 MINUTE), is_used = 2 " +
                "WHERE token = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 4. Các hàm khác giữ nguyên...
    public Integer getUserIdByValidToken(String token) {
        String sql = "SELECT user_id FROM password_reset_tokens " +
                "WHERE token = ? AND expiry_date > NOW() AND is_used = 2";
        try {
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
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    // Trong TokenDao.java

    // Hàm xóa yêu cầu dựa trên token
    public void deleteRequest(String token) {
        String sql = "DELETE FROM password_reset_tokens WHERE token = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void revokeTokensByUserId(int userId) {
        String sql = "UPDATE password_reset_tokens SET is_used = 1 WHERE user_id = ? AND is_used <> 1";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

}