package com.generatorproject.model;

public class SparePartUsage {
    private int sparePartId;
    private String sparePartName;
    private String partCode;
    private int totalQuantityUsed;
    private double totalCost;

    public int getSparePartId() { return sparePartId; }
    public void setSparePartId(int sparePartId) { this.sparePartId = sparePartId; }

    public String getSparePartName() { return sparePartName; }
    public void setSparePartName(String sparePartName) { this.sparePartName = sparePartName; }

    public String getPartCode() { return partCode; }
    public void setPartCode(String partCode) { this.partCode = partCode; }

    public int getTotalQuantityUsed() { return totalQuantityUsed; }
    public void setTotalQuantityUsed(int totalQuantityUsed) { this.totalQuantityUsed = totalQuantityUsed; }

    public double getTotalCost() { return totalCost; }
    public void setTotalCost(double totalCost) { this.totalCost = totalCost; }
}