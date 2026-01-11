package com.generatorproject.model;

import java.sql.Timestamp;

public class Users {
    private int id;
    private int roleId;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String avatarUrl;
    private int status;
    private Timestamp createdAt;

    public Users() {}

    private Users(Builder builder) {
        this.id = builder.id;
        this.roleId = builder.roleId;
        this.email = builder.email;
        this.password = builder.password;
        this.fullName = builder.fullName;
        this.phone = builder.phone;
        this.avatarUrl = builder.avatarUrl;
        this.status = builder.status;
        this.createdAt = builder.createdAt;
    }

    public int getId() { return id; }
    public int getRoleId() { return roleId; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getFullName() { return fullName; }
    public String getPhone() { return phone; }
    public String getAvatarUrl() { return avatarUrl; }
    public int getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }

    public static class Builder {
        private int id;
        private int roleId;
        private String email;
        private String password;
        private String fullName;
        private String phone;
        private String avatarUrl;
        private int status;
        private Timestamp createdAt;

        public Builder setId(int id) { this.id = id; return this; }
        public Builder setRoleId(int roleId) { this.roleId = roleId; return this; }
        public Builder setEmail(String email) { this.email = email; return this; }
        public Builder setPassword(String password) { this.password = password; return this; }
        public Builder setFullName(String fullName) { this.fullName = fullName; return this; }
        public Builder setPhone(String phone) { this.phone = phone; return this; }
        public Builder setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; return this; }
        public Builder setStatus(int status) { this.status = status; return this; }
        public Builder setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; return this; }

        public Users build() {
            return new Users(this);
        }
    }
}