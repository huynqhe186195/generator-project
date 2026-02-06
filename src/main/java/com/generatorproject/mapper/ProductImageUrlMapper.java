package com.generatorproject.mapper;

import java.sql.ResultSet;

public class ProductImageUrlMapper implements RowMapper<String> {

    @Override
    public String mapRow(ResultSet rs) {
        try {
            return rs.getString("image_url");
        } catch (Exception e) {
            // log nếu cần
            e.printStackTrace();
            return null;
        }
    }
}
