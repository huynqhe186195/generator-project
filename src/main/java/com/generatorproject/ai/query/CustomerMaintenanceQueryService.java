package com.generatorproject.ai.query;

import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.model.Maintenance;

import java.util.List;

public class CustomerMaintenanceQueryService {
    private final MaintenanceDAO maintenanceDAO = new MaintenanceDAO();

    public List<Maintenance> findCompletedByCustomerAndKeyword(long customerId, String keyword, int limit) {
        return maintenanceDAO.findCompletedByCustomerAndKeyword(customerId, keyword, limit);
    }
}
