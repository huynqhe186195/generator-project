package com.generatorproject.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import com.generatorproject.model.QuoteDetail;

public class QuoteDetailMapper implements RowMapper<QuoteDetail> {

    @Override
    public QuoteDetail mapRow(ResultSet rs) {
        try {
            // Sử dụng Builder Pattern để khởi tạo đối tượng
            return new QuoteDetail.Builder()
                    .setId(rs.getInt("id"))
                    .setQuoteId(rs.getInt("quote_id"))
                    .setDescription(rs.getString("description"))
                    .setQuantity(rs.getInt("quantity"))
                    .setUnitPrice(rs.getDouble("unit_price"))
                    .setTotalPrice(rs.getDouble("total_price"))
                    .build();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}