package com.generatorproject.model.reports;

/// Thêm DTO cho dropdown filters (simple option)

public class IdNameOption {
    private int id;
    private String name;

    public IdNameOption() {}

    public IdNameOption(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}