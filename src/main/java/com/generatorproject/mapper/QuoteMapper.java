package com.generatorproject.mapper;

import com.generatorproject.model.Quote;
import java.sql.ResultSet;
import java.sql.SQLException;

public class QuoteMapper implements RowMapper<Quote> { // Lưu ý: Đảm bảo interface RowMapper khớp với project của bạn

    @Override
    public Quote mapRow(ResultSet rs) {
        try {
            Quote quote = new Quote();

            // Map Khóa chính
            quote.setId(rs.getLong("id"));

            // Map các cột bắt buộc có dữ liệu
            quote.setTotalAmount(rs.getDouble("total_amount"));
            quote.setStatus(rs.getString("status"));
            quote.setCreatedAt(rs.getTimestamp("created_at"));
            quote.setApprovedAt(rs.getTimestamp("approved_at"));

            // ==========================================
            // Map các cột Khóa ngoại (Có thể bị NULL trong DB)
            // ==========================================
            if (rs.getObject("customer_id") != null) {
                quote.setCustomerId(rs.getLong("customer_id"));
            }

            if (rs.getObject("created_by") != null) {
                quote.setCreatedBy(rs.getInt("created_by"));
            }

            // Nếu trong model Quote bạn có khai báo thêm biến approvedBy thì dùng đoạn này:
            // if (rs.getObject("approved_by") != null) {
            //     quote.setApprovedBy(rs.getInt("approved_by"));
            // }

            if (rs.getObject("maintenance_id") != null) {
                quote.setMaintenanceId(rs.getInt("maintenance_id"));
            }

            return quote;

        } catch (SQLException e) {
            System.out.println("===> [LỖI QUOTE_MAPPER] Không thể map dữ liệu từ ResultSet: " + e.getMessage());
            return null;
        }
    }
}