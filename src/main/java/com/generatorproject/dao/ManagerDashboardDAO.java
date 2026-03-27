package com.generatorproject.dao;

import com.generatorproject.model.dashboard.ManagerDashboardKpi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ManagerDashboardDAO extends DbContext{
    public ManagerDashboardKpi loadKpis() {
        ManagerDashboardKpi kpi = new ManagerDashboardKpi();

        kpi.setTotalCustomers(countCustomers());
        kpi.setTotalDevices(countDevices());

        kpi.setDevicesRunning(countDevicesByStatus("RUNNING"));
        kpi.setDevicesMaintenance(countDevicesByStatus("MAINTENANCE"));
        kpi.setDevicesBroken(countDevicesByStatus("BROKEN")); // nếu bạn có status khác cho "ngừng vận hành" thì bổ sung sau

        kpi.setTicketsOpenedToday(countTicketsOpenedToday());

        kpi.setMaintenancesToday(countMaintenancesByDateScope("DAY"));
        kpi.setMaintenancesThisWeek(countMaintenancesByDateScope("WEEK"));
        kpi.setMaintenancesThisMonth(countMaintenancesByDateScope("MONTH"));

        kpi.setJobsCompletedThisMonth(countJobsCompletedThisMonth());
        kpi.setOverdueMaintenances(countOverdueMaintenances());

        kpi.setServiceRevenueThisMonth(sumServiceRevenueThisMonth());
        kpi.setSlaOnTimeRateThisMonth(calcSlaOnTimeRateThisMonth());

        return kpi;
    }

    private int countCustomers() {
        // role_id = 5 theo DB dump bạn đưa: customer/user
        String sql = "SELECT COUNT(*) FROM users WHERE role_id = 5 AND status = 1";
        return queryInt(sql);
    }

    private int countDevices() {
        String sql = "SELECT COUNT(*) FROM products";
        return queryInt(sql);
    }

    private int countDevicesByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM products WHERE status = ?";
        return queryInt(sql, status);
    }

    private int countTicketsOpenedToday() {
        // “ticket mở hôm nay”: created_at = today, và chưa completed/rejected
        String sql = """
            SELECT COUNT(*)
            FROM incidents
            WHERE DATE(created_at) = CURDATE()
              AND status NOT IN ('COMPLETED', 'REJECTED')
        """;
        return queryInt(sql);
    }

    private int countMaintenancesByDateScope(String scope) {
        String sql;
        switch (scope) {
            case "DAY":
                sql = """
                    SELECT COUNT(*)
                    FROM maintenances
                    WHERE maintenance_date = CURDATE()
                """;
                break;
            case "WEEK":
                // ISO week (MySQL WEEK(...,1)) - tùy bạn muốn week bắt đầu từ Monday
                sql = """
                    SELECT COUNT(*)
                    FROM maintenances
                    WHERE YEARWEEK(maintenance_date, 1) = YEARWEEK(CURDATE(), 1)
                """;
                break;
            case "MONTH":
            default:
                sql = """
                    SELECT COUNT(*)
                    FROM maintenances
                    WHERE YEAR(maintenance_date) = YEAR(CURDATE())
                      AND MONTH(maintenance_date) = MONTH(CURDATE())
                """;
                break;
        }
        return queryInt(sql);
    }

    private int countJobsCompletedThisMonth() {
        // lấy theo completed_at để đúng “job đã hoàn thành”
        String sql = """
            SELECT COUNT(*)
            FROM maintenances
            WHERE completed_at IS NOT NULL
              AND YEAR(completed_at) = YEAR(CURDATE())
              AND MONTH(completed_at) = MONTH(CURDATE())
        """;
        return queryInt(sql);
    }

    private int countOverdueMaintenances() {
        // cảnh báo quá hạn: có scheduled_end, scheduled_end < now, chưa completed/cancelled
        String sql = """
            SELECT COUNT(*)
            FROM maintenances
            WHERE scheduled_end IS NOT NULL
              AND scheduled_end < NOW()
              AND (completed_at IS NULL)
              AND status <> 'CANCELLED'
        """;
        return queryInt(sql);
    }

    private double sumServiceRevenueThisMonth() {
        // doanh thu service tháng này: SUM(total_cost) của job hoàn thành trong tháng
        String sql = """
            SELECT COALESCE(SUM(total_cost), 0)
            FROM maintenances
            WHERE completed_at IS NOT NULL
              AND YEAR(completed_at) = YEAR(CURDATE())
              AND MONTH(completed_at) = MONTH(CURDATE())
        """;
        return queryDouble(sql);
    }

    private double calcSlaOnTimeRateThisMonth() {
        // SLA job: completed_at <= scheduled_end
        // Chỉ tính các job completed trong tháng và có scheduled_end
        String sql = """
            SELECT
                COALESCE(
                    100.0 * SUM(CASE WHEN completed_at <= scheduled_end THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0),
                    0
                ) AS on_time_rate
            FROM maintenances
            WHERE completed_at IS NOT NULL
              AND scheduled_end IS NOT NULL
              AND YEAR(completed_at) = YEAR(CURDATE())
              AND MONTH(completed_at) = MONTH(CURDATE())
        """;
        return queryDouble(sql);
    }

    private int queryInt(String sql, Object... params) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private double queryDouble(String sql, Object... params) {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    private void bind(PreparedStatement ps, Object... params) throws Exception {
        if (params == null) return;
        for (int i = 0; i < params.length; i++) {
            ps.setObject(i + 1, params[i]);
        }
    }
}
