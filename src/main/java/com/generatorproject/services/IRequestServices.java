package com.generatorproject.services;

import com.generatorproject.model.SystemRequest;

import java.util.List;

public interface IRequestServices {
    Long save (SystemRequest systemRequest);
    void update (SystemRequest systemRequest);
    List<SystemRequest> findByReceiverRole(String role, String status);
    SystemRequest findById(Long id);
    boolean isRequestPending(String email);
    List<SystemRequest> findBySenderId(Long senderId);
}
