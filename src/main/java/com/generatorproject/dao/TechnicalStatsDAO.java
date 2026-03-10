package com.generatorproject.dao;

import com.generatorproject.model.Maintenance;
import com.generatorproject.model.SparePartUsage;
import com.generatorproject.model.TechnicalStats;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TechnicalStatsDAO extends DbContext {

    public TechnicalStats getOverview(int technicianId) {
        TechnicalStats stats = new TechnicalStats();

        String sqlTask = """
            SELECT
                COUNT(*) AS total_tasks,
                SUM(CASE WHEN m.status = 'SCHEDULED' THEN 1 ELSE 0 END) AS scheduled_tasks,
                SUM(CASE WHEN m.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_tasks,
                SUM(CASE WHEN m.status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_tasks,

                SUM(CASE WHEN m.type = 'REPAIR' THEN 1 ELSE 0 END) AS repair_tasks,
                SUM(CASE WHEN m.type = 'PERIODIC' THEN 1 ELSE 0 END) AS periodic_tasks,
                SUM(CASE WHEN m.type = 'INSPECTION' THEN 1 ELSE 0 END) AS inspection_tasks,

                SUM(CASE
                    WHEN YEAR(m.maintenance_date) = YEAR(CURDATE())
                     AND MONTH(m.maintenance_date) = MONTH(CURDATE())
                    THEN 1 ELSE 0 END) AS tasks_this_month,

                SUM(CASE
                    WHEN m.status = 'COMPLETED'
                     AND YEAR(m.maintenance_date) = YEAR(CURDATE())
                     AND MONTH(m.maintenance_date) = MONTH(CURDATE())
                    THEN 1 ELSE 0 END) AS completed_this_month,

                COUNT(DISTINCT m.product_id) AS distinct_products,

                COALESCE(SUM(m.total_cost), 0) AS total_all_task_cost,
                COALESCE(SUM(CASE WHEN m.status = 'COMPLETED' THEN m.total_cost ELSE 0 END), 0) AS total_completed_cost
            FROM maintenances m
            WHERE m.technician_id = ?
        """;

        String sqlMaterial = """
            SELECT
                COALESCE(SUM(msp.quantity_used), 0) AS total_material_quantity,
                COUNT(*) AS total_material_lines,
                COUNT(DISTINCT msp.spare_part_id) AS distinct_spare_parts,
                COALESCE(SUM(msp.cost_at_time), 0) AS total_material_cost
            FROM maintenance_spare_parts msp
            JOIN maintenances m ON m.id = msp.maintenance_id
            WHERE m.technician_id = ?
        """;

        try (Connection conn = getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement(sqlTask)) {
                ps.setInt(1, technicianId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    stats.setTotalTasks(rs.getInt("total_tasks"));
                    stats.setScheduledTasks(rs.getInt("scheduled_tasks"));
                    stats.setCompletedTasks(rs.getInt("completed_tasks"));
                    stats.setCancelledTasks(rs.getInt("cancelled_tasks"));

                    stats.setRepairTasks(rs.getInt("repair_tasks"));
                    stats.setPeriodicTasks(rs.getInt("periodic_tasks"));
                    stats.setInspectionTasks(rs.getInt("inspection_tasks"));

                    stats.setTasksThisMonth(rs.getInt("tasks_this_month"));
                    stats.setCompletedThisMonth(rs.getInt("completed_this_month"));
                    stats.setDistinctProducts(rs.getInt("distinct_products"));

                    stats.setTotalAllTaskCost(rs.getDouble("total_all_task_cost"));
                    stats.setTotalCompletedCost(rs.getDouble("total_completed_cost"));
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlMaterial)) {
                ps.setInt(1, technicianId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    stats.setTotalMaterialQuantity(rs.getInt("total_material_quantity"));
                    stats.setTotalMaterialLines(rs.getInt("total_material_lines"));
                    stats.setDistinctSpareParts(rs.getInt("distinct_spare_parts"));
                    stats.setTotalMaterialCost(rs.getDouble("total_material_cost"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return stats;
    }

    public List<SparePartUsage> getTopUsedSpareParts(int technicianId, int limit) {
        List<SparePartUsage> list = new ArrayList<>();

        String sql = """
            SELECT
                sp.id,
                sp.name,
                sp.part_code,
                SUM(msp.quantity_used) AS total_qty,
                SUM(msp.cost_at_time) AS total_cost
            FROM maintenance_spare_parts msp
            JOIN maintenances m ON m.id = msp.maintenance_id
            JOIN spare_parts sp ON sp.id = msp.spare_part_id
            WHERE m.technician_id = ?
            GROUP BY sp.id, sp.name, sp.part_code
            ORDER BY total_qty DESC, total_cost DESC
            LIMIT ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, technicianId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SparePartUsage item = new SparePartUsage();
                item.setSparePartId(rs.getInt("id"));
                item.setSparePartName(rs.getString("name"));
                item.setPartCode(rs.getString("part_code"));
                item.setTotalQuantityUsed(rs.getInt("total_qty"));
                item.setTotalCost(rs.getDouble("total_cost"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Maintenance> getRecentCompletedTasks(int technicianId, int limit) {
        List<Maintenance> list = new ArrayList<>();

        String sql = """
            SELECT
                m.id,
                m.maintenance_date,
                m.type,
                m.total_cost,
                p.serial_number AS product_serial_number,
                pm.name AS product_name
            FROM maintenances m
            JOIN products p ON m.product_id = p.id
            LEFT JOIN product_models pm ON p.model_id = pm.id
            WHERE m.technician_id = ?
              AND m.status = 'COMPLETED'
            ORDER BY m.maintenance_date DESC, m.id DESC
            LIMIT ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, technicianId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Maintenance m = new Maintenance();
                m.setId(rs.getInt("id"));
                m.setMaintenanceDate(rs.getDate("maintenance_date"));
                m.setType(rs.getString("type"));
                m.setTotalCost(rs.getDouble("total_cost"));
                m.setProductSerialNumber(rs.getString("product_serial_number"));
                m.setProductName(rs.getString("product_name"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}