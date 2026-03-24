package com.generatorproject.model;

import java.sql.Timestamp;

public class IncidentPlan {
    private Long id;
    private Integer incidentId;
    private Integer plannedBy;
    private Long previousPlanId;
    private int planVersion;
    private boolean current;
    private String workType;
    private int estimatedDurationMinutes;
    private int requiredTechnicianCount;
    private boolean requiresPartsPreparation;
    private String partsNote;
    private String serviceLocation;
    private String priorityOverride;
    private String staffNote;
    private String managerReviewStatus;
    private Integer approvedBy;
    private Timestamp approvedAt;
    private String rejectionReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getIncidentId() { return incidentId; }
    public void setIncidentId(Integer incidentId) { this.incidentId = incidentId; }
    public Integer getPlannedBy() { return plannedBy; }
    public void setPlannedBy(Integer plannedBy) { this.plannedBy = plannedBy; }
    public Long getPreviousPlanId() { return previousPlanId; }
    public void setPreviousPlanId(Long previousPlanId) { this.previousPlanId = previousPlanId; }
    public int getPlanVersion() { return planVersion; }
    public void setPlanVersion(int planVersion) { this.planVersion = planVersion; }
    public boolean isCurrent() { return current; }
    public void setCurrent(boolean current) { this.current = current; }
    public String getWorkType() { return workType; }
    public void setWorkType(String workType) { this.workType = workType; }
    public int getEstimatedDurationMinutes() { return estimatedDurationMinutes; }
    public void setEstimatedDurationMinutes(int estimatedDurationMinutes) { this.estimatedDurationMinutes = estimatedDurationMinutes; }
    public int getRequiredTechnicianCount() { return requiredTechnicianCount; }
    public void setRequiredTechnicianCount(int requiredTechnicianCount) { this.requiredTechnicianCount = requiredTechnicianCount; }
    public boolean isRequiresPartsPreparation() { return requiresPartsPreparation; }
    public void setRequiresPartsPreparation(boolean requiresPartsPreparation) { this.requiresPartsPreparation = requiresPartsPreparation; }
    public String getPartsNote() { return partsNote; }
    public void setPartsNote(String partsNote) { this.partsNote = partsNote; }
    public String getServiceLocation() { return serviceLocation; }
    public void setServiceLocation(String serviceLocation) { this.serviceLocation = serviceLocation; }
    public String getPriorityOverride() { return priorityOverride; }
    public void setPriorityOverride(String priorityOverride) { this.priorityOverride = priorityOverride; }
    public String getStaffNote() { return staffNote; }
    public void setStaffNote(String staffNote) { this.staffNote = staffNote; }
    public String getManagerReviewStatus() { return managerReviewStatus; }
    public void setManagerReviewStatus(String managerReviewStatus) { this.managerReviewStatus = managerReviewStatus; }
    public Integer getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }
    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
