package com.generatorproject.services;

import com.generatorproject.dao.ReportDAO;

import java.util.List;
import java.util.Map;

public class ReportService implements  IReportService{

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    public int countActiveContracts(){
        return reportDAO.countActiveContracts();
    }

    @Override
    public int countNewCustomersThisMonth(){
        return reportDAO.countNewCustomersThisMonth();
    }

    @Override
    public int countPendingIncidents(){
        return reportDAO.countPendingIncidents();
    }

    @Override
    public int countMaintenanceThisMonth(){
        return reportDAO.countMaintenanceThisMonth();
    }

    @Override
    public Map<Integer, Integer> getNewCustomersByMonth(int year){
        return reportDAO.getNewCustomersByMonth(year);
    }

    @Override
    public Map<String, Integer> getMaintenanceStatusCount(int year){
        return reportDAO.getMaintenanceStatusCount(year);
    }

    @Override
    public List<Map<String, Object>> getContractRenewRateByMonth(int year){
        return reportDAO.getContractRenewRateByMonth(year);
    }

    @Override
    public Map<String, Integer> getIncidentsByPriority(int year){
        return reportDAO.getIncidentsByPriority(year);
    }

    @Override
    public List<Map<String, Object>> getTopSpareParts(int limit){
        return reportDAO.getTopSpareParts(limit);
    }

    // Dashboard v2 - Inventory
    @Override
    public int countCustomers(){
        return reportDAO.countCustomers();
    }

    @Override
    public int countDevices(){
        return reportDAO.countDevices();
    }

    @Override
    public int countDevicesByStatus(String status){
        return reportDAO.countDevicesByStatus(status);
    }

    @Override
    public int countDevicesBrokenLike(){
        return reportDAO.countDevicesBrokenLike();
    }

    @Override
    public List<Map<String, Object>> getDevicesByBrand(){
        return reportDAO.getDevicesByBrand();
    }

    @Override
    public List<Map<String, Object>> getDevicesByCategory(){
        return reportDAO.getDevicesByCategory();
    }

    @Override
    public List<Map<String, Object>> getDevicesByKvaBucket(){
        return reportDAO.getDevicesByKvaBucket();
    }

    @Override
    public List<Map<String, Object>> getTopModels(int limit){
        return reportDAO.getTopModels(limit);
    }

    // Service module (Warranty)
    @Override
    public int countIncidentsInWarrantyByYear(int year) {
        return reportDAO.countIncidentsInWarrantyByYear(year);
    }

    @Override
    public int countIncidentsOutWarrantyByYear(int year) {
        return reportDAO.countIncidentsOutWarrantyByYear(year);
    }

    @Override
    public int countMaintenancesInWarrantyByYear(int year) {
        return reportDAO.countMaintenancesInWarrantyByYear(year);
    }

    @Override
    public int countMaintenancesOutWarrantyByYear(int year) {
        return reportDAO.countMaintenancesOutWarrantyByYear(year);
    }

    @Override
    public List<Map<String, Object>> getIncidentsWarrantyByMonth(int year) {
        return reportDAO.getIncidentsWarrantyByMonth(year);
    }

    @Override
    public List<Map<String, Object>> getMaintenancesWarrantyByMonth(int year) {
        return reportDAO.getMaintenancesWarrantyByMonth(year);
    }

    /// Financial module

    @Override
    public double getAverageTicketValueByYear(int year){
        return reportDAO.getAverageTicketValueByYear(year);
    }

    @Override
    public double getTotalServiceRevenueByYear(int year){
        return reportDAO.getTotalServiceRevenueByYear(year);
    }

    @Override
    public int getTotalPartsQuantityUsedByYear(int year){
        return reportDAO.getTotalPartsQuantityUsedByYear(year);
    }

    @Override
    public List<Map<String, Object>> getServiceRevenueByMonth(int year){
        return reportDAO.getServiceRevenueByMonth(year);
    }

    @Override
    public List<Map<String, Object>> getTopPartsByQuantity(int year, int limit){
        return reportDAO.getTopPartsByQuantity(year,limit);
    }

    @Override
    public List<Map<String, Object>> getTopPartsByValue(int year, int limit){
        return reportDAO.getTopPartsByValue(year,limit);
    }

    @Override
    public List<Map<String, Object>> getTopMaintenanceTickets(int year, int limit){
        return reportDAO.getTopMaintenanceTickets(year,limit);
    }

    /// Risk module

    @Override
    public int countRedZoneDevices(int months){
        return reportDAO.countRedZoneDevices(months);
    }

    @Override
    public double getServicePenetrationRateByYear(int year){
        return reportDAO.getServicePenetrationRateByYear(year);
    }

    @Override
    public double getFirstTimeFixRateByYear(int year){
        return reportDAO.getFirstTimeFixRateByYear(year);
    }

    @Override
    public List<Map<String, Object>> getRedZoneDevicesByCategory(int months){
        return reportDAO.getRedZoneDevicesByCategory(months);
    }

    @Override
    public List<Map<String, Object>> getRedZoneDeviceList(int months, int limit){
        return reportDAO.getRedZoneDeviceList(months,limit);
    }
}
