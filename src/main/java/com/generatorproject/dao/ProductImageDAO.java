package com.generatorproject.dao;

import com.generatorproject.mapper.ProductImageItemMapper;
import com.generatorproject.model.ProductImageItem;

import java.util.List;

public class ProductImageDAO extends GenericDAO<ProductImageItem> {

    public Long insertImage(int modelId, String imageUrl) {
        String sql = "INSERT INTO product_images (model_id, image_url) VALUES (?, ?)";
        return insert(sql, modelId, imageUrl);
    }

    public List<ProductImageItem> findByModelId(int modelId) {
        String sql = "SELECT id, model_id, image_url FROM product_images WHERE model_id = ? ORDER BY id DESC";
        return query(sql, new ProductImageItemMapper(), modelId);
    }

    public void deleteByIdAndModelId(int imageId, int modelId) {
        String sql = "DELETE FROM product_images WHERE id = ? AND model_id = ?";
        update(sql, imageId, modelId);
    }
}
