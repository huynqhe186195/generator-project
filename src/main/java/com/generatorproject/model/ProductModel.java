package com.generatorproject.model;

import java.sql.Timestamp;

public class ProductModel {
    private int id;
    private String name;
    private String slug;
    private int brandId;
    private int categoryId;
    private String origin;
    private String fuelType;
    private Double power;
    private String description;
    private String specifications;
    private String manualUrl;
    private String imageUrl;
    private Timestamp createdAt;
    private String status;

    private ProductModel(Builder builder) {
        this.id = builder.id;
        this.name = builder.name;
        this.slug = builder.slug;
        this.brandId = builder.brandId;
        this.categoryId = builder.categoryId;
        this.origin = builder.origin;
        this.fuelType = builder.fuelType;
        this.power = builder.power;
        this.description = builder.description;
        this.specifications = builder.specifications;
        this.manualUrl = builder.manualUrl;
        this.imageUrl = builder.imageUrl;
        this.createdAt = builder.createdAt;
        this.status = builder.status;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getSlug() { return slug; }
    public int getBrandId() { return brandId; }
    public int getCategoryId() { return categoryId; }
    public String getOrigin() { return origin; }
    public String getFuelType() { return fuelType; }
    public Double getPower() { return power; }
    public String getDescription() { return description; }
    public String getSpecifications() { return specifications; }
    public String getManualUrl() { return manualUrl; }
    public String getImageUrl() { return imageUrl; }
    public Timestamp getCreatedAt() { return createdAt; }
    public String getStatus() { return status; }

    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }

    public static class Builder {
        private int id;
        private String name;
        private String slug;
        private int brandId;
        private int categoryId;
        private String origin;
        private String fuelType;
        private Double power;
        private String description;
        private String specifications;
        private String manualUrl;
        private String imageUrl;
        private Timestamp createdAt;
        private String status;

        public Builder() {}

        public Builder setId(int id) { this.id = id; return this; }
        public Builder setName(String name) { this.name = name; return this; }
        public Builder setSlug(String slug) { this.slug = slug; return this; }
        public Builder setBrandId(int brandId) { this.brandId = brandId; return this; }
        public Builder setCategoryId(int categoryId) { this.categoryId = categoryId; return this; }
        public Builder setOrigin(String origin) { this.origin = origin; return this; }
        public Builder setFuelType(String fuelType) { this.fuelType = fuelType; return this; }
        public Builder setPower(Double power) { this.power = power; return this; }
        public Builder setDescription(String description) { this.description = description; return this; }
        public Builder setSpecifications(String specifications) { this.specifications = specifications; return this; }
        public Builder setManualUrl(String manualUrl) { this.manualUrl = manualUrl; return this; }
        public Builder setImageUrl(String imageUrl) { this.imageUrl = imageUrl; return this; }
        public Builder setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; return this; }
        public Builder setStatus(String status) { this.status = status; return this; }

        public ProductModel build() {
            return new ProductModel(this);
        }
    }
}