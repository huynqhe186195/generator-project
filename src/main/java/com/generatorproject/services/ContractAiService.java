package com.generatorproject.services;

import com.generatorproject.dao.ContractAiExtractedItemDAO;
import com.generatorproject.dao.ContractEventDAO;
import com.generatorproject.dao.DbContext;
import com.generatorproject.model.AiExtractResponse;
import com.generatorproject.model.ContractAiExtractedItem;
import com.google.gson.Gson;

import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;

public class ContractAiService {
    private final ContractAiExtractedItemDAO itemDAO = new ContractAiExtractedItemDAO();
    private final OcrService ocrService = new OcrService();
    private final AiExtractionService extractionService = new AiExtractionService();
    private final DbContext dbContext = new DbContext();
    private final AiCoreService aiCoreService = new AiCoreService();
    private final ContractEventDAO contractEventDAO = new ContractEventDAO();

    public List<ContractAiExtractedItem> extractAndSave(Long contractId, String sourceFilePath) throws Exception {
        File file = sourceFilePath == null ? null : new File(sourceFilePath);
        String content = ocrService.readText(file);
        AiExtractionService.ExtractResult extractionResult = extractionService.extractDevicesResult(content, sourceFilePath, contractId,
                "Trích xuất danh sách thiết bị trong hợp đồng");
        List<ContractAiExtractedItem> items = extractionResult.getItems();

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

    public AiExtractResponse extractForContract(Long contractId, Integer managerId, Long existingAiSessionId, String fallbackSourcePath, String userPrompt) throws Exception {
        Long aiSessionId = existingAiSessionId;
        String sourcePath = null;
        Long runId = null;
        List<String> preWarnings = new ArrayList<>();

        try {
            if (managerId != null) {
                try {
                    if (aiSessionId == null) {
                        aiSessionId = aiCoreService.ensureSession(managerId, "CONTRACT", "CONTRACT", contractId,
                                "Contract draft #" + contractId);
                    }
                    sourcePath = aiCoreService.findLatestAttachmentPath(aiSessionId);
                    Long triggerMsgId = aiCoreService.addMessage(aiSessionId, "USER", "Extract device list from attachment", "TEXT");
                    runId = aiCoreService.createExtractRun(aiSessionId, triggerMsgId);
                } catch (Exception aiCoreEx) {
                    aiSessionId = null;
                    runId = null;
                    preWarnings.add("AI session tạm thời không khả dụng, hệ thống sẽ tiếp tục trích xuất không lưu lịch sử.");
                }
            }

            if (sourcePath == null || sourcePath.trim().isEmpty()) {
                sourcePath = fallbackSourcePath;
            }

            File file = sourcePath == null ? null : new File(sourcePath);
            String content = ocrService.readText(file);
            AiExtractionService.ExtractResult extractionResult = extractionService.extractDevicesResult(content, sourcePath, contractId,
                    userPrompt == null || userPrompt.trim().isEmpty() ? "Trích xuất danh sách thiết bị trong hợp đồng" : userPrompt.trim());
            if (!preWarnings.isEmpty()) {
                ensureWarnings(extractionResult).addAll(preWarnings);
            }

            try {
                saveExtractedItems(contractId, extractionResult.getItems());
            } catch (Exception saveEx) {
                if (isMissingExtractTableError(saveEx)) {
                    ensureWarnings(extractionResult).add("Chưa có bảng contract_ai_extracted_items. Vui lòng chạy migration `scripts/contract_ai_flow_migration.sql`.");
                } else {
                    throw saveEx;
                }
            }

            AiExtractResponse response = buildResponse(extractionResult);
            response.setAiSessionId(aiSessionId);

            String payloadJson = new Gson().toJson(toPayloadMap(response));
            if (aiSessionId != null) {
                aiCoreService.addMessage(aiSessionId, "AI", payloadJson, "JSON");
                if (runId != null) {
                    aiCoreService.markRunSuccess(runId, response.getChatMessage(), payloadJson, 0.80);
                }
            }

            Map<String, Object> meta = new HashMap<>();
            meta.put("total_items", response.getTotalItems());
            contractEventDAO.insertEvent(contractId, "AI_EXTRACT", "AI_EXTRACT_DONE", null, null,
                    "Extract device list from source file", managerId == null ? null : managerId.longValue(),
                    null, null, new Gson().toJson(meta));

            return response;
        } catch (Exception ex) {
            try {
                if (aiSessionId != null) {
                    aiCoreService.addMessage(aiSessionId, "SYSTEM", "AI extract failed: " + safeMessage(ex), "TEXT");
                }
                aiCoreService.markRunFailed(runId, safeMessage(ex));
            } catch (Exception ignored) {
            }
            throw ex;
        }
    }

    public Map<String, Object> toPayloadMap(AiExtractResponse response) {
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("chatMessage", response.getChatMessage());
        payload.put("items", response.getItems());
        payload.put("warnings", response.getWarnings());
        return payload;
    }

    private AiExtractResponse buildResponse(AiExtractionService.ExtractResult extractionResult) {
        AiExtractResponse response = new AiExtractResponse();
        response.setChatMessage(extractionResult.getChatMessage());

        List<ContractAiExtractedItem> items = extractionResult.getItems();
        List<Map<String, Object>> itemPayload = new ArrayList<>();

        for (ContractAiExtractedItem item : items) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("raw_model_name", item.getRawModelName());
            row.put("quantity", item.getQuantity());
            row.put("raw_serial_number", item.getRawSerialNumber());
            row.put("manufacture_year", item.getManufactureYear());
            row.put("current_location", item.getCurrentLocation());
            itemPayload.add(row);
        }

        response.setItems(itemPayload);
        response.setWarnings(extractionResult.getWarnings() == null || extractionResult.getWarnings().isEmpty()
                ? Collections.singletonList("Không có cảnh báo")
                : extractionResult.getWarnings());
        response.setTotalItems(items.size());
        return response;
    }

