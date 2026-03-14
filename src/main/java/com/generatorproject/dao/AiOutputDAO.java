package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class AiOutputDAO extends DbContext {
    public void insertStructuredJson(Long runId, String contentText, String contentJson, Double confidenceScore) throws Exception {
        String sql = "INSERT INTO ai_outputs (run_id, output_type, content_text, content_json, confidence_score, is_applied, created_at) VALUES (?, 'STRUCTURED_JSON', ?, CAST(? AS JSON), ?, 0, NOW())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, runId);
            ps.setString(2, contentText);
            ps.setString(3, contentJson);
            ps.setObject(4, confidenceScore);
            ps.executeUpdate();
        }
    }
}
