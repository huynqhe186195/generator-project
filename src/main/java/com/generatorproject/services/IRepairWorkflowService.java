package com.generatorproject.services;

import com.generatorproject.model.RepairRequestDTO;

public interface IRepairWorkflowService {
    public RepairRequestDTO getRepairRequestDetails(Long requestId);

    public void processStaffApprove(Long requestId, RepairRequestDTO dto, Long staffId) throws Exception;
    public void processStaffReject(Long requestId, Long staffId) throws Exception;
}
