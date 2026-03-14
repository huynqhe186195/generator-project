package com.generatorproject.services;

import com.generatorproject.dao.ContractAiExtractedItemDAO;
import com.generatorproject.dao.DbContext;
import com.generatorproject.model.ContractAiExtractedItem;

import java.io.File;
import java.sql.Connection;
import java.util.List;

public class ContractAiService {
    private final ContractAiExtractedItemDAO itemDAO = new ContractAiExtractedItemDAO();
    private final OcrService ocrService = new OcrService();
    private final AiExtractionService extractionService = new AiExtractionService();
    private final DbContext dbContext = new DbContext();

    public List<ContractAiExtractedItem> extractAndSave(Long contractId, String sourceFilePath) throws Exception {
        File file = sourceFilePath == null ? null : new File(sourceFilePath);
        String content = ocrService.readText(file);
        List<ContractAiExtractedItem> items = extractionService.extractDevices(content, sourceFilePath, contractId);

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);
            itemDAO.deleteByContractId(conn, contractId);
            for (ContractAiExtractedItem item : items) {
                itemDAO.insert(conn, item);
            }
            conn.commit();
        }
        return items;
    }

    public List<ContractAiExtractedItem> findByContractId(Long contractId) {
        return itemDAO.findByContractId(contractId);
    }

    public void applyReview(Long itemId, Long matchedModelId, Integer quantity, String serial, Integer year, String location) {
        itemDAO.updateReviewData(itemId, matchedModelId, quantity, serial, year, location);
    }
}
