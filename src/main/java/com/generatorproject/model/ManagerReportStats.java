package com.generatorproject.model;

import java.util.ArrayList;
import java.util.List;

public class ManagerReportStats {
    private int serviceRequestsToday;
    private int serviceRequestsThisWeek;
    private int serviceRequestsThisMonth;
    private int maintenanceTickets;
    private int repairTickets;
    private int waitingRequests;
    private int completedRequests;
    private int overdueRequests;

    private int periodicMaintenanceCount;
    private int unexpectedMaintenanceCount;
    private int machinesDueSoon;
    private int machinesOverdue;
    private double averageMaintenanceHours;
    private String mostCommonMaintenanceType;
    private String mostMaintainedModel;

    private int repairsThisMonth;
    private int repairsDone;
    private int repairsPending;
    private int repairsWithParts;
    private double averageRepairHours;
    private double onsiteRepairRate;
    private String highestFailureModel;

    private int warrantyActiveCases;
    private int warrantyRejectedCases;
    private int warrantyExpiredCases;
    private double warrantyCoverageRate;
    private String topWarrantyPart;
    private String topWarrantyCustomer;
    private String topWarrantyModel;

    private int totalCustomersSupported;
    private int totalTrackedMachines;
    private int activeMachines;
    private int stoppedMachines;
    private int customersDueSoon;
    private String topServiceCustomer;

    private double averageResponseHours;
    private double averageCompletionHours;
    private double onTimeRate;
    private double repeatFailureRate;
    private double revisitRate;

    private List<ChartPoint> requestTrend = new ArrayList<ChartPoint>();
    private List<SimpleStatItem> topRepairIssues = new ArrayList<SimpleStatItem>();
    private List<SimpleStatItem> failureGroups = new ArrayList<SimpleStatItem>();
    private List<SimpleStatItem> topModels = new ArrayList<SimpleStatItem>();
    private List<SimpleStatItem> technicianPerformance = new ArrayList<SimpleStatItem>();
    private List<SimpleStatItem> customerHistory = new ArrayList<SimpleStatItem>();

    public static class ChartPoint {
        private String label;
        private int value;
        public ChartPoint() {}
        public ChartPoint(String label, int value) { this.label = label; this.value = value; }
        public String getLabel() { return label; }
        public void setLabel(String label) { this.label = label; }
        public int getValue() { return value; }
        public void setValue(int value) { this.value = value; }
    }

    public static class SimpleStatItem {
        private String label;
        private String extra;
        private int value;
        private double percentage;

        public SimpleStatItem() {}
        public SimpleStatItem(String label, String extra, int value, double percentage) {
            this.label = label;
            this.extra = extra;
            this.value = value;
            this.percentage = percentage;
        }
        public String getLabel() { return label; }
        public void setLabel(String label) { this.label = label; }
        public String getExtra() { return extra; }
        public void setExtra(String extra) { this.extra = extra; }
        public int getValue() { return value; }
        public void setValue(int value) { this.value = value; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }

