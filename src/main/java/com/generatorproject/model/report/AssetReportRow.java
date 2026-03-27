package com.generatorproject.model.report;

import java.math.BigDecimal;
import java.sql.Date;

public class AssetReportRow {
    private int productId;
    private String serialNumber;

    private String modelName;
    private BigDecimal modelPowerKva;

    private String brandName;

    private Integer manufactureYear;
    private String currentLocation;

    private String customerName;

    private String status;
    private Double totalRunningHours;

    private Date warrantyEndDate;

    // stats
    private int incidents90d;
    private Date lastIncidentDate;

    private Date lastPeriodicDate;
    private Date lastMaintenanceDate;

    private double totalCostAllTime;

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public String getModelName() { return modelName; }
    public void setModelName(String modelName) { this.modelName = modelName; }

    public BigDecimal getModelPowerKva() { return modelPowerKva; }
    public void setModelPowerKva(BigDecimal modelPowerKva) { this.modelPowerKva = modelPowerKva; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public Integer getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; }

    public String getCurrentLocation() { return currentLocation; }
    public void setCurrentLocation(String currentLocation) { this.currentLocation = currentLocation; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Double getTotalRunningHours() { return totalRunningHours; }
    public void setTotalRunningHours(Double totalRunningHours) { this.totalRunningHours = totalRunningHours; }

    public Date getWarrantyEndDate() { return warrantyEndDate; }
    public void setWarrantyEndDate(Date warrantyEndDate) { this.warrantyEndDate = warrantyEndDate; }

    public int getIncidents90d() { return incidents90d; }
    public void setIncidents90d(int incidents90d) { this.incidents90d = incidents90d; }

    public Date getLastIncidentDate() { return lastIncidentDate; }
    public void setLastIncidentDate(Date lastIncidentDate) { this.lastIncidentDate = lastIncidentDate; }

    public Date getLastPeriodicDate() { return lastPeriodicDate; }
    public void setLastPeriodicDate(Date lastPeriodicDate) { this.lastPeriodicDate = lastPeriodicDate; }

    public Date getLastMaintenanceDate() { return lastMaintenanceDate; }
    public void setLastMaintenanceDate(Date lastMaintenanceDate) { this.lastMaintenanceDate = lastMaintenanceDate; }

    public double getTotalCostAllTime() { return totalCostAllTime; }
    public void setTotalCostAllTime(double totalCostAllTime) { this.totalCostAllTime = totalCostAllTime; }
}