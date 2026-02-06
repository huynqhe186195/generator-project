package com.generatorproject.mapper;

import com.generatorproject.model.ProductImageItem;
import java.sql.ResultSet;

public class ProductImageItemMapper implements RowMapper<ProductImageItem> {
    @Override
    public ProductImageItem mapRow(ResultSet rs) {
        try {
            ProductImageItem x = new ProductImageItem();
            x.setId(rs.getInt("id"));
            x.setModelId(rs.getInt("model_id"));
            x.setImageUrl(rs.getString("image_url"));
            return x;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
