package com.generatorproject.services;

import com.generatorproject.dao.ManagerDashboardDAO;
import com.generatorproject.model.dashboard.ManagerDashboardKpi;

public class ManagerDashboardService {

    private final ManagerDashboardDAO dashboardDAO;

    public ManagerDashboardService() {
        this.dashboardDAO = new ManagerDashboardDAO();
    }

    public ManagerDashboardKpi loadKpis() {
        return dashboardDAO.loadKpis();
    }
}