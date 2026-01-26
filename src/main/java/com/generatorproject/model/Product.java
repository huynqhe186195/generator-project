package com.generatorproject.model;

public class Product {
    private int id;
    private String serialNumber;
    private String name;
    private String model;
    private double powerPrime;
    private String status;
    private String imageUrl;

    // Constructor mặc định
    public Product() {}

    // Constructor có tham số
    public Product(int id, String serialNumber, String name, String model, double powerPrime, String status, String imageUrl) {
        this.id = id;
        this.serialNumber = serialNumber;
        this.name = name;
        this.model = model;
        this.powerPrime = powerPrime;
        this.status = status;
        this.imageUrl = imageUrl;
    }

    // --- CÁC HÀM GETTER ---
    public int getId() { return id; }
    public String getSerialNumber() { return serialNumber; }
    public String getName() { return name; }
    public String getModel() { return model; }
    public double getPowerPrime() { return powerPrime; }
    public String getStatus() { return status; }
    public String getImageUrl() { return imageUrl; }

    // --- CÁC HÀM SETTER (Bổ sung để hết lỗi gạch đỏ) ---
    public void setId(int id) { this.id = id; }

    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public void setName(String name) { this.name = name; }

    public void setModel(String model) { this.model = model; }

    public void setPowerPrime(double powerPrime) { this.powerPrime = powerPrime; }

    public void setStatus(String status) { this.status = status; }

    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}