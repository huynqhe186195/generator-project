package com.generatorproject.model;

public class HomeStats {

    private int totalProducts;        // bảng products
    private int totalProductModels;   // bảng product_models
    private int totalHours;
    private int totalUsers;

    // ===== PRODUCTS =====
    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }

    // ===== PRODUCT MODELS =====
    public int getTotalProductModels() {
        return totalProductModels;
    }

    public void setTotalProductModels(int totalProductModels) {
        this.totalProductModels = totalProductModels;
    }

    // ===== HOURS =====
    public int getTotalHours() {
        return totalHours;
    }

    public void setTotalHours(int totalHours) {
        this.totalHours = totalHours;
    }

    // ===== USERS =====
    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }
}