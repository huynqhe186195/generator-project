package com.generatorproject.model;

public class Product {

    private int id;
    private String serialNumber;
    private String name;
    private String model;
    private double powerPrime;
    private String status;
    private String imageUrl;

    // 🔥 THÊM THEO DB
    private Brand brand;        // từ products.brand_id -> brands
    private String fuelType;    // enum('DIESEL','GASOLINE')

    // ===== CONSTRUCTOR =====
    public Product() {}

    public Product(int id, String serialNumber, String name, String model,
                   double powerPrime, String status, String imageUrl) {
        this.id = id;
        this.serialNumber = serialNumber;
        this.name = name;
        this.model = model;
        this.powerPrime = powerPrime;
        this.status = status;
        this.imageUrl = imageUrl;
    }

    // ===== GETTER =====
    public int getId() { return id; }

    public String getSerialNumber() { return serialNumber; }

    public String getName() { return name; }

    public String getModel() { return model; }

    public double getPowerPrime() { return powerPrime; }

    public String getStatus() { return status; }

    public String getImageUrl() { return imageUrl; }

    // 🔥 GETTER MỚI
    public Brand getBrand() { return brand; }

    public String getFuelType() { return fuelType; }

    // ===== SETTER =====
    public void setId(int id) { this.id = id; }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public void setName(String name) { this.name = name; }

    public void setModel(String model) { this.model = model; }

    public void setPowerPrime(double powerPrime) {
        this.powerPrime = powerPrime;
    }

    public void setStatus(String status) { this.status = status; }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // 🔥 SETTER MỚI
    public void setBrand(Brand brand) {
        this.brand = brand;
    }

    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }
}