    public int getServiceRequestsToday() { return serviceRequestsToday; }
    public void setServiceRequestsToday(int serviceRequestsToday) { this.serviceRequestsToday = serviceRequestsToday; }
    public int getServiceRequestsThisWeek() { return serviceRequestsThisWeek; }
    public void setServiceRequestsThisWeek(int serviceRequestsThisWeek) { this.serviceRequestsThisWeek = serviceRequestsThisWeek; }
    public int getServiceRequestsThisMonth() { return serviceRequestsThisMonth; }
    public void setServiceRequestsThisMonth(int serviceRequestsThisMonth) { this.serviceRequestsThisMonth = serviceRequestsThisMonth; }
    public int getMaintenanceTickets() { return maintenanceTickets; }
    public void setMaintenanceTickets(int maintenanceTickets) { this.maintenanceTickets = maintenanceTickets; }
    public int getRepairTickets() { return repairTickets; }
    public void setRepairTickets(int repairTickets) { this.repairTickets = repairTickets; }
    public int getWaitingRequests() { return waitingRequests; }
    public void setWaitingRequests(int waitingRequests) { this.waitingRequests = waitingRequests; }
    public int getCompletedRequests() { return completedRequests; }
    public void setCompletedRequests(int completedRequests) { this.completedRequests = completedRequests; }
    public int getOverdueRequests() { return overdueRequests; }
    public void setOverdueRequests(int overdueRequests) { this.overdueRequests = overdueRequests; }
    public int getPeriodicMaintenanceCount() { return periodicMaintenanceCount; }
    public void setPeriodicMaintenanceCount(int periodicMaintenanceCount) { this.periodicMaintenanceCount = periodicMaintenanceCount; }
    public int getUnexpectedMaintenanceCount() { return unexpectedMaintenanceCount; }
    public void setUnexpectedMaintenanceCount(int unexpectedMaintenanceCount) { this.unexpectedMaintenanceCount = unexpectedMaintenanceCount; }
    public int getMachinesDueSoon() { return machinesDueSoon; }
    public void setMachinesDueSoon(int machinesDueSoon) { this.machinesDueSoon = machinesDueSoon; }
    public int getMachinesOverdue() { return machinesOverdue; }
    public void setMachinesOverdue(int machinesOverdue) { this.machinesOverdue = machinesOverdue; }
    public double getAverageMaintenanceHours() { return averageMaintenanceHours; }
    public void setAverageMaintenanceHours(double averageMaintenanceHours) { this.averageMaintenanceHours = averageMaintenanceHours; }
    public String getMostCommonMaintenanceType() { return mostCommonMaintenanceType; }
    public void setMostCommonMaintenanceType(String mostCommonMaintenanceType) { this.mostCommonMaintenanceType = mostCommonMaintenanceType; }
    public String getMostMaintainedModel() { return mostMaintainedModel; }
    public void setMostMaintainedModel(String mostMaintainedModel) { this.mostMaintainedModel = mostMaintainedModel; }
    public int getRepairsThisMonth() { return repairsThisMonth; }
    public void setRepairsThisMonth(int repairsThisMonth) { this.repairsThisMonth = repairsThisMonth; }
    public int getRepairsDone() { return repairsDone; }
    public void setRepairsDone(int repairsDone) { this.repairsDone = repairsDone; }
    public int getRepairsPending() { return repairsPending; }
    public void setRepairsPending(int repairsPending) { this.repairsPending = repairsPending; }
    public int getRepairsWithParts() { return repairsWithParts; }
    public void setRepairsWithParts(int repairsWithParts) { this.repairsWithParts = repairsWithParts; }
    public double getAverageRepairHours() { return averageRepairHours; }
    public void setAverageRepairHours(double averageRepairHours) { this.averageRepairHours = averageRepairHours; }
    public double getOnsiteRepairRate() { return onsiteRepairRate; }
    public void setOnsiteRepairRate(double onsiteRepairRate) { this.onsiteRepairRate = onsiteRepairRate; }
    public String getHighestFailureModel() { return highestFailureModel; }
    public void setHighestFailureModel(String highestFailureModel) { this.highestFailureModel = highestFailureModel; }
    public int getWarrantyActiveCases() { return warrantyActiveCases; }
    public void setWarrantyActiveCases(int warrantyActiveCases) { this.warrantyActiveCases = warrantyActiveCases; }
    public int getWarrantyRejectedCases() { return warrantyRejectedCases; }
    public void setWarrantyRejectedCases(int warrantyRejectedCases) { this.warrantyRejectedCases = warrantyRejectedCases; }
    public int getWarrantyExpiredCases() { return warrantyExpiredCases; }
    public void setWarrantyExpiredCases(int warrantyExpiredCases) { this.warrantyExpiredCases = warrantyExpiredCases; }
    public double getWarrantyCoverageRate() { return warrantyCoverageRate; }
    public void setWarrantyCoverageRate(double warrantyCoverageRate) { this.warrantyCoverageRate = warrantyCoverageRate; }
    public String getTopWarrantyPart() { return topWarrantyPart; }
    public void setTopWarrantyPart(String topWarrantyPart) { this.topWarrantyPart = topWarrantyPart; }
    public String getTopWarrantyCustomer() { return topWarrantyCustomer; }
    public void setTopWarrantyCustomer(String topWarrantyCustomer) { this.topWarrantyCustomer = topWarrantyCustomer; }
    public String getTopWarrantyModel() { return topWarrantyModel; }
    public void setTopWarrantyModel(String topWarrantyModel) { this.topWarrantyModel = topWarrantyModel; }
    public int getTotalCustomersSupported() { return totalCustomersSupported; }
    public void setTotalCustomersSupported(int totalCustomersSupported) { this.totalCustomersSupported = totalCustomersSupported; }
    public int getTotalTrackedMachines() { return totalTrackedMachines; }
    public void setTotalTrackedMachines(int totalTrackedMachines) { this.totalTrackedMachines = totalTrackedMachines; }
    public int getActiveMachines() { return activeMachines; }
    public void setActiveMachines(int activeMachines) { this.activeMachines = activeMachines; }
    public int getStoppedMachines() { return stoppedMachines; }
    public void setStoppedMachines(int stoppedMachines) { this.stoppedMachines = stoppedMachines; }
    public int getCustomersDueSoon() { return customersDueSoon; }
    public void setCustomersDueSoon(int customersDueSoon) { this.customersDueSoon = customersDueSoon; }
    public String getTopServiceCustomer() { return topServiceCustomer; }
    public void setTopServiceCustomer(String topServiceCustomer) { this.topServiceCustomer = topServiceCustomer; }
    public double getAverageResponseHours() { return averageResponseHours; }
    public void setAverageResponseHours(double averageResponseHours) { this.averageResponseHours = averageResponseHours; }
    public double getAverageCompletionHours() { return averageCompletionHours; }
    public void setAverageCompletionHours(double averageCompletionHours) { this.averageCompletionHours = averageCompletionHours; }
    public double getOnTimeRate() { return onTimeRate; }
    public void setOnTimeRate(double onTimeRate) { this.onTimeRate = onTimeRate; }
    public double getRepeatFailureRate() { return repeatFailureRate; }
    public void setRepeatFailureRate(double repeatFailureRate) { this.repeatFailureRate = repeatFailureRate; }
    public double getRevisitRate() { return revisitRate; }
    public void setRevisitRate(double revisitRate) { this.revisitRate = revisitRate; }
    public List<ChartPoint> getRequestTrend() { return requestTrend; }
    public void setRequestTrend(List<ChartPoint> requestTrend) { this.requestTrend = requestTrend; }
    public List<SimpleStatItem> getTopRepairIssues() { return topRepairIssues; }
    public void setTopRepairIssues(List<SimpleStatItem> topRepairIssues) { this.topRepairIssues = topRepairIssues; }
    public List<SimpleStatItem> getFailureGroups() { return failureGroups; }
    public void setFailureGroups(List<SimpleStatItem> failureGroups) { this.failureGroups = failureGroups; }
    public List<SimpleStatItem> getTopModels() { return topModels; }
    public void setTopModels(List<SimpleStatItem> topModels) { this.topModels = topModels; }
    public List<SimpleStatItem> getTechnicianPerformance() { return technicianPerformance; }
    public void setTechnicianPerformance(List<SimpleStatItem> technicianPerformance) { this.technicianPerformance = technicianPerformance; }
    public List<SimpleStatItem> getCustomerHistory() { return customerHistory; }
    public void setCustomerHistory(List<SimpleStatItem> customerHistory) { this.customerHistory = customerHistory; }
}
