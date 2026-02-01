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

<<<<<<< HEAD
    // ✅ GET ALL: JOIN lấy brand.name + fuel_type
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();

        String sql =
                "SELECT " +
                        "  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, " +
                        "  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url " +
                        "FROM products p " +
                        "JOIN brands b ON p.brand_id = b.id";
=======
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
>>>>>>> Hung1

        String sql =
                "SELECT " +
                        "  p.id, p.serial_number, p.name, p.model, p.origin, p.power_prime, p.status, p.image_url, p.fuel_type, " +
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
<<<<<<< HEAD
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
=======
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
>>>>>>> Hung1

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
<<<<<<< HEAD
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
=======
    // ✅ ADMIN - LIST (filter + paging)
    // =========================
    public List<Product> filterProductsPagedAdmin(Integer brandId,
                                                  Double minPower,
                                                  Double maxPower,
                                                  String fuelType,
                                                  String keyword,
                                                  int limit,
                                                  int offset) {
>>>>>>> Hung1

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
<<<<<<< HEAD
                .append("  p.id, p.serial_number, p.name, p.model, p.power_prime, p.status, p.image_url, p.fuel_type, ")
                .append("  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url ")
                .append("FROM products p ")
                .append("JOIN brands b ON p.brand_id = b.id ")
                .append("WHERE p.customer_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);
=======
                .append("  p.id, p.serial_number, p.name, p.model, p.origin, p.power_prime, p.status, p.image_url, p.fuel_type, ")
                .append("  b.id AS brand_id, b.name AS brand_name, b.slug, b.logo_url, ")
                .append("  u.full_name AS customer_name ")
                .append("FROM products p ")
                .append("JOIN brands b ON p.brand_id = b.id ")
                .append("LEFT JOIN users u ON p.customer_id = u.id ")
                .append("WHERE 1=1 ");


        List<Object> params = new ArrayList<>();
>>>>>>> Hung1

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

<<<<<<< HEAD
        sql.append(" ORDER BY p.id DESC ");
        sql.append(" LIMIT ? OFFSET ? ");
=======
        sql.append(" ORDER BY p.id DESC LIMIT ? OFFSET ? ");
>>>>>>> Hung1
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

<<<<<<< HEAD
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
=======
    // =========================
    // CUSTOMER - COUNT (filter + paging)
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

>>>>>>> Hung1
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

<<<<<<< HEAD
=======
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

            if (p.getManufactureYear() != null) ps.setInt(i++, p.getManufactureYear());
            else ps.setNull(i++, java.sql.Types.INTEGER);

            ps.setInt(i++, p.getBrandId());
            ps.setInt(i++, p.getCategoryId());

            if (p.getPowerPrime() != null) ps.setObject(i++, p.getPowerPrime());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            if (p.getPowerStandby() != null) ps.setObject(i++, p.getPowerStandby());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getVoltage());

            if (p.getFuelTankCapacity() != null) ps.setObject(i++, p.getFuelTankCapacity());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getFuelType());
            ps.setString(i++, p.getCurrentLocation());
            ps.setString(i++, p.getStatus());

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

    // ✅ dùng cho detail + edit (lấy đủ field + created_at/updated_at)
    public Product findByIdAdmin(int id) {
        String sql =
                "SELECT " +
                        " p.id, p.serial_number, p.name, p.model, p.origin, p.manufacture_year, " +
                        " p.brand_id, p.category_id, " +
                        " p.power_prime, p.power_standby, p.voltage, p.fuel_tank_capacity, p.fuel_type, " +
                        " p.current_location, p.status, p.total_running_hours, p.image_url, " +
                        " p.customer_id, p.created_at, p.updated_at, " +
                        " b.id AS brand_id2, b.name AS brand_name, b.slug, b.logo_url, " +
                        " u.full_name AS customer_name " +
                        "FROM products p " +
                        "JOIN brands b ON p.brand_id = b.id " +
                        "LEFT JOIN users u ON p.customer_id = u.id " +
                        "WHERE p.id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();

                    p.setId(rs.getInt("id"));
                    p.setSerialNumber(rs.getString("serial_number"));
                    p.setName(rs.getString("name"));
                    p.setModel(rs.getString("model"));
                    p.setOrigin(rs.getString("origin"));

                    int year = rs.getInt("manufacture_year");
                    p.setManufactureYear(rs.wasNull() ? null : year);

                    p.setBrandId(rs.getInt("brand_id"));
                    p.setCategoryId(rs.getInt("category_id"));

                    p.setPowerPrime(rs.getDouble("power_prime"));
                    p.setPowerStandby(rs.getDouble("power_standby"));
                    p.setVoltage(rs.getString("voltage"));
                    p.setFuelTankCapacity(rs.getDouble("fuel_tank_capacity"));
                    p.setFuelType(rs.getString("fuel_type"));
                    p.setCurrentLocation(rs.getString("current_location"));
                    p.setStatus(rs.getString("status"));
                    p.setTotalRunningHours(rs.getDouble("total_running_hours"));
                    p.setImageUrl(rs.getString("image_url"));

                    int customerId = rs.getInt("customer_id");
                    p.setCustomerId(rs.wasNull() ? null : customerId);

                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));

                    Brand brand = new Brand();
                    brand.setId(rs.getInt("brand_id2"));
                    brand.setName(rs.getString("brand_name"));
                    brand.setSlug(rs.getString("slug"));
                    brand.setLogoUrl(rs.getString("logo_url"));
                    p.setBrand(brand);

                    p.setCustomerName(rs.getString("customer_name"));

                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ UPDATE (CHỈ CÒN 1 HÀM - hết trùng)
    public boolean update(Product p) {
        String sql =
                "UPDATE products SET " +
                        " serial_number = ?, name = ?, model = ?, origin = ?, manufacture_year = ?, " +
                        " brand_id = ?, category_id = ?, " +
                        " power_prime = ?, power_standby = ?, voltage = ?, " +
                        " fuel_tank_capacity = ?, fuel_type = ?, current_location = ?, status = ?, " +
                        " total_running_hours = ?, image_url = ?, customer_id = ?, " +
                        " updated_at = NOW() " +
                        "WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;

            ps.setString(i++, p.getSerialNumber());
            ps.setString(i++, p.getName());
            ps.setString(i++, p.getModel());
            ps.setString(i++, p.getOrigin());

            if (p.getManufactureYear() != null) ps.setInt(i++, p.getManufactureYear());
            else ps.setNull(i++, java.sql.Types.INTEGER);

            ps.setInt(i++, p.getBrandId());
            ps.setInt(i++, p.getCategoryId());

            if (p.getPowerPrime() != null) ps.setObject(i++, p.getPowerPrime());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            if (p.getPowerStandby() != null) ps.setObject(i++, p.getPowerStandby());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getVoltage());

            if (p.getFuelTankCapacity() != null) ps.setObject(i++, p.getFuelTankCapacity());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getFuelType());
            ps.setString(i++, p.getCurrentLocation());
            ps.setString(i++, p.getStatus());

            if (p.getTotalRunningHours() != null) ps.setObject(i++, p.getTotalRunningHours());
            else ps.setNull(i++, java.sql.Types.DECIMAL);

            ps.setString(i++, p.getImageUrl());

            if (p.getCustomerId() != null) ps.setInt(i++, p.getCustomerId());
            else ps.setNull(i++, java.sql.Types.INTEGER);

            ps.setInt(i++, p.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

>>>>>>> Hung1
    // =========================
    // ✅ Helpers
    // =========================
    private void bindParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

<<<<<<< HEAD
=======
    // mapRow phục vụ list (đang select những field nào thì map field đó)
>>>>>>> Hung1
    private Product mapRow(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setSerialNumber(rs.getString("serial_number"));
        p.setName(rs.getString("name"));
        p.setModel(rs.getString("model"));
<<<<<<< HEAD
=======

        // ✅ FIX: lấy origin từ DB
        try {
            p.setOrigin(rs.getString("origin"));
        } catch (Exception ignored) {
            // nếu query nào chưa select origin thì bỏ qua (nhưng mình đã sửa các query bên dưới)
        }

>>>>>>> Hung1
        p.setStatus(rs.getString("status"));
        p.setImageUrl(rs.getString("image_url"));
        p.setPowerPrime(rs.getDouble("power_prime"));
        p.setFuelType(rs.getString("fuel_type"));

        Brand brand = new Brand();
        brand.setId(rs.getInt("brand_id"));
        brand.setName(rs.getString("brand_name"));
        brand.setSlug(rs.getString("slug"));
        brand.setLogoUrl(rs.getString("logo_url"));
<<<<<<< HEAD

        p.setBrand(brand);
        return p;
    }
=======
        p.setBrand(brand);

        // ✅ customer name from users
        try {
            p.setCustomerName(rs.getString("customer_name"));
        } catch (Exception ignored) {}

        return p;
    }

    public boolean deleteById(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

>>>>>>> Hung1
}
