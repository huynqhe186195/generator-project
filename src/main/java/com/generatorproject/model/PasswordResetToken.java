package com.generatorproject.model;

import java.sql.Timestamp;

public class PasswordResetToken {
    private int id;
    private int userId;
    private String token;
    private Timestamp expiryDate;
    private boolean isUsed;

    public PasswordResetToken() {}

    private PasswordResetToken(Builder builder) {
        this.id = builder.id;
        this.userId = builder.userId;
        this.token = builder.token;
        this.expiryDate = builder.expiryDate;
        this.isUsed = builder.isUsed;
    }

    public int getId() {
        return id;
    }

    public int getUserId() {
        return userId;
    }

    public String getToken() {
        return token;
    }

    public Timestamp getExpiryDate() {
        return expiryDate;
    }

    public boolean isUsed() {
        return isUsed;
    }
    public static class Builder {
        private int id;
        private int userId;
        private String token;
        private Timestamp expiryDate;
        private boolean isUsed;

        public Builder setId(int id) { this.id = id; return this; }
        public Builder setUserId(int userId) { this.userId = userId; return this; }
        public Builder setToken(String token) { this.token = token; return this; }
        public Builder setExpiryDate(Timestamp expiryDate) { this.expiryDate = expiryDate; return this; }
        public Builder setUsed(boolean used) { this.isUsed = used; return this; }

        public PasswordResetToken build() {
            return new PasswordResetToken(this);
        }
    }
}
