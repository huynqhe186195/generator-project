package com.generatorproject.model.report;

public class TicketReportFilter {
    private String from;     // yyyy-MM-dd
    private String to;       // yyyy-MM-dd
    private String status;   // incidents.status
    private String priority; // incidents.priority

    private String keyword;  // search serial/model/customer/technician/title/contract...
    private Integer customerId;
    private Integer technicianId;
    private Integer modelId;

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getPriority() {
        return priority;
    }
    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getKeyword() {
        return keyword;
    }
    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Integer getCustomerId() {
        return customerId;
    }
    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getTechnicianId() {
        return technicianId;
    }
    public void setTechnicianId(Integer technicianId) {
        this.technicianId = technicianId;
    }

    public Integer getModelId() {
        return modelId;
    }
    public void setModelId(Integer modelId) {
        this.modelId = modelId;
    }
}