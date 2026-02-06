package com.generatorproject.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Contract {
    // 1. Các trường mapping trực tiếp với Database
    private Long id;
    private String contractNumber;
    private int customerId;
    private int productId;
    private Date startDate;
    private Date endDate;
    private String status;    // ENUM: ACTIVE, EXPIRED, TERMINATED
    private int managerId;
    private Timestamp createdAt;

    // 2. Các trường phụ (Dùng để hiển thị khi JOIN, không lưu xuống bảng contracts)
    private String customerName;  // Tên khách hàng (từ bảng users)
    private String productSerial; // Serial máy (từ bảng products)

    // Trường tạm dùng cho logic Import (như đã bàn ở luồng trước)
    private String tempCustomerEmail;

    // Constructor rỗng (Bắt buộc phải có để RowMapper sử dụng reflection/setter)
    public Contract() {
    }

    // Constructor Private dùng cho Builder
    private Contract(Builder builder) {
        this.id = builder.id;
        this.contractNumber = builder.contractNumber;
        this.customerId = builder.customerId;
        this.productId = builder.productId;
        this.startDate = builder.startDate;
        this.endDate = builder.endDate;
        this.status = builder.status;
        this.managerId = builder.managerId;
        this.createdAt = builder.createdAt;
        this.customerName = builder.customerName;
        this.productSerial = builder.productSerial;
    }

    // --- GETTERS & SETTERS (Cần thiết cho RowMapper & JSP) ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getContractNumber() { return contractNumber; }
    public void setContractNumber(String contractNumber) { this.contractNumber = contractNumber; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getProductSerial() { return productSerial; }
    public void setProductSerial(String productSerial) { this.productSerial = productSerial; }

    public String getTempCustomerEmail() { return tempCustomerEmail; }
    public void setTempCustomerEmail(String tempCustomerEmail) { this.tempCustomerEmail = tempCustomerEmail; }

    // --- BUILDER PATTERN ---
    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private Long id;
        private String contractNumber;
        private int customerId;
        private int productId;
        private Date startDate;
        private Date endDate;
        private String status;
        private int managerId;
        private Timestamp createdAt;
        private String customerName;
        private String productSerial;

        public Builder id(Long id) {
            this.id = id;
            return this;
        }

        public Builder contractNumber(String contractNumber) {
            this.contractNumber = contractNumber;
            return this;
        }

        public Builder customerId(int customerId) {
            this.customerId = customerId;
            return this;
        }

        public Builder productId(int productId) {
            this.productId = productId;
            return this;
        }

        public Builder startDate(Date startDate) {
            this.startDate = startDate;
            return this;
        }

        public Builder endDate(Date endDate) {
            this.endDate = endDate;
            return this;
        }

        public Builder status(String status) {
            this.status = status;
            return this;
        }

        public Builder managerId(int managerId) {
            this.managerId = managerId;
            return this;
        }

        public Builder createdAt(Timestamp createdAt) {
            this.createdAt = createdAt;
            return this;
        }

        public Builder customerName(String customerName) {
            this.customerName = customerName;
            return this;
        }

        public Builder productSerial(String productSerial) {
            this.productSerial = productSerial;
            return this;
        }

        public Contract build() {
            return new Contract(this);
        }
    }
}