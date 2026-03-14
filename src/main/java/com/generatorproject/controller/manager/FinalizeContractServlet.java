package com.generatorproject.controller.manager;

import com.generatorproject.model.Users;
import com.generatorproject.services.FinalizeContractService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/manager/contracts/finalize")
public class FinalizeContractServlet extends HttpServlet {
    private final FinalizeContractService finalizeContractService = new FinalizeContractService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long contractId = Long.parseLong(req.getParameter("contractId"));
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        try {
            finalizeContractService.finalizeDraft(contractId, manager == null ? null : (long) manager.getId());
            resp.sendRedirect(req.getContextPath() + "/manager/contracts?action=detail&id=" + contractId + "&msg=finalized");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&errorMessage=" + e.getMessage());
        }
    }
}
