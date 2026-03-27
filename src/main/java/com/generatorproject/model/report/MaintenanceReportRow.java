package com.generatorproject.model.report;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class MaintenanceReportRow {
    private int maintenanceId;
    private String type; // PERIODIC / REPAIR / INSPECTION
    private String maintenanceDate; // yyyy-MM-dd

    private Timestamp scheduledStart;
    private Timestamp scheduledEnd;
    private Timestamp completedAt;

    private String scheduleStatus;
    private String executionStatus;
    private String status;

    private int productId;
    private String serialNumber;
    private String modelName;
    private BigDecimal modelPowerKva;

    private String customerName;
    private String site;

    private String technicianName;

    // spare parts summary
    private int partsQty;
    private double partsValue;

    // images summary
    private int beforeImages;
    private int afterImages;

    public int getMaintenanceId() { return maintenanceId; }
    public void setMaintenanceId(int maintenanceId) { this.maintenanceId = maintenanceId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getMaintenanceDate() { return maintenanceDate; }
    public void setMaintenanceDate(String maintenanceDate) { this.maintenanceDate = maintenanceDate; }

    public Timestamp getScheduledStart() { return scheduledStart; }
    public void setScheduledStart(Timestamp scheduledStart) { this.scheduledStart = scheduledStart; }

    public Timestamp getScheduledEnd() { return scheduledEnd; }
    public void setScheduledEnd(Timestamp scheduledEnd) { this.scheduledEnd = scheduledEnd; }

    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }

    public String getScheduleStatus() { return scheduleStatus; }
    public void setScheduleStatus(String scheduleStatus) { this.scheduleStatus = scheduleStatus; }

    public String getExecutionStatus() { return executionStatus; }
    public void setExecutionStatus(String executionStatus) { this.executionStatus = executionStatus; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public String getModelName() { return modelName; }
    public void setModelName(String modelName) { this.modelName = modelName; }

    public BigDecimal getModelPowerKva() { return modelPowerKva; }
    public void setModelPowerKva(BigDecimal modelPowerKva) { this.modelPowerKva = modelPowerKva; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getSite() { return site; }
    public void setSite(String site) { this.site = site; }

    public String getTechnicianName() { return technicianName; }
    public void setTechnicianName(String technicianName) { this.technicianName = technicianName; }

    public int getPartsQty() { return partsQty; }
    public void setPartsQty(int partsQty) { this.partsQty = partsQty; }

    public double getPartsValue() { return partsValue; }
    public void setPartsValue(double partsValue) { this.partsValue = partsValue; }

    public int getBeforeImages() { return beforeImages; }
    public void setBeforeImages(int beforeImages) { this.beforeImages = beforeImages; }

    public int getAfterImages() { return afterImages; }
    public void setAfterImages(int afterImages) { this.afterImages = afterImages; }
}