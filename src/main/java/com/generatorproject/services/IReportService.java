package com.generatorproject.services;

import java.util.List;
import java.util.Map;

public interface IReportService {

    ///KPI
    int countActiveContracts();
    int countNewCustomersThisMonth();
    int countPendingIncidents();
    int countMaintenanceThisMonth();

    Map<Integer, Integer> getNewCustomersByMonth(int year);
    Map<String, Integer> getMaintenanceStatusCount(int year);
    List<Map<String, Object>> getContractRenewRateByMonth(int year);
    Map<String, Integer> getIncidentsByPriority(int year);
    List<Map<String, Object>> getTopSpareParts(int limit);

    /// Dashboard v2 - Inventory
    int countCustomers();
    int countDevices();
    int countDevicesByStatus(String status);
    int countDevicesBrokenLike();

    List<Map<String, Object>> getDevicesByBrand();
    List<Map<String, Object>> getDevicesByCategory();
    List<Map<String, Object>> getDevicesByKvaBucket();

    List<Map<String, Object>> getTopModels(int limit);

    ///Service module
    int countIncidentsInWarrantyByYear(int year);
    int countIncidentsOutWarrantyByYear(int year);
    int countMaintenancesInWarrantyByYear(int year);
    int countMaintenancesOutWarrantyByYear(int year);

    List<Map<String, Object>> getIncidentsWarrantyByMonth(int year);
    List<Map<String, Object>> getMaintenancesWarrantyByMonth(int year);

    ///Financial module
    double getAverageTicketValueByYear(int year);
    double getTotalServiceRevenueByYear(int year);
    int getTotalPartsQuantityUsedByYear(int year);

    List<Map<String, Object>> getServiceRevenueByMonth(int year);
    List<Map<String, Object>> getTopPartsByQuantity(int year, int limit);
    List<Map<String, Object>> getTopPartsByValue(int year, int limit);
    List<Map<String, Object>> getTopMaintenanceTickets(int year, int limit);

    /// Risk module
    int countRedZoneDevices(int months);
    double getServicePenetrationRateByYear(int year);
    double getFirstTimeFixRateByYear(int year);

    List<Map<String, Object>> getRedZoneDevicesByCategory(int months);
    List<Map<String, Object>> getRedZoneDeviceList(int months, int limit);

    /// Contract module
    int countContractsByStatus(String status);
    int countContractsExpiringInDays(int days);
    int countContractsDateMismatch();

    List<Map<String, Object>> getContractsStatusDistribution();
    List<Map<String, Object>> getContractsEndingByMonth(int year);

    List<Map<String, Object>> getContractsExpiringList(int days, int limit);
    List<Map<String, Object>> getPendingContractsList(int limit);
}
