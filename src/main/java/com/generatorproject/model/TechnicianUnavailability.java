package com.generatorproject.model;

import java.sql.Timestamp;

public class TechnicianUnavailability {
    private int technicianId;
    private Timestamp unavailableStart;
    private Timestamp unavailableEnd;

    public int getTechnicianId() {
        return technicianId;
    }

    public void setTechnicianId(int technicianId) {
        this.technicianId = technicianId;
    }

    public Timestamp getUnavailableStart() {
        return unavailableStart;
    }

    public void setUnavailableStart(Timestamp unavailableStart) {
        this.unavailableStart = unavailableStart;
    }

    public Timestamp getUnavailableEnd() {
        return unavailableEnd;
    }

    public void setUnavailableEnd(Timestamp unavailableEnd) {
        this.unavailableEnd = unavailableEnd;
    }
}
