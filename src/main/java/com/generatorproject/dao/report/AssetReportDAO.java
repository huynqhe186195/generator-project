package com.generatorproject.dao.report;

import com.generatorproject.dao.DbContext;
import com.generatorproject.model.report.AssetReportFilter;
import com.generatorproject.model.report.AssetReportKpi;
import com.generatorproject.model.report.AssetReportRow;
import com.generatorproject.model.report.OptionItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Asset lifecycle report DAO - aligned with your schema:
 * - products: serial_number, manufacture_year, current_location, status, total_running_hours, customer_id, model_id, purchase_date, contract_id
 * - product_models: brand_id, name, power (assumed)
 * - brands: id, name
 */
public class AssetReportDAO extends DbContext {

    public AssetReportKpi loadKpis(AssetReportFilter f) {
        AssetReportKpi k = new AssetReportKpi();

        k.setTotalAssets(countAssets(f));

        // warranty KPI will be enabled after you confirm the actual column exists
        k.setExpiringWarranty30(0);

        // broken/problem: with your sample statuses, treat MAINTENANCE as "problem". READY/RUNNING are healthy.
        k.setBrokenOrProblemAssets(countByStatuses(f, new String[]{"MAINTENANCE"}));

        k.setOverduePmAssets(countOverduePmAssetsHeuristic(f, 60));

        return k;
    }

