package com.generatorproject.controller.manager;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Users;
import com.generatorproject.services.ContractAiService;
import com.generatorproject.services.ContractService;
import com.generatorproject.services.UserServices;
import com.generatorproject.services.ProductModelServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/manager/contracts/draft")
public class CreateContractDraftServlet extends HttpServlet {
    private final ContractService contractService = new ContractService();
    private final UserServices userServices = new UserServices();
    private final ContractAiService contractAiService = new ContractAiService();
    private final ProductModelServices productModelServices = new ProductModelServices();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        if (id != null && !id.trim().isEmpty()) {
            Contract contract = contractService.findById(Long.parseLong(id));
            req.setAttribute("draftContract", contract);
            req.setAttribute("aiItems", contractAiService.findByContractId(contract.getId()));
        }
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.setAttribute("models", productModelServices.findAll());
        req.getRequestDispatcher("/views/manager/contract/contract-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");
            if (manager == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            String contractNumber = req.getParameter("contractNumber");
            Long customerId = Long.parseLong(req.getParameter("customerId"));
            Date signedDate = Date.valueOf(req.getParameter("signedDate"));
            Date startDate = Date.valueOf(req.getParameter("startDate"));
            Date endDate = Date.valueOf(req.getParameter("endDate"));
            if (startDate.after(endDate)) {
                throw new IllegalArgumentException("Ngày hiệu lực phải <= ngày hết hạn.");
            }

            Contract draft = Contract.builder()
                    .contractNumber(contractNumber)
                    .customerId(customerId.intValue())
                    .signedDate(signedDate)
                    .startDate(startDate)
                    .endDate(endDate)
                    .managerId(manager.getId())
                    .status("PENDING_SERIAL")
                    .build();

            Long id = contractService.createDraft(draft);
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + id + "&msg=draft_saved");
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            doGet(req, resp);
        }
    }
}
