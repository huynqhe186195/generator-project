package com.generatorproject.model;

import java.sql.Timestamp;
import java.sql.Date;

public class Maintenance {

    private int id;
    private int productId;        // product_id
    private int technicianId;     // technician_id
    private Integer incidentId;   // incident_id (nullable)

    private Date maintenanceDate; // maintenance_date
    private String type;          // PERIODIC | REPAIR | INSPECTION
    private String description;   // description
    private double totalCost;     // total_cost
    private String status;        // SCHEDULED | COMPLETED | CANCELLED

    private Timestamp createdAt;  // created_at
    private Integer createdBy;    // created_by

    private String actualDescription;

    public String getActualDescription() {
        return actualDescription;
    }

    public void setActualDescription(String actualDescription) {
        this.actualDescription = actualDescription;
    }

    private String productName;

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }



    private String productSerialNumber;

    public String getProductSerialNumber() {
        return productSerialNumber;
    }

    public void setProductSerialNumber(String productSerialNumber) {
        this.productSerialNumber = productSerialNumber;
    }

    private String assignmentStatus;  // DRAFT | QUOTE_PENDING | APPROVED | REJECTED
    private Integer approvedBy;

    public String getAssignmentStatus() { return assignmentStatus; }
    public void setAssignmentStatus(String assignmentStatus) { this.assignmentStatus = assignmentStatus; }

    public Integer getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }

    public Maintenance() {}

    // ===== Getter & Setter =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getTechnicianId() { return technicianId; }
    public void setTechnicianId(int technicianId) { this.technicianId = technicianId; }

    public Integer getIncidentId() { return incidentId; }
    public void setIncidentId(Integer incidentId) { this.incidentId = incidentId; }

    public Date getMaintenanceDate() { return maintenanceDate; }
    public void setMaintenanceDate(Date maintenanceDate) { this.maintenanceDate = maintenanceDate; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getTotalCost() { return totalCost; }
    public void setTotalCost(double totalCost) { this.totalCost = totalCost; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
}
