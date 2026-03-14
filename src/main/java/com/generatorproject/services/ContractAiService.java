package com.generatorproject.services;

import com.generatorproject.dao.ContractAiExtractedItemDAO;
import com.generatorproject.dao.ContractEventDAO;
import com.generatorproject.dao.DbContext;
import com.generatorproject.model.AiExtractResponse;
import com.generatorproject.model.ContractAiExtractedItem;
import com.google.gson.Gson;

import java.io.File;
import java.sql.Connection;
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

    public AiExtractResponse extractForContract(Long contractId, Integer managerId, Long existingAiSessionId, String fallbackSourcePath) throws Exception {
        Long aiSessionId = existingAiSessionId;
        String sourcePath = null;
        Long runId = null;

        try {
            if (managerId != null) {
                if (aiSessionId == null) {
                    aiSessionId = aiCoreService.ensureSession(managerId, "CONTRACT", "CONTRACT", contractId,
                            "Contract draft #" + contractId);
                }
                sourcePath = aiCoreService.findLatestAttachmentPath(aiSessionId);
                Long triggerMsgId = aiCoreService.addMessage(aiSessionId, "USER", "Extract device list from attachment", "TEXT");
                runId = aiCoreService.createExtractRun(aiSessionId, triggerMsgId);
            }

            if (sourcePath == null || sourcePath.trim().isEmpty()) {
                sourcePath = fallbackSourcePath;
            }

            List<ContractAiExtractedItem> items = extractAndSave(contractId, sourcePath);
            AiExtractResponse response = buildResponse(items);
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
                    aiCoreService.addMessage(aiSessionId, "SYSTEM", "AI extract failed: " + ex.getMessage(), "TEXT");
                }
                aiCoreService.markRunFailed(runId, ex.getMessage());
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

    private AiExtractResponse buildResponse(List<ContractAiExtractedItem> items) {
        AiExtractResponse response = new AiExtractResponse();
        response.setChatMessage("Ok, tôi đã trích xuất xong cho bạn danh sách thiết bị có trong hợp đồng.");

        List<Map<String, Object>> itemPayload = new ArrayList<>();
        List<String> warnings = new ArrayList<>();

        for (ContractAiExtractedItem item : items) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("raw_model_name", item.getRawModelName());
            row.put("quantity", item.getQuantity());
            row.put("raw_serial_number", item.getRawSerialNumber());
            row.put("manufacture_year", item.getManufactureYear());
            row.put("current_location", item.getCurrentLocation());
            itemPayload.add(row);
            if (item.getRawSerialNumber() == null || item.getRawSerialNumber().trim().isEmpty()) {
                warnings.add("Không đọc rõ serial number ở một số dòng");
            }
        }

        response.setItems(itemPayload);
        response.setWarnings(warnings.isEmpty() ? Collections.singletonList("Không có cảnh báo") : warnings);
        response.setTotalItems(items.size());
        return response;
    }

    public List<ContractAiExtractedItem> findByContractId(Long contractId) {
        return itemDAO.findByContractId(contractId);
    }

    public void applyReview(Long itemId, Long matchedModelId, Integer quantity, String serial, Integer year, String location) {
        itemDAO.updateReviewData(itemId, matchedModelId, quantity, serial, year, location);
    }
}
