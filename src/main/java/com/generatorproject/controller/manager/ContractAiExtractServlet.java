package com.generatorproject.controller.manager;

import com.generatorproject.dao.ContractEventDAO;
import com.generatorproject.model.ContractAiExtractedItem;
import com.generatorproject.model.Users;
import com.generatorproject.services.AiCoreService;
import com.generatorproject.services.ContractAiService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet("/manager/contracts/ai/extract")
public class ContractAiExtractServlet extends HttpServlet {
    private final ContractAiService contractAiService = new ContractAiService();
    private final AiCoreService aiCoreService = new AiCoreService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long contractId = Long.parseLong(req.getParameter("contractId"));
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");

        Long aiSessionId = (Long) req.getSession().getAttribute("contractAiSessionId_" + contractId);
        String sourcePath = null;
        Long runId = null;

        try {
            if (manager != null) {
                if (aiSessionId == null) {
                    aiSessionId = aiCoreService.ensureSession(manager.getId(), "CONTRACT", "CONTRACT", contractId,
                            "Contract draft #" + contractId);
                    req.getSession().setAttribute("contractAiSessionId_" + contractId, aiSessionId);
                }
                sourcePath = aiCoreService.findLatestAttachmentPath(aiSessionId);
                Long triggerMsgId = aiCoreService.addMessage(aiSessionId, "USER", "Extract device list from attachment", "TEXT");
                runId = aiCoreService.createExtractRun(aiSessionId, triggerMsgId);
            }

            if (sourcePath == null || sourcePath.trim().isEmpty()) {
                sourcePath = (String) req.getSession().getAttribute("contractAiSourceFilePath_" + contractId);
            }

            List<ContractAiExtractedItem> items = contractAiService.extractAndSave(contractId, sourcePath);

            Map<String, Object> payload = new LinkedHashMap<>();
            payload.put("chatMessage", "Ok, tôi đã trích xuất xong cho bạn danh sách thiết bị có trong hợp đồng.");

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
            payload.put("items", itemPayload);
            payload.put("warnings", warnings.isEmpty() ? Collections.singletonList("Không có cảnh báo") : warnings);

            String payloadJson = new Gson().toJson(payload);
            if (aiSessionId != null) {
                aiCoreService.addMessage(aiSessionId, "AI", payloadJson, "JSON");
                if (runId != null) {
                    aiCoreService.markRunSuccess(runId,
                            "Ok, tôi đã trích xuất xong cho bạn danh sách thiết bị có trong hợp đồng.",
                            payloadJson,
                            0.80);
                }
            }

            Map<String, Object> meta = new HashMap<>();
            meta.put("total_items", items.size());
            new ContractEventDAO().insertEvent(contractId, "AI_EXTRACT", "AI_EXTRACT_DONE", null, null,
                    "Extract device list from source file", manager == null ? null : (long) manager.getId(),
                    null, null, new Gson().toJson(meta));

            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=ai_extracted");
        } catch (Exception e) {
            try {
                if (aiSessionId != null) {
                    aiCoreService.addMessage(aiSessionId, "SYSTEM", "AI extract failed: " + e.getMessage(), "TEXT");
                }
                aiCoreService.markRunFailed(runId, e.getMessage());
            } catch (Exception ignored) {
            }
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=ai_extract_error");
        }
    }
}