    private void saveExtractedItems(Long contractId, List<ContractAiExtractedItem> items) throws Exception {
        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);
            itemDAO.deleteByContractId(conn, contractId);
            for (ContractAiExtractedItem item : items) {
                itemDAO.insert(conn, item);
            }
            conn.commit();
        }
    }

    public List<ContractAiExtractedItem> findByContractId(Long contractId) {
        try {
            return itemDAO.findByContractId(contractId);
        } catch (RuntimeException ex) {
            if (isMissingExtractTableError(ex)) {
                return Collections.emptyList();
            }
            throw ex;
        }
    }

    public void applyReview(Long itemId, Long matchedModelId, Integer quantity, String serial, Integer year, String location) {
        itemDAO.updateReviewData(itemId, matchedModelId, quantity, serial, year, location);
    }

    private List<String> ensureWarnings(AiExtractionService.ExtractResult extractionResult) {
        if (extractionResult.getWarnings() == null) {
            extractionResult.setWarnings(new ArrayList<>());
        }
        return extractionResult.getWarnings();
    }

    private boolean isMissingExtractTableError(Throwable ex) {
        Throwable cur = ex;
        while (cur != null) {
            String msg = cur.getMessage();
            if (msg != null) {
                String lower = msg.toLowerCase();
                if (lower.contains("contract_ai_extracted_items") &&
                        (lower.contains("doesn't exist") || lower.contains("does not exist") ||
                                lower.contains("unknown table") || lower.contains("no such table"))) {
                    return true;
                }
            }
            if (cur instanceof SQLException) {
                String state = ((SQLException) cur).getSQLState();
                if ("42S02".equalsIgnoreCase(state)) {
                    return true;
                }
            }
            cur = cur.getCause();
        }
        return false;
    }

    private String safeMessage(Throwable ex) {
        if (ex == null) return "Unknown error";
        Throwable cur = ex;
        while (cur != null) {
            String msg = cur.getMessage();
            if (msg != null && !msg.trim().isEmpty() && !"null".equalsIgnoreCase(msg.trim())) {
                return msg.trim();
            }
            cur = cur.getCause();
        }
        return ex.getClass().getSimpleName();
    }

}
