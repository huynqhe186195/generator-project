package com.generatorproject.controller.manager;

import com.generatorproject.dao.ContractEventDAO;
import com.generatorproject.model.Users;
import com.generatorproject.services.ContractAiService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/manager/contracts/ai/apply")
public class ContractAiApplyServlet extends HttpServlet {
    private final ContractAiService contractAiService = new ContractAiService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long contractId = Long.parseLong(req.getParameter("contractId"));
        String[] ids = req.getParameterValues("itemId");
        String[] models = req.getParameterValues("matchedModelId");
        String[] quantities = req.getParameterValues("quantity");
        String[] serials = req.getParameterValues("serial");
        String[] years = req.getParameterValues("manufactureYear");
        String[] locations = req.getParameterValues("currentLocation");

        if (ids != null) {
            for (int i = 0; i < ids.length; i++) {
                Long itemId = Long.parseLong(ids[i]);
                Long modelId = (models != null && i < models.length && !models[i].trim().isEmpty()) ? Long.parseLong(models[i]) : null;
                Integer quantity = (quantities != null && i < quantities.length && !quantities[i].trim().isEmpty()) ? Integer.parseInt(quantities[i]) : 1;
                String serial = serials != null && i < serials.length ? serials[i] : null;
                Integer year = (years != null && i < years.length && !years[i].trim().isEmpty()) ? Integer.parseInt(years[i]) : null;
                String location = locations != null && i < locations.length ? locations[i] : null;
                contractAiService.applyReview(itemId, modelId, quantity, serial, year, location);
            }
        }

        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        new ContractEventDAO().insertEvent(contractId, "AI_APPLY", "MANAGER_APPLIED_AI_ITEMS", null, null,
                "Manager reviewed and applied AI extracted items", manager == null ? null : (long) manager.getId(),
                null, null, null);

        resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=ai_applied");
    }
}
