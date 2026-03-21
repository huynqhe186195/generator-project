package com.generatorproject.services;

import com.generatorproject.model.RepairRequestDTO;

public interface IRepairWorkflowService {
    RepairRequestDTO getRepairRequestDetails(Long requestId);

    void processStaffApprove(Long requestId, RepairRequestDTO dto, Long staffId) throws Exception;
    void processStaffReject(Long requestId, Long staffId) throws Exception;
    void processStaffSendToCustomer(Long requestId, Long staffId) throws Exception;
    void acceptQuote(Long requestId, Long userId) throws Exception;
    void rejectQuote(Long requestId, Long userId) throws Exception;
}
