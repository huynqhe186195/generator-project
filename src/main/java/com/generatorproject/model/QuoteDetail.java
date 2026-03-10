package com.generatorproject.model;

public class QuoteDetail {
    private int id;
    private int quoteId;
    private String description;
    private int quantity;
    private double unitPrice;
    private double totalPrice;

    public QuoteDetail() {}

    // --- CONSTRUCTOR BUILDER (QUAN TRỌNG) ---
    private QuoteDetail(Builder builder) {
        this.id = builder.id;
        this.quoteId = builder.quoteId;
        this.description = builder.description;
        this.quantity = builder.quantity;
        this.unitPrice = builder.unitPrice;
        this.totalPrice = builder.totalPrice;
    }

    // --- GETTER ---
    public int getId() { return id; }
    public int getQuoteId() { return quoteId; }
    public String getDescription() { return description; }
    public int getQuantity() { return quantity; }
    public double getUnitPrice() { return unitPrice; }
    public double getTotalPrice() { return totalPrice; }

    // --- SETTER ---
    public void setId(int id) { this.id = id; }
    public void setQuoteId(int quoteId) { this.quoteId = quoteId; }
    public void setDescription(String description) { this.description = description; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    // --- BUILDER CLASS ---
    public static class Builder {
        private int id;
        private int quoteId;
        private String description;
        private int quantity;
        private double unitPrice;
        private double totalPrice;

        public Builder setId(int id) {
            this.id = id;
            return this;
        }

        public Builder setQuoteId(int quoteId) {
            this.quoteId = quoteId;
            return this;
        }

        public Builder setDescription(String description) {
            this.description = description;
            return this;
        }

        public Builder setQuantity(int quantity) {
            this.quantity = quantity;
            return this;
        }

        public Builder setUnitPrice(double unitPrice) {
            this.unitPrice = unitPrice;
            return this;
        }

        public Builder setTotalPrice(double totalPrice) {
            this.totalPrice = totalPrice;
            return this;
        }

        public QuoteDetail build() {
            return new QuoteDetail(this);
        }
    }
}