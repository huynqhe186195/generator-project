package com.generatorproject.controller.manager;

import com.generatorproject.dao.ContractEventDAO;
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

@WebServlet("/manager/contracts/ai/extract")
public class ContractAiExtractServlet extends HttpServlet {
    private final ContractAiService contractAiService = new ContractAiService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long contractId = Long.parseLong(req.getParameter("contractId"));
        String sourcePath = (String) req.getSession().getAttribute("contractAiSourceFilePath_" + contractId);
        try {
            int total = contractAiService.extractAndSave(contractId, sourcePath).size();
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");
            Map<String, Object> meta = new HashMap<>();
            meta.put("total_items", total);
            new ContractEventDAO().insertEvent(contractId, "AI_EXTRACT", "AI_EXTRACT_DONE", null, null,
                    "Extract device list from source file", manager == null ? null : (long) manager.getId(),
                    null, null, new Gson().toJson(meta));
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=ai_extracted");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=ai_extract_error");
        }
    }
}
