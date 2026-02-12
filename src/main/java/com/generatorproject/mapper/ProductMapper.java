package com.generatorproject.mapper;

import com.generatorproject.model.Product;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductMapper implements RowMapper<Product> {

    @Override
    public Product mapRow(ResultSet rs) {
        try {
            Product.Builder builder = Product.builder();

            builder.id(rs.getInt("id"))
                    .serialNumber(rs.getString("serial_number"))
                    .manufactureYear(rs.getObject("manufacture_year") == null ? null : rs.getInt("manufacture_year"))
                    .currentLocation(rs.getString("current_location"))
                    .status(rs.getString("status"))
                    .totalRunningHours(rs.getObject("total_running_hours") == null ? null : rs.getDouble("total_running_hours"))
                    .customerId(rs.getObject("customer_id") == null ? null : rs.getLong("customer_id"))
                    .modelId(rs.getObject("model_id") == null ? null : rs.getLong("model_id"))
                    .purchaseDate(rs.getDate("purchase_date"))
                    .createdAt(rs.getTimestamp("created_at"))
                    .updatedAt(rs.getTimestamp("updated_at"))
                    .contractId(rs.getLong("contract_id"));
            try { builder.modelName(rs.getString("model_name")); } catch (SQLException ignored) {}
            try { builder.brandName(rs.getString("brand_name")); } catch (SQLException ignored) {}
            try { builder.customerName(rs.getString("customer_name")); } catch (SQLException ignored) {}
            try { builder.brandName(rs.getString("brand_name")); } catch (Exception ignored) {}
            try { builder.categoryName(rs.getString("category_name")); } catch (Exception ignored) {}
            try { builder.customerEmail(rs.getString("customer_email")); } catch (Exception ignored) {}


            return builder.build();
        } catch (Exception e) {
            return null;
        }
    }
}