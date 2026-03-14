package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AiMessageDAO extends DbContext {
    public Long insert(Long sessionId, String senderType, String messageText, String contentType) throws Exception {
        String sql = "INSERT INTO ai_messages (session_id, sender_type, message_text, content_type, created_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, sessionId);
            ps.setString(2, senderType);
            ps.setString(3, messageText);
            ps.setString(4, contentType);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        }
    }
}
