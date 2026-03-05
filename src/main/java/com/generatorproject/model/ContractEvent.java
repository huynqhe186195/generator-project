package com.generatorproject.model;

import java.sql.Timestamp;

public class ContractEvent {
    private Long id;
    private Long contractId;
    private String eventType;
    private String reasonCode;
    private String terminatedReason;
    private String decisionDoc;
    private String note;
    private Long actorId;
    private String oldStatus;
    private String newStatus;
    private String meta;
    private Timestamp createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getContractId() { return contractId; }
    public void setContractId(Long contractId) { this.contractId = contractId; }

    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }

    public String getReasonCode() { return reasonCode; }
    public void setReasonCode(String reasonCode) { this.reasonCode = reasonCode; }

    public String getTerminatedReason() { return terminatedReason; }
    public void setTerminatedReason(String terminatedReason) { this.terminatedReason = terminatedReason; }

    public String getDecisionDoc() { return decisionDoc; }
    public void setDecisionDoc(String decisionDoc) { this.decisionDoc = decisionDoc; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Long getActorId() { return actorId; }
    public void setActorId(Long actorId) { this.actorId = actorId; }

    public String getOldStatus() { return oldStatus; }
    public void setOldStatus(String oldStatus) { this.oldStatus = oldStatus; }

    public String getNewStatus() { return newStatus; }
    public void setNewStatus(String newStatus) { this.newStatus = newStatus; }

    public String getMeta() { return meta; }
    public void setMeta(String meta) { this.meta = meta; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
