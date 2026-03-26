package com.generatorproject.model;

import java.sql.Timestamp;

public class Invoice {
    // --- FIELDS KHỚP VỚI DATABASE ---
    private Long id;
    private String invoiceCode;
    private Long customerId;
    private Long quoteId;
    private Integer maintenanceId;
    private Integer createdBy;

    // Tiền nong
    private Double subtotal;     // Tiền trước thuế
    private Double taxRate;      // % Thuế
    private Double taxAmount;    // Tiền thuế
    private Double totalAmount;  // Tổng thanh toán

    // Trạng thái & Ghi chú
    private String paymentMethod; // CASH, BANK_TRANSFER...
    private String paymentStatus; // UNPAID, PAID...
    private String note;

    // Thời gian
    private Timestamp issuedDate; // Ngày xuất
    private Timestamp dueDate;    // Hạn nộp
    private Timestamp paidAt;     // Ngày thực trả

    // --- FIELDS PHỤ TRỢ (Dùng khi JOIN bảng để hiển thị) ---
    private String customerName;
    private String customerEmail;
    private String createdByName; // Tên nhân viên tạo
    private Double laborCost;
    // 1. Constructor rỗng (Cần thiết cho RowMapper/Libraries)
    public Invoice() {}

    // 2. Constructor Private dùng cho Builder
    private Invoice(Builder builder) {
        this.id = builder.id;
        this.invoiceCode = builder.invoiceCode;
        this.customerId = builder.customerId;
        this.quoteId = builder.quoteId;
        this.maintenanceId = builder.maintenanceId;
        this.createdBy = builder.createdBy;
        this.subtotal = builder.subtotal;
        this.taxRate = builder.taxRate;
        this.taxAmount = builder.taxAmount;
        this.totalAmount = builder.totalAmount;
        this.paymentMethod = builder.paymentMethod;
        this.paymentStatus = builder.paymentStatus;
        this.note = builder.note;
        this.issuedDate = builder.issuedDate;
        this.dueDate = builder.dueDate;
        this.paidAt = builder.paidAt;
        this.laborCost = builder.laborCost;
        // Các trường phụ
        this.customerName = builder.customerName;
        this.customerEmail = builder.customerEmail;
        this.createdByName = builder.createdByName;
    }

    // --- GETTER ---
    public Long getId() { return id; }
    public String getInvoiceCode() { return invoiceCode; }
    public Long getCustomerId() { return customerId; }
    public Long getQuoteId() { return quoteId; }
    public Integer getMaintenanceId() { return maintenanceId; }
    public Integer getCreatedBy() { return createdBy; }
    public Double getSubtotal() { return subtotal; }
    public Double getTaxRate() { return taxRate; }
    public Double getTaxAmount() { return taxAmount; }
    public Double getTotalAmount() { return totalAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getPaymentStatus() { return paymentStatus; }
    public String getNote() { return note; }
    public Timestamp getIssuedDate() { return issuedDate; }
    public Timestamp getDueDate() { return dueDate; }
    public Timestamp getPaidAt() { return paidAt; }
    public String getCustomerName() { return customerName; }
    public String getCustomerEmail() { return customerEmail; }
    public String getCreatedByName() { return createdByName; }

    // --- SETTER (Đầy đủ để dùng với RowMapper) ---
    public void setId(Long id) { this.id = id; }
    public void setInvoiceCode(String invoiceCode) { this.invoiceCode = invoiceCode; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }
    public void setQuoteId(Long quoteId) { this.quoteId = quoteId; }
    public void setMaintenanceId(Integer maintenanceId) { this.maintenanceId = maintenanceId; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public void setSubtotal(Double subtotal) { this.subtotal = subtotal; }
    public void setTaxRate(Double taxRate) { this.taxRate = taxRate; }
    public void setTaxAmount(Double taxAmount) { this.taxAmount = taxAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public void setNote(String note) { this.note = note; }
    public void setIssuedDate(Timestamp issuedDate) { this.issuedDate = issuedDate; }
    public void setDueDate(Timestamp dueDate) { this.dueDate = dueDate; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public Double getLaborCost() {
        return laborCost;
    }

    public void setLaborCost(Double laborCost) {
        this.laborCost = laborCost;
    }

    // --- STATIC BUILDER CLASS ---
    public static class Builder {
        private Long id;
        private String invoiceCode;
        private Long customerId;
        private Long quoteId;
        private Integer maintenanceId;
        private Integer createdBy;
        private Double subtotal;
        private Double taxRate;
        private Double taxAmount;
        private Double totalAmount;
        private String paymentMethod;
        private String paymentStatus;
        private String note;
        private Timestamp issuedDate;
        private Timestamp dueDate;
        private Timestamp paidAt;
        private Double laborCost;
        // Fields phụ
        private String customerName;
        private String customerEmail;
        private String createdByName;

        public Builder setId(Long id) { this.id = id; return this; }
        public Builder setInvoiceCode(String invoiceCode) { this.invoiceCode = invoiceCode; return this; }
        public Builder setCustomerId(Long customerId) { this.customerId = customerId; return this; }
        public Builder setQuoteId(Long quoteId) { this.quoteId = quoteId; return this; }
        public Builder setMaintenanceId(Integer maintenanceId) { this.maintenanceId = maintenanceId; return this; }
        public Builder setCreatedBy(Integer createdBy) { this.createdBy = createdBy; return this; }

        public Builder setSubtotal(Double subtotal) { this.subtotal = subtotal; return this; }
        public Builder setTaxRate(Double taxRate) { this.taxRate = taxRate; return this; }
        public Builder setTaxAmount(Double taxAmount) { this.taxAmount = taxAmount; return this; }
        public Builder setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; return this; }

        public Builder setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; return this; }
        public Builder setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; return this; }
        public Builder setNote(String note) { this.note = note; return this; }

        public Builder setIssuedDate(Timestamp issuedDate) { this.issuedDate = issuedDate; return this; }
        public Builder setDueDate(Timestamp dueDate) { this.dueDate = dueDate; return this; }
        public Builder setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; return this; }

        public Builder setCustomerName(String customerName) { this.customerName = customerName; return this; }
        public Builder setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; return this; }
        public Builder setCreatedByName(String createdByName) { this.createdByName = createdByName; return this; }

        public Builder setLaborCost(Double laborCost ) { this.laborCost = laborCost; return this; }


        public Invoice build() {
            return new Invoice(this);
        }
    }
}