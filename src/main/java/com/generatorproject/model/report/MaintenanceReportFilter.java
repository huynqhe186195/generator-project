package com.generatorproject.model.report;

/**
 * Filter dùng chung cho Report C.
 * - from/to lọc theo maintenance_date
 * - customer/technician/model/site là các filter vận hành
 * - onlyPeriodic: null=ALL, true=PERIODIC, false=NON_PERIODIC
 */
public class MaintenanceReportFilter {
    private String from;
    private String to;

    private Integer customerId;
    private Integer technicianId;
    private Integer modelId;
    private String siteKeyword;

    private Boolean onlyPeriodic;

    public String getFrom() { return from; }
    public void setFrom(String from) { this.from = from; }

    public String getTo() { return to; }
    public void setTo(String to) { this.to = to; }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    public Integer getTechnicianId() { return technicianId; }
    public void setTechnicianId(Integer technicianId) { this.technicianId = technicianId; }

    public Integer getModelId() { return modelId; }
    public void setModelId(Integer modelId) { this.modelId = modelId; }

    public String getSiteKeyword() { return siteKeyword; }
    public void setSiteKeyword(String siteKeyword) { this.siteKeyword = siteKeyword; }

    public Boolean getOnlyPeriodic() { return onlyPeriodic; }
    public void setOnlyPeriodic(Boolean onlyPeriodic) { this.onlyPeriodic = onlyPeriodic; }
}