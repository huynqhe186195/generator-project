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

    //Inventory
    int countCustomers();
    int countDevices();
    int countDevicesByStatus(String status);
    int countDevicesBrokenLike();

    List<Map<String, Object>> getDevicesByBrand();
    List<Map<String, Object>> getDevicesByCategory();
    List<Map<String, Object>> getDevicesByKvaBucket();

    List<Map<String, Object>> getTopModels(int limit);
}
