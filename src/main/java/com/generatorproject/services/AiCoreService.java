package com.generatorproject.services;

import com.generatorproject.dao.*;

public class AiCoreService {
    private final AiSessionDAO aiSessionDAO = new AiSessionDAO();
    private final AiMessageDAO aiMessageDAO = new AiMessageDAO();
    private final AiAttachmentDAO aiAttachmentDAO = new AiAttachmentDAO();
    private final AiRunDAO aiRunDAO = new AiRunDAO();
    private final AiOutputDAO aiOutputDAO = new AiOutputDAO();

    public Long ensureSession(int userId, String moduleCode, String contextEntityType, Long contextEntityId, String title) throws Exception {
        Long existing = aiSessionDAO.findOpenSession(userId, moduleCode, contextEntityType, contextEntityId);
        return existing != null ? existing : aiSessionDAO.createSession(userId, moduleCode, contextEntityType, contextEntityId, title);
    }

    public Long addMessage(Long sessionId, String senderType, String messageText, String contentType) throws Exception {
        return aiMessageDAO.insert(sessionId, senderType, messageText, contentType);
    }

    public Long addAttachment(Long sessionId, Long messageId, String originalFileName, String storedPath, String mimeType, Long fileSize, String attachmentKind) throws Exception {
        return aiAttachmentDAO.insert(sessionId, messageId, originalFileName, storedPath, mimeType, fileSize, attachmentKind);
    }

    public String findLatestAttachmentPath(Long sessionId) throws Exception {
        return aiAttachmentDAO.findLatestStoredPathBySessionId(sessionId);
    }

    public Long createExtractRun(Long sessionId, Long triggerMessageId) throws Exception {
        return aiRunDAO.createRunning(sessionId, triggerMessageId, "EXTRACT", "LOCAL", "V1_RULE_BASED");
    }

    public void markRunSuccess(Long runId, String chatMessage, String jsonPayload, Double confidence) throws Exception {
        aiOutputDAO.insertStructuredJson(runId, chatMessage, jsonPayload, confidence);
        aiRunDAO.markSuccess(runId);
    }

    public void markRunFailed(Long runId, String errorMessage) throws Exception {
        if (runId != null) {
            aiRunDAO.markFailed(runId, errorMessage);
        }
    }

    public String detectAttachmentKind(String fileName, String mimeType) {
        String lower = fileName == null ? "" : fileName.toLowerCase();
        String mime = mimeType == null ? "" : mimeType.toLowerCase();
        if (lower.endsWith(".pdf") || mime.contains("pdf")) return "PDF";
        if (mime.startsWith("image/") || lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "IMAGE";
        if (lower.endsWith(".doc")) return "DOC";
        if (lower.endsWith(".docx")) return "DOCX";
        if (lower.endsWith(".xls")) return "XLS";
        if (lower.endsWith(".xlsx")) return "XLSX";
        return "OTHER";
    }
}
