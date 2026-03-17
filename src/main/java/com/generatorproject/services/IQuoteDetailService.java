package com.generatorproject.services;

import com.generatorproject.model.QuoteDetail;
import java.util.List;

public interface IQuoteDetailService {

    /**
     * Lấy danh sách chi tiết vật tư của một báo giá
     * @param quoteId Mã báo giá gốc
     * @return Danh sách QuoteDetail
     */
    List<QuoteDetail> findByQuoteId(Long quoteId);

    /**
     * Thêm mới một chi tiết báo giá
     * @param detail Đối tượng QuoteDetail
     * @return ID của bản ghi vừa thêm
     */
    Long insertDetail(QuoteDetail detail);

    /**
     * Xóa toàn bộ chi tiết của một báo giá (dùng khi cập nhật lại báo giá)
     * @param quoteId Mã báo giá gốc
     * @return true nếu xóa thành công
     */
    boolean deleteByQuoteId(Long quoteId);
}