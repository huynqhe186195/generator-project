package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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

    //================================================================

    //charts
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

    //Dashboard v2 - Inventory

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

    public List<Map<String, Object>> queryLabelValue(String sql){
        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
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

    //=============================================================

    /**
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

    //Helper
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
