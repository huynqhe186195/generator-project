package com.generatorproject.model;

import java.sql.Timestamp;

public class MaintenanceAssignment {
    private Long id;
    private Integer maintenanceId;
    private Integer technicianId;
    private String assignmentRole;
    private String assignedStatus;
    private Timestamp assignedAt;
    private Integer assignedBy;
    private String note;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getMaintenanceId() { return maintenanceId; }
    public void setMaintenanceId(Integer maintenanceId) { this.maintenanceId = maintenanceId; }
    public Integer getTechnicianId() { return technicianId; }
    public void setTechnicianId(Integer technicianId) { this.technicianId = technicianId; }
    public String getAssignmentRole() { return assignmentRole; }
    public void setAssignmentRole(String assignmentRole) { this.assignmentRole = assignmentRole; }
    public String getAssignedStatus() { return assignedStatus; }
    public void setAssignedStatus(String assignedStatus) { this.assignedStatus = assignedStatus; }
    public Timestamp getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Timestamp assignedAt) { this.assignedAt = assignedAt; }
    public Integer getAssignedBy() { return assignedBy; }
    public void setAssignedBy(Integer assignedBy) { this.assignedBy = assignedBy; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
