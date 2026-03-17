package com.generatorproject.services;

import com.generatorproject.model.Quote;
import com.generatorproject.model.RepairRequestDTO;

import java.util.List;

public interface IQuoteService {

    /**
     * Tạo mới một báo giá gốc
     * @return ID của báo giá vừa tạo
     */
    Long createQuote(int maintenanceId, Long customerId, double totalAmount, int createdBy);

    /**
     * Thêm danh sách vật tư vào chi tiết báo giá
     */
    void createQuoteDetails(Long quoteId, List<RepairRequestDTO.MaterialDTO> materials);

    /**
     * Lấy danh sách lịch sử báo giá theo ID của máy (Product)
     */
    List<Quote> getQuotesByProductId(int productId);

    /**
     * Lấy thông tin chi tiết của 1 Báo giá theo ID
     */
    Quote findById(Long id);
}