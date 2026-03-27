package com.generatorproject.model.report;

import java.sql.Timestamp;

public class TicketReportRow {
    private int id;
    private String title;
    private String status;
    private String priority;

    private Integer productId;
    private Integer contractId;
    private String inputContractNumber;
    private String inputSerialNumber;

    private String serialNumber;       // products.serial_number
    private String customerName;       // users.full_name (customer)
    private String technicianName;     // users.full_name (technician) - từ incidents.technician_id hoặc maintenance_assignments
    private String modelName;          // product_models.name

    private Timestamp createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public Integer getContractId() { return contractId; }
    public void setContractId(Integer contractId) { this.contractId = contractId; }

    public String getInputContractNumber() { return inputContractNumber; }
    public void setInputContractNumber(String inputContractNumber) { this.inputContractNumber = inputContractNumber; }

    public String getInputSerialNumber() { return inputSerialNumber; }
    public void setInputSerialNumber(String inputSerialNumber) { this.inputSerialNumber = inputSerialNumber; }

    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getTechnicianName() { return technicianName; }
    public void setTechnicianName(String technicianName) { this.technicianName = technicianName; }

    public String getModelName() { return modelName; }
    public void setModelName(String modelName) { this.modelName = modelName; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}