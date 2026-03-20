package com.generatorproject.dao;

import com.generatorproject.mapper.ProductModelMapper;
import com.generatorproject.model.ProductModel;

import java.util.ArrayList;
import java.util.List;

public class ProductModelDAO extends GenericDAO<ProductModel> {

    public ProductModel findByName(String name) {
        String sql = "SELECT * FROM product_models WHERE LOWER(name) = LOWER(?) AND status = 'ACTIVE'";
        List<ProductModel> results = query(sql, new ProductModelMapper(), name.trim());
        return results.isEmpty() ? null : results.get(0);
    }

    public List<ProductModel> findAll() {
        String sql = "SELECT * FROM product_models";
        return query(sql, new ProductModelMapper());
    }

    public ProductModel findById(int id) {
        String sql = "SELECT * FROM product_models WHERE id = ?";
        List<ProductModel> results = query(sql, new ProductModelMapper(), id);
        return results.isEmpty() ? null : results.get(0);
    }

    public Long save(ProductModel model) {
        String sql = "INSERT INTO product_models (name, slug, brand_id, category_id, origin, fuel_type, power, description, specifications, manual_url, image_url, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return insert(sql,
                model.getName(),
                model.getSlug(),
                model.getBrandId(),
                model.getCategoryId(),
                model.getOrigin(),
                model.getFuelType(),
                model.getPower(),
                model.getDescription(),
                model.getSpecifications(),
                model.getManualUrl(),
                model.getImageUrl(),
                model.getStatus());
    }
    public int countFilteredProductModels(Integer brandId, Integer categoryId, String fuelType,
                                          Integer powerMin, Integer powerMax,
                                          String status, String keyword) {

        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT COUNT(1) ");
        sql.append("FROM product_models pm ");
        sql.append("LEFT JOIN brands b ON pm.brand_id = b.id ");
        sql.append("LEFT JOIN categories c ON pm.category_id = c.id ");
        sql.append("WHERE 1=1 ");

        if (brandId != null) {
            sql.append(" AND pm.brand_id = ? ");
            params.add(brandId);
        }

        if (categoryId != null) {
            sql.append(" AND pm.category_id = ? ");
            params.add(categoryId);
        }

        if (fuelType != null && !fuelType.trim().isEmpty()) {
            sql.append(" AND pm.fuel_type = ? ");
            params.add(fuelType.trim());
        }

        if (powerMin != null) {
            sql.append(" AND pm.power >= ? ");
            params.add(powerMin);
        }

        if (powerMax != null) {
            sql.append(" AND pm.power <= ? ");
            params.add(powerMax);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND pm.status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(pm.name) LIKE ? OR LOWER(pm.slug) LIKE ? OR LOWER(b.name) LIKE ? OR LOWER(c.name) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        return count(sql.toString(), params.toArray());
    }
    public List<ProductModel> filterProductModelsPaged(Integer brandId, Integer categoryId, String fuelType,
                                                       Integer powerMin, Integer powerMax,
                                                       String status, String keyword, int limit, int offset) {

        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT pm.* ");
        sql.append("FROM product_models pm ");
        sql.append("LEFT JOIN brands b ON pm.brand_id = b.id ");
        sql.append("LEFT JOIN categories c ON pm.category_id = c.id ");
        sql.append("WHERE 1=1 ");

        if (brandId != null) {
            sql.append(" AND pm.brand_id = ? ");
            params.add(brandId);
        }

        if (categoryId != null) {
            sql.append(" AND pm.category_id = ? ");
            params.add(categoryId);
        }

        if (fuelType != null && !fuelType.trim().isEmpty()) {
            sql.append(" AND pm.fuel_type = ? ");
            params.add(fuelType.trim());
        }

        if (powerMin != null) {
            sql.append(" AND pm.power >= ? ");
            params.add(powerMin);
        }

        if (powerMax != null) {
            sql.append(" AND pm.power <= ? ");
            params.add(powerMax);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND pm.status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(pm.name) LIKE ? OR LOWER(pm.slug) LIKE ? OR LOWER(b.name) LIKE ? OR LOWER(c.name) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY pm.id DESC LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        return query(sql.toString(), new ProductModelMapper(), params.toArray());
    }
    public Long insertProductModel(ProductModel model) {
        String sql = "INSERT INTO product_models " +
                "(name, slug, brand_id, category_id, origin, fuel_type, power, description, specifications, manual_url, image_url, status, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        return insert(sql,
                model.getName(),
                model.getSlug(),
                model.getBrandId(),
                model.getCategoryId(),
                model.getOrigin(),
                model.getFuelType(),
                model.getPower(),
                model.getDescription(),
                model.getSpecifications(),
                model.getManualUrl(),
                model.getImageUrl(),
                model.getStatus()
        );
    }

    public List<ProductModel> searchPublicDeviceModels(String keyword, int limit) {
        String normalizedKeyword = keyword == null ? "" : keyword.trim().toLowerCase();

        if (normalizedKeyword.isEmpty()) {
            String sql = """
                SELECT pm.*
                FROM product_models pm
                WHERE pm.status = 'ACTIVE'
                ORDER BY pm.id DESC
                LIMIT ?
            """;
            return query(sql, new ProductModelMapper(), limit);
        }

        String sql = """
            SELECT pm.*
            FROM product_models pm
            LEFT JOIN brands b ON pm.brand_id = b.id
            LEFT JOIN categories c ON pm.category_id = c.id
            WHERE pm.status = 'ACTIVE'
              AND (LOWER(COALESCE(pm.name, '')) LIKE ?
                   OR LOWER(COALESCE(pm.slug, '')) LIKE ?
                   OR LOWER(COALESCE(b.name, '')) LIKE ?
                   OR LOWER(COALESCE(c.name, '')) LIKE ?
                   OR LOWER(COALESCE(pm.origin, '')) LIKE ?
                   OR LOWER(COALESCE(pm.fuel_type, '')) LIKE ?
                   OR LOWER(COALESCE(pm.description, '')) LIKE ?
                   OR LOWER(COALESCE(pm.specifications, '')) LIKE ?
                   OR LOWER(COALESCE(pm.manual_url, '')) LIKE ?)
            ORDER BY
                CASE WHEN LOWER(COALESCE(pm.name, '')) = ? THEN 0 ELSE 1 END,
                CASE WHEN LOWER(COALESCE(pm.slug, '')) = ? THEN 0 ELSE 1 END,
                CASE WHEN LOWER(COALESCE(b.name, '')) = ? THEN 0 ELSE 1 END,
                pm.id DESC
            LIMIT ?
        """;

        String likeKeyword = "%" + normalizedKeyword + "%";
        return query(sql, new ProductModelMapper(), likeKeyword, likeKeyword, likeKeyword, likeKeyword,
                likeKeyword, likeKeyword, likeKeyword, likeKeyword, likeKeyword,
                normalizedKeyword, normalizedKeyword, normalizedKeyword, limit);
    }
    public void updateProductModel(ProductModel model) {
        String sql =
                "UPDATE product_models SET " +
                        "name = ?, " +
                        "slug = ?, " +
                        "brand_id = ?, " +
                        "category_id = ?, " +
                        "origin = ?, " +
                        "fuel_type = ?, " +
                        "power = ?, " +
                        "description = ?, " +
                        "specifications = ?, " +
                        "manual_url = ?, " +
                        "image_url = ?, " +
                        "status = ? " +
                        "WHERE id = ?";

        update(sql,
                model.getName(),
                model.getSlug(),
                model.getBrandId(),
                model.getCategoryId(),
                model.getOrigin(),
                model.getFuelType(),
                model.getPower(),
                model.getDescription(),
                model.getSpecifications(),
                model.getManualUrl(),
                model.getImageUrl(),
                model.getStatus(),
                model.getId()
        );
    }
    public void deleteById(int id) {
        String sql = "DELETE FROM product_models WHERE id = ?";
        update(sql, id);
    }
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM product_models";
        return count(sql); // dùng method count có sẵn trong GenericDAO
    }
}