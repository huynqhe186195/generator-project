package com.generatorproject.model;

public class MaintenanceSparePart {
    private int maintenanceId;
    private int sparePartId;
    private int quantityUsed;
    private double costAtTime;

    public MaintenanceSparePart(int maintenanceId, int sparePartId, int quantityUsed, double costAtTime) {
        this.maintenanceId = maintenanceId;
        this.sparePartId = sparePartId;
        this.quantityUsed = quantityUsed;
        this.costAtTime = costAtTime;
    }

    // getter / setter

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
}

