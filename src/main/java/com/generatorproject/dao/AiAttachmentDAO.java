package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AiAttachmentDAO extends DbContext {

    public Long insert(Long sessionId, Long messageId, String originalFileName, String storedPath, String mimeType, Long fileSize, String attachmentKind) throws Exception {
        String sql = "INSERT INTO ai_attachments (session_id, message_id, original_file_name, stored_path, mime_type, file_size, attachment_kind, upload_status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, 'UPLOADED', NOW())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, sessionId);
            ps.setObject(2, messageId);
            ps.setString(3, originalFileName);
            ps.setString(4, storedPath);
            ps.setString(5, mimeType);
            ps.setObject(6, fileSize);
            ps.setString(7, attachmentKind);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        }
    }

    public String findLatestStoredPathBySessionId(Long sessionId) throws Exception {
        String sql = "SELECT stored_path FROM ai_attachments WHERE session_id = ? ORDER BY id DESC LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : null;
            }
        }
    }
}
