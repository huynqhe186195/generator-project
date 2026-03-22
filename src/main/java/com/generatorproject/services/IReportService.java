package com.generatorproject.services;

import java.util.List;
import java.util.Map;

public interface IReportService {

    int countActiveContracts();
    int countNewCustomersThisMonth();
    int countPendingIncidents();
    int countMaintenanceThisMonth();

    // Dashboard v2 - Inventory
    int countCustomers();
    int countDevices();
    int countDevicesByStatus(String status);
    int countDevicesBrokenLike();

    Map<Integer, Integer> getNewCustomersByMonth(int year);
    Map<String, Integer> getMaintenanceStatusCount(int year);
    List<Map<String, Object>> getContractRenewRateByMonth(int year);
    Map<String, Integer> getIncidentsByPriority(int year);
    List<Map<String, Object>> getTopSpareParts(int limit);

    // Dashboard v2 - Inventory
    List<Map<String, Object>> getDevicesByBrand();
    List<Map<String, Object>> getDevicesByCategory();
    List<Map<String, Object>> getDevicesByKvaBucket();

    List<Map<String, Object>> getTopModels(int limit);
}
