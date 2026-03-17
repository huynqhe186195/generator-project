package com.generatorproject.dao;

import com.generatorproject.mapper.QuoteDetailMapper;
import com.generatorproject.model.QuoteDetail;

import java.util.List;

public class QuoteDetailDAO extends GenericDAO<QuoteDetail> {

    /**
     * Lấy toàn bộ danh sách hạng mục/vật tư thuộc về 1 Báo giá gốc
     * (Sử dụng cho UserQuoteDetailController vừa tạo)
     */
    public List<QuoteDetail> findByQuoteId(Long quoteId) {
        String sql = "SELECT * FROM quote_details WHERE quote_id = ?";
        return query(sql, new QuoteDetailMapper(), quoteId);
    }

    /**
     * Lưu chi tiết báo giá mới vào Database
     */
    public Long insertDetail(QuoteDetail detail) {
        String sql = "INSERT INTO quote_details (quote_id, description, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";
        return insert(sql,
                detail.getQuoteId(),
                detail.getDescription(),
                detail.getQuantity(),
                detail.getUnitPrice(),
                detail.getTotalPrice()
        );
    }

    /**
     * Xóa toàn bộ chi tiết của một báo giá
     * (Dùng trong trường hợp Staff cập nhật lại báo giá: Xóa hết cái cũ đi -> Insert lại cái mới)
     */
    public boolean deleteByQuoteId(Long quoteId) {
        String sql = "DELETE FROM quote_details WHERE quote_id = ?";
        try {
            update(sql, quoteId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}