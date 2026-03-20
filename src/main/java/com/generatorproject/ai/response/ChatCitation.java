package com.generatorproject.ai.response;

public class ChatCitation {
    private String label;
    private String detail;

    public ChatCitation() {}
    public ChatCitation(String label, String detail) { this.label = label; this.detail = detail; }
    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
    public String getDetail() { return detail; }
    public void setDetail(String detail) { this.detail = detail; }
}
