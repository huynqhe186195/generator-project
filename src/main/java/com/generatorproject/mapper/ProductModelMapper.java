package com.generatorproject.mapper;

import com.generatorproject.model.ProductModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductModelMapper implements RowMapper<ProductModel> {
    @Override
    public ProductModel mapRow(ResultSet rs) {
        try {
            return new ProductModel.Builder()
                    .setId(rs.getInt("id"))
                    .setName(rs.getString("name"))
                    .setSlug(rs.getString("slug"))
                    .setBrandId(rs.getInt("brand_id"))
                    .setCategoryId(rs.getInt("category_id"))
                    .setOrigin(rs.getString("origin"))
                    .setFuelType(rs.getString("fuel_type"))
                    .setPower(rs.getDouble("power"))
                    .setDescription(rs.getString("description"))
                    .setSpecifications(rs.getString("specifications"))
                    .setManualUrl(rs.getString("manual_url"))
                    .setImageUrl(rs.getString("image_url"))
                    .setCreatedAt(rs.getTimestamp("created_at"))
                    .setStatus(rs.getString("status"))
                    .build();
        } catch (SQLException e) {
            return null;
        }
    }
}