package com.generatorproject.model;

import java.sql.Time;

public class TechnicianProfile {
    private int technicianId;
    private String serviceArea;
    private String homeBase;
    private Time workingHoursStart;
    private Time workingHoursEnd;
    private Integer maxTasksPerDay;
    private boolean activeStatus;
    private String timezoneName;

    public int getTechnicianId() {
        return technicianId;
    }

    public void setTechnicianId(int technicianId) {
        this.technicianId = technicianId;
    }

    public String getServiceArea() {
        return serviceArea;
    }

    public void setServiceArea(String serviceArea) {
        this.serviceArea = serviceArea;
    }

    public String getHomeBase() {
        return homeBase;
    }

    public void setHomeBase(String homeBase) {
        this.homeBase = homeBase;
    }

    public Time getWorkingHoursStart() {
        return workingHoursStart;
    }

    public void setWorkingHoursStart(Time workingHoursStart) {
        this.workingHoursStart = workingHoursStart;
    }

    public Time getWorkingHoursEnd() {
        return workingHoursEnd;
    }

    public void setWorkingHoursEnd(Time workingHoursEnd) {
        this.workingHoursEnd = workingHoursEnd;
    }

    public Integer getMaxTasksPerDay() {
        return maxTasksPerDay;
    }

    public void setMaxTasksPerDay(Integer maxTasksPerDay) {
        this.maxTasksPerDay = maxTasksPerDay;
    }

    public boolean isActiveStatus() {
        return activeStatus;
    }

    public void setActiveStatus(boolean activeStatus) {
        this.activeStatus = activeStatus;
    }

    public String getTimezoneName() {
        return timezoneName;
    }

    public void setTimezoneName(String timezoneName) {
        this.timezoneName = timezoneName;
    }
}
