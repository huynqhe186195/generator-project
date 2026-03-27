package com.generatorproject.dao.report;

import com.generatorproject.dao.DbContext;
import com.generatorproject.model.report.MaintenanceKpi;
import com.generatorproject.model.report.MaintenanceReportFilter;
import com.generatorproject.model.report.MaintenanceReportRow;

import java.sql.*;
import java.util.*;

/**
 * DAO cho Report C (Bảo trì định kỳ).
 * Tối ưu cho:
 * - KPI theo kỳ
 * - Breakdown theo type/power/customer-site/technician
 * - List chi tiết có vật tư + ảnh BEFORE/AFTER
 */
public class MaintenanceReportDAO extends DbContext {

    // ===== KPI =====

    public MaintenanceKpi loadKpis(MaintenanceReportFilter f) {
        MaintenanceKpi kpi = new MaintenanceKpi();

        kpi.setPlanned(countPlanned(f));
        kpi.setDone(countDone(f));
        kpi.setOverdue(countOverdue(f));
        kpi.setCancelledOrRescheduled(countCancelledOrRescheduled(f));

        double onTimeRate = calcOnTimeRatePlannedBased(f);
        kpi.setOnTimeRate(onTimeRate);
        kpi.setOnTimeRateNote("= (Số lịch COMPLETED đúng hạn) / (Tổng lịch đã lên kế hoạch, không tính CANCELLED) * 100");

        return kpi;
    }

    /**
     * "Lịch theo kế hoạch" của report C:
     * - focus PERIODIC
     * - mẫu số theo BA: các bản ghi không bị huỷ và đang/đã thực hiện
     *   (mapping: execution_status IN ('PENDING','ON_THE_WAY','IN_PROGRESS','WAITING_PARTS','COMPLETED'))
     */
    private int countPlanned(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT COUNT(*)
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" AND m.type = 'PERIODIC' ");
        sb.append(" AND m.status <> 'CANCELLED' ");
        sb.append(" AND m.execution_status IN ('PENDING','ON_THE_WAY','IN_PROGRESS','WAITING_PARTS','COMPLETED') ");

