package com.generatorproject.model;

import java.util.List;
import java.util.Map;

public class AiExtractResponse {
    private String chatMessage;
    private List<Map<String, Object>> items;
    private List<String> warnings;
    private Long aiSessionId;
    private int totalItems;

    public String getChatMessage() {
        return chatMessage;
    }

    public void setChatMessage(String chatMessage) {
        this.chatMessage = chatMessage;
    }

    public List<Map<String, Object>> getItems() {
        return items;
    }

    public void setItems(List<Map<String, Object>> items) {
        this.items = items;
    }

    public List<String> getWarnings() {
        return warnings;
    }

    public void setWarnings(List<String> warnings) {
        this.warnings = warnings;
    }

    public Long getAiSessionId() {
        return aiSessionId;
    }

    public void setAiSessionId(Long aiSessionId) {
        this.aiSessionId = aiSessionId;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }
}
