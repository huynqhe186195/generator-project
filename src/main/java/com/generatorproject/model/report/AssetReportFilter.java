package com.generatorproject.model.report;

public class AssetReportFilter {
    private String keyword;
    private String status; // products.status (optional)

    private Integer customerId;
    private Integer modelId;
    private Integer brandId;

    private Integer manufactureYear; // new

    // warranty scope: "EXPIRING_30" (dựa trên contracts.end_date)
    private String warrantyScope;

    // cost bucket: "LT_500K", "500K_1M", "1M_2M", "GE_2M"
    private String costBucket;

    // last periodic: "HAS", "NONE" (null = ALL)
    private String periodicScope;

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    public Integer getModelId() { return modelId; }
    public void setModelId(Integer modelId) { this.modelId = modelId; }

    public Integer getBrandId() { return brandId; }
    public void setBrandId(Integer brandId) { this.brandId = brandId; }

    public Integer getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; }

    public String getWarrantyScope() { return warrantyScope; }
    public void setWarrantyScope(String warrantyScope) { this.warrantyScope = warrantyScope; }

    public String getCostBucket() { return costBucket; }
    public void setCostBucket(String costBucket) { this.costBucket = costBucket; }

    public String getPeriodicScope() { return periodicScope; }
    public void setPeriodicScope(String periodicScope) { this.periodicScope = periodicScope; }
}