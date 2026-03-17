package com.generatorproject.services;

import com.generatorproject.dao.QuoteDAO;
import com.generatorproject.model.Quote;
import com.generatorproject.model.RepairRequestDTO;

import java.util.List;

public class QuoteService implements IQuoteService {

    private final QuoteDAO quoteDAO;

    public QuoteService() {
        this.quoteDAO = new QuoteDAO();
    }

    @Override
    public Long createQuote(int maintenanceId, Long customerId, double totalAmount, int createdBy) {
        // Validate cơ bản
        if (maintenanceId <= 0 || customerId == null || customerId <= 0) {
            System.err.println("[QuoteService] Lỗi: maintenanceId hoặc customerId không hợp lệ!");
            return null;
        }
        if (totalAmount < 0) {
            totalAmount = 0;
        }

        return quoteDAO.insertQuote(maintenanceId, customerId, totalAmount, createdBy);
    }

    @Override
    public void createQuoteDetails(Long quoteId, List<RepairRequestDTO.MaterialDTO> materials) {
        if (quoteId == null || quoteId <= 0) {
            System.err.println("[QuoteService] Lỗi: quoteId không hợp lệ để thêm chi tiết!");
            return;
        }
        if (materials == null || materials.isEmpty()) {
            System.out.println("[QuoteService] Không có vật tư nào để thêm vào chi tiết báo giá.");
            return;
        }

        quoteDAO.insertQuoteDetails(quoteId, materials);
    }

    @Override
    public List<Quote> getQuotesByProductId(int productId) {
        if (productId <= 0) {
            return null;
        }
        return quoteDAO.findQuotesByProductId(productId);
    }

    @Override
    public Quote findById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        return quoteDAO.findById(id);
    }
}