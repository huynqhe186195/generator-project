package com.generatorproject.services;

import com.generatorproject.dao.RequestDAO;
import com.generatorproject.model.SystemRequest;

import java.sql.Date;
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

    @Override
    public int countByFilter(Date fromDate, Date toDate, String status, String requestType) {
        return requestDAO.countByFilter(fromDate,toDate,status,requestType);
    }

    @Override
    public List<SystemRequest> getByFilter(Date fromDate, Date toDate, String status, String requestType, int page, int pageSize) {
        return requestDAO.findByFilter(fromDate,toDate,status,requestType,page,pageSize);
    }

    @Override
    public void updateStatus(int id, String status) {
        requestDAO.updateStatus(id,status);
    }
}
