package com.generatorproject.services;

import com.generatorproject.model.ContractAiExtractedItem;
import com.generatorproject.model.ProductModel;
import com.google.gson.Gson;

import java.util.*;

public class AiExtractionService {
    private final ProductModelMatcherService matcherService = new ProductModelMatcherService();
    private final GeminiGatewayService geminiGatewayService = new GeminiGatewayService();
    private final Gson gson = new Gson();

    public static class ExtractResult {
        private String chatMessage;
        private List<ContractAiExtractedItem> items;
        private List<String> warnings;

        public String getChatMessage() { return chatMessage; }
        public void setChatMessage(String chatMessage) { this.chatMessage = chatMessage; }
        public List<ContractAiExtractedItem> getItems() { return items; }
        public void setItems(List<ContractAiExtractedItem> items) { this.items = items; }
        public List<String> getWarnings() { return warnings; }
        public void setWarnings(List<String> warnings) { this.warnings = warnings; }
    }

    public List<ContractAiExtractedItem> extractDevices(String text, String sourceFilePath, Long contractId) {
        return extractDevicesResult(text, sourceFilePath, contractId, "Trích xuất danh sách thiết bị trong hợp đồng").getItems();
    }

    public ExtractResult extractDevicesResult(String text, String sourceFilePath, Long contractId, String userPrompt) {
        if (text == null) text = "";
        try {
            String json = geminiGatewayService.extractDeviceList(userPrompt, text);
            ExtractResult result = parseGeminiJson(json, sourceFilePath, contractId);
            if (result.getItems() != null && !result.getItems().isEmpty()) {
                return result;
            }
        } catch (Exception ignored) {
        }
        return fallbackExtract(text, sourceFilePath, contractId);
    }

    private ExtractResult parseGeminiJson(String json, String sourceFilePath, Long contractId) {
        Map<?, ?> payload = gson.fromJson(json, Map.class);
        ExtractResult result = new ExtractResult();

        result.setChatMessage(payload.get("chatMessage") == null
                ? "Ok, tôi đã trích xuất xong cho bạn danh sách thiết bị có trong hợp đồng."
                : String.valueOf(payload.get("chatMessage")));

        List<String> warnings = new ArrayList<>();
        Object warningsObj = payload.get("warnings");
        if (warningsObj instanceof List) {
            for (Object w : (List<?>) warningsObj) {
                warnings.add(String.valueOf(w));
            }
        }

        List<ContractAiExtractedItem> items = new ArrayList<>();
        Object itemsObj = payload.get("items");
        if (itemsObj instanceof List) {
            for (Object x : (List<?>) itemsObj) {
                if (!(x instanceof Map)) continue;
                Map<?, ?> row = (Map<?, ?>) x;
                ContractAiExtractedItem item = new ContractAiExtractedItem();
                item.setContractId(contractId);
                item.setSourceFilePath(sourceFilePath);
                item.setRawModelName(asString(row.get("rawModelName")));
                item.setRawBrand(asString(row.get("rawBrand")));
                item.setRawPower(asString(row.get("rawPower")));
                item.setQuantity(asInt(row.get("quantity"), 1));
                item.setRawSerialNumber(asString(row.get("rawSerialNumber")));
                item.setManufactureYear(asIntObj(row.get("manufactureYear")));
                item.setCurrentLocation(asString(row.get("currentLocation")));
                item.setConfidenceScore(asDoubleObj(row.get("confidenceScore")));
                item.setReviewStatus("EXTRACTED");

                ProductModel matched = matcherService.matchByName(item.getRawModelName());
                if (matched != null) {
                    item.setMatchedModelId((long) matched.getId());
                    if (item.getConfidenceScore() == null) item.setConfidenceScore(0.7);
                }
                items.add(item);
            }
        }

        result.setItems(items);
        result.setWarnings(warnings.isEmpty() ? Collections.singletonList("Không có cảnh báo") : warnings);
        return result;
    }

    private ExtractResult fallbackExtract(String text, String sourceFilePath, Long contractId) {
        List<ContractAiExtractedItem> items = new ArrayList<>();
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

        ExtractResult result = new ExtractResult();
        result.setChatMessage("Ok, tôi đã trích xuất xong cho bạn danh sách thiết bị có trong hợp đồng.");
        result.setItems(items);
        result.setWarnings(Collections.singletonList("Không đọc rõ serial number ở một số dòng"));
        return result;
    }

    private String asString(Object o) {
        if (o == null) return null;
        String s = String.valueOf(o).trim();
        return s.isEmpty() || "null".equalsIgnoreCase(s) ? null : s;
    }

    private int asInt(Object o, int defaultVal) {
        Integer x = asIntObj(o);
        return x == null ? defaultVal : x;
    }

    private Integer asIntObj(Object o) {
        if (o == null) return null;
        if (o instanceof Number) return ((Number) o).intValue();
        try {
            return Integer.parseInt(String.valueOf(o));
        } catch (Exception e) {
            return null;
        }
    }

    private Double asDoubleObj(Object o) {
        if (o == null) return null;
        if (o instanceof Number) return ((Number) o).doubleValue();
        try {
            return Double.parseDouble(String.valueOf(o));
        } catch (Exception e) {
            return null;
        }
    }
}
