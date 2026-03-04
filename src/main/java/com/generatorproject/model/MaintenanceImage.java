package com.generatorproject.model;

import java.sql.Timestamp;

public class MaintenanceImage {
    private int id;
    private int maintenanceId;
    private String imagePath;
    private Timestamp uploadedAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMaintenanceId() { return maintenanceId; }
    public void setMaintenanceId(int maintenanceId) { this.maintenanceId = maintenanceId; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}