package com.generatorproject.model;

public class MaintenanceSparePart {
    private int maintenanceId;
    private int sparePartId;
    private int quantityUsed;
    private double costAtTime;

    // NEW: để hiển thị ra màn hình
    private String sparePartName;
    private String partCode;
    private String unit;

    public MaintenanceSparePart(int maintenanceId, int sparePartId, int quantityUsed, double costAtTime) {
        this.maintenanceId = maintenanceId;
        this.sparePartId = sparePartId;
        this.quantityUsed = quantityUsed;
        this.costAtTime = costAtTime;
    }

    public MaintenanceSparePart() {}

    public int getMaintenanceId() {
        return maintenanceId;
    }

    public void setMaintenanceId(int maintenanceId) {
        this.maintenanceId = maintenanceId;
    }

    public int getSparePartId() {
        return sparePartId;
    }

    public void setSparePartId(int sparePartId) {
        this.sparePartId = sparePartId;
    }

    public int getQuantityUsed() {
        return quantityUsed;
    }

    public void setQuantityUsed(int quantityUsed) {
        this.quantityUsed = quantityUsed;
    }

    public double getCostAtTime() {
        return costAtTime;
    }

    public void setCostAtTime(double costAtTime) {
        this.costAtTime = costAtTime;
    }

    public String getSparePartName() {
        return sparePartName;
    }

    public void setSparePartName(String sparePartName) {
        this.sparePartName = sparePartName;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }
}