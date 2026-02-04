package com.generatorproject.services;

import com.generatorproject.dao.RequestDAO;
import com.generatorproject.model.SystemRequest;

import java.util.List;

public class RequestServices implements IRequestServices{
    private RequestDAO requestDAO;
    public RequestServices() {
        requestDAO = new RequestDAO();
    }

    @Override
    public Long save(SystemRequest systemRequest) {
        return requestDAO.save(systemRequest);
    }

    @Override
    public void update(SystemRequest systemRequest) {
         requestDAO.update(systemRequest);
    }

    @Override
    public List<SystemRequest> findByReceiverRole(String role, String status) {
        return requestDAO.findByReceiverRole(role, status);
    }

    @Override
    public SystemRequest findById(Long id) {
        return requestDAO.findById(id);
    }

    @Override
    public boolean isRequestPending(String email) {
        return requestDAO.isRequestPending(email);
    }

    @Override
    public List<SystemRequest> findBySenderId(Long senderId) {
        return  requestDAO.findBySenderId(senderId);
    }
}
