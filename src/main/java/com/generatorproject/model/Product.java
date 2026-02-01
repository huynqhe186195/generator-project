package com.generatorproject.model;

public class Product {

    // ===== DB columns =====
    private int id;
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

    private String fuelType;          // DIESEL / GASOLINE
    private String currentLocation;

    private String status;            // READY / RUNNING / MAINTENANCE / BROKEN
    private Double totalRunningHours;

    private String imageUrl;

    private Integer customerId;

    // ===== join objects (optional) =====
    private Brand brand;              // JOIN brands
    private String customerName;      // JOIN users.full_name

    // ===== CONSTRUCTOR =====
    public Product() {}

    // (Giữ constructor cũ, nhưng update powerPrime từ double -> Double)
    public Product(int id, String serialNumber, String name, String model,
                   Double powerPrime, String status, String imageUrl) {
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

    public String getOrigin() { return origin; }
    public Integer getManufactureYear() { return manufactureYear; }

    public Integer getBrandId() { return brandId; }
    public Integer getCategoryId() { return categoryId; }

    public Double getPowerPrime() { return powerPrime; }
    public Double getPowerStandby() { return powerStandby; }

    public String getVoltage() { return voltage; }
    public Double getFuelTankCapacity() { return fuelTankCapacity; }

    public String getFuelType() { return fuelType; }
    public String getCurrentLocation() { return currentLocation; }

    public String getStatus() { return status; }
    public Double getTotalRunningHours() { return totalRunningHours; }

    public String getImageUrl() { return imageUrl; }

    public Integer getCustomerId() { return customerId; }

    // JOIN fields
    public Brand getBrand() { return brand; }
    public String getCustomerName() { return customerName; }

    // ===== SETTER =====
    public void setId(int id) { this.id = id; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }
    public void setName(String name) { this.name = name; }
    public void setModel(String model) { this.model = model; }

    public void setOrigin(String origin) { this.origin = origin; }
    public void setManufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; }

    public void setBrandId(Integer brandId) { this.brandId = brandId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public void setPowerPrime(Double powerPrime) { this.powerPrime = powerPrime; }
    public void setPowerStandby(Double powerStandby) { this.powerStandby = powerStandby; }

    public void setVoltage(String voltage) { this.voltage = voltage; }
    public void setFuelTankCapacity(Double fuelTankCapacity) { this.fuelTankCapacity = fuelTankCapacity; }

    public void setFuelType(String fuelType) { this.fuelType = fuelType; }
    public void setCurrentLocation(String currentLocation) { this.currentLocation = currentLocation; }

    public void setStatus(String status) { this.status = status; }
    public void setTotalRunningHours(Double totalRunningHours) { this.totalRunningHours = totalRunningHours; }

    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    // JOIN setters
    public void setBrand(Brand brand) { this.brand = brand; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
}
