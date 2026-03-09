package com.generatorproject.mapper;

import com.generatorproject.model.Invoice;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InvoiceMapper implements RowMapper<Invoice> {

    @Override
    public Invoice mapRow(ResultSet rs) {
        try {
            // Sử dụng Builder để khởi tạo đối tượng Invoice gọn gàng
            Invoice.Builder builder = new Invoice.Builder();

            // 1. Map các trường CƠ BẢN (Luôn có trong bảng invoices)
            builder.setId(rs.getLong("id"))
                    .setInvoiceCode(rs.getString("invoice_code"))
                    .setCustomerId(rs.getLong("customer_id"))
                    .setSubtotal(rs.getDouble("subtotal"))
                    .setTaxRate(rs.getDouble("tax_rate"))
                    .setTaxAmount(rs.getDouble("tax_amount"))
                    .setTotalAmount(rs.getDouble("total_amount"))
                    .setPaymentStatus(rs.getString("payment_status"))
                    .setIssuedDate(rs.getTimestamp("issued_date"));

            // 2. Map các trường có thể NULL (Dùng rs.getObject để an toàn)
            if (rs.getObject("quote_id") != null) {
                builder.setQuoteId(rs.getLong("quote_id"));
            }
            if (rs.getObject("maintenance_id") != null) {
                builder.setMaintenanceId(rs.getInt("maintenance_id"));
            }
            if (rs.getObject("created_by") != null) {
                builder.setCreatedBy(rs.getInt("created_by"));
            }

            // Các trường String có thể null, lấy bình thường
            builder.setPaymentMethod(rs.getString("payment_method"));
            builder.setNote(rs.getString("note"));
            builder.setDueDate(rs.getTimestamp("due_date"));
            builder.setPaidAt(rs.getTimestamp("paid_at"));

            // 3. Map các trường PHỤ (Chỉ có khi câu SQL dùng JOIN)
            // Kiểm tra xem trong ResultSet có cột đó không để tránh lỗi "Column not found"
            if (hasColumn(rs, "customer_name")) {
                builder.setCustomerName(rs.getString("customer_name"));
            }
            if (hasColumn(rs, "customer_email")) {
                builder.setCustomerEmail(rs.getString("customer_email"));
            }
            if (hasColumn(rs, "created_by_name")) {
                builder.setCreatedByName(rs.getString("created_by_name"));
            }

            return builder.build();

        } catch (SQLException e) {
            System.out.println("===> [LỖI INVOICE_MAPPER] " + e.getMessage());
            return null;
        }
    }

    // Hàm tiện ích để kiểm tra cột có tồn tại trong ResultSet không
    // (Giúp Mapper dùng lại được cho nhiều câu SQL khác nhau)
    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }
}