        return queryInt(sb.toString(), params);
    }

    /**
     * "Đã thực hiện" = execution_status = COMPLETED (theo yêu cầu định nghĩa mới).
     * (Không dùng completed_at != null nữa vì có thể data bẩn/missing)
     */
    private int countDone(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT COUNT(*)
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" AND m.type = 'PERIODIC' ");
        sb.append(" AND m.status <> 'CANCELLED' ");
        sb.append(" AND m.execution_status = 'COMPLETED' ");

        return queryInt(sb.toString(), params);
    }

    /**
     * Trễ hạn:
     * - NOW() > scheduled_end
     * - execution_status <> COMPLETED
     * - status <> CANCELLED
     * - scheduled_end IS NOT NULL
     */
    private int countOverdue(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT COUNT(*)
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" AND m.type = 'PERIODIC' ");
        sb.append(" AND m.status <> 'CANCELLED' ");
        sb.append(" AND m.scheduled_end IS NOT NULL ");
        sb.append(" AND NOW() > m.scheduled_end ");
        sb.append(" AND m.execution_status <> 'COMPLETED' ");

        return queryInt(sb.toString(), params);
    }

    /**
     * Hủy / Dời lịch:
     * - status = CANCELLED
     * - hoặc schedule_status IN (RESCHEDULED, REJECTED)
     *
     * (Cái này giữ theo logic cũ vì BA chưa đổi phần này.)
     */
    private int countCancelledOrRescheduled(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT COUNT(*)
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" AND m.type = 'PERIODIC' ");
        sb.append(" AND (m.status = 'CANCELLED' OR m.schedule_status IN ('RESCHEDULED','REJECTED')) ");

        return queryInt(sb.toString(), params);
    }

    /**
     * On-time planned-based:
     * numerator: execution_status='COMPLETED' AND completed_at <= scheduled_end
     * denominator: tổng lịch đã lên kế hoạch (theo countPlanned)
     */
    private double calcOnTimeRatePlannedBased(MaintenanceReportFilter f) {
        int denom = countPlanned(f);
        if (denom == 0) return 0.0;

        int num = countOnTimeCompleted(f);
        return 100.0 * num / denom;
    }

    private int countOnTimeCompleted(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT COUNT(*)
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" AND m.type = 'PERIODIC' ");
        sb.append(" AND m.status <> 'CANCELLED' ");
        sb.append(" AND m.execution_status = 'COMPLETED' ");
        sb.append(" AND m.scheduled_end IS NOT NULL ");
        sb.append(" AND m.completed_at IS NOT NULL ");
        sb.append(" AND m.completed_at <= m.scheduled_end ");

        return queryInt(sb.toString(), params);
    }

    // ===== Breakdown =====

    public Map<String, Integer> breakdownByType(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
            SELECT m.type AS k, COUNT(*) AS cnt
            FROM maintenances m
            LEFT JOIN products p ON p.id = m.product_id
            WHERE 1=1
        """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" GROUP BY m.type ORDER BY cnt DESC");
        return queryCountMap(sb.toString(), params);
    }

    public Map<String, Integer> breakdownByPowerBucket(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT
            CASE
                WHEN pm.power IS NULL THEN 'Unknown'
                WHEN pm.power < 20 THEN '<20kVA'
                WHEN pm.power < 50 THEN '20-49kVA'
                WHEN pm.power < 100 THEN '50-99kVA'
                WHEN pm.power < 200 THEN '100-199kVA'
                ELSE '>=200kVA'
            END AS k,
            COUNT(*) AS cnt
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        LEFT JOIN product_models pm ON pm.id = p.model_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        // IMPORTANT: không ép PERIODIC ở đây nữa.
        // Loại (ALL/PERIODIC/NON) đã được applyFilter xử lý bằng onlyPeriodic rồi.

        sb.append(" GROUP BY k ORDER BY cnt DESC");
        return queryCountMap(sb.toString(), params);
    }

    public Map<String, Integer> breakdownByCustomerSite(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT
            CONCAT(COALESCE(cu.full_name,'Unknown'), ' | ', COALESCE(p.current_location,'(no site)')) AS k,
            COUNT(*) AS cnt
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        LEFT JOIN users cu ON cu.id = p.customer_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        // không ép PERIODIC
        sb.append(" GROUP BY k ORDER BY cnt DESC LIMIT 20");
        return queryCountMap(sb.toString(), params);
    }

    public Map<String, Integer> breakdownByTechnician(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT COALESCE(t.full_name, 'Unassigned') AS k, COUNT(*) AS cnt
        FROM maintenances m
        LEFT JOIN products p ON p.id = m.product_id
        LEFT JOIN users t ON t.id = m.technician_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        // không ép PERIODIC
        sb.append(" GROUP BY k ORDER BY cnt DESC");
        return queryCountMap(sb.toString(), params);
    }

    // ===== List =====

    public int countRows(MaintenanceReportFilter f) {
        StringBuilder sb = new StringBuilder("""
            SELECT COUNT(*)
            FROM maintenances m
            LEFT JOIN products p ON p.id = m.product_id
            WHERE 1=1
        """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);
        return queryInt(sb.toString(), params);
    }

    public List<MaintenanceReportRow> findRows(MaintenanceReportFilter f, int page, int pageSize) {
        int offset = Math.max(0, (page - 1) * pageSize);

        StringBuilder sb = new StringBuilder("""
            SELECT
                m.id AS maintenance_id,
                m.type,
                DATE_FORMAT(m.maintenance_date, '%Y-%m-%d') AS maintenance_date,
                m.scheduled_start,
                m.scheduled_end,
                m.completed_at,
                m.schedule_status,
                m.execution_status,
                m.status,

                p.id AS product_id,
                p.serial_number,
                p.current_location AS site,

                pm.name AS model_name,
                pm.power AS power_kva,

                cu.full_name AS customer_name,
                tech.full_name AS technician_name,

                COALESCE(sp.parts_qty, 0) AS parts_qty,
                COALESCE(sp.parts_value, 0) AS parts_value,

                COALESCE(img.before_count, 0) AS before_count,
                COALESCE(img.after_count, 0) AS after_count

            FROM maintenances m
            LEFT JOIN products p ON p.id = m.product_id
            LEFT JOIN product_models pm ON pm.id = p.model_id
            LEFT JOIN users cu ON cu.id = p.customer_id
            LEFT JOIN users tech ON tech.id = m.technician_id

            LEFT JOIN (
                SELECT maintenance_id,
                       COALESCE(SUM(quantity_used),0) AS parts_qty,
                       COALESCE(SUM(COALESCE(cost_at_time,0)),0) AS parts_value
                FROM maintenance_spare_parts
                GROUP BY maintenance_id
            ) sp ON sp.maintenance_id = m.id

            LEFT JOIN (
                SELECT maintenance_id,
                       SUM(CASE WHEN image_type='BEFORE' THEN 1 ELSE 0 END) AS before_count,
                       SUM(CASE WHEN image_type='AFTER' THEN 1 ELSE 0 END) AS after_count
                FROM maintenance_images
                GROUP BY maintenance_id
            ) img ON img.maintenance_id = m.id

            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" ORDER BY m.maintenance_date DESC, m.id DESC LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add(offset);

        List<MaintenanceReportRow> rows = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sb.toString())) {

            bind(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceReportRow r = new MaintenanceReportRow();
                    r.setMaintenanceId(rs.getInt("maintenance_id"));
                    r.setType(rs.getString("type"));
                    r.setMaintenanceDate(rs.getString("maintenance_date"));
                    r.setScheduledStart(rs.getTimestamp("scheduled_start"));
                    r.setScheduledEnd(rs.getTimestamp("scheduled_end"));
                    r.setCompletedAt(rs.getTimestamp("completed_at"));
                    r.setScheduleStatus(rs.getString("schedule_status"));
                    r.setExecutionStatus(rs.getString("execution_status"));
                    r.setStatus(rs.getString("status"));

                    r.setProductId(rs.getInt("product_id"));
                    r.setSerialNumber(rs.getString("serial_number"));
                    r.setSite(rs.getString("site"));
                    r.setModelName(rs.getString("model_name"));
                    r.setModelPowerKva(rs.getBigDecimal("power_kva"));

                    r.setCustomerName(rs.getString("customer_name"));
                    r.setTechnicianName(rs.getString("technician_name"));

                    r.setPartsQty(rs.getInt("parts_qty"));
                    r.setPartsValue(rs.getDouble("parts_value"));
                    r.setBeforeImages(rs.getInt("before_count"));
                    r.setAfterImages(rs.getInt("after_count"));

                    rows.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rows;
    }

    // ===== Common filter =====

    private void applyFilter(StringBuilder sb, List<Object> params, MaintenanceReportFilter f) {
        if (f == null) return;

        if (f.getFrom() != null && !f.getFrom().isBlank()) {
            sb.append(" AND m.maintenance_date >= ? ");
            params.add(f.getFrom().trim());
        }
        if (f.getTo() != null && !f.getTo().isBlank()) {
            sb.append(" AND m.maintenance_date <= ? ");
            params.add(f.getTo().trim());
        }
        if (f.getCustomerId() != null && f.getCustomerId() > 0) {
            sb.append(" AND p.customer_id = ? ");
            params.add(f.getCustomerId());
        }
        if (f.getTechnicianId() != null && f.getTechnicianId() > 0) {
            sb.append(" AND m.technician_id = ? ");
            params.add(f.getTechnicianId());
        }
        if (f.getModelId() != null && f.getModelId() > 0) {
            sb.append(" AND p.model_id = ? ");
            params.add(f.getModelId());
        }
        if (f.getSiteKeyword() != null && !f.getSiteKeyword().isBlank()) {
            sb.append(" AND p.current_location LIKE ? ");
            params.add("%" + f.getSiteKeyword().trim() + "%");
        }

        // filter PERIODIC vs NON_PERIODIC (nếu user chọn)
        if (f.getOnlyPeriodic() != null) {
            if (Boolean.TRUE.equals(f.getOnlyPeriodic())) {
                sb.append(" AND m.type = 'PERIODIC' ");
            } else {
                sb.append(" AND m.type <> 'PERIODIC' ");
            }
        }
    }

    // ===== Small helpers =====

    private int queryInt(String sql, List<Object> params) {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private Map<String, Integer> queryCountMap(String sql, List<Object> params) {
        Map<String, Integer> out = new LinkedHashMap<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.put(rs.getString("k"), rs.getInt("cnt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out;
    }

    private void bind(PreparedStatement ps, List<Object> params) throws Exception {
        if (params == null) return;
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }
}