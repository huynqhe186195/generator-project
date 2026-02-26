package com.generatorproject.dao;

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

}
