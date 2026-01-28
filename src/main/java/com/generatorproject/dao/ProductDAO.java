package com.generatorproject.dao;

import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DbContext {

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double sumRunningHours() {
        String sql = "SELECT SUM(total_running_hours) FROM products";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ GET ALL: JOIN lấy brand.name + fuel_type
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();

        String sql =
                "SELECT " +
                        "  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, " +
                        "  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url " +
                        "FROM products p " +
                        "JOIN brands b ON p.brand_id = b.id";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // ✅ FILTER (không phân trang - giữ nguyên)
    // =========================
    public List<Product> filterProducts(int customerId,
                                        Integer brandId,
                                        Double minPower,
                                        Double maxPower,
                                        String fuelType,
                                        String keyword) {

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
                .append("  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, ")
                .append("  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url ")
                .append("FROM products p ")
                .append("JOIN brands b ON p.brand_id = b.id ")
                .append("WHERE p.customer_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        if (brandId != null) {
            sql.append(" AND p.brand_id = ? ");
            params.add(brandId);
        }

        if (fuelType != null && !fuelType.trim().isEmpty()) {
            sql.append(" AND p.fuel_type = ? ");
            params.add(fuelType.trim());
        }

        if (minPower != null) {
            sql.append(" AND p.power_prime >= ? ");
            params.add(minPower);
        }

        if (maxPower != null) {
            sql.append(" AND p.power_prime <= ? ");
            params.add(maxPower);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(p.name) LIKE ? ");
            params.add("%" + keyword.trim().toLowerCase() + "%");
        }

        sql.append(" ORDER BY p.id DESC ");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // ✅ PHÂN TRANG - COUNT
    // =========================
    public int countFilteredProducts(int customerId,
                                     Integer brandId,
                                     Double minPower,
                                     Double maxPower,
                                     String fuelType,
                                     String keyword) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ")
                .append("FROM products p ")
                .append("WHERE p.customer_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        if (brandId != null) {
            sql.append(" AND p.brand_id = ? ");
            params.add(brandId);
        }

        if (fuelType != null && !fuelType.trim().isEmpty()) {
            sql.append(" AND p.fuel_type = ? ");
            params.add(fuelType.trim());
        }

        if (minPower != null) {
            sql.append(" AND p.power_prime >= ? ");
            params.add(minPower);
        }

        if (maxPower != null) {
            sql.append(" AND p.power_prime <= ? ");
            params.add(maxPower);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(p.name) LIKE ? ");
            params.add("%" + keyword.trim().toLowerCase() + "%");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // ✅ PHÂN TRANG - LIST
    // =========================
    public List<Product> filterProductsPaged(int customerId,
                                             Integer brandId,
                                             Double minPower,
                                             Double maxPower,
                                             String fuelType,
                                             String keyword,
                                             int limit,
                                             int offset) {

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
                .append("  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, ")
                .append("  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url ")
                .append("FROM products p ")
                .append("JOIN brands b ON p.brand_id = b.id ")
                .append("WHERE p.customer_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        if (brandId != null) {
            sql.append(" AND p.brand_id = ? ");
            params.add(brandId);
        }

        if (fuelType != null && !fuelType.trim().isEmpty()) {
            sql.append(" AND p.fuel_type = ? ");
            params.add(fuelType.trim());
        }

        if (minPower != null) {
            sql.append(" AND p.power_prime >= ? ");
            params.add(minPower);
        }

        if (maxPower != null) {
            sql.append(" AND p.power_prime <= ? ");
            params.add(maxPower);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(p.name) LIKE ? ");
            params.add("%" + keyword.trim().toLowerCase() + "%");
        }

        sql.append(" ORDER BY p.id DESC ");
        sql.append(" LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Product> getByCustomerId(int customerId) {
        List<Product> list = new ArrayList<>();

        String sql =
                "SELECT " +
                        "  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, " +
                        "  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url " +
                        "FROM products p " +
                        "JOIN brands b ON p.brand_id = b.id " +
                        "WHERE p.customer_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // ✅ Helpers
    // =========================
    private void bindParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    private Product mapRow(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setSerialNumber(rs.getString("serial_number"));
        p.setName(rs.getString("name"));
        p.setModel(rs.getString("model"));
        p.setStatus(rs.getString("status"));
        p.setImageUrl(rs.getString("image_url"));
        p.setPowerPrime(rs.getDouble("power_prime"));
        p.setFuelType(rs.getString("fuel_type"));

        Brand brand = new Brand();
        brand.setId(rs.getInt("brand_id"));
        brand.setName(rs.getString("brand_name"));
        brand.setSlug(rs.getString("slug"));
        brand.setLogoUrl(rs.getString("logo_url"));

        p.setBrand(brand);
        return p;
    }
}
