package com.generatorproject.model;

import java.sql.Timestamp;

public class Quote {
    private Long id;
    private Long customerId;
    private Integer createdBy;
    private Double totalAmount; // Tương ứng với decimal(15,2)
    private String status;      // Tương ứng với ENUM
    private Timestamp createdAt;
    private Timestamp approvedAt;
    private Integer maintenanceId;

    // 1. Constructor rỗng (Bắt buộc phải có để Mapper hoạt động)
    public Quote() {
    }

    // 2. Constructor đầy đủ tham số (Tùy chọn, dùng khi cần khởi tạo nhanh)
    public Quote(Long id, Long customerId, Integer createdBy, Double totalAmount, String status, Timestamp createdAt, Timestamp approvedAt, Integer maintenanceId) {
        this.id = id;
        this.customerId = customerId;
        this.createdBy = createdBy;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
        this.approvedAt = approvedAt;
        this.maintenanceId = maintenanceId;
    }

    // 3. Các hàm Getter và Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }

    public Integer getMaintenanceId() {
        return maintenanceId;
    }

    public void setMaintenanceId(Integer maintenanceId) {
        this.maintenanceId = maintenanceId;
    }

    // Hàm toString() để in ra console dễ debug (tùy chọn)
    @Override
    public String toString() {
        return "Quote{" +
                "id=" + id +
                ", customerId=" + customerId +
                ", createdBy=" + createdBy +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", approvedAt=" + approvedAt +
                ", maintenanceId=" + maintenanceId +
                '}';
    }
}