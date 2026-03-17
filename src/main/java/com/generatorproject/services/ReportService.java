package com.generatorproject.services;

import com.generatorproject.dao.ReportDAO;

import java.util.List;
import java.util.Map;

public class ReportService implements IReportService {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    public int countActiveContracts() {
        return reportDAO.countActiveContracts();
    }

    @Override
    public int countNewCustomersThisMonth() {
        return reportDAO.countNewCustomersThisMonth();
    }

    @Override
    public int countPendingIncidents() {
        return reportDAO.countPendingIncidents();
    }

    @Override
    public int countMaintenanceThisMonth() {
        return reportDAO.countMaintenanceThisMonth();
    }

    @Override
    public Map<Integer, Integer> getNewCustomersByMonth(int year) {
        return reportDAO.getNewCustomersByMonth(year);
    }

    @Override
    public Map<String, Integer> getMaintenanceStatusCount(int year) {
        return reportDAO.getMaintenanceStatusCount(year);
    }

    @Override
    public List<Map<String, Object>> getContractRenewRateByMonth(int year) {
        return reportDAO.getContractRenewRateByMonth(year);
    }

    @Override
    public Map<String, Integer> getIncidentsByPriority(int year) {
        return reportDAO.getIncidentsByPriority(year);
    }

    @Override
    public List<Map<String, Object>> getTopSpareParts(int limit) {
        return reportDAO.getTopSpareParts(limit);
    }
}
