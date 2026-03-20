package com.generatorproject.ai.orchestrator;

public class ChatRequest {
    private final Long userId;
    private final Integer roleId;
    private final String message;
    private final String contextPath;

    public ChatRequest(Long userId, Integer roleId, String message, String contextPath) {
        this.userId = userId;
        this.roleId = roleId;
        this.message = message;
        this.contextPath = contextPath;
    }

    public Long getUserId() { return userId; }
    public Integer getRoleId() { return roleId; }
    public String getMessage() { return message; }
    public String getContextPath() { return contextPath; }
}
