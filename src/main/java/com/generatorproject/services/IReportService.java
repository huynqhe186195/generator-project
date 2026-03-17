package com.generatorproject.services;

import java.util.List;
import java.util.Map;

public interface IReportService {

    // KPI
    int countActiveContracts();
    int countNewCustomersThisMonth();
    int countPendingIncidents();
    int countMaintenanceThisMonth();

    // Chart data
    Map<Integer, Integer> getNewCustomersByMonth(int year);
    Map<String, Integer> getMaintenanceStatusCount(int year);
    List<Map<String, Object>> getContractRenewRateByMonth(int year);
    Map<String, Integer> getIncidentsByPriority(int year);
    List<Map<String, Object>> getTopSpareParts(int limit);
}
