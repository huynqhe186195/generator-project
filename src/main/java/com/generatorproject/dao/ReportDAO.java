package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO extends GenericDAO<Object> {

    // ==================== KPI CARDS ====================

    public int countActiveContracts() {
        return count("SELECT COUNT(*) FROM contracts WHERE status = 'ACTIVE'");
    }

    public int countNewCustomersThisMonth() {
        return count(
            "SELECT COUNT(*) FROM users WHERE role_id = 5 " +
            "AND MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())"
        );
    }

    public int countPendingIncidents() {
        return count(
            "SELECT COUNT(*) FROM incidents WHERE status NOT IN ('COMPLETED', 'REJECTED')"
        );
    }

    public int countMaintenanceThisMonth() {
        return count(
            "SELECT COUNT(*) FROM maintenances " +
            "WHERE MONTH(maintenance_date) = MONTH(CURDATE()) AND YEAR(maintenance_date) = YEAR(CURDATE())"
        );
    }

    // ==================== CHART 1: Khách hàng mới theo tháng (Bar) ====================

    public Map<Integer, Integer> getNewCustomersByMonth(int year) {
        String sql = "SELECT MONTH(created_at) AS month, COUNT(*) AS cnt " +
                     "FROM users WHERE role_id = 5 AND YEAR(created_at) = ? " +
                     "GROUP BY MONTH(created_at) ORDER BY month";

        Map<Integer, Integer> result = new LinkedHashMap<>();
        for (int i = 1; i <= 12; i++) result.put(i, 0);

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();
            while (rs.next()) {
                result.put(rs.getInt("month"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, ps, rs);
        }
        return result;
    }

    // ==================== CHART 2: Trạng thái bảo trì (Pie) ====================

    public Map<String, Integer> getMaintenanceStatusCount(int year) {
        String sql = "SELECT status, COUNT(*) AS cnt FROM maintenances " +
                     "WHERE YEAR(maintenance_date) = ? GROUP BY status";

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
            while (rs.next()) {
                result.put(rs.getString("status"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, ps, rs);
        }
        return result;
    }

    // ==================== CHART 3: Tỷ lệ tái ký theo tháng (Line) ====================

    public List<Map<String, Object>> getContractRenewRateByMonth(int year) {
        String sql = "SELECT MONTH(c.created_at) AS month, " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN (SELECT COUNT(*) FROM contracts prev " +
                     "              WHERE prev.customer_id = c.customer_id AND prev.id < c.id) > 0 " +
                     "    THEN 1 ELSE 0 END) AS renew_count " +
                     "FROM contracts c WHERE YEAR(c.created_at) = ? " +
                     "GROUP BY MONTH(c.created_at) ORDER BY month";

        List<Map<String, Object>> result = new ArrayList<>();
        for (int i = 1; i <= 12; i++) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("month", i);
            m.put("total", 0);
            m.put("renew", 0);
            m.put("rate", 0.0);
            result.add(m);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            rs = ps.executeQuery();
            while (rs.next()) {
                int month = rs.getInt("month");
                int total = rs.getInt("total");
                int renew = rs.getInt("renew_count");
                double rate = (total > 0) ? Math.round((double) renew / total * 1000.0) / 10.0 : 0.0;
                Map<String, Object> m = result.get(month - 1);
                m.put("total", total);
                m.put("renew", renew);
                m.put("rate", rate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, ps, rs);
        }
        return result;
    }

    // ==================== CHART 4: Sự cố theo mức độ ưu tiên (Horizontal Bar) ====================

    public Map<String, Integer> getIncidentsByPriority(int year) {
        String sql = "SELECT priority, COUNT(*) AS cnt FROM incidents " +
                     "WHERE YEAR(created_at) = ? GROUP BY priority";

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
            while (rs.next()) {
                result.put(rs.getString("priority"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, ps, rs);
        }
        return result;
    }

    // ==================== CHART 5: Top linh kiện sử dụng nhiều nhất (Bar) ====================

    public List<Map<String, Object>> getTopSpareParts(int limit) {
        String sql = "SELECT sp.name, SUM(msp.quantity_used) AS total_used " +
                     "FROM maintenance_spare_parts msp " +
                     "JOIN spare_parts sp ON msp.spare_part_id = sp.id " +
                     "GROUP BY sp.id, sp.name ORDER BY total_used DESC LIMIT ?";

        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("name", rs.getString("name"));
                m.put("total", rs.getInt("total_used"));
                result.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, ps, rs);
        }
        return result;
    }

    // ==================== HELPER ====================

    private void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
