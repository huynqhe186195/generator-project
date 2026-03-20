package com.generatorproject.ai.response;

public class ChatSourceUsage {
    private String type;
    private String detail;

    public ChatSourceUsage() {}
    public ChatSourceUsage(String type, String detail) { this.type = type; this.detail = detail; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getDetail() { return detail; }
    public void setDetail(String detail) { this.detail = detail; }
}
