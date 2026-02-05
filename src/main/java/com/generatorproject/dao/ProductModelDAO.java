package com.generatorproject.dao;

import com.generatorproject.mapper.ProductModelMapper;
import com.generatorproject.model.ProductModel;

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
}