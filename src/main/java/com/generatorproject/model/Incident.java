package com.generatorproject.model;

import java.sql.Timestamp;

public class Incident {
    // --- FIELDS FROM DATABASE (Mapping theo ảnh) ---
    private int id;
    private int productId;
    private int reportedBy;
    private String title;
    private String description;
    private String imageEvidence;
    private String priority; // ENUM: LOW, MEDIUM, HIGH, CRITICAL
    private String status;   // ENUM: NEW, VERIFYING, WAITING_MANAGER, APPROVED...
    private int technicianId;
    private Timestamp createdAt;
    private Timestamp resolvedAt;

    // --- NEW FIELDS (Bổ sung theo ảnh DB) ---
    private String inputContractNumber; // varchar(50)
    private String inputSerialNumber;   // varchar(100)
    private int contractId;             // int

    // --- EXTRA FIELDS (Dùng để hiển thị UI, không có trong bảng incidents) ---
    private String productName;
    private String reporterName;
    private String technicianName;

    // --- CONSTRUCTOR DEFAULT ---
    public Incident() {
    }

    // --- CONSTRUCTOR BUILDER ---
    private Incident(Builder builder) {
        this.id = builder.id;
        this.productId = builder.productId;
        this.reportedBy = builder.reportedBy;
        this.title = builder.title;
        this.description = builder.description;
        this.imageEvidence = builder.imageEvidence;
        this.priority = builder.priority;
        this.status = builder.status;
        this.technicianId = builder.technicianId;
        this.createdAt = builder.createdAt;
        this.resolvedAt = builder.resolvedAt;

        // Gán giá trị cho 3 trường mới
        this.inputContractNumber = builder.inputContractNumber;
        this.inputSerialNumber = builder.inputSerialNumber;
        this.contractId = builder.contractId;

        // Extra fields
        this.productName = builder.productName;
        this.reporterName = builder.reporterName;
        this.technicianName = builder.technicianName;
    }

    // --- GETTER & SETTER (Đã bổ sung 3 trường mới) ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getReportedBy() { return reportedBy; }
    public void setReportedBy(int reportedBy) { this.reportedBy = reportedBy; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageEvidence() { return imageEvidence; }
    public void setImageEvidence(String imageEvidence) { this.imageEvidence = imageEvidence; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getTechnicianId() { return technicianId; }
    public void setTechnicianId(int technicianId) { this.technicianId = technicianId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }

    // --- Getters/Setters cho 3 trường mới ---
    public String getInputContractNumber() { return inputContractNumber; }
    public void setInputContractNumber(String inputContractNumber) { this.inputContractNumber = inputContractNumber; }

    public String getInputSerialNumber() { return inputSerialNumber; }
    public void setInputSerialNumber(String inputSerialNumber) { this.inputSerialNumber = inputSerialNumber; }

    public int getContractId() { return contractId; }
    public void setContractId(int contractId) { this.contractId = contractId; }

    // --- Getters/Setters cho Extra fields ---
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }

    public String getTechnicianName() { return technicianName; }
    public void setTechnicianName(String technicianName) { this.technicianName = technicianName; }


    // --- STATIC BUILDER CLASS ---
    public static class Builder {
        private int id;
        private int productId;
        private int reportedBy;
        private String title;
        private String description;
        private String imageEvidence;
        private String priority;
        private String status;
        private int technicianId;
        private Timestamp createdAt;
        private Timestamp resolvedAt;

        // New Fields in Builder
        private String inputContractNumber;
        private String inputSerialNumber;
        private int contractId;

        // Extra fields
        private String productName;
        private String reporterName;
        private String technicianName;

        public Builder setId(int id) { this.id = id; return this; }
        public Builder setProductId(int productId) { this.productId = productId; return this; }
        public Builder setReportedBy(int reportedBy) { this.reportedBy = reportedBy; return this; }
        public Builder setTitle(String title) { this.title = title; return this; }
        public Builder setDescription(String description) { this.description = description; return this; }
        public Builder setImageEvidence(String imageEvidence) { this.imageEvidence = imageEvidence; return this; }
        public Builder setPriority(String priority) { this.priority = priority; return this; }
        public Builder setStatus(String status) { this.status = status; return this; }
        public Builder setTechnicianId(int technicianId) { this.technicianId = technicianId; return this; }
        public Builder setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; return this; }
        public Builder setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; return this; }

        // Builder methods cho 3 trường mới
        public Builder setInputContractNumber(String inputContractNumber) { this.inputContractNumber = inputContractNumber; return this; }
        public Builder setInputSerialNumber(String inputSerialNumber) { this.inputSerialNumber = inputSerialNumber; return this; }
        public Builder setContractId(int contractId) { this.contractId = contractId; return this; }

        // Builder methods cho Extra fields
        public Builder setProductName(String productName) { this.productName = productName; return this; }
        public Builder setReporterName(String reporterName) { this.reporterName = reporterName; return this; }
        public Builder setTechnicianName(String technicianName) { this.technicianName = technicianName; return this; }

        public Incident build() {
            return new Incident(this);
        }
    }
}