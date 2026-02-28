package com.generatorproject.services;

import com.generatorproject.model.RepairRequestDTO;
import com.generatorproject.model.SystemRequest;

import java.sql.Date;
import java.util.List;

public interface IRequestServices {
    Long save(SystemRequest systemRequest);

    void update(SystemRequest systemRequest);

    List<SystemRequest> findByReceiverRole(String role, String status);

    SystemRequest findById(Long id);

    boolean isRequestPending(String email);

    List<SystemRequest> findBySenderId(Long senderId);

    int countByFilter(Date fromDate, Date toDate, String status, String requestType);

    List<SystemRequest> getByFilter(Date fromDate, Date toDate, String status, String requestType, int page,
            int pageSize);

    void updateStatus(int id, String status);

    List<SystemRequest> findInboxByRole(String role, String status);

    void approve(long id, String responseMessage);

    void reject(long id, String responseMessage);

}
