package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class SystemRequestDAO extends DbContext {

    public boolean createRepairQuoteRequest(int senderId, String requestDataJson) {
        // NOTE: chỉnh tên bảng/cột đúng theo DB của bạn
        String sql = """
            INSERT INTO system_requests(sender_id, receiver_role, request_type, request_data, status)
            VALUES (?, 'MANAGER', 'REPAIR_QUOTE', ?, 'PENDING')
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, senderId);
            ps.setString(2, requestDataJson);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createRequest(int senderId,
                                 String receiverRole,
                                 String requestType,
                                 String requestData) {

        String sql = """
        INSERT INTO system_requests
        (sender_id, receiver_role, request_type, request_data, status, created_at)
        VALUES (?, ?, ?, ?, 'PENDING', NOW())
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
