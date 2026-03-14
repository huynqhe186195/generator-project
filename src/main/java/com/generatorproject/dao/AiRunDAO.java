package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AiRunDAO extends DbContext {
    public Long createRunning(Long sessionId, Long triggerMessageId, String runType, String provider, String modelName) throws Exception {
        String sql = "INSERT INTO ai_runs (session_id, trigger_message_id, run_type, provider, model_name, status, started_at, created_at) VALUES (?, ?, ?, ?, ?, 'RUNNING', NOW(), NOW())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, sessionId);
            ps.setObject(2, triggerMessageId);
            ps.setString(3, runType);
            ps.setString(4, provider);
            ps.setString(5, modelName);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        }
    }

    public void markSuccess(Long runId) throws Exception {
        String sql = "UPDATE ai_runs SET status = 'SUCCESS', finished_at = NOW() WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, runId);
            ps.executeUpdate();
        }
    }

    public void markFailed(Long runId, String errorMessage) throws Exception {
        String sql = "UPDATE ai_runs SET status = 'FAILED', finished_at = NOW(), error_message = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, errorMessage);
            ps.setLong(2, runId);
            ps.executeUpdate();
        }
    }
}
