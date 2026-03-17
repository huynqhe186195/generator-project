package com.generatorproject.controller.web;

import com.generatorproject.model.Contract;
import com.generatorproject.model.ContractEvent;
import com.generatorproject.model.Product;
import com.generatorproject.model.Users;
import com.generatorproject.services.ContractServices;
import com.generatorproject.services.IContractServices;
import com.generatorproject.services.ProductServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/contracts")
public class CustomerContractController extends HttpServlet {

    private final IContractServices contractService = new ContractServices();
    private final ProductServices productServices = new ProductServices();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users user = (Users) req.getSession().getAttribute("USERMODEL");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "detail";
        }

        switch (action) {
            case "detail":
                showDetail(req, resp, user);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/product-list");
                break;
        }
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp, Users user)
            throws ServletException, IOException {
        try {
            String productIdRaw = req.getParameter("productId");
            if (productIdRaw == null || productIdRaw.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            Long productId = Long.parseLong(productIdRaw);

            Product product = productServices.findByIdAndCustomerId(productId, (long) user.getId());
            if (product == null) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem thiết bị này.");
                return;
            }

            if (product.getContractId() == null) {
                req.setAttribute("errorMessage", "Thiết bị này hiện chưa có hợp đồng.");
                req.getRequestDispatcher("/views/home/customer-contract-detail.jsp").forward(req, resp);
                return;
            }

            Contract contract = contractService.findContractDetailForCustomer(
                    product.getContractId(), (long) user.getId());

            if (contract == null) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem hợp đồng này.");
                return;
            }

            List<Product> contractProducts = productServices.findByContractId(contract.getId());
            ContractEvent terminatedEvent = contractService.findLatestTerminatedEvent(contract.getId());
            List<ContractEvent> contractEvents = contractService.findEventsByContractId(contract.getId());

            req.setAttribute("contract", contract);
            req.setAttribute("product", product);
            req.setAttribute("products", contractProducts);
            req.setAttribute("terminatedEvent", terminatedEvent);
            req.setAttribute("contractEvents", contractEvents);


            req.getRequestDispatcher("/views/home/customer-contract-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/product-list?msg=contract_error");
        }
    }
}