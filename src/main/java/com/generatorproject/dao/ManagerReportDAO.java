package com.generatorproject.dao;

import com.generatorproject.model.ManagerReportStats;
import com.generatorproject.model.ManagerReportStats.ChartPoint;
import com.generatorproject.model.ManagerReportStats.SimpleStatItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ManagerReportDAO extends DbContext {

    public ManagerReportStats getDashboardStats() {
        ManagerReportStats stats = new ManagerReportStats();

        String overviewSql = """
            SELECT
                (SELECT COUNT(*) FROM incidents WHERE DATE(created_at) = CURDATE()) AS service_today,
                (SELECT COUNT(*) FROM incidents WHERE YEARWEEK(created_at, 1) = YEARWEEK(CURDATE(), 1)) AS service_week,
                (SELECT COUNT(*) FROM incidents WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS service_month,
                (SELECT COUNT(*) FROM maintenances WHERE type IN ('PERIODIC', 'INSPECTION')) AS maintenance_tickets,
                (SELECT COUNT(*) FROM maintenances WHERE type = 'REPAIR') AS repair_tickets,
                (SELECT COUNT(*) FROM incidents WHERE status IN ('NEW', 'VERIFYING', 'WAITING_MANAGER', 'APPROVED', 'ASSIGNED')) AS waiting_requests,
                (SELECT COUNT(*) FROM incidents WHERE status IN ('RESOLVED', 'COMPLETED')) +
                (SELECT COUNT(*) FROM maintenances WHERE status = 'COMPLETED') AS completed_requests,
                (SELECT COUNT(*) FROM incidents WHERE status NOT IN ('RESOLVED', 'COMPLETED') AND created_at < DATE_SUB(NOW(), INTERVAL 72 HOUR)) AS overdue_requests,
                (SELECT COUNT(*) FROM maintenances WHERE type = 'PERIODIC') AS periodic_maintenance,
                (SELECT COUNT(*) FROM maintenances WHERE type <> 'PERIODIC' OR incident_id IS NOT NULL) AS unexpected_maintenance,
                (SELECT COUNT(*) FROM (
                    SELECT p.id,
                           COALESCE(MAX(CASE WHEN m.type IN ('PERIODIC', 'INSPECTION') THEN m.maintenance_date END), p.purchase_date) AS last_service_date
                    FROM products p
                    LEFT JOIN maintenances m ON m.product_id = p.id
                    GROUP BY p.id, p.purchase_date
                ) due_list
                WHERE last_service_date IS NOT NULL
                  AND DATEDIFF(DATE_ADD(last_service_date, INTERVAL 180 DAY), CURDATE()) BETWEEN 0 AND 30) AS machines_due_soon,
                (SELECT COUNT(*) FROM (
                    SELECT p.id,
                           COALESCE(MAX(CASE WHEN m.type IN ('PERIODIC', 'INSPECTION') THEN m.maintenance_date END), p.purchase_date) AS last_service_date
                    FROM products p
                    LEFT JOIN maintenances m ON m.product_id = p.id
                    GROUP BY p.id, p.purchase_date
                ) due_list
                WHERE last_service_date IS NOT NULL
                  AND DATE_ADD(last_service_date, INTERVAL 180 DAY) < CURDATE()) AS machines_overdue,
                (SELECT COALESCE(AVG(TIMESTAMPDIFF(HOUR, created_at, completed_at)), 0)
                    FROM maintenances
                    WHERE type IN ('PERIODIC', 'INSPECTION') AND completed_at IS NOT NULL) AS avg_maintenance_hours,
                (SELECT COALESCE(type, 'N/A') FROM maintenances GROUP BY type ORDER BY COUNT(*) DESC LIMIT 1) AS common_maintenance_type,
                (SELECT COALESCE(pm.name, 'N/A')
                    FROM maintenances m
                    JOIN products p ON p.id = m.product_id
                    LEFT JOIN product_models pm ON pm.id = p.model_id
                    GROUP BY pm.name
                    ORDER BY COUNT(*) DESC
                    LIMIT 1) AS maintained_model,
                (SELECT COUNT(*) FROM maintenances WHERE type = 'REPAIR' AND YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS repairs_this_month,
                (SELECT COUNT(*) FROM maintenances WHERE type = 'REPAIR' AND status = 'COMPLETED') AS repairs_done,
                (SELECT COUNT(*) FROM maintenances WHERE type = 'REPAIR' AND status <> 'COMPLETED') AS repairs_pending,
                (SELECT COUNT(DISTINCT m.id) FROM maintenances m JOIN maintenance_spare_parts msp ON msp.maintenance_id = m.id WHERE m.type = 'REPAIR') AS repairs_with_parts,
                (SELECT COALESCE(AVG(TIMESTAMPDIFF(HOUR, created_at, completed_at)), 0) FROM maintenances WHERE type = 'REPAIR' AND completed_at IS NOT NULL) AS avg_repair_hours,
                (SELECT COALESCE(AVG(CASE WHEN p.current_location IS NOT NULL AND TRIM(p.current_location) <> '' THEN 1 ELSE 0 END) * 100, 0)
                    FROM maintenances m JOIN products p ON p.id = m.product_id WHERE m.type = 'REPAIR') AS onsite_repair_rate,
                (SELECT COALESCE(pm.name, 'N/A')
                    FROM maintenances m
                    JOIN products p ON p.id = m.product_id
                    LEFT JOIN product_models pm ON pm.id = p.model_id
                    WHERE m.type = 'REPAIR'
                    GROUP BY pm.name
                    ORDER BY COUNT(*) DESC
                    LIMIT 1) AS highest_failure_model,
                (SELECT COUNT(*) FROM maintenances m JOIN products p ON p.id = m.product_id WHERE m.type = 'REPAIR' AND p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)) AS warranty_active_cases,
                (SELECT COUNT(*) FROM maintenances m JOIN products p ON p.id = m.product_id WHERE m.type = 'REPAIR' AND p.purchase_date < DATE_SUB(CURDATE(), INTERVAL 12 MONTH)) AS warranty_rejected_cases,
                (SELECT COUNT(*) FROM products WHERE purchase_date < DATE_SUB(CURDATE(), INTERVAL 12 MONTH)) AS warranty_expired_cases,
                (SELECT COALESCE(AVG(CASE WHEN p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) THEN 1 ELSE 0 END) * 100, 0)
                    FROM maintenances m JOIN products p ON p.id = m.product_id WHERE m.type = 'REPAIR') AS warranty_coverage_rate,
                (SELECT COALESCE(sp.name, 'N/A')
                    FROM maintenance_spare_parts msp
                    JOIN maintenances m ON m.id = msp.maintenance_id
                    JOIN products p ON p.id = m.product_id
                    JOIN spare_parts sp ON sp.id = msp.spare_part_id
                    WHERE m.type = 'REPAIR' AND p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
                    GROUP BY sp.name
                    ORDER BY COUNT(*) DESC, SUM(msp.quantity_used) DESC
                    LIMIT 1) AS top_warranty_part,
                (SELECT COALESCE(c.full_name, 'N/A')
                    FROM maintenances m
                    JOIN products p ON p.id = m.product_id
                    LEFT JOIN users c ON c.id = p.customer_id
                    WHERE m.type = 'REPAIR' AND p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
                    GROUP BY c.full_name
                    ORDER BY COUNT(*) DESC
                    LIMIT 1) AS top_warranty_customer,
                (SELECT COALESCE(pm.name, 'N/A')
                    FROM maintenances m
                    JOIN products p ON p.id = m.product_id
                    LEFT JOIN product_models pm ON pm.id = p.model_id
                    WHERE m.type = 'REPAIR' AND p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
                    GROUP BY pm.name
                    ORDER BY COUNT(*) DESC
                    LIMIT 1) AS top_warranty_model,
                (SELECT COUNT(DISTINCT customer_id) FROM products WHERE customer_id IS NOT NULL) AS total_customers_supported,
                (SELECT COUNT(*) FROM products) AS total_tracked_machines,
                (SELECT COUNT(*) FROM products WHERE status IN ('ACTIVE', 'RUNNING', 'OPERATIONAL')) AS active_machines,
                (SELECT COUNT(*) FROM products WHERE status IN ('STOPPED', 'WAITING_REPAIR', 'INACTIVE', 'BROKEN')) AS stopped_machines,
                (SELECT COUNT(DISTINCT customer_id) FROM (
                    SELECT p.customer_id,
                           COALESCE(MAX(CASE WHEN m.type IN ('PERIODIC', 'INSPECTION') THEN m.maintenance_date END), p.purchase_date) AS last_service_date
                    FROM products p
                    LEFT JOIN maintenances m ON m.product_id = p.id
                    WHERE p.customer_id IS NOT NULL
                    GROUP BY p.id, p.customer_id, p.purchase_date
                ) due_customers
                WHERE last_service_date IS NOT NULL
                  AND DATEDIFF(DATE_ADD(last_service_date, INTERVAL 180 DAY), CURDATE()) BETWEEN 0 AND 30) AS customers_due_soon,
                (SELECT COALESCE(c.full_name, 'N/A')
                    FROM maintenances m
                    JOIN products p ON p.id = m.product_id
                    LEFT JOIN users c ON c.id = p.customer_id
                    GROUP BY c.full_name
                    ORDER BY COUNT(*) DESC
                    LIMIT 1) AS top_service_customer,
                (SELECT COALESCE(AVG(TIMESTAMPDIFF(HOUR, i.created_at, m.created_at)), 0)
                    FROM incidents i JOIN maintenances m ON m.incident_id = i.id) AS avg_response_hours,
                (SELECT COALESCE(AVG(TIMESTAMPDIFF(HOUR, created_at, completed_at)), 0)
                    FROM maintenances WHERE completed_at IS NOT NULL) AS avg_completion_hours,
                (SELECT COALESCE(AVG(CASE WHEN completed_at IS NOT NULL AND completed_at <= DATE_ADD(maintenance_date, INTERVAL 1 DAY) THEN 1 ELSE 0 END) * 100, 0)
                    FROM maintenances) AS on_time_rate,
                (SELECT COALESCE((COUNT(*) / NULLIF((SELECT COUNT(*) FROM maintenances WHERE type = 'REPAIR'), 0)) * 100, 0)
                    FROM (
                        SELECT product_id FROM maintenances WHERE type = 'REPAIR'
                        GROUP BY product_id HAVING COUNT(*) > 1
                    ) repeated_repairs) AS repeat_failure_rate,
                (SELECT COALESCE((COUNT(*) / NULLIF((SELECT COUNT(*) FROM maintenances WHERE type = 'REPAIR'), 0)) * 100, 0)
                    FROM maintenances WHERE type = 'REPAIR' AND incident_id IS NOT NULL) AS revisit_rate
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(overviewSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.setServiceRequestsToday(rs.getInt("service_today"));
                stats.setServiceRequestsThisWeek(rs.getInt("service_week"));
                stats.setServiceRequestsThisMonth(rs.getInt("service_month"));
                stats.setMaintenanceTickets(rs.getInt("maintenance_tickets"));
                stats.setRepairTickets(rs.getInt("repair_tickets"));
                stats.setWaitingRequests(rs.getInt("waiting_requests"));
                stats.setCompletedRequests(rs.getInt("completed_requests"));
                stats.setOverdueRequests(rs.getInt("overdue_requests"));
                stats.setPeriodicMaintenanceCount(rs.getInt("periodic_maintenance"));
                stats.setUnexpectedMaintenanceCount(rs.getInt("unexpected_maintenance"));
                stats.setMachinesDueSoon(rs.getInt("machines_due_soon"));
                stats.setMachinesOverdue(rs.getInt("machines_overdue"));
                stats.setAverageMaintenanceHours(rs.getDouble("avg_maintenance_hours"));
                stats.setMostCommonMaintenanceType(rs.getString("common_maintenance_type"));
                stats.setMostMaintainedModel(rs.getString("maintained_model"));
                stats.setRepairsThisMonth(rs.getInt("repairs_this_month"));
                stats.setRepairsDone(rs.getInt("repairs_done"));
                stats.setRepairsPending(rs.getInt("repairs_pending"));
                stats.setRepairsWithParts(rs.getInt("repairs_with_parts"));
                stats.setAverageRepairHours(rs.getDouble("avg_repair_hours"));
                stats.setOnsiteRepairRate(rs.getDouble("onsite_repair_rate"));
                stats.setHighestFailureModel(rs.getString("highest_failure_model"));
                stats.setWarrantyActiveCases(rs.getInt("warranty_active_cases"));
                stats.setWarrantyRejectedCases(rs.getInt("warranty_rejected_cases"));
                stats.setWarrantyExpiredCases(rs.getInt("warranty_expired_cases"));
                stats.setWarrantyCoverageRate(rs.getDouble("warranty_coverage_rate"));
                stats.setTopWarrantyPart(rs.getString("top_warranty_part"));
                stats.setTopWarrantyCustomer(rs.getString("top_warranty_customer"));
                stats.setTopWarrantyModel(rs.getString("top_warranty_model"));
                stats.setTotalCustomersSupported(rs.getInt("total_customers_supported"));
                stats.setTotalTrackedMachines(rs.getInt("total_tracked_machines"));
                stats.setActiveMachines(rs.getInt("active_machines"));
                stats.setStoppedMachines(rs.getInt("stopped_machines"));
                stats.setCustomersDueSoon(rs.getInt("customers_due_soon"));
                stats.setTopServiceCustomer(rs.getString("top_service_customer"));
                stats.setAverageResponseHours(rs.getDouble("avg_response_hours"));
                stats.setAverageCompletionHours(rs.getDouble("avg_completion_hours"));
                stats.setOnTimeRate(rs.getDouble("on_time_rate"));
                stats.setRepeatFailureRate(rs.getDouble("repeat_failure_rate"));
                stats.setRevisitRate(rs.getDouble("revisit_rate"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        stats.setRequestTrend(getRequestTrend());
        stats.setTopRepairIssues(getTopRepairIssues());
        stats.setFailureGroups(getFailureGroups());
        stats.setTopModels(getTopModels());
        stats.setTechnicianPerformance(getTechnicianPerformance());
        stats.setCustomerHistory(getCustomerHistory());
        return stats;
    }

    private List<ChartPoint> getRequestTrend() {
        List<ChartPoint> list = new ArrayList<ChartPoint>();
        String sql = """
            SELECT DATE_FORMAT(created_at, '%d/%m') AS label, COUNT(*) AS total
            FROM incidents
            WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
            GROUP BY DATE(created_at), DATE_FORMAT(created_at, '%d/%m')
            ORDER BY DATE(created_at)
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ChartPoint(rs.getString("label"), rs.getInt("total")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<SimpleStatItem> getTopRepairIssues() {
        List<SimpleStatItem> list = new ArrayList<SimpleStatItem>();
        String sql = """
            SELECT COALESCE(NULLIF(TRIM(title), ''), 'Không có tiêu đề') AS label, COUNT(*) AS total
            FROM incidents
            GROUP BY COALESCE(NULLIF(TRIM(title), ''), 'Không có tiêu đề')
            ORDER BY total DESC, label ASC
            LIMIT 5
        """;
        return querySimpleItems(sql, null);
    }

    private List<SimpleStatItem> getFailureGroups() {
        List<SimpleStatItem> list = new ArrayList<SimpleStatItem>();
        String sql = """
            SELECT label, COUNT(*) AS total FROM (
                SELECT CASE
                    WHEN LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%động cơ%' OR LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%dong co%' THEN 'Động cơ'
                    WHEN LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%đầu phát%' OR LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%dau phat%' THEN 'Đầu phát'
                    WHEN LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%tủ điều khiển%' OR LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%tu dieu khien%' THEN 'Tủ điều khiển'
                    WHEN LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%ats%' THEN 'ATS'
                    WHEN LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%nhiên liệu%' OR LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%nhien lieu%' THEN 'Nhiên liệu'
                    WHEN LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%làm mát%' OR LOWER(CONCAT(COALESCE(title, ''), ' ', COALESCE(description, ''))) LIKE '%lam mat%' THEN 'Làm mát'
                    ELSE 'Khác'
                END AS label
                FROM incidents
            ) grouped
            GROUP BY label
            ORDER BY total DESC, label ASC
        """;
        return querySimpleItems(sql, null);
    }

    private List<SimpleStatItem> getTopModels() {
        String sql = """
            SELECT COALESCE(pm.name, 'Chưa có model') AS label,
                   MAX(COALESCE(b.name, '')) AS extra,
                   COUNT(*) AS total
            FROM maintenances m
            JOIN products p ON p.id = m.product_id
            LEFT JOIN product_models pm ON pm.id = p.model_id
            LEFT JOIN brands b ON b.id = pm.brand_id
            GROUP BY pm.name
            ORDER BY total DESC, label ASC
            LIMIT 5
        """;
        return querySimpleItems(sql, "extra");
    }

    private List<SimpleStatItem> getTechnicianPerformance() {
        String sql = """
            SELECT COALESCE(u.full_name, 'Chưa phân công') AS label,
                   CONCAT('Đúng hạn: ', ROUND(AVG(CASE WHEN m.completed_at IS NOT NULL AND m.completed_at <= DATE_ADD(m.maintenance_date, INTERVAL 1 DAY) THEN 100 ELSE 0 END), 0), '%') AS extra,
                   COUNT(*) AS total,
                   COALESCE(AVG(TIMESTAMPDIFF(HOUR, m.created_at, m.completed_at)), 0) AS pct
            FROM maintenances m
            LEFT JOIN users u ON u.id = m.technician_id
            GROUP BY u.full_name
            ORDER BY total DESC, pct ASC
            LIMIT 6
        """;
        return querySimpleItems(sql, "extra", "pct");
    }

    private List<SimpleStatItem> getCustomerHistory() {
        String sql = """
            SELECT COALESCE(c.full_name, 'Khách lẻ') AS label,
                   CONCAT(COUNT(DISTINCT p.id), ' máy theo dõi') AS extra,
                   COUNT(m.id) AS total
            FROM products p
            LEFT JOIN users c ON c.id = p.customer_id
            LEFT JOIN maintenances m ON m.product_id = p.id
            GROUP BY c.full_name
            ORDER BY total DESC, label ASC
            LIMIT 5
        """;
        return querySimpleItems(sql, "extra");
    }

    private List<SimpleStatItem> querySimpleItems(String sql, String extraColumn) {
        return querySimpleItems(sql, extraColumn, null);
    }

    private List<SimpleStatItem> querySimpleItems(String sql, String extraColumn, String percentageColumn) {
        List<SimpleStatItem> list = new ArrayList<SimpleStatItem>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String extra = extraColumn == null ? null : rs.getString(extraColumn);
                double percentage = percentageColumn == null ? 0 : rs.getDouble(percentageColumn);
                list.add(new SimpleStatItem(rs.getString("label"), extra, rs.getInt("total"), percentage));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
