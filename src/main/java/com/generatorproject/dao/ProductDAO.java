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

    // ✅ Fuel distinct cho dropdown
    public List<String> getAllFuelTypes() {
        List<String> fuels = new ArrayList<>();
        String sql = "SELECT DISTINCT fuel_type FROM products " +
                "WHERE fuel_type IS NOT NULL AND fuel_type <> '' ORDER BY fuel_type";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) fuels.add(rs.getString(1));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fuels;
    }

    // ✅ GET ALL: JOIN brand + user(full_name)
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();

        String sql =
                "SELECT " +
                        "  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, " +
                        "  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url, " +
                        "  u.full_name AS customer_name " +
                        "FROM products p " +
                        "JOIN brands b ON p.brand_id = b.id " +
                        "LEFT JOIN users u ON p.customer_id = u.id " +
                        "ORDER BY p.id DESC";

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
    // ✅ ADMIN - COUNT (filter + paging)
    // =========================
    public int countFilteredProductsAdmin(Integer brandId,
                                          Double minPower,
                                          Double maxPower,
                                          String fuelType,
                                          String keyword) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM products p WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

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
    // ✅ ADMIN - LIST (filter + paging)
    // =========================
    public List<Product> filterProductsPagedAdmin(Integer brandId,
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
                .append("  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url, ")
                .append("  u.full_name AS customer_name ")
                .append("FROM products p ")
                .append("JOIN brands b ON p.brand_id = b.id ")
                .append("LEFT JOIN users u ON p.customer_id = u.id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

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

        sql.append(" ORDER BY p.id DESC LIMIT ? OFFSET ? ");
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

        // ✅ customer name from users
        p.setCustomerName(rs.getString("customer_name"));

        return p;
    }
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

        List<Object> params = new ArrayList<Object>();
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

    public List<Product> filterProductsPaged(int customerId,
                                             Integer brandId,
                                             Double minPower,
                                             Double maxPower,
                                             String fuelType,
                                             String keyword,
                                             int limit,
                                             int offset) {

        List<Product> list = new ArrayList<Product>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
                .append("  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, ")
                .append("  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url ")
                .append("FROM products p ")
                .append("JOIN brands b ON p.brand_id = b.id ")
                .append("WHERE p.customer_id = ? ");

        List<Object> params = new ArrayList<Object>();
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

        sql.append(" ORDER BY p.id DESC LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public int insert(Product p) {
        String sql =
                "INSERT INTO products " +
                        "(serial_number, name, model, origin, manufacture_year, brand_id, category_id, " +
                        " power_prime, power_standby, voltage, fuel_tank_capacity, fuel_type, current_location, status, " +
                        " total_running_hours, image_url, customer_id, created_at, updated_at) " +
                        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, NOW(), NOW())";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            int i = 1;

            ps.setString(i++, p.getSerialNumber());
            ps.setString(i++, p.getName());
            ps.setString(i++, p.getModel());
            ps.setString(i++, p.getOrigin());

            // manufacture_year (Integer)
            if (p.getManufactureYear() != null) ps.setInt(i++, p.getManufactureYear());
            else ps.setNull(i++, java.sql.Types.INTEGER);

            // brand_id, category_id (bắt buộc nên setInt)
            ps.setInt(i++, p.getBrandId());
            ps.setInt(i++, p.getCategoryId());

            // power_prime, power_standby (Double/BigDecimal đều ok nếu dùng setObject)
            if (p.getPowerPrime() != null) ps.setObject(i++, p.getPowerPrime());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            if (p.getPowerStandby() != null) ps.setObject(i++, p.getPowerStandby());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getVoltage());

            if (p.getFuelTankCapacity() != null) ps.setObject(i++, p.getFuelTankCapacity());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getFuelType()); // "DIESEL" / "GASOLINE"
            ps.setString(i++, p.getCurrentLocation());
            ps.setString(i++, p.getStatus());   // "READY" / "RUNNING" / ...

            if (p.getTotalRunningHours() != null) ps.setObject(i++, p.getTotalRunningHours());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getImageUrl());

            if (p.getCustomerId() != null) ps.setInt(i++, p.getCustomerId());
            else ps.setNull(i++, java.sql.Types.INTEGER);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

}


