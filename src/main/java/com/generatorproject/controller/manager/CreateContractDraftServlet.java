package com.generatorproject.controller.manager;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Users;
import com.generatorproject.model.ContractDraft;
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
        Long id = parseLongParam(req.getParameter("id"));
        if (id != null) {
            Contract contract = contractService.findById(id);
            if (contract != null) {
                req.setAttribute("draftContract", contract);
                req.setAttribute("aiItems", contractAiService.findByContractId(contract.getId()));
            }
        }
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.setAttribute("models", productModelServices.findAll());
        req.getRequestDispatcher("/views/manager/contract/create-contract.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");
            if (manager == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            ContractDraft draftInput = new ContractDraft();
            draftInput.setContractNumber(normalize(req.getParameter("contractNumber")));
            draftInput.setCustomerId(requireLongParam(req.getParameter("customerId"), "Vui lòng chọn khách hàng."));
            draftInput.setSignedDate(requireDateParam(req.getParameter("signedDate"), "Vui lòng chọn ngày ký."));
            draftInput.setStartDate(requireDateParam(req.getParameter("startDate"), "Vui lòng chọn ngày hiệu lực."));
            draftInput.setEndDate(requireDateParam(req.getParameter("endDate"), "Vui lòng chọn ngày hết hạn."));

            if (draftInput.getContractNumber() == null || draftInput.getContractNumber().isEmpty()) {
                throw new IllegalArgumentException("Số hợp đồng không được để trống.");
            }

            if (draftInput.getStartDate().after(draftInput.getEndDate())) {
                throw new IllegalArgumentException("Ngày hiệu lực phải <= ngày hết hạn.");
            }

            Contract draft = Contract.builder()
                     .contractNumber(draftInput.getContractNumber())
                    .customerId(draftInput.getCustomerId().intValue())
                    .signedDate(draftInput.getSignedDate())
                    .startDate(draftInput.getStartDate())
                    .endDate(draftInput.getEndDate())
                    .managerId(manager.getId())
                    .status("PENDING_SERIAL")
                    .build();

            Long id = contractService.createDraft(draft);
            if (id == null) {
                throw new IllegalStateException("Không thể tạo draft hợp đồng. Vui lòng thử lại.");
            }
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + id + "&msg=draft_saved");
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            doGet(req, resp);
        }
    }

    private Long parseLongParam(String value) {
        String normalized = normalize(value);
        if (normalized == null) return null;
        try {
            return Long.parseLong(normalized);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Long requireLongParam(String value, String message) {
        Long parsed = parseLongParam(value);
        if (parsed == null) {
            throw new IllegalArgumentException(message);
        }
        return parsed;
    }

    private Date requireDateParam(String value, String message) {
        String normalized = normalize(value);
        if (normalized == null) {
            throw new IllegalArgumentException(message);
        }
        try {
            return Date.valueOf(normalized);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(message);
        }
    }

    private String normalize(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() || "null".equalsIgnoreCase(trimmed) ? null : trimmed;
    }

}
