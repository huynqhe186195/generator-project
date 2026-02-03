package com.generatorproject.model;

import java.sql.Timestamp;

public class SystemRequest {
    private Long id;
    private Long senderId;
    private String receiverRole; // ADMIN, MANAGER, STAFF
    private String requestType;  // CREATE_USER, APPROVE_REPAIR...
    private String requestData;  // JSON Data
    private String status;       // PENDING, APPROVED, REJECTED
    private String responseMessage;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public SystemRequest() {
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getSenderId() { return senderId; }
    public void setSenderId(Long senderId) { this.senderId = senderId; }

    public String getReceiverRole() { return receiverRole; }
    public void setReceiverRole(String receiverRole) { this.receiverRole = receiverRole; }

    public String getRequestType() { return requestType; }
    public void setRequestType(String requestType) { this.requestType = requestType; }

    public String getRequestData() { return requestData; }
    public void setRequestData(String requestData) { this.requestData = requestData; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getResponseMessage() { return responseMessage; }
    public void setResponseMessage(String responseMessage) { this.responseMessage = responseMessage; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    private SystemRequest(Builder builder) {
        this.id = builder.id;
        this.senderId = builder.senderId;
        this.receiverRole = builder.receiverRole;
        this.requestType = builder.requestType;
        this.requestData = builder.requestData;
        this.status = builder.status;
        this.responseMessage = builder.responseMessage;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private Long id;
        private Long senderId;
        private String receiverRole;
        private String requestType;
        private String requestData;
        private String status = "PENDING"; // Mặc định là PENDING nếu không set
        private String responseMessage;

        public Builder id(Long id) {
            this.id = id;
            return this;
        }

        public Builder senderId(Long senderId) {
            this.senderId = senderId;
            return this;
        }

        public Builder receiverRole(String receiverRole) {
            this.receiverRole = receiverRole;
            return this;
        }

        public Builder requestType(String requestType) {
            this.requestType = requestType;
            return this;
        }

        public Builder requestData(String requestData) {
            this.requestData = requestData;
            return this;
        }

        public Builder status(String status) {
            this.status = status;
            return this;
        }

        public Builder responseMessage(String responseMessage) {
            this.responseMessage = responseMessage;
            return this;
        }

        // Hàm chốt đơn: Tạo ra object SystemRequest thật
        public SystemRequest build() {
            return new SystemRequest(this);
        }
    }

    @Override
    public String toString() {
        return "SystemRequest{" +
                "id=" + id +
                ", senderId=" + senderId +
                ", requestType='" + requestType + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}