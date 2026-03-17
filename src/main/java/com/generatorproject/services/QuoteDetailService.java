package com.generatorproject.services;

import com.generatorproject.dao.QuoteDetailDAO;
import com.generatorproject.model.QuoteDetail;

import java.util.List;

public class QuoteDetailService implements IQuoteDetailService {

    // Khai báo DAO
    private final QuoteDetailDAO quoteDetailDAO;

    // Constructor khởi tạo DAO
    public QuoteDetailService() {
        this.quoteDetailDAO = new QuoteDetailDAO();
    }

    @Override
    public List<QuoteDetail> findByQuoteId(Long quoteId) {
        // Bạn có thể thêm các logic kiểm tra (validate) ở đây trước khi gọi DAO nếu cần
        if (quoteId == null || quoteId <= 0) {
            return null;
        }
        return quoteDetailDAO.findByQuoteId(quoteId);
    }

    @Override
    public Long insertDetail(QuoteDetail detail) {
        if (detail == null || detail.getQuoteId() <= 0) {
            return null;
        }
        return quoteDetailDAO.insertDetail(detail);
    }

    @Override
    public boolean deleteByQuoteId(Long quoteId) {
        if (quoteId == null || quoteId <= 0) {
            return false;
        }
        return quoteDetailDAO.deleteByQuoteId(quoteId);
    }
}