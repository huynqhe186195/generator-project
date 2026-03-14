package com.generatorproject.model;

public class ContractAiExtractedItem {
    private Long id;
    private Long contractId;
    private String sourceFilePath;
    private String rawModelName;
    private String rawBrand;
    private String rawPower;
    private Integer quantity;
    private String rawSerialNumber;
    private Integer manufactureYear;
    private String currentLocation;
    private Long matchedModelId;
    private String matchedModelName;
    private Double confidenceScore;
    private String reviewStatus;
    private boolean userEdited;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getContractId() { return contractId; }
    public void setContractId(Long contractId) { this.contractId = contractId; }
    public String getSourceFilePath() { return sourceFilePath; }
    public void setSourceFilePath(String sourceFilePath) { this.sourceFilePath = sourceFilePath; }
    public String getRawModelName() { return rawModelName; }
    public void setRawModelName(String rawModelName) { this.rawModelName = rawModelName; }
    public String getRawBrand() { return rawBrand; }
    public void setRawBrand(String rawBrand) { this.rawBrand = rawBrand; }
    public String getRawPower() { return rawPower; }
    public void setRawPower(String rawPower) { this.rawPower = rawPower; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public String getRawSerialNumber() { return rawSerialNumber; }
    public void setRawSerialNumber(String rawSerialNumber) { this.rawSerialNumber = rawSerialNumber; }
    public Integer getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; }
    public String getCurrentLocation() { return currentLocation; }
    public void setCurrentLocation(String currentLocation) { this.currentLocation = currentLocation; }
    public Long getMatchedModelId() { return matchedModelId; }
    public void setMatchedModelId(Long matchedModelId) { this.matchedModelId = matchedModelId; }
    public Double getConfidenceScore() { return confidenceScore; }
    public void setConfidenceScore(Double confidenceScore) { this.confidenceScore = confidenceScore; }
    public String getReviewStatus() { return reviewStatus; }
    public void setReviewStatus(String reviewStatus) { this.reviewStatus = reviewStatus; }
    public boolean isUserEdited() { return userEdited; }
    public void setUserEdited(boolean userEdited) { this.userEdited = userEdited; }
    public String getMatchedModelName() { return matchedModelName; }
    public void setMatchedModelName(String matchedModelName) { this.matchedModelName = matchedModelName; }
}
