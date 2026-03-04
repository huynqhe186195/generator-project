package com.generatorproject.dao;

import com.generatorproject.mapper.QuoteMapper;
import com.generatorproject.model.Quote;
import com.generatorproject.model.RepairRequestDTO;
import java.util.List;

public class QuoteDAO extends GenericDAO<Object> {

    /**
     * LƯU BẢNG CHA: quotes
     * Đã cập nhật đúng các cột: customer_id, maintenance_id, total_amount, status, created_at, approved_at
     */
    public Long insertQuote(int maintenanceId, Long customerId, double totalAmount,int createdBy) {
        System.out.println("====> [DAO] Bắt đầu gọi GenericDAO để chèn vào bảng quotes...");

        // Truyền rõ ràng NULL vào các cột chưa dùng tới để tránh lỗi "doesn't have a default value"
        String sql = "INSERT INTO quotes (maintenance_id, customer_id, total_amount, status, created_at, approved_at, incident_id, created_by, approved_by) " +
                "VALUES (?, ?, ?, 'APPROVED', NOW(), NOW(), NULL, ?, NULL)";

        Long newId = insert(sql, maintenanceId, customerId, totalAmount,customerId);

        System.out.println("====> [DAO] GenericDAO chạy xong. ID báo giá vừa tạo là: " + newId);

        return newId;
    }

    /**
     * LƯU BẢNG CON: quote_details
     * Đã cập nhật cột 'description' để lưu tên vật tư
     */
    public void insertQuoteDetails(Long quoteId, List<RepairRequestDTO.MaterialDTO> materials) {
        if (materials == null || materials.isEmpty()) return;

        // Lưu ý: Cột lưu tên phụ tùng trong DB của bạn tên là 'description'
        String sql = "INSERT INTO quote_details (quote_id, description, quantity, unit_price, total_price) " +
                "VALUES (?, ?, ?, ?, ?)";

        for (RepairRequestDTO.MaterialDTO mat : materials) {
            double unitPrice = mat.getCostAtTime() != null ? mat.getCostAtTime().doubleValue() : 0.0;
            int quantity = mat.getQuantityUsed() != null ? mat.getQuantityUsed() : 0;
            double totalPrice = unitPrice * quantity;

            // Truyền tên phụ tùng vào cột description
            String description = (mat.getPartName() != null && !mat.getPartName().isEmpty())
                    ? mat.getPartName()
                    : "Vật tư không tên";

            insert(sql,
                    quoteId,
                    description,
                    quantity,
                    unitPrice,
                    totalPrice);
        }
    }

    public List<Quote> findQuotesByProductId(int productId) {
        // JOIN bảng quotes với bảng maintenances để tìm theo product_id
        String sql = "SELECT q.* FROM quotes q " +
                "JOIN maintenances m ON q.maintenance_id = m.id " +
                "WHERE m.product_id = ? " +
                "ORDER BY q.created_at DESC";

        // Cần có QuoteMapper để map dữ liệu (Giống như SystemRequestMapper của bạn)
        return query(sql, new QuoteMapper(), productId);
    }
}