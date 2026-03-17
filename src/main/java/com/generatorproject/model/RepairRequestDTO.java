package com.generatorproject.model;

import java.math.BigDecimal;
import java.util.List;

public class RepairRequestDTO {

    private Integer maintenanceId;
    private Integer technicianId;
    private String actualDescription;

    private BigDecimal partsTotal;
    private BigDecimal grandTotal;
    private List<MaterialDTO> materials;
    private BigDecimal laborCost;
    // --- Getters and Setters cho DTO gốc ---
    public Integer getMaintenanceId() { return maintenanceId; }
    public void setMaintenanceId(Integer maintenanceId) { this.maintenanceId = maintenanceId; }

    public Integer getTechnicianId() { return technicianId; }
    public void setTechnicianId(Integer technicianId) { this.technicianId = technicianId; }

    public String getActualDescription() { return actualDescription; }
    public void setActualDescription(String actualDescription) { this.actualDescription = actualDescription; }



    public BigDecimal getPartsTotal() { return partsTotal; }
    public void setPartsTotal(BigDecimal partsTotal) { this.partsTotal = partsTotal; }

    public BigDecimal getGrandTotal() { return grandTotal; }
    public void setGrandTotal(BigDecimal grandTotal) { this.grandTotal = grandTotal; }

    public List<MaterialDTO> getMaterials() { return materials; }
    public void setMaterials(List<MaterialDTO> materials) { this.materials = materials; }

    public BigDecimal getLaborCost() {
        return laborCost;
    }

    public void setLaborCost(BigDecimal laborCost) {
        this.laborCost = laborCost;
    }

    // --- Inner Class MaterialDTO ---
    public static class MaterialDTO {
        private Integer sparePartId;
        private String partName; // Dùng để hiển thị JSP, tự map sau khi lấy từ DB
        private Integer quantityUsed;

        // BỔ SUNG TRƯỜNG MỚI ĐỂ HỨNG ĐƠN GIÁ TỪ JSON
        private BigDecimal unitPrice;

        private BigDecimal costAtTime; // Thành tiền (quantityUsed * unitPrice)

        // Getters and Setters cho MaterialDTO
        public Integer getSparePartId() { return sparePartId; }
        public void setSparePartId(Integer sparePartId) { this.sparePartId = sparePartId; }

        public String getPartName() { return partName; }
        public void setPartName(String partName) { this.partName = partName; }

        public Integer getQuantityUsed() { return quantityUsed; }
        public void setQuantityUsed(Integer quantityUsed) { this.quantityUsed = quantityUsed; }

        public BigDecimal getUnitPrice() { return unitPrice; }
        public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

        public BigDecimal getCostAtTime() { return costAtTime; }
        public void setCostAtTime(BigDecimal costAtTime) { this.costAtTime = costAtTime; }
    }
}