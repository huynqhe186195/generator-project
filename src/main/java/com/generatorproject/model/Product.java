package com.generatorproject.model;

import java.sql.Timestamp;

public class Product {

    private Integer id;
    private String serialNumber;
    private String name;
    private String model;
    private String origin;
    private Integer manufactureYear;

    private Integer brandId;
    private Integer categoryId;

    private Double powerPrime;
    private Double powerStandby;
    private String voltage;
    private Double fuelTankCapacity;
    private String fuelType;

    private String currentLocation;
    private String status;
    private Double totalRunningHours;
    private String imageUrl;

    private Integer customerId;
    private String customerName;

    private Brand brand;

    // ✅ NEW
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // ======================
    // GETTER / SETTER
    // ======================
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }

    public Integer getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; }

    public Integer getBrandId() { return brandId; }
    public void setBrandId(Integer brandId) { this.brandId = brandId; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public Double getPowerPrime() { return powerPrime; }
    public void setPowerPrime(Double powerPrime) { this.powerPrime = powerPrime; }

    public Double getPowerStandby() { return powerStandby; }
    public void setPowerStandby(Double powerStandby) { this.powerStandby = powerStandby; }

    public String getVoltage() { return voltage; }
    public void setVoltage(String voltage) { this.voltage = voltage; }

    public Double getFuelTankCapacity() { return fuelTankCapacity; }
    public void setFuelTankCapacity(Double fuelTankCapacity) { this.fuelTankCapacity = fuelTankCapacity; }

    public String getFuelType() { return fuelType; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }

    public String getCurrentLocation() { return currentLocation; }
    public void setCurrentLocation(String currentLocation) { this.currentLocation = currentLocation; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Double getTotalRunningHours() { return totalRunningHours; }
    public void setTotalRunningHours(Double totalRunningHours) { this.totalRunningHours = totalRunningHours; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public Brand getBrand() { return brand; }
    public void setBrand(Brand brand) { this.brand = brand; }

    // ✅ NEW
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
