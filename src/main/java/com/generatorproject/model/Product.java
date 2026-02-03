package com.generatorproject.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Product {
    // --- CỘT TRONG DATABASE (Bảng products) ---
    private int id;
    private String serialNumber;      // Số khung/số máy
    private Integer manufactureYear;  // Năm sản xuất
    private String currentLocation;   // Vị trí lắp đặt
    private String status;            // READY, BROKEN, MAINTENANCE...
    private Double totalRunningHours; // Số giờ chạy
    private Long customerId;          // FK: Chủ sở hữu
    private Long modelId;             // FK: Dòng máy (Link sang product_models)
    private Date purchaseDate;        // Ngày mua
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String brandName;

    // --- TRƯỜNG PHỤ (Transient - Không lưu trong bảng products) ---
    // Dùng để hiển thị khi JOIN với bảng product_models hoặc users
    private String modelName;   // Tên dòng máy (VD: Honda EU22i)
    private String customerName; // Tên khách hàng

    public Product() {
    }

    // Constructor cho Builder
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
    }

    // --- GETTERS & SETTERS ---
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

    // --- BUILDER PATTERN ---
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


        public Product build() {
            return new Product(this);
        }
    }
}