    public int countAssets(AssetReportFilter f) {
        StringBuilder sb = new StringBuilder("""
            SELECT COUNT(*)
            FROM products p
            LEFT JOIN product_models pm ON pm.id = p.model_id
            LEFT JOIN brands b ON b.id = pm.brand_id
            LEFT JOIN users cu ON cu.id = p.customer_id
            WHERE 1=1
        """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        return queryInt(sb.toString(), params);
    }

    public List<AssetReportRow> findAssets(AssetReportFilter f, int page, int pageSize) {
        int offset = Math.max(0, (page - 1) * pageSize);

        StringBuilder sb = new StringBuilder("""
        SELECT
            p.id AS product_id,
            p.serial_number,
            p.manufacture_year,
            p.current_location,
            p.status,
            p.total_running_hours,

            pm.name AS model_name,
            pm.power AS power_kva,

            b.name AS brand_name,

            cu.full_name AS customer_name,

            c.end_date AS warranty_end_date,

            COALESCE(inc90.inc_cnt, 0) AS incidents_90d,
            inc90.last_incident_date AS last_incident_date,

            pmx.last_periodic_date AS last_periodic_date,
            mx.last_maintenance_date AS last_maintenance_date,

            COALESCE(cost.total_cost, 0) AS total_cost_all_time

        FROM products p
        LEFT JOIN contracts c ON c.id = p.contract_id
        LEFT JOIN product_models pm ON pm.id = p.model_id
        LEFT JOIN brands b ON b.id = pm.brand_id
        LEFT JOIN users cu ON cu.id = p.customer_id

        LEFT JOIN (
            SELECT product_id,
                   COUNT(*) AS inc_cnt,
                   MAX(DATE(created_at)) AS last_incident_date
            FROM incidents
            WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
            GROUP BY product_id
        ) inc90 ON inc90.product_id = p.id

        LEFT JOIN (
            SELECT product_id, MAX(maintenance_date) AS last_periodic_date
            FROM maintenances
            WHERE type = 'PERIODIC'
            GROUP BY product_id
        ) pmx ON pmx.product_id = p.id

        LEFT JOIN (
            SELECT product_id, MAX(maintenance_date) AS last_maintenance_date
            FROM maintenances
            GROUP BY product_id
        ) mx ON mx.product_id = p.id

        LEFT JOIN (
            SELECT product_id, COALESCE(SUM(COALESCE(total_cost,0)),0) AS total_cost
            FROM maintenances
            GROUP BY product_id
        ) cost ON cost.product_id = p.id

        WHERE 1=1
    """);

        List<Object> params = new ArrayList<>();
        applyFilterBase(sb, params, f);

        // warranty scope
        if ("EXPIRING_30".equalsIgnoreCase(nz(f.getWarrantyScope()))) {
            sb.append(" AND c.end_date IS NOT NULL ");
            sb.append(" AND c.end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) ");
        }

        // periodic scope
        String pse = nz(f.getPeriodicScope());
        if ("HAS".equalsIgnoreCase(pse)) {
            sb.append(" AND pmx.last_periodic_date IS NOT NULL ");
        } else if ("NONE".equalsIgnoreCase(pse)) {
            sb.append(" AND pmx.last_periodic_date IS NULL ");
        }

        // cost bucket (total all time)
        String cb = nz(f.getCostBucket());
        if ("LT_500K".equalsIgnoreCase(cb)) {
            sb.append(" AND COALESCE(cost.total_cost,0) < ? ");
            params.add(500000);
        } else if ("500K_1M".equalsIgnoreCase(cb)) {
            sb.append(" AND COALESCE(cost.total_cost,0) >= ? AND COALESCE(cost.total_cost,0) < ? ");
            params.add(500000);
            params.add(1000000);
        } else if ("1M_2M".equalsIgnoreCase(cb)) {
            sb.append(" AND COALESCE(cost.total_cost,0) >= ? AND COALESCE(cost.total_cost,0) < ? ");
            params.add(1000000);
            params.add(2000000);
        } else if ("GE_2M".equalsIgnoreCase(cb)) {
            sb.append(" AND COALESCE(cost.total_cost,0) >= ? ");
            params.add(2000000);
        }

        sb.append(" ORDER BY p.id DESC LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add(offset);

        List<AssetReportRow> rows = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sb.toString())) {

            bind(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssetReportRow r = new AssetReportRow();
                    r.setProductId(rs.getInt("product_id"));
                    r.setSerialNumber(rs.getString("serial_number"));

                    int y = rs.getInt("manufacture_year");
                    r.setManufactureYear(rs.wasNull() ? null : y);

                    r.setCurrentLocation(rs.getString("current_location"));
                    r.setStatus(rs.getString("status"));

                    double hrs = rs.getDouble("total_running_hours");
                    r.setTotalRunningHours(rs.wasNull() ? null : hrs);

                    // warranty_end_date disabled until column confirmed
                    r.setWarrantyEndDate(rs.getDate("warranty_end_date"));

                    r.setModelName(rs.getString("model_name"));
                    r.setModelPowerKva(rs.getBigDecimal("power_kva"));
                    r.setBrandName(rs.getString("brand_name"));
                    r.setCustomerName(rs.getString("customer_name"));

                    r.setIncidents90d(rs.getInt("incidents_90d"));
                    r.setLastIncidentDate(rs.getDate("last_incident_date"));

                    r.setLastPeriodicDate(rs.getDate("last_periodic_date"));
                    r.setLastMaintenanceDate(rs.getDate("last_maintenance_date"));

                    r.setTotalCostAllTime(rs.getDouble("total_cost_all_time"));

                    rows.add(r);
                }
            }
        } catch (Exception e) {
            // IMPORTANT: don't swallow; otherwise UI shows "0" and we lose root cause.
            throw new RuntimeException("Asset report query failed. SQL=" + sb, e);
        }
        return rows;
    }

    public int countAssetsForList(AssetReportFilter f) {
        StringBuilder sb = new StringBuilder("""
            SELECT COUNT(*)
            FROM products p
            LEFT JOIN product_models pm ON pm.id = p.model_id
            LEFT JOIN brands b ON b.id = pm.brand_id
            LEFT JOIN users cu ON cu.id = p.customer_id
            WHERE 1=1
        """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);
        return queryInt(sb.toString(), params);
    }

    private int countByStatuses(AssetReportFilter f, String[] statuses) {
        if (statuses == null || statuses.length == 0) return 0;

        StringBuilder sb = new StringBuilder("""
            SELECT COUNT(*)
            FROM products p
            LEFT JOIN product_models pm ON pm.id = p.model_id
            LEFT JOIN brands b ON b.id = pm.brand_id
            LEFT JOIN users cu ON cu.id = p.customer_id
            WHERE 1=1
        """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" AND p.status IN (");
        for (int i = 0; i < statuses.length; i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
            params.add(statuses[i]);
        }
        sb.append(") ");

        return queryInt(sb.toString(), params);
    }

    private int countOverduePmAssetsHeuristic(AssetReportFilter f, int days) {
        StringBuilder sb = new StringBuilder("""
            SELECT COUNT(*)
            FROM products p
            LEFT JOIN (
                SELECT product_id, MAX(maintenance_date) AS last_periodic_date
                FROM maintenances
                WHERE type = 'PERIODIC'
                GROUP BY product_id
            ) pmx ON pmx.product_id = p.id
            LEFT JOIN product_models pm ON pm.id = p.model_id
            LEFT JOIN brands b ON b.id = pm.brand_id
            LEFT JOIN users cu ON cu.id = p.customer_id
            WHERE 1=1
        """);
        List<Object> params = new ArrayList<>();
        applyFilter(sb, params, f);

        sb.append(" AND (pmx.last_periodic_date IS NULL OR pmx.last_periodic_date < DATE_SUB(CURDATE(), INTERVAL ? DAY)) ");
        params.add(days);

        return queryInt(sb.toString(), params);
    }

    public List<OptionItem> listCustomersForAssetReport() {
        String sql = """
        SELECT DISTINCT u.id, u.full_name
        FROM products p
        JOIN users u ON u.id = p.customer_id
        WHERE p.customer_id IS NOT NULL
        ORDER BY u.full_name
    """;

        List<OptionItem> out = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(new OptionItem(rs.getInt("id"), rs.getString("full_name")));
            }
        } catch (Exception e) {
            throw new RuntimeException("listCustomersForAssetReport failed. SQL=" + sql, e);
        }
        return out;
    }

    private void applyFilter(StringBuilder sb, List<Object> params, AssetReportFilter f) {
        if (f == null) return;

        String status = nz(f.getStatus());
        if (status != null && !"ALL".equalsIgnoreCase(status)) {
            sb.append(" AND p.status = ? ");
            params.add(status);
        }
        if (f.getCustomerId() != null && f.getCustomerId() > 0) {
            sb.append(" AND p.customer_id = ? ");
            params.add(f.getCustomerId());
        }
        if (f.getModelId() != null && f.getModelId() > 0) {
            sb.append(" AND p.model_id = ? ");
            params.add(f.getModelId());
        }
        // brand filter must be on pm.brand_id (not p.brand_id)
        if (f.getBrandId() != null && f.getBrandId() > 0) {
            sb.append(" AND pm.brand_id = ? ");
            params.add(f.getBrandId());
        }

        String kw = nz(f.getKeyword());
        if (kw != null) {
            sb.append("""
                AND (
                    p.serial_number LIKE ?
                    OR pm.name LIKE ?
                    OR b.name LIKE ?
                    OR cu.full_name LIKE ?
                    OR p.current_location LIKE ?
                )
            """);
            String like = "%" + kw + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }

        // warrantyScope intentionally ignored until warranty_end_date is confirmed in schema
    }

    private String nz(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    public int countWarrantyExpiring30(AssetReportFilter f) {
        StringBuilder sb = new StringBuilder("""
        SELECT COUNT(*)
        FROM products p
        LEFT JOIN contracts c ON c.id = p.contract_id
        LEFT JOIN product_models pm ON pm.id = p.model_id
        LEFT JOIN brands b ON b.id = pm.brand_id
        LEFT JOIN users cu ON cu.id = p.customer_id
        WHERE 1=1
    """);
        List<Object> params = new ArrayList<>();
        applyFilterBase(sb, params, f);

        // warranty end = contracts.end_date
        sb.append(" AND c.end_date IS NOT NULL ");
        sb.append(" AND c.end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) ");

        return queryInt(sb.toString(), params);
    }

    private void applyFilterBase(StringBuilder sb, List<Object> params, AssetReportFilter f) {
        if (f == null) return;

        String status = nz(f.getStatus());
        if (status != null && !"ALL".equalsIgnoreCase(status)) {
            sb.append(" AND p.status = ? ");
            params.add(status);
        }

        if (f.getCustomerId() != null && f.getCustomerId() > 0) {
            sb.append(" AND p.customer_id = ? ");
            params.add(f.getCustomerId());
        }

        if (f.getModelId() != null && f.getModelId() > 0) {
            sb.append(" AND p.model_id = ? ");
            params.add(f.getModelId());
        }

        if (f.getBrandId() != null && f.getBrandId() > 0) {
            sb.append(" AND pm.brand_id = ? ");
            params.add(f.getBrandId());
        }

        if (f.getManufactureYear() != null && f.getManufactureYear() > 0) {
            sb.append(" AND p.manufacture_year = ? ");
            params.add(f.getManufactureYear());
        }

        String kw = nz(f.getKeyword());
        if (kw != null) {
            sb.append("""
            AND (
                p.serial_number LIKE ?
                OR pm.name LIKE ?
                OR b.name LIKE ?
                OR cu.full_name LIKE ?
                OR p.current_location LIKE ?
            )
        """);
            String like = "%" + kw + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
    }

    public List<OptionItem> listModelsForAssetReport() {
        String sql = """
        SELECT DISTINCT pm.id, pm.name
        FROM products p
        JOIN product_models pm ON pm.id = p.model_id
        WHERE p.model_id IS NOT NULL
        ORDER BY pm.name
    """;

        List<OptionItem> out = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(new OptionItem(rs.getInt("id"), rs.getString("name")));
            }
        } catch (Exception e) {
            throw new RuntimeException("listModelsForAssetReport failed. SQL=" + sql, e);
        }
        return out;
    }

    private int queryInt(String sql, List<Object> params) {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            throw new RuntimeException("AssetReportDAO queryInt failed. SQL=" + sql, e);
        }
    }

    private void bind(PreparedStatement ps, List<Object> params) throws Exception {
        if (params == null) return;
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }
}