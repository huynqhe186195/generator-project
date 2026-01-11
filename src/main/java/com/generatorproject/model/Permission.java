package com.generatorproject.model;

public class Permission {
    private int id;
    private String name;
    private String code;
    private String module;
    private boolean checked; // dùng cho form update

    public Permission() {
    }

    public Permission(int id, String name, String code, String module, boolean checked) {
        this.id = id;
        this.name = name;
        this.code = code;
        this.module = module;
        this.checked = checked;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }
}

