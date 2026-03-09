package com.generatorproject.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Product {
    private int id;
    private String serialNumber;
    private Integer manufactureYear;
    private String currentLocation;
    private String status;
    private Double totalRunningHours;
    private Long customerId;
    private Long modelId;
    private Date purchaseDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String brandName;
    private Long contractId;
    private String categoryName;
    private String customerEmail;
    private String contractStatus;
    private Date contractEndDate;
    private String latestTerminatedEvent;
    private Timestamp terminatedAt;

    private String modelName;
    private String customerName;

    public Product() {
    }

    private Product(Builder builder) {
        this.id = builder.id;
        this.serialNumber = builder.serialNumber;
        this.manufactureYear = builder.manufactureYear;
        this.currentLocation = builder.currentLocation;
        this.status = builder.status;
        this.totalRunningHours = builder.totalRunningHours;
        this.customerId = builder.customerId;
        this.modelId = builder.modelId;
        this.purchaseDate = builder.purchaseDate;
        this.createdAt = builder.createdAt;
        this.updatedAt = builder.updatedAt;
        this.modelName = builder.modelName;
        this.customerName = builder.customerName;
        this.brandName = builder.brandName;
        this.contractId = builder.contractId;
        this.categoryName = builder.categoryName;
        this.customerEmail = builder.customerEmail;
        this.contractStatus = builder.contractStatus;
        this.contractEndDate = builder.contractEndDate;
        this.latestTerminatedEvent = builder.latestTerminatedEvent;
        this.terminatedAt = builder.terminatedAt;
    }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public Long getContractId() {
        return contractId;
    }

    public void setContractId(Long contractId) {
        this.contractId = contractId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public Integer getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; }

    public String getCurrentLocation() { return currentLocation; }
    public void setCurrentLocation(String currentLocation) { this.currentLocation = currentLocation; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Double getTotalRunningHours() { return totalRunningHours; }
    public void setTotalRunningHours(Double totalRunningHours) { this.totalRunningHours = totalRunningHours; }

    public Long getCustomerId() { return customerId; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }

    public Long getModelId() { return modelId; }
    public void setModelId(Long modelId) { this.modelId = modelId; }

    public Date getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(Date purchaseDate) { this.purchaseDate = purchaseDate; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getModelName() { return modelName; }
    public void setModelName(String modelName) { this.modelName = modelName; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public String getContractStatus() {
        return contractStatus;
    }

    public void setContractStatus(String contractStatus) {
        this.contractStatus = contractStatus;
    }

    public Date getContractEndDate() {
        return contractEndDate;
    }

    public void setContractEndDate(Date contractEndDate) {
        this.contractEndDate = contractEndDate;
    }

    public String getLatestTerminatedEvent() {
        return latestTerminatedEvent;
    }

    public void setLatestTerminatedEvent(String latestTerminatedEvent) {
        this.latestTerminatedEvent = latestTerminatedEvent;
    }

    public Timestamp getTerminatedAt() {
        return terminatedAt;
    }

    public void setTerminatedAt(Timestamp terminatedAt) {
        this.terminatedAt = terminatedAt;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private int id;
        private String serialNumber;
        private Integer manufactureYear;
        private String currentLocation;
        private String status;
        private Double totalRunningHours;
        private Long customerId;
        private Long modelId;
        private Date purchaseDate;
        private Timestamp createdAt;
        private Timestamp updatedAt;
        private String modelName;
        private String customerName;
        private String brandName;
        private Long contractId;
        private String categoryName;
        private String customerEmail;
        private String contractStatus;
        private Date contractEndDate;
        private String latestTerminatedEvent;
        private Timestamp terminatedAt;

        public Builder id(int id) { this.id = id; return this; }
        public Builder serialNumber(String serialNumber) { this.serialNumber = serialNumber; return this; }
        public Builder manufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; return this; }
        public Builder currentLocation(String currentLocation) { this.currentLocation = currentLocation; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder totalRunningHours(Double totalRunningHours) { this.totalRunningHours = totalRunningHours; return this; }
        public Builder customerId(Long customerId) { this.customerId = customerId; return this; }
        public Builder modelId(Long modelId) { this.modelId = modelId; return this; }
        public Builder purchaseDate(Date purchaseDate) { this.purchaseDate = purchaseDate; return this; }
        public Builder createdAt(Timestamp createdAt) { this.createdAt = createdAt; return this; }
        public Builder updatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; return this; }
        public Builder modelName(String modelName) { this.modelName = modelName; return this; }
        public Builder customerName(String customerName) { this.customerName = customerName; return this; }
        public Builder brandName(String brandName) { this.brandName = brandName; return this; }
        public Builder contractId(Long contractId) {
            this.contractId = contractId;
            return this;
        }
        public Builder categoryName(String categoryName) { this.categoryName = categoryName; return this; }
        public Builder customerEmail(String customerEmail) { this.customerEmail = customerEmail; return this; }
        public Builder contractStatus(String contractStatus) { this.contractStatus = contractStatus; return this; }
        public Builder contractEndDate(Date contractEndDate) { this.contractEndDate = contractEndDate; return this; }
        public Builder latestTerminatedEvent(String latestTerminatedEvent) { this.latestTerminatedEvent = latestTerminatedEvent; return this; }
        public Builder terminatedAt(Timestamp terminatedAt) { this.terminatedAt = terminatedAt; return this; }

        public Product build() {
            return new Product(this);
        }
    }
}
