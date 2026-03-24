package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ReportDAO extends GenericDAO<Object>{

    //kpi card
    public int countActiveContracts(){
        return count("SELECT COUNT(*) FROM contracts WHERE status = 'ACTIVE' ");
    }

    public int countNewCustomersThisMonth(){
        return count("SELECT COUNT(*) FROM users WHERE role_id = 5 " +
                "AND MONTH(created_at) = MONTH(CURDATE()) " +
                "AND YEAR(created_at) = YEAR(CURDATE()) " );
    }

    public int countPendingIncidents(){
        return count("SELECT COUNT(*) FROM incidents " +
                "WHERE status NOT IN ('COMPLETED', 'REJECTED') ");
    }

    public int countMaintenanceThisMonth(){
        return count("SELECT COUNT(*) FROM maintenances " +
                "WHERE MONTH(maintenance_date) = MONTH(CURDATE()) " +
                "AND YEAR(maintenance_date) = YEAR(CURDATE()) ");
    }

    //Dashboard v2 - Inventory
    public int countCustomers(){
        return count("SELECT COUNT(*) FROM users WHERE role_id = 5 ");
    }

    public int countDevices(){
        return count("SELECT COUNT(*) FROM products ");
    }

    public int countDevicesByStatus(String status){
        return  count("SELECT COUNT(*) FROM products WHERE status = ? ",
                status);
    }

    public int countDevicesBrokenLike(){
        return count("SELECT COUNT(*) FROM products " +
                "WHERE status IN ('BROKEN', 'REPAIRING') ");
    }

    /**
     * =========================================================================
     * charts
     */

    public Map<Integer, Integer> getNewCustomersByMonth(int year){
        String sql = "SELECT MONTH(created_at) AS month, COUNT(*) AS cnt " +
                "FROM users WHERE role_id = 5 AND YEAR(created_at) = ? " +
                "GROUP BY MONTH(created_at) ORDER BY month";

        Map<Integer, Integer> result = new LinkedHashMap<>();
        for (int i = 1; i <= 12; i++){
            result.put(i, 0);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            while (rs.next()){
                result.put(rs.getInt("month"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    public Map<String, Integer> getMaintenanceStatusCount(int year){
        String sql = "SELECT status, COUNT(*) AS cnt  FROM maintenances " +
                "WHERE YEAR(maintenance_date) = ? GROUP BY status ";

        Map<String, Integer> result = new LinkedHashMap<>();
        result.put("SCHEDULED", 0);
        result.put("COMPLETED", 0);
        result.put("CANCELLED", 0);

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            while (rs.next()){
                result.put(rs.getString("status"), rs.getInt("cnt"));
            }

        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    public List<Map<String, Object>> getContractRenewRateByMonth(int year){
        String sql = "SELECT MONTH(c.created_at) AS month, " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN (SELECT COUNT(*) FROM contracts prev " +
                "  WHERE prev.customer_id = c.customer_id AND prev.id < c.id) > 0 " +
                "  THEN 1 ELSE 0 END) AS  renew_count " +
                "FROM contracts c WHERE YEAR(c.created_at) = ? " +
                "GROUP BY MONTH(c.created_at) ORDER BY month ";

        List<Map<String, Object>> result = new ArrayList<>();
        for (int i = 1; i <= 12; i++){
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("month", i);
            map.put("total", 0);
            map.put("renew", 0);
            map.put("rate", 0.0);
            result.add(map);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            while (rs.next()){
                int month = rs.getInt("month");
                int total = rs.getInt("total");
                int renew = rs.getInt("renew_count");

                double rate = (total > 0)
                        ? Math.round((double) renew / total * 1000.0) / 10.0
                        : 0.0;

                Map<String, Object> map = result.get(month - 1);
                map.put("total", total);
                map.put("renew", renew);
                map.put("rate", rate);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    public Map<String, Integer> getIncidentsByPriority(int year){
        String sql = "SELECT priority, COUNT(*) AS cnt FROM incidents " +
                "WHERE YEAR(created_at) = ? GROUP BY priority ";

        Map<String, Integer> result = new LinkedHashMap<>();
        result.put("LOW", 0);
        result.put("MEDIUM", 0);
        result.put("HIGH", 0);
        result.put("CRITICAL", 0);

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            while (rs.next()){
                result.put(rs.getString("priority"), rs.getInt("cnt"));
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    public List<Map<String, Object>> getTopSpareParts(int limit){
        String sql = "SELECT sp.name, SUM(msp.quantity_used) AS total_used " +
                "FROM maintenance_spare_parts msp " +
                "JOIN spare_parts sp ON msp.spare_part_id = sp.id " +
                "GROUP BY sp.id, sp.name " +
                "ORDER BY total_used DESC " +
                "LIMIT ? ";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();

            while (rs.next()){
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("name", rs.getString("name"));
                map.put("total", rs.getInt("total_used"));
                result.add(map);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    /**
     * =========================================
     * Dashboard v2 - Inventory
     */

    public List<Map<String, Object>> getDevicesByBrand(){
        String sql = "SELECT b.name AS label, COUNT(*) AS value " +
                "FROM products p " +
                "JOIN product_models pm ON p.model_id = pm.id " +
                "JOIN brands b ON pm.brand_id = b.id " +
                "GROUP BY b.id, b.name " +
                "ORDER BY value DESC";

        return queryLabelValue(sql);
    }

    public List<Map<String, Object>> getDevicesByCategory() {
        String sql = "SELECT c.name AS label, COUNT(*) AS value " +
                "FROM products p " +
                "JOIN product_models pm ON p.model_id = pm.id " +
                "JOIN categories c ON pm.category_id = c.id " +
                "GROUP BY c.id, c.name " +
                "ORDER BY value DESC";

        return queryLabelValue(sql);
    }

    public List<Map<String, Object>> getDevicesByKvaBucket() {
        String sql = "SELECT CASE WHEN pm.power < 10 THEN '< 10 kVA' " +
                "  WHEN pm.power >= 10 AND pm.power < 30 THEN '10-<30 kVA' " +
                "  WHEN pm.power >= 30 AND pm.power < 75 THEN '30-<75 kVA' " +
                "  WHEN pm.power >= 75 AND pm.power < 150 THEN '75-<150 kVA' " +
                "  ELSE '>= 150 kVA' " +
                "END AS label, " +
                "COUNT(*) AS value " +
                "FROM products p " +
                "JOIN product_models pm ON p.model_id = pm.id " +
                "GROUP BY label " +
                "ORDER BY value DESC";

        return queryLabelValue(sql);
    }

    public List<Map<String, Object>> getTopModels(int limit){
        String sql = "SELECT pm.name AS modelName, " +
                "b.name AS brandName, " +
                "pm.power AS kva, " +
                "COUNT(*) AS totalDevices " +
                "FROM products p " +
                "JOIN product_models pm ON p.model_id = pm.id " +
                "LEFT JOIN brands b ON pm.brand_id = b.id " +
                "GROUP BY pm.id, pm.name, b.name, pm.power " +
                "ORDER BY totalDevices DESC " +
                "LIMIT ?";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();

            while (rs.next()){
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("modelName", rs.getString("modelName"));
                row.put("brandName", rs.getString("brandName"));
                row.put("kva", rs.getBigDecimal("kva"));
                row.put("totalDevices", rs.getInt("totalDevices"));
                result.add(row);
            }

        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    public List<Map<String, Object>> queryLabelValue(String sql, Object... params){
        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);

            for (int i = 0; i < params.length; i++){
                ps.setObject(i + 1, params[i]);
            }

            rs = ps.executeQuery();

            while (rs.next()){
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("label", rs.getString("label"));
                row.put("value", rs.getInt("value"));
                result.add(row);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    public List<Map<String, Object>> getDevicesByCurrentLocationAsOfYear(int year){
        String sql = "SELECT " +
                "  COALESCE(NULLIF(TRIM(p.current_location), ''), 'Chưa có vị trí') AS label, " +
                "  COUNT(*) AS value " +
                "FROM products p " +
                "WHERE COALESCE(p.purchase_date, DATE(p.created_at)) <= STR_TO_DATE(CONCAT(?, '-12-31'), '%Y-%m-%d') " +
                "GROUP BY label " +
                "ORDER BY value DESC";

        return queryLabelValue(sql, year);
    }

    /**
     * ================================================================================
    *Service module (Warranty)
    *Incident warranty: ticket_created_at = incidents.created_at
    *Contract lookup: ưu tiên incidents.contract_id, fallback products.contract_id
    **/
    public int countIncidentsInWarrantyByYear(int year) {
        String sql = "SELECT COUNT(*) FROM incidents i " +
                "JOIN products p ON i.product_id = p.id " +
                "LEFT JOIN contracts c1 ON i.contract_id = c1.id " +
                "LEFT JOIN contracts c2 ON p.contract_id = c2.id " +
                "WHERE YEAR(i.created_at) = ? " +
                "AND DATE(i.created_at) >= COALESCE(c1.start_date, c2.start_date) " +
                "AND DATE(i.created_at) <= COALESCE(c1.end_date, c2.end_date)";

        return count(sql, year);
    }

    public int countIncidentsOutWarrantyByYear(int year) {
        String sql = "SELECT COUNT(*) FROM incidents i " +
                "JOIN products p ON i.product_id = p.id " +
                "LEFT JOIN contracts c1 ON i.contract_id = c1.id " +
                "LEFT JOIN contracts c2 ON p.contract_id = c2.id " +
                "WHERE YEAR(i.created_at) = ? " +
                "AND NOT ( " +
                "  DATE(i.created_at) >= COALESCE(c1.start_date, c2.start_date) " +
                "  AND DATE(i.created_at) <= COALESCE(c1.end_date, c2.end_date) " +
                ")";

        return count(sql, year);
    }

    /**
     * Maintenance warranty: nếu có incident_id => dùng incident.created_at,
     *  else dùng maintenances.created_at (ngày tạo phiếu).
     */

    public int countMaintenancesInWarrantyByYear(int year) {
        String sql = "SELECT COUNT(*) FROM maintenances m " +
                "JOIN products p ON m.product_id = p.id " +
                "LEFT JOIN incidents i ON m.incident_id = i.id " +
                "LEFT JOIN contracts c ON p.contract_id = c.id " +
                "WHERE YEAR(COALESCE(i.created_at, m.created_at)) = ? " +
                "AND DATE(COALESCE(i.created_at, m.created_at)) >= c.start_date " +
                "AND DATE(COALESCE(i.created_at, m.created_at)) <= c.end_date";

        return count(sql, year);
    }

    public int countMaintenancesOutWarrantyByYear(int year) {
        String sql = "SELECT COUNT(*) FROM maintenances m " +
                "JOIN products p ON m.product_id = p.id " +
                "LEFT JOIN incidents i ON m.incident_id = i.id " +
                "LEFT JOIN contracts c ON p.contract_id = c.id " +
                "WHERE YEAR(COALESCE(i.created_at, m.created_at)) = ? " +
                "AND NOT ( " +
                "  DATE(COALESCE(i.created_at, m.created_at)) >= c.start_date " +
                "  AND DATE(COALESCE(i.created_at, m.created_at)) <= c.end_date " +
                ")";

        return count(sql, year);
    }



    public List<Map<String, Object>> getIncidentsWarrantyByMonth(int year) {
        String sql = "SELECT MONTH(i.created_at) AS month, SUM(CASE WHEN " +
                "  DATE(i.created_at) >= COALESCE(c1.start_date, c2.start_date) " +
                "  AND DATE(i.created_at) <= COALESCE(c1.end_date, c2.end_date) " +
                "THEN 1 ELSE 0 END) AS in_warranty, " +
                "SUM(CASE WHEN NOT ( " +
                "  DATE(i.created_at) >= COALESCE(c1.start_date, c2.start_date) " +
                "  AND DATE(i.created_at) <= COALESCE(c1.end_date, c2.end_date) " +
                ") THEN 1 ELSE 0 END) AS out_warranty " +
                "FROM incidents i " +
                "JOIN products p ON i.product_id = p.id " +
                "LEFT JOIN contracts c1 ON i.contract_id = c1.id " +
                "LEFT JOIN contracts c2 ON p.contract_id = c2.id " +
                "WHERE YEAR(i.created_at) = ? " +
                "GROUP BY MONTH(i.created_at) " +
                "ORDER BY month";

        return queryMonthInOut(sql, year);
    }

    public List<Map<String, Object>> getMaintenancesWarrantyByMonth(int year) {
        String sql = " SELECT MONTH(COALESCE(i.created_at, m.created_at)) AS month, " +
                "SUM(CASE WHEN " +
                "  DATE(COALESCE(i.created_at, m.created_at)) >= c.start_date " +
                "  AND DATE(COALESCE(i.created_at, m.created_at)) <= c.end_date " +
                "THEN 1 ELSE 0 END) AS in_warranty, " +
                "SUM(CASE WHEN NOT ( " +
                "  DATE(COALESCE(i.created_at, m.created_at)) >= c.start_date " +
                "  AND DATE(COALESCE(i.created_at, m.created_at)) <= c.end_date " +
                ") THEN 1 ELSE 0 END) AS out_warranty " +
                "FROM maintenances m " +
                "JOIN products p ON m.product_id = p.id " +
                "LEFT JOIN incidents i ON m.incident_id = i.id " +
                "LEFT JOIN contracts c ON p.contract_id = c.id " +
                "WHERE YEAR(COALESCE(i.created_at, m.created_at)) = ? " +
                "GROUP BY MONTH(COALESCE(i.created_at, m.created_at)) " +
                "ORDER BY month";

        return queryMonthInOut(sql, year);
    }

    private List<Map<String, Object>> queryMonthInOut(String sql, int year) {
        List<Map<String, Object>> result = new ArrayList<>();

        // init 12 months to 0
        for(int m = 1; m <= 12; m++){
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("month", m);
            row.put("in", 0);
            row.put("out", 0);
            result.add(row);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            while (rs.next()){
                int month = rs.getInt("month");
                int inW = rs.getInt("in_warranty");
                int outW = rs.getInt("out_warranty");

                Map<String, Object> row = result.get(month - 1);
                row.put("in", inW);
                row.put("out", outW);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    /**
     * ===========================================================================
     * Financial module
     */

    public double getTotalServiceRevenueByYear(int year) {
        String sql = "SELECT COALESCE(SUM(COALESCE(m.labor_cost,0) + " +
                "COALESCE(parts.parts_cost,0)), 0) AS revenue " +
                "FROM maintenances m " +
                "LEFT JOIN ( " +
                "  SELECT maintenance_id, SUM(cost_at_time) AS parts_cost " +
                "  FROM maintenance_spare_parts " +
                "  GROUP BY maintenance_id " +
                ") parts ON parts.maintenance_id = m.id " +
                "WHERE YEAR(m.maintenance_date) = ?";

        return querySingleDouble(sql, year);
    }

    public double getAverageTicketValueByYear(int year){
        String sql = "SELECT COALESCE(AVG(COALESCE(m.labor_cost,0) + " +
                "COALESCE(parts.parts_cost,0)), 0) AS avg_ticket " +
                "FROM maintenances m " +
                "LEFT JOIN ( " +
                "  SELECT maintenance_id, SUM(cost_at_time) AS parts_cost " +
                "  FROM maintenance_spare_parts " +
                "  GROUP BY maintenance_id " +
                ") parts ON parts.maintenance_id = m.id " +
                "WHERE YEAR(m.maintenance_date) = ?";

        return querySingleDouble(sql, year);
    }

    public int getTotalPartsQuantityUsedByYear(int year){
        String sql = "SELECT COALESCE (SUM(msp.quantity_used),0) AS qty " +
                "FROM maintenance_spare_parts msp " +
                "JOIN maintenances m ON msp.maintenance_id = m.id " +
                "WHERE YEAR(m.maintenance_date) = ?";

        return querySingleInt(sql, year);
    }

    public List<Map<String, Object>> getServiceRevenueByMonth(int year){
        String sql = "SELECT MONTH(m.maintenance_date) AS month, " +
                "COALESCE(SUM(COALESCE(m.labor_cost,0) + COALESCE(parts.parts_cost,0)),0) " +
                "AS revenue " +
                "FROM maintenances m " +
                "LEFT JOIN ( " +
                "  SELECT maintenance_id, SUM(cost_at_time) AS parts_cost " +
                "  FROM maintenance_spare_parts " +
                "  GROUP BY maintenance_id " +
                ") parts ON parts.maintenance_id = m.id " +
                "WHERE YEAR(m.maintenance_date) = ? " +
                "GROUP BY MONTH(m.maintenance_date) " +
                "ORDER BY month";

        List<Map<String, Object>> result = new ArrayList<>();
        for(int m = 1; m <= 12; m++){
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("month", m);
            row.put("revenue", 0.0);
            result.add(row);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            while (rs.next()){
                int month = rs.getInt("month");
                double rev = rs.getDouble("revenue");
                if(month >= 1 && month <= 12){
                    result.get(month - 1).put("revenue", rev);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    public List<Map<String, Object>> getTopPartsByQuantity(int year, int limit){
        String sql = "SELECT sp.name AS partName, sp.part_code AS partCode, " +
                "COALESCE(SUM(msp.quantity_used),0) AS qty " +
                "FROM maintenance_spare_parts msp " +
                "JOIN maintenances m ON msp.maintenance_id = m.id " +
                "JOIN spare_parts sp ON msp.spare_part_id = sp.id " +
                "WHERE YEAR(m.maintenance_date) = ? " +
                "GROUP BY sp.id, sp.name, sp.part_code " +
                "ORDER BY qty DESC " +
                "LIMIT ?";

        return queryPartRanking(sql, year, limit, "qty");
    }

    public List<Map<String, Object>> getTopPartsByValue(int year, int limit){
        String sql = "SELECT sp.name AS partName, sp.part_code AS partCode, " +
                "COALESCE(SUM(msp.cost_at_time),0) AS value " +
                "FROM maintenance_spare_parts msp " +
                "JOIN maintenances m ON msp.maintenance_id = m.id " +
                "JOIN spare_parts sp ON msp.spare_part_id = sp.id " +
                "WHERE YEAR(m.maintenance_date) = ? " +
                "GROUP BY sp.id, sp.name, sp.part_code " +
                "ORDER BY value DESC " +
                "LIMIT ?";

        return queryPartRanking(sql, year, limit, "value");
    }

    public List<Map<String, Object>> getTopMaintenanceTickets(int year, int limit){
        String sql = "SELECT m.id AS maintenanceId, p.serial_number AS serialNumber, " +
                "COALESCE(m.labor_cost,0) AS laborCost, " +
                "COALESCE(parts.parts_cost,0) AS partsCost, " +
                "COALESCE(m.labor_cost,0) + COALESCE(parts.parts_cost,0) AS total " +
                "FROM maintenances m " +
                "JOIN products p ON m.product_id = p.id " +
                "LEFT JOIN ( " +
                "  SELECT maintenance_id, SUM(cost_at_time) AS parts_cost " +
                "  FROM maintenance_spare_parts " +
                "  GROUP BY maintenance_id " +
                ") parts ON parts.maintenance_id = m.id " +
                "WHERE YEAR(m.maintenance_date) = ? " +
                "ORDER BY total DESC " +
                "LIMIT ? ";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            ps.setInt(2, limit);
            rs = ps.executeQuery();

            while (rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("maintenanceId", rs.getInt("maintenanceId"));
                row.put("serialNumber", rs.getString("serialNumber"));
                row.put("laborCost", rs.getDouble("laborCost"));
                row.put("partsCost", rs.getDouble("partsCost"));
                row.put("total", rs.getDouble("total"));
                result.add(row);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    private double querySingleDouble(String sql, int year){
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();
            if (rs.next()){
                return rs.getDouble(1);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return 0.0;
    }

    private int querySingleInt(String sql, int year){
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();
            if (rs.next()){
                return rs.getInt(1);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return 0;
    }

    private List<Map<String, Object>> queryPartRanking(String sql, int year,
                                                      int limit, String metrickey){

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            ps.setInt(2, limit);
            rs = ps.executeQuery();

            while (rs.next()){
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("name", rs.getString("partName"));
                row.put("code", rs.getString("partCode"));
                row.put(metrickey, rs.getDouble(metrickey));
                result.add(row);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    /**
     * ==============================================================================
     * Risk Module
     * Red zone definition:
     *  * A device is red zone if it has no maintenance in the last {months}.
     *  * We use maintenances.maintenance_date as "last updated on maintenance ticket".
     */
    public int countRedZoneDevices(int months){
        String sql = "SELECT COUNT(*) FROM products p " +
                "LEFT JOIN ( " +
                "  SELECT product_id, MAX(maintenance_date) AS last_date " +
                "  FROM maintenances " +
                "  GROUP BY product_id " +
                ") lm ON lm.product_id = p.id " +
                "WHERE (lm.last_date IS NULL OR lm.last_date < DATE_SUB(CURDATE(), INTERVAL ? MONTH)) ";

        return count(sql, months);
    }

    public double getServicePenetrationRateByYear(int year){
        String sql = "SELECT ( " +
                "    SELECT COUNT(DISTINCT p.customer_id) " +
                "    FROM products p " +
                "    JOIN maintenances m ON m.product_id = p.id " +
                "    WHERE YEAR(m.maintenance_date) = ? " +
                "  ) AS numerator, " +
                "  ( " +
                "    SELECT COUNT(DISTINCT customer_id) FROM products " +
                "  ) AS denominator ";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            if (rs.next()){
                int num = rs.getInt("numerator");
                int den = rs.getInt("denominator");
                if (den <= 0){
                    return 0.0;
                }
                return Math.round(((double) num / den) * 1000.0) / 10.0; // 1 decimal %
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return 0.0;
    }

    /**
     * First-Time Fix Rate (approx):
     * % REPAIR maintenances in a year that do NOT have a subsequent REPAIR on the same product
     * within 30 days.
     *
     * Assumptions:
     * - maintenances.type contains 'REPAIR' for repair tickets.
     * - Uses maintenance_date for sequencing.
     */
    public double getFirstTimeFixRateByYear(int year){
        String sql = "SELECT " +
                "  SUM(CASE WHEN next_m.next_date IS NULL THEN 1 ELSE 0 END) AS fixed_first_time, " +
                "  COUNT(*) AS total_repairs " +
                "FROM maintenances m " +
                "LEFT JOIN ( " +
                "  SELECT m1.id AS mid, MIN(m2.maintenance_date) AS next_date " +
                "  FROM maintenances m1 " +
                "  JOIN maintenances m2 " +
                "    ON m2.product_id = m1.product_id " +
                "   AND m2.type = 'REPAIR' " +
                "   AND m2.maintenance_date > m1.maintenance_date " +
                "   AND m2.maintenance_date <= DATE_ADD(m1.maintenance_date, INTERVAL 30 DAY) " +
                "  WHERE m1.type = 'REPAIR' " +
                "  GROUP BY m1.id " +
                ") next_m ON next_m.mid = m.id " +
                "WHERE m.type = 'REPAIR' " +
                "AND YEAR(m.maintenance_date) = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            if (rs.next()){
                int fixed =  rs.getInt("fixed_first_time");
                int total = rs.getInt("total_repairs");
                if (total <= 0){
                    return 0.0;
                }
                return Math.round(((double) fixed/total) * 1000.0) / 10.0;// 1 decimal %
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return 0.0;
    }

    /**
     * Chart: red zone by category (segment).
     */

    public List<Map<String, Object>> getRedZoneDevicesByCategory(int months){
        String sql = "SELECT c.name AS label, COUNT(*) AS value " +
                "FROM products p " +
                "JOIN product_models pm ON p.model_id = pm.id " +
                "JOIN categories c ON pm.category_id = c.id " +
                "LEFT JOIN ( " +
                "  SELECT product_id, MAX(maintenance_date) AS last_date " +
                "  FROM maintenances " +
                "  GROUP BY product_id " +
                ") lm ON lm.product_id = p.id " +
                "WHERE (lm.last_date IS NULL OR lm.last_date < DATE_SUB(CURDATE(), INTERVAL ? MONTH)) " +
                "GROUP BY c.id, c.name " +
                "ORDER BY value DESC ";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, months);
            rs = ps.executeQuery();

            while (rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("label", rs.getString("label"));
                row.put("value", rs.getInt("value"));
                result.add(row);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    /**
     * Table: list red zone devices (top N oldest last maintenance).
     */
    public List<Map<String, Object>> getRedZoneDeviceList(int months, int limit){
        String sql = "SELECT p.id AS productId, p.serial_number AS serialNumber, " +
                "u.full_name AS customerName, " +
                "COALESCE(lm.last_date, COALESCE(p.purchase_date, DATE(p.created_at))) AS lastMaintenanceDate, " +
                "p.current_location AS location " +
                "FROM products p " +
                "LEFT JOIN users u ON p.customer_id = u.id " +
                "LEFT JOIN ( " +
                "  SELECT product_id, MAX(maintenance_date) AS last_date " +
                "  FROM maintenances " +
                "  GROUP BY product_id " +
                ") lm ON lm.product_id = p.id " +
                "WHERE (lm.last_date IS NULL OR lm.last_date < DATE_SUB(CURDATE(), INTERVAL ? MONTH)) " +
                "ORDER BY COALESCE(lm.last_date, COALESCE(p.purchase_date, DATE(p.created_at))) ASC " +
                "LIMIT ? ";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, months);
            ps.setInt(2, limit);
            rs = ps.executeQuery();
            while (rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("productId", rs.getInt("productId"));
                row.put("serialNumber", rs.getString("serialNumber"));
                row.put("customerName", rs.getString("customerName"));
                row.put("lastMaintenanceDate", rs.getDate("lastMaintenanceDate"));
                row.put("location", rs.getString("location"));
                result.add(row);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    /**
     * ====================================================================================
     *Contract module
     */

    public int countContractsByStatus(String status){
        String sql = "SELECT COUNT(*) FROM contracts WHERE status = ?";
        return count(sql, status);
    }

    public int countContractsExpiringInDays(int days){
        String sql = "SELECT COUNT(*) FROM contracts " +
                "WHERE end_date IS NOT NULL " +
                "AND end_date >= CURDATE() " +
                "AND end_date <= DATE_ADD(CURDATE(), INTERVAL ? DAY)";

        return count(sql, days);
    }

    /**
     * Data mismatch(dữ liệu không khớp) (audit-kế toán):
     * - end_date < today but status still ACTIVE or PENDING_SERIAl
     * - end_date < hôm nay nhưng trạng thái vẫn ACTIVE(hoạt động) hoặc PENDING_SERIAL(chưa giải quyết nối tiếp)
     */
    public int countContractsDateMismatch(){
        String sql = "SELECT COUNT(*) FROM contracts " +
                "WHERE end_date IS NOT NULL " +
                "AND end_date < CURDATE() " +
                "AND status IN ('ACTIVE', 'PENDING_SERIAL')";
        return count(sql);
    }

    /**
     * For pie chart: status distribution. -- Đối với biểu đồ hình tròn: phân phối trạng thái.
     * Return format: [{label: 'ACTIVE', value: 10}, ...]
     */
    public List<Map<String, Object>> getContractsStatusDistribution(){
        String sql = "SELECT status AS label, COUNT(*) AS value " +
                "FROM contracts " +
                "GROUP BY status " +
                "ORDER BY value DESC";

        return queryLabelValue(sql);
    }


    /**
     * For chart: contracts ending by month in selected year (end_date).
     * Đối với biểu đồ: hợp đồng kết thúc theo tháng trong năm đã chọn (end_date).
     * Return: 12 rows (month, value).
     */
    public List<Map<String, Object>> getContractsMonth(int year){
        String sql = "SELECT MONTH(end_date) AS month, COUNT(*) AS cnt " +
                "FROM contracts " +
                "WHERE end_date IS NOT NULL AND YEAR(end_date) = ? " +
                "GROUP BY MONTH(end_date) " +
                "ORDER BY month";

        List<Map<String, Object>> result = new ArrayList<>();
        for(int m = 1; m <= 12; m++){
            Map<String, Object> row = new HashMap<>();
            row.put("month", m);
            row.put("value", 0);
            result.add(row);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();

            while (rs.next()){
                int month = rs.getInt("month");
                int cnt = rs.getInt("cnt");
                if(month >= 1 && month <= 12){
                    result.get(month - 1).put("value", cnt);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }
        return result;
    }

    /**
     * Table: contracts expiring soon.(hợp đồng sắp hết hạn.)
     */
    public List<Map<String, Object>> getContractsExpiringList(int days, int limit){
        String sql = "SELECT c.id AS contractId, c.contract_number AS contractNumber, " +
                "u.full_name AS customerName, c.end_date AS endDate, c.status AS status, " +
                "DATEDIFF(c.end_date, CURDATE()) AS daysLeft " +
                "FROM contracts c " +
                "LEFT JOIN users u ON c.customer_id = u.id " +
                "WHERE c.end_date IS NOT NULL " +
                "AND c.status = 'ACTIVE' " +
                "AND DATEDIFF(c.end_date, CURDATE()) BETWEEN 0 AND ? " +
                "ORDER BY c.end_date ASC " +
                "LIMIT ?";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, days);
            ps.setInt(2, limit);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("contractId", rs.getInt("contractId"));
                row.put("contractNumber", rs.getString("contractNumber"));
                row.put("customerName", rs.getString("customerName"));
                row.put("endDate", rs.getDate("endDate"));
                row.put("status", rs.getString("status"));
                row.put("daysLeft", rs.getInt("daysLeft"));
                result.add(row);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }
        return result;
    }

    /**
     * Table: pending(chưa giải quyết) contracts list.
     */
    public List<Map<String, Object>> getPendingContractsList(int Limit){
        String sql = "SELECT c.id AS contractId, c.contract_number AS contractNumber, " +
                "u.full_name AS customerName, c.created_at AS createdAt, c.status AS status " +
                "FROM contracts c " +
                "LEFT JOIN users u ON c.customer_id = u.id " +
                "WHERE c.status = 'PENDING_SERIAL' " +
                "ORDER BY c.created_at DESC " +
                "LIMIT ?";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Limit);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("contractId", rs.getInt("contractId"));
                row.put("contractNumber", rs.getString("contractNumber"));
                row.put("customerName", rs.getString("customerName"));
                row.put("createdAt", rs.getTimestamp("createdAt"));
                row.put("status", rs.getString("status"));
                result.add(row);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }
        return result;
    }

    /**
     * ==========================================================================
     * Users Module
     */

    //all users
    public int countAllUsers(){
        return count("SELECT COUNT(*) FROM users");
    }

    //new users within the range
    public int countNewUsersInRange(String fromDate, String toDate){
        String sql = "SELECT COUNT(*) FROM users " +
                "WHERE created_at >= STR_TO_DATE(?, '%Y-%m-%d') " +
                "AND created_at < DATE_ADD(STR_TO_DATE(?, '%Y-%m-%d'), INTERVAL 1 DAY)";

        return count(sql, fromDate, toDate);
    }

    //new users by role
    public List<Map<String, Object>> getNewUsersByRoleInRange(String fromDate, String toDate){
        String sql = "SELECT r.name AS label, COUNT(u.id) AS value " +
                "FROM roles r " +
                "LEFT JOIN users u " +
                "  ON u.role_id = r.id " +
                " AND u.created_at >= STR_TO_DATE(?, '%Y-%m-%d') " +
                " AND u.created_at < DATE_ADD(STR_TO_DATE(?, '%Y-%m-%d'), INTERVAL 1 DAY) " +
                "GROUP BY r.id, r.name " +
                "ORDER BY value DESC";

        return queryLabelValue(sql, fromDate, toDate);
    }

    // New users by month in range(trong khoang)
    public List<Map<String, Object>> getNewUsersByMonthInRange(String fromDate, String toDate){
        String sql = "SELECT YEAR(created_at) AS y, MONTH(created_at) AS m, COUNT(*) AS cnt " +
                "FROM users " +
                "WHERE created_at >= STR_TO_DATE(?, '%Y-%m-%d') " +
                "AND created_at < DATE_ADD(STR_TO_DATE(?, '%Y-%m-%d'), INTERVAL 1 DAY) " +
                "GROUP BY YEAR(created_at), MONTH(created_at) " +
                "ORDER BY y, m";

        List<Map<String, Object>> result = new ArrayList<>();
        //init 12 months
        for(int i = 2; i <= 12; i++){
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("month", i);
            row.put("value", 0);
            result.add(row);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            rs = ps.executeQuery();

            while (rs.next()) {
                int month = rs.getInt("m");
                int cnt = rs.getInt("cnt");
                if(month >= 1 && month <= 12){
                    result.get(month - 1).put("value", cnt);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(conn, ps, rs);
        }

        return result;
    }

    /**
     * ============================================================================
     * Helper
    **/
    private void close(Connection conn, PreparedStatement ps, ResultSet rs){
        try {
            if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
            if(conn != null){ conn.close(); }
        }catch (SQLException e){
            e.printStackTrace();
        }
    }
}
