package com.generatorproject.model;

import java.sql.Date;

public class ContractDraft {
    private String contractNumber;
    private Long customerId;
    private Date signedDate;
    private Date startDate;
    private Date endDate;

    public String getContractNumber() { return contractNumber; }
    public void setContractNumber(String contractNumber) { this.contractNumber = contractNumber; }
    public Long getCustomerId() { return customerId; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }
    public Date getSignedDate() { return signedDate; }
    public void setSignedDate(Date signedDate) { this.signedDate = signedDate; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
}
