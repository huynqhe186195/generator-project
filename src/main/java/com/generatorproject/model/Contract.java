package com.generatorproject.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Contract {
    private Long id;
    private String contractNumber;
    private int customerId;
    private int productId;
    private Date signedDate;
    private Date startDate;
    private Date endDate;
    private String status;
    private int managerId;
    private Timestamp createdAt;
    private Timestamp terminatedAt;
    private String customerName;
    private String tempCustomerEmail;

    private String productSerial;
    private String productModelName;
    private Integer productManufactureYear;

    public Contract() {
    }

    private Contract(Builder builder) {
        this.id = builder.id;
        this.contractNumber = builder.contractNumber;
        this.customerId = builder.customerId;
        this.productId = builder.productId;
        this.signedDate = builder.signedDate;
        this.startDate = builder.startDate;
        this.endDate = builder.endDate;
        this.status = builder.status;
        this.managerId = builder.managerId;
        this.createdAt = builder.createdAt;
        this.terminatedAt = builder.terminatedAt;

        this.customerName = builder.customerName;
        this.productSerial = builder.productSerial;
        this.productModelName = builder.productModelName;
        this.productManufactureYear = builder.productManufactureYear;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getContractNumber() {
        return contractNumber;
    }

    public void setContractNumber(String contractNumber) {
        this.contractNumber = contractNumber;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Date getSignedDate() {
        return signedDate;
    }

    public void setSignedDate(Date signedDate) {
        this.signedDate = signedDate;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getTerminatedAt() {
        return terminatedAt;
    }

    public void setTerminatedAt(Timestamp terminatedAt) {
        this.terminatedAt = terminatedAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getProductSerial() {
        return productSerial;
    }

    public void setProductSerial(String productSerial) {
        this.productSerial = productSerial;
    }

    public String getProductModelName() {
        return productModelName;
    }

    public void setProductModelName(String productModelName) {
        this.productModelName = productModelName;
    }

    public Integer getProductManufactureYear() {
        return productManufactureYear;
    }

    public void setProductManufactureYear(Integer productManufactureYear) {
        this.productManufactureYear = productManufactureYear;
    }

    public String getTempCustomerEmail() {
        return tempCustomerEmail;
    }

    public void setTempCustomerEmail(String tempCustomerEmail) {
        this.tempCustomerEmail = tempCustomerEmail;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private Long id;
        private String contractNumber;
        private int customerId;
        private int productId;
        private Date signedDate;
        private Date startDate;
        private Date endDate;
        private String status;
        private int managerId;
        private Timestamp createdAt;
        private Timestamp terminatedAt;
        private String customerName;
        private String productSerial;
        private String productModelName;
        private Integer productManufactureYear;

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

        public Builder signedDate(Date signedDate) {
            this.signedDate = signedDate;
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

        public Builder terminatedAt(Timestamp terminatedAt) {
            this.terminatedAt = terminatedAt;
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

        public Builder productModelName(String productModelName) {
            this.productModelName = productModelName;
            return this;
        }

        public Builder productManufactureYear(Integer productManufactureYear) {
            this.productManufactureYear = productManufactureYear;
            return this;
        }

        public Contract build() {
            return new Contract(this);
        }
    }
}
