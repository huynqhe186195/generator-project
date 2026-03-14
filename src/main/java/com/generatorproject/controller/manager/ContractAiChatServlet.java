package com.generatorproject.controller.manager;

import com.generatorproject.model.AiExtractResponse;
import com.generatorproject.model.Users;
import com.generatorproject.services.ContractAiService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/manager/contracts/ai/chat")
public class ContractAiChatServlet extends HttpServlet {
    private final ContractAiService contractAiService = new ContractAiService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long contractId = Long.parseLong(req.getParameter("contractId"));
        String userPrompt = req.getParameter("userPrompt");

        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        Integer managerId = manager == null ? null : manager.getId();
        Long aiSessionId = (Long) req.getSession().getAttribute("contractAiSessionId_" + contractId);
        String sourcePath = (String) req.getSession().getAttribute("contractAiSourceFilePath_" + contractId);

        try {
            AiExtractResponse response = contractAiService.extractForContract(contractId, managerId, aiSessionId, sourcePath, userPrompt);
            if (response.getAiSessionId() != null) {
                req.getSession().setAttribute("contractAiSessionId_" + contractId, response.getAiSessionId());
            }
            writeJson(resp, HttpServletResponse.SC_OK, contractAiService.toPayloadMap(response));
        } catch (Exception e) {
            Map<String, Object> err = new HashMap<>();
            err.put("chatMessage", "AI extract thất bại.");
            err.put("items", new Object[0]);
            err.put("warnings", new String[]{e.getMessage()});
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, err);
        }
    }

    private void writeJson(HttpServletResponse resp, int status, Object payload) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(gson.toJson(payload));
    }
}
