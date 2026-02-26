package com.generatorproject.dao;

import com.generatorproject.model.SystemRequest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class SystemRequestDAO extends DbContext {

    public String getRepairQuoteStatus(int maintenanceId) {

        String sql = """
        SELECT status
        FROM system_requests
        WHERE request_type = 'REPAIR_QUOTE'
          AND request_data LIKE ?
        ORDER BY id DESC
        LIMIT 1
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%\"maintenanceId\":" + maintenanceId + "%");
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("status"); // WAITING_MANAGER / APPROVED / REJECTED
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null; // chưa gửi quote
    }

    public boolean createRequest(int senderId,
                                 String receiverRole,
                                 String requestType,
                                 String requestData) {

        String sql = """
        INSERT INTO system_requests
        (sender_id, receiver_role, request_type, request_data, status, created_at)
        VALUES (?, ?, ?, ?, 'WAITING_STAFF', NOW())
    """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, senderId);
            ps.setString(2, receiverRole);
            ps.setString(3, requestType);
            ps.setString(4, requestData);

            boolean result = ps.executeUpdate() > 0;

            ps.close();
            conn.close();

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public SystemRequest getSystemRequestById(long id) {
        String sql = "SELECT * FROM system_requests WHERE id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            // Set giá trị id vào câu query
            ps.setLong(1, id);

            // Thực thi và lấy kết quả
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                SystemRequest req = new SystemRequest();

                req.setId(rs.getLong("id"));
                req.setSenderId((long)rs.getInt("sender_id"));
                req.setReceiverRole(rs.getString("receiver_role"));
                req.setRequestType(rs.getString("request_type"));
                req.setRequestData(rs.getString("request_data"));
                req.setStatus(rs.getString("status"));
                req.setResponseMessage(rs.getString("response_message"));
                req.setCreatedAt(rs.getTimestamp("created_at"));
                req.setUpdatedAt(rs.getTimestamp("updated_at"));

                return req; // Trả về object chứa toàn bộ data
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null; // Trả về null nếu không tìm thấy ID này
    }
}
