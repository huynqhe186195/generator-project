package com.generatorproject.model.report;

public class AssetReportKpi {
    private int totalAssets;
    private int expiringWarranty30;
    private int brokenOrProblemAssets;
    private int overduePmAssets; // heuristic: last periodic > X days

    public int getTotalAssets() { return totalAssets; }
    public void setTotalAssets(int totalAssets) { this.totalAssets = totalAssets; }

    public int getExpiringWarranty30() { return expiringWarranty30; }
    public void setExpiringWarranty30(int expiringWarranty30) { this.expiringWarranty30 = expiringWarranty30; }

    public int getBrokenOrProblemAssets() { return brokenOrProblemAssets; }
    public void setBrokenOrProblemAssets(int brokenOrProblemAssets) { this.brokenOrProblemAssets = brokenOrProblemAssets; }

    public int getOverduePmAssets() { return overduePmAssets; }
    public void setOverduePmAssets(int overduePmAssets) { this.overduePmAssets = overduePmAssets; }
}