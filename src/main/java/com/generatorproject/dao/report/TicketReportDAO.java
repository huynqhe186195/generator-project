package com.generatorproject.dao.report;

import com.generatorproject.dao.DbContext;
import com.generatorproject.model.reports.IdNameOption;
import com.generatorproject.model.reports.TicketReportFilter;
import com.generatorproject.model.reports.TicketReportRow;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class TicketReportDAO extends DbContext {

    // dropdown filters
    public List<IdNameOption> listCustomers() {
        // role_id=5: customer
        String sql = "SELECT id, COALESCE(full_name, email) AS name FROM users WHERE role_id = 5 ORDER BY name";
        return queryOptions(sql);
    }

    public List<IdNameOption> listTechnicians() {
        // role_id=4: technical
        String sql = "SELECT id, COALESCE(full_name, email) AS name FROM users WHERE role_id = 4 ORDER BY name";
        return queryOptions(sql);
    }

    public List<IdNameOption> listModels() {
        String sql = "SELECT id, name FROM product_models ORDER BY name";
        return queryOptions(sql);
    }

    // --- Replace 2 methods countTickets/countOpenTickets bằng bản dưới ---

    public int countTickets(TicketReportFilter f) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(DISTINCT i.id)
    """);
        sql.append(baseFromWhere());
        List<Object> params = new ArrayList<>();
        applyFilter(sql, params, f);
        return queryInt(sql.toString(), params);
    }

    public int countOpenTickets(TicketReportFilter f) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(DISTINCT i.id)
    """);
        sql.append(baseFromWhere());
        List<Object> params = new ArrayList<>();

        // open condition
        sql.append(" AND i.status NOT IN ('COMPLETED','REJECTED') ");
        applyFilter(sql, params, f);

        return queryInt(sql.toString(), params);
    }

    public Map<String, Integer> countByStatus(TicketReportFilter f) {
        StringBuilder sql = new StringBuilder("""
            SELECT i.status, COUNT(DISTINCT i.id) AS cnt
        """);
        sql.append(baseFromWhere());
        List<Object> params = new ArrayList<>();
        applyFilter(sql, params, f);
        sql.append(" GROUP BY i.status ORDER BY cnt DESC");
        return queryCountMap(sql.toString(), params, "status");
    }

    public Map<String, Integer> countByPriority(TicketReportFilter f) {
        StringBuilder sql = new StringBuilder("""
            SELECT i.priority, COUNT(DISTINCT i.id) AS cnt
        """);
        sql.append(baseFromWhere());
        List<Object> params = new ArrayList<>();
        applyFilter(sql, params, f);
        sql.append(" GROUP BY i.priority ORDER BY cnt DESC");
        return queryCountMap(sql.toString(), params, "priority");
    }

    public List<TicketReportRow> findTickets(TicketReportFilter f, int page, int pageSize) {
        int offset = Math.max(0, (page - 1) * pageSize);

        StringBuilder sql = new StringBuilder("""
            SELECT
                i.id, i.title, i.status, i.priority,
                i.product_id, i.contract_id, i.input_contract_number, i.input_serial_number,
                i.created_at,

                p.serial_number AS serial_number,
                pm.name AS model_name,

                cu.full_name AS customer_name,
                COALESCE(ti.full_name, ta.full_name) AS technician_name

        """);
        sql.append(baseFromWhere());
        List<Object> params = new ArrayList<>();
        applyFilter(sql, params, f);

        sql.append(" ORDER BY i.created_at DESC LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add(offset);

        List<TicketReportRow> rows = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {

            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketReportRow r = new TicketReportRow();
                    r.setId(rs.getInt("id"));
                    r.setTitle(rs.getString("title"));
                    r.setStatus(rs.getString("status"));
                    r.setPriority(rs.getString("priority"));

                    int productId = rs.getInt("product_id");
                    r.setProductId(rs.wasNull() ? null : productId);

                    int contractId = rs.getInt("contract_id");
                    r.setContractId(rs.wasNull() ? null : contractId);

                    r.setInputContractNumber(rs.getString("input_contract_number"));
                    r.setInputSerialNumber(rs.getString("input_serial_number"));

                    r.setSerialNumber(rs.getString("serial_number"));
                    r.setModelName(rs.getString("model_name"));
                    r.setCustomerName(rs.getString("customer_name"));
                    r.setTechnicianName(rs.getString("technician_name"));

                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    rows.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rows;
    }

    // ---------- SQL building ----------
    private String baseFromWhere() {
        // NOTE:
        // - customer: incidents.reported_by -> users cu
        // - product: incidents.product_id -> products p
        // - model: products.model_id -> product_models pm
        // - technician direct: incidents.technician_id -> users ti
        // - technician assigned via maintenances/assignments:
        //   get a technician from the latest assignment for incident (subquery)
        return """
            FROM incidents i
            LEFT JOIN products p ON p.id = i.product_id
            LEFT JOIN product_models pm ON pm.id = p.model_id
            LEFT JOIN users cu ON cu.id = i.reported_by
            LEFT JOIN users ti ON ti.id = i.technician_id

            LEFT JOIN (
                SELECT m.incident_id, ma.technician_id
                FROM maintenances m
                JOIN maintenance_assignments ma ON ma.maintenance_id = m.id
                WHERE m.incident_id IS NOT NULL
                ORDER BY ma.assigned_at DESC
            ) last_assign ON last_assign.incident_id = i.id
            LEFT JOIN users ta ON ta.id = last_assign.technician_id

            WHERE 1=1
        """;
    }

    private String wrapCount(String fromWhereWithSelectCountAtEnd) {
        // fromWhereWithSelectCountAtEnd is not ideal; keep simple instead:
        // We'll not use this wrapper; using queryInt directly is easier.
        return fromWhereWithSelectCountAtEnd;
    }

    private void applyFilter(StringBuilder sql, List<Object> params, TicketReportFilter f) {
        if (f == null) return;

        if (f.getFrom() != null && !f.getFrom().isBlank()) {
            sql.append(" AND DATE(i.created_at) >= ? ");
            params.add(f.getFrom().trim());
        }
        if (f.getTo() != null && !f.getTo().isBlank()) {
            sql.append(" AND DATE(i.created_at) <= ? ");
            params.add(f.getTo().trim());
        }
        if (f.getStatus() != null && !f.getStatus().isBlank() && !"ALL".equalsIgnoreCase(f.getStatus())) {
            sql.append(" AND i.status = ? ");
            params.add(f.getStatus().trim());
        }
        if (f.getPriority() != null && !f.getPriority().isBlank() && !"ALL".equalsIgnoreCase(f.getPriority())) {
            sql.append(" AND i.priority = ? ");
            params.add(f.getPriority().trim());
        }

        if (f.getCustomerId() != null && f.getCustomerId() > 0) {
            sql.append(" AND i.reported_by = ? ");
            params.add(f.getCustomerId());
        }

        if (f.getModelId() != null && f.getModelId() > 0) {
            sql.append(" AND p.model_id = ? ");
            params.add(f.getModelId());
        }

        if (f.getTechnicianId() != null && f.getTechnicianId() > 0) {
            // match either direct technician_id or assignment-derived technician
            sql.append(" AND (i.technician_id = ? OR last_assign.technician_id = ?) ");
            params.add(f.getTechnicianId());
            params.add(f.getTechnicianId());
        }

        if (f.getKeyword() != null && !f.getKeyword().isBlank()) {
            String kw = "%" + f.getKeyword().trim() + "%";
            sql.append("""
                AND (
                    i.title LIKE ?
                    OR i.input_serial_number LIKE ?
                    OR i.input_contract_number LIKE ?
                    OR p.serial_number LIKE ?
                    OR pm.name LIKE ?
                    OR cu.full_name LIKE ?
                    OR ti.full_name LIKE ?
                    OR ta.full_name LIKE ?
                )
            """);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
    }

    // ---------- query helpers ----------
    private int queryInt(String sql, List<Object> params) {
        // Replace SELECT clause for count variants when needed
        // Easiest: detect if query already has SELECT COUNT(*)... not; we build separately in controller/service
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

    private Map<String, Integer> queryCountMap(String sql, List<Object> params, String keyCol) {
        Map<String, Integer> out = new LinkedHashMap<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.put(rs.getString(keyCol), rs.getInt("cnt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out;
    }

    private List<IdNameOption> queryOptions(String sql) {
        List<IdNameOption> out = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(new IdNameOption(rs.getInt("id"), rs.getString("name")));
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