package com.generatorproject.model;

import java.sql.Timestamp;

public class TechnicianSkill {
    private int technicianId;
    private String skillCode;
    private String skillName;
    private Timestamp expiresAt;
    private boolean catalogActive;

    public int getTechnicianId() {
        return technicianId;
    }

    public void setTechnicianId(int technicianId) {
        this.technicianId = technicianId;
    }

    public String getSkillCode() {
        return skillCode;
    }

    public void setSkillCode(String skillCode) {
        this.skillCode = skillCode;
    }

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isCatalogActive() {
        return catalogActive;
    }

    public void setCatalogActive(boolean catalogActive) {
        this.catalogActive = catalogActive;
    }
}
