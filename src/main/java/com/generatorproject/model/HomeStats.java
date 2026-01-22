package com.generatorproject.model;

public class HomeStats {
    private int totalProducts;
    private int totalHours;
    private int totalUsers;

    // BẮT BUỘC PHẢI CÓ GETTER
    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }

    public int getTotalHours() { return totalHours; }
    public void setTotalHours(int totalHours) { this.totalHours = totalHours; }

    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
}