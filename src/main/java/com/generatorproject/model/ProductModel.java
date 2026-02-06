package com.generatorproject.model;

import java.sql.Timestamp;

public class ProductModel {
    private Long id;
    private String name;
    private String slug;
    private Integer brandId;
    private Integer categoryId;
    private String origin;
    private String fuelType;   // 'DIESEL','GASOLINE','OTHER'
    private Double power;      // kVA
    private String description;
    private String specifications;
    private String manualUrl;
    private String imageUrl;
    private Timestamp createdAt;
    private String status;     // 'ACTIVE','INACTIVE','COMING_SOON'

    // Optional: embed Brand object (nếu bạn muốn)
    private Brand brand;

    private ProductModel(Builder b) {
        this.id = b.id;
        this.name = b.name;
        this.slug = b.slug;
        this.brandId = b.brandId;
        this.categoryId = b.categoryId;
        this.origin = b.origin;
        this.fuelType = b.fuelType;
        this.power = b.power;
        this.description = b.description;
        this.specifications = b.specifications;
        this.manualUrl = b.manualUrl;
        this.imageUrl = b.imageUrl;
        this.createdAt = b.createdAt;
        this.status = b.status;
        this.brand = b.brand;
    }

    public static Builder builder() { return new Builder(); }

    public static class Builder {
        private Long id;
        private String name;
        private String slug;
        private Integer brandId;
        private Integer categoryId;
        private String origin;
        private String fuelType;
        private Double power;
        private String description;
        private String specifications;
        private String manualUrl;
        private String imageUrl;
        private Timestamp createdAt;
        private String status;
        private Brand brand;

        public Builder id(Long id) { this.id = id; return this; }
        public Builder name(String name) { this.name = name; return this; }
        public Builder slug(String slug) { this.slug = slug; return this; }
        public Builder brandId(Integer brandId) { this.brandId = brandId; return this; }
        public Builder categoryId(Integer categoryId) { this.categoryId = categoryId; return this; }
        public Builder origin(String origin) { this.origin = origin; return this; }
        public Builder fuelType(String fuelType) { this.fuelType = fuelType; return this; }
        public Builder power(Double power) { this.power = power; return this; }
        public Builder description(String description) { this.description = description; return this; }
        public Builder specifications(String specifications) { this.specifications = specifications; return this; }
        public Builder manualUrl(String manualUrl) { this.manualUrl = manualUrl; return this; }
        public Builder imageUrl(String imageUrl) { this.imageUrl = imageUrl; return this; }
        public Builder createdAt(Timestamp createdAt) { this.createdAt = createdAt; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder brand(Brand brand) { this.brand = brand; return this; }

        public ProductModel build() { return new ProductModel(this); }
    }

    // Getters (setters không bắt buộc nếu dùng builder)
    public Long getId() { return id; }
    public String getName() { return name; }
    public String getSlug() { return slug; }
    public Integer getBrandId() { return brandId; }
    public Integer getCategoryId() { return categoryId; }
    public String getOrigin() { return origin; }
    public String getFuelType() { return fuelType; }
    public Double getPower() { return power; }
    public String getDescription() { return description; }
    public String getSpecifications() { return specifications; }
    public String getManualUrl() { return manualUrl; }
    public String getImageUrl() { return imageUrl; }
    public Timestamp getCreatedAt() { return createdAt; }
    public String getStatus() { return status; }
    public Brand getBrand() { return brand; }
}
