package com.generatorproject.services;

import com.generatorproject.model.ContractAiExtractedItem;
import com.generatorproject.model.ProductModel;

import java.util.ArrayList;
import java.util.List;

public class AiExtractionService {
    private final ProductModelMatcherService matcherService = new ProductModelMatcherService();

    public List<ContractAiExtractedItem> extractDevices(String text, String sourceFilePath, Long contractId) {
        List<ContractAiExtractedItem> items = new ArrayList<>();
        if (text == null) text = "";

        String[] lines = text.split("\\r?\\n");
        for (String line : lines) {
            String trimmed = line.trim();
            if (trimmed.isEmpty()) continue;
            ContractAiExtractedItem item = new ContractAiExtractedItem();
            item.setContractId(contractId);
            item.setSourceFilePath(sourceFilePath);
            item.setRawModelName(trimmed);
            item.setQuantity(1);
            item.setReviewStatus("EXTRACTED");
            ProductModel matched = matcherService.matchByName(trimmed);
            if (matched != null) {
                item.setMatchedModelId((long) matched.getId());
                item.setConfidenceScore(0.7);
            }
            items.add(item);
            if (items.size() >= 20) break;
        }

        if (items.isEmpty()) {
            ContractAiExtractedItem item = new ContractAiExtractedItem();
            item.setContractId(contractId);
            item.setSourceFilePath(sourceFilePath);
            item.setRawModelName("UNKNOWN_MODEL_FROM_UPLOAD");
            item.setQuantity(1);
            item.setReviewStatus("EXTRACTED");
            items.add(item);
        }

        return items;
    }
}
