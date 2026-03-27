package com.generatorproject.model.dashboard;

public class ManagerDashboardKpi {
    private int totalCustomers;
    private int totalDevices;

    private int devicesRunning;
    private int devicesBroken;
    private int devicesMaintenance;

    private int ticketsOpenedToday;

    private int maintenancesToday;
    private int maintenancesThisWeek;
    private int maintenancesThisMonth;

    private int jobsCompletedThisMonth;

    private int overdueMaintenances; // cảnh báo quá hạn (job có scheduled_end < now, chưa completed/cancelled)

    private double slaOnTimeRateThisMonth; // 0..100
    private double serviceRevenueThisMonth;

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public int getTotalDevices() {
        return totalDevices;
    }

    public void setTotalDevices(int totalDevices) {
        this.totalDevices = totalDevices;
    }

    public int getDevicesRunning() {
        return devicesRunning;
    }

    public void setDevicesRunning(int devicesRunning) {
        this.devicesRunning = devicesRunning;
    }

    public int getDevicesBroken() {
        return devicesBroken;
    }

    public void setDevicesBroken(int devicesBroken) {
        this.devicesBroken = devicesBroken;
    }

    public int getDevicesMaintenance() {
        return devicesMaintenance;
    }

    public void setDevicesMaintenance(int devicesMaintenance) {
        this.devicesMaintenance = devicesMaintenance;
    }

    public int getTicketsOpenedToday() {
        return ticketsOpenedToday;
    }

    public void setTicketsOpenedToday(int ticketsOpenedToday) {
        this.ticketsOpenedToday = ticketsOpenedToday;
    }

    public int getMaintenancesToday() {
        return maintenancesToday;
    }

    public void setMaintenancesToday(int maintenancesToday) {
        this.maintenancesToday = maintenancesToday;
    }

    public int getMaintenancesThisWeek() {
        return maintenancesThisWeek;
    }

    public void setMaintenancesThisWeek(int maintenancesThisWeek) {
        this.maintenancesThisWeek = maintenancesThisWeek;
    }

    public int getMaintenancesThisMonth() {
        return maintenancesThisMonth;
    }

    public void setMaintenancesThisMonth(int maintenancesThisMonth) {
        this.maintenancesThisMonth = maintenancesThisMonth;
    }

    public int getJobsCompletedThisMonth() {
        return jobsCompletedThisMonth;
    }

    public void setJobsCompletedThisMonth(int jobsCompletedThisMonth) {
        this.jobsCompletedThisMonth = jobsCompletedThisMonth;
    }

    public int getOverdueMaintenances() {
        return overdueMaintenances;
    }

    public void setOverdueMaintenances(int overdueMaintenances) {
        this.overdueMaintenances = overdueMaintenances;
    }

    public double getSlaOnTimeRateThisMonth() {
        return slaOnTimeRateThisMonth;
    }

    public void setSlaOnTimeRateThisMonth(double slaOnTimeRateThisMonth) {
        this.slaOnTimeRateThisMonth = slaOnTimeRateThisMonth;
    }

    public double getServiceRevenueThisMonth() {
        return serviceRevenueThisMonth;
    }

    public void setServiceRevenueThisMonth(double serviceRevenueThisMonth) {
        this.serviceRevenueThisMonth = serviceRevenueThisMonth;
    }
}