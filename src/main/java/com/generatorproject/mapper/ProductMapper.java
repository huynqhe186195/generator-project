package com.generatorproject.mapper;

import com.generatorproject.model.Product;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductMapper implements RowMapper<Product> {

    @Override
    public Product mapRow(ResultSet rs) {
        try {
            Product.Builder builder = Product.builder();

            builder.id(rs.getLong("id"))
                    .serialNumber(rs.getString("serial_number"))
                    .manufactureYear(rs.getObject("manufacture_year") != null ? rs.getInt("manufacture_year") : null)
                    .currentLocation(rs.getString("current_location"))
                    .status(rs.getString("status"))
                    .totalRunningHours(rs.getDouble("total_running_hours"))
                    .customerId(rs.getLong("customer_id"))
                    .modelId(rs.getLong("model_id"))
                    .purchaseDate(rs.getDate("purchase_date"))
                    .createdAt(rs.getTimestamp("created_at"))
                    .updatedAt(rs.getTimestamp("updated_at"));

            try {
                builder.modelName(rs.getString("model_name"));
            } catch (SQLException e) {  }

            try {
                builder.customerName(rs.getString("customer_name"));
            } catch (SQLException e) { }

            return builder.build();

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}