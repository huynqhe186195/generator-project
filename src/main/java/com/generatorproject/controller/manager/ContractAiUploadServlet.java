package com.generatorproject.controller.manager;

import com.generatorproject.dao.ContractEventDAO;
import com.generatorproject.model.Users;
import com.generatorproject.services.AiCoreService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet("/manager/contracts/ai/upload")
@MultipartConfig
public class ContractAiUploadServlet extends HttpServlet {
    private final AiCoreService aiCoreService = new AiCoreService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long contractId = Long.parseLong(req.getParameter("contractId"));
        Part file = req.getPart("sourceFile");
        if (file == null || file.getSize() == 0) {
            if (isJsonRequest(req)) {
                writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, "Vui lòng chọn file upload.");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=no_file");
            return;
        }

        String uploadRoot = req.getServletContext().getRealPath("/uploads/contract-ai");
        Files.createDirectories(Paths.get(uploadRoot));
        String originalName = Paths.get(file.getSubmittedFileName()).getFileName().toString();
        String fileName = UUID.randomUUID() + "_" + originalName;
        File target = new File(uploadRoot, fileName);
        file.write(target.getAbsolutePath());

        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        try {
            if (manager != null) {
                Long sessionId = aiCoreService.ensureSession(manager.getId(), "CONTRACT", "CONTRACT", contractId,
                        "Contract draft #" + contractId);
                Long userMessageId = aiCoreService.addMessage(sessionId, "USER",
                        "Upload file for extract: " + originalName, "TEXT");
                aiCoreService.addAttachment(sessionId, userMessageId, originalName, target.getAbsolutePath(),
                        file.getContentType(), file.getSize(),
                        aiCoreService.detectAttachmentKind(originalName, file.getContentType()));
                req.getSession().setAttribute("contractAiSessionId_" + contractId, sessionId);
            }
        } catch (Exception ignored) {
        }

        Map<String, Object> meta = new HashMap<>();
        meta.put("source_file_path", target.getAbsolutePath());
        new ContractEventDAO().insertEvent(contractId, "AI_UPLOAD", "AI_FILE_UPLOADED", null, null,
                "Upload source file for AI extraction", manager == null ? null : (long) manager.getId(),
                null, null, new Gson().toJson(meta));

        req.getSession().setAttribute("contractAiSourceFilePath_" + contractId, target.getAbsolutePath());
        if (isJsonRequest(req)) {
            Map<String, Object> ok = new HashMap<>();
            ok.put("chatMessage", "Upload file thành công.");
            ok.put("items", new Object[0]);
            ok.put("warnings", new String[0]);
            writeJson(resp, HttpServletResponse.SC_OK, ok);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=file_uploaded");
    }


    private boolean isJsonRequest(HttpServletRequest req) {
        String format = req.getParameter("format");
        if ("json".equalsIgnoreCase(format)) {
            return true;
        }
        String accept = req.getHeader("Accept");
        return accept != null && accept.toLowerCase().contains("application/json");
    }

    private void writeJson(HttpServletResponse resp, int status, Object payload) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(gson.toJson(payload));
    }
}
