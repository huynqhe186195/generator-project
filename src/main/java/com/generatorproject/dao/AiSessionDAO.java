package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AiSessionDAO extends DbContext {

    public Long findOpenSession(int userId, String moduleCode, String contextEntityType, Long contextEntityId) throws Exception {
        String sql = "SELECT id FROM ai_sessions WHERE user_id = ? AND module_code = ? AND context_entity_type = ? AND context_entity_id = ? AND status = 'OPEN' ORDER BY id DESC LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, moduleCode);
            ps.setString(3, contextEntityType);
            ps.setLong(4, contextEntityId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        }
    }

    public Long createSession(int userId, String moduleCode, String contextEntityType, Long contextEntityId, String title) throws Exception {
        String sql = "INSERT INTO ai_sessions (user_id, module_code, context_entity_type, context_entity_id, title, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, 'OPEN', NOW(), NOW())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, moduleCode);
            ps.setString(3, contextEntityType);
            ps.setLong(4, contextEntityId);
            ps.setString(5, title);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        }
    }
}
