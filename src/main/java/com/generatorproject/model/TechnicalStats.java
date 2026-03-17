package com.generatorproject.model;

public class TechnicalStats {

    private int totalTasks;
    private int scheduledTasks;
    private int completedTasks;
    private int cancelledTasks;

    private int repairTasks;
    private int periodicTasks;
    private int inspectionTasks;

    private int tasksThisMonth;
    private int completedThisMonth;
    private int distinctProducts;

    private int totalMaterialQuantity;
    private int totalMaterialLines;
    private int distinctSpareParts;

    private double totalAllTaskCost;
    private double totalCompletedCost;
    private double totalMaterialCost;

    public int getTotalTasks() { return totalTasks; }
    public void setTotalTasks(int totalTasks) { this.totalTasks = totalTasks; }

    public int getScheduledTasks() { return scheduledTasks; }
    public void setScheduledTasks(int scheduledTasks) { this.scheduledTasks = scheduledTasks; }

    public int getCompletedTasks() { return completedTasks; }
    public void setCompletedTasks(int completedTasks) { this.completedTasks = completedTasks; }

    public int getCancelledTasks() { return cancelledTasks; }
    public void setCancelledTasks(int cancelledTasks) { this.cancelledTasks = cancelledTasks; }

    public int getRepairTasks() { return repairTasks; }
    public void setRepairTasks(int repairTasks) { this.repairTasks = repairTasks; }

    public int getPeriodicTasks() { return periodicTasks; }
    public void setPeriodicTasks(int periodicTasks) { this.periodicTasks = periodicTasks; }

    public int getInspectionTasks() { return inspectionTasks; }
    public void setInspectionTasks(int inspectionTasks) { this.inspectionTasks = inspectionTasks; }

    public int getTasksThisMonth() { return tasksThisMonth; }
    public void setTasksThisMonth(int tasksThisMonth) { this.tasksThisMonth = tasksThisMonth; }

    public int getCompletedThisMonth() { return completedThisMonth; }
    public void setCompletedThisMonth(int completedThisMonth) { this.completedThisMonth = completedThisMonth; }

    public int getDistinctProducts() { return distinctProducts; }
    public void setDistinctProducts(int distinctProducts) { this.distinctProducts = distinctProducts; }

    public int getTotalMaterialQuantity() { return totalMaterialQuantity; }
    public void setTotalMaterialQuantity(int totalMaterialQuantity) { this.totalMaterialQuantity = totalMaterialQuantity; }

    public int getTotalMaterialLines() { return totalMaterialLines; }
    public void setTotalMaterialLines(int totalMaterialLines) { this.totalMaterialLines = totalMaterialLines; }

    public int getDistinctSpareParts() { return distinctSpareParts; }
    public void setDistinctSpareParts(int distinctSpareParts) { this.distinctSpareParts = distinctSpareParts; }

    public double getTotalAllTaskCost() { return totalAllTaskCost; }
    public void setTotalAllTaskCost(double totalAllTaskCost) { this.totalAllTaskCost = totalAllTaskCost; }

    public double getTotalCompletedCost() { return totalCompletedCost; }
    public void setTotalCompletedCost(double totalCompletedCost) { this.totalCompletedCost = totalCompletedCost; }

    public double getTotalMaterialCost() { return totalMaterialCost; }
    public void setTotalMaterialCost(double totalMaterialCost) { this.totalMaterialCost = totalMaterialCost; }
}