package com.generatorproject.dao;

import com.generatorproject.mapper.ProductMapper;
import com.generatorproject.mapper.RowMapper;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends GenericDAO<Product> {

    private final ProductMapper mapper = new ProductMapper();

    public int countFilteredProducts(long customerId,
                                     Integer brandId,
                                     String keyword) {

        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("""
    SELECT COUNT(1)
    FROM products p
    LEFT JOIN product_models pm ON p.model_id = pm.id
    LEFT JOIN brands b          ON pm.brand_id = b.id
    WHERE p.customer_id = ?
""");
        params.add(customerId);

        if (brandId != null) {
            sql.append(" AND pm.brand_id = ? ");
            params.add(brandId);
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (LOWER(p.serial_number) LIKE ? OR LOWER(pm.name) LIKE ? OR LOWER(b.name) LIKE ?) ");
            String kw = "%" + keyword.toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        return count(sql.toString(), params.toArray());
    }


    public List<Product> filterProductsPaged(long customerId,
                                             Integer brandId,
                                             String keyword,
                                             int limit,
                                             int offset) {

        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("""
        SELECT
            p.*,
            pm.name AS model_name,
            b.name  AS brand_name
        FROM products p
        LEFT JOIN product_models pm ON p.model_id = pm.id
        LEFT JOIN brands b          ON pm.brand_id = b.id
        WHERE p.customer_id = ?
    """);
        params.add(customerId);

        if (brandId != null) {
            sql.append(" AND pm.brand_id = ? ");
            params.add(brandId);
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (LOWER(p.serial_number) LIKE ? OR LOWER(pm.name) LIKE ? OR LOWER(b.name) LIKE ?) ");
            String kw = "%" + keyword.toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY p.id DESC LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        return query(sql.toString(), mapper, params.toArray());
    }



    /**
     * Lấy danh sách sản phẩm theo filter (keyword / modelId / customerId / status / year range ...)
     * Bạn muốn filter nào thì mở comment/ thêm điều kiện tương ứng.
     */
    public List<Product> findByFilter(String keyword, Long modelId, Long customerId, String status,
                                      Integer yearFrom, Integer yearTo) {

        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("""
        SELECT
            p.id, p.serial_number, p.status, p.manufacture_year, p.current_location, p.customer_id, p.model_id,
            pm.name AS model_name,
            b.name  AS brand_name
        FROM products p
        LEFT JOIN product_models pm ON p.model_id = pm.id
        LEFT JOIN brands b          ON pm.brand_id = b.id
        WHERE 1=1
    """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(p.serial_number) LIKE ? OR LOWER(p.current_location) LIKE ? OR LOWER(pm.name) LIKE ? OR LOWER(b.name) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }

        if (modelId != null) { sql.append(" AND p.model_id = ? "); params.add(modelId); }
        if (customerId != null) { sql.append(" AND p.customer_id = ? "); params.add(customerId); }
        if (status != null && !status.trim().isEmpty()) { sql.append(" AND p.status = ? "); params.add(status.trim()); }
        if (yearFrom != null) { sql.append(" AND p.manufacture_year >= ? "); params.add(yearFrom); }
        if (yearTo != null) { sql.append(" AND p.manufacture_year <= ? "); params.add(yearTo); }

        sql.append(" ORDER BY p.id DESC ");
        return query(sql.toString(), mapper, params.toArray());
    }


    /**
     * Lấy 1 product theo id (có join để lấy model_name/customer_name)
     */
    public Product findOne(long id) {
        String sql = """
        SELECT
            p.id, p.serial_number, p.status, p.manufacture_year, p.current_location, p.total_running_hours,
            p.customer_id, p.purchase_date, p.model_id,
            pm.name AS model_name,
            b.name  AS brand_name
        FROM products p
        LEFT JOIN product_models pm ON p.model_id = pm.id
        LEFT JOIN brands b          ON pm.brand_id = b.id
        WHERE p.id = ?
    """;

        List<Product> list = query(sql, mapper, id);
        return (list == null || list.isEmpty()) ? null : list.get(0);
    }


    /**
     * Update status hoặc location… (ví dụ)
     */
    public void updateStatus(long id, String status) {
        String sql = "UPDATE products SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        update(sql, status, id);
    }

    /**
     * Insert (ví dụ)
     */
    public Long insertProduct(Product p) {
        String sql = """
            INSERT INTO products(serial_number, manufacture_year, current_location, status, total_running_hours,
                                 customer_id, model_id, purchase_date, created_at, updated_at)
            VALUES(?,?,?,?,?,?,?,?,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
        """;

        return insert(sql,
                p.getSerialNumber(),
                p.getManufactureYear(),
                p.getCurrentLocation(),
                p.getStatus(),
                p.getTotalRunningHours(),
                p.getCustomerId(),
                p.getModelId(),
                p.getPurchaseDate()
        );
    }

    /**
     * COUNT để làm paging (nếu bạn cần phân trang)
     */
    public int countByFilter(String keyword, Long modelId, Long customerId, String status, Integer yearFrom, Integer yearTo) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("""
            SELECT COUNT(1)
            FROM products p
            LEFT JOIN models m ON p.model_id = m.id
            LEFT JOIN customers c ON p.customer_id = c.id
            WHERE 1 = 1
        """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(p.serial_number) LIKE ? OR LOWER(p.current_location) LIKE ? OR LOWER(m.name) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (modelId != null) { sql.append(" AND p.model_id = ? "); params.add(modelId); }
        if (customerId != null) { sql.append(" AND p.customer_id = ? "); params.add(customerId); }
        if (status != null && !status.trim().isEmpty()) { sql.append(" AND p.status = ? "); params.add(status.trim()); }
        if (yearFrom != null) { sql.append(" AND p.manufacture_year >= ? "); params.add(yearFrom); }
        if (yearTo != null) { sql.append(" AND p.manufacture_year <= ? "); params.add(yearTo); }

        return count(sql.toString(), params.toArray());
    }

    /**
     * Paging (LIMIT/OFFSET) - nếu DB là MySQL/Postgres
     */
    public List<Product> findByFilterPaging(
            String keyword,
            Long modelId,
            Long customerId,
            String status,
            Integer yearFrom,
            Integer yearTo,
            int page,
            int pageSize
    ) {
        int offset = Math.max(0, (page - 1) * pageSize);

        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("""
            SELECT 
                p.*,
                m.name AS model_name,
                c.full_name AS customer_name
            FROM products p
            LEFT JOIN models m ON p.model_id = m.id
            LEFT JOIN customers c ON p.customer_id = c.id
            WHERE 1 = 1
        """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(p.serial_number) LIKE ? OR LOWER(p.current_location) LIKE ? OR LOWER(m.name) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (modelId != null) { sql.append(" AND p.model_id = ? "); params.add(modelId); }
        if (customerId != null) { sql.append(" AND p.customer_id = ? "); params.add(customerId); }
        if (status != null && !status.trim().isEmpty()) { sql.append(" AND p.status = ? "); params.add(status.trim()); }
        if (yearFrom != null) { sql.append(" AND p.manufacture_year >= ? "); params.add(yearFrom); }
        if (yearTo != null) { sql.append(" AND p.manufacture_year <= ? "); params.add(yearTo); }

        sql.append(" ORDER BY p.id DESC ");
        sql.append(" LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add(offset);

        return query(sql.toString(), mapper, params.toArray());
    }

    public Product findBySerial(String serialNumber) {
        String sql = "SELECT * FROM products WHERE serial_number = ?";

        List<Product> results = query(sql, new ProductMapper(), serialNumber);

        return results.isEmpty() ? null : results.get(0);
    }

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";

        return count(sql, null);
    }

    public double sumRunningHours() {
        String sql = "SELECT COALESCE(SUM(total_running_hours), 0) AS total_hours FROM products";


        return count(sql, null);
    }

    public void update(Product product) {
        String sql = "UPDATE products SET customer_id = ?, status = ?, current_location = ?, updated_at = NOW() WHERE id = ?";

        update(sql,
                product.getCustomerId(),
                product.getStatus(),
                product.getCurrentLocation(),
                product.getId()
        );
    }

    public List<Product> findAll() {
        String sql = "SELECT * FROM products";
        return query(sql, new ProductMapper());
    }
}
