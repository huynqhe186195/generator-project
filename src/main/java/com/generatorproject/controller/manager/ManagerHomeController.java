package com.generatorproject.controller.manager;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Users;
import com.generatorproject.services.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/manager", "/manager/home"})
public class ManagerHomeController extends HttpServlet {

    private final IContractServices contractService;
    private final IProductServices productService;
    // private final IIncidentServices incidentService; // Nếu bạn đã làm module sự cố

    public ManagerHomeController() {
        contractService = new ContractServices();
        productService = new ProductServices();
        // incidentService = new IncidentServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int activeContracts = contractService.countByStatus("ACTIVE");
        int expiringContracts = contractService.countExpiringSoon(30);
        int totalProducts = productService.countAll("");

        // chưa làm module Incident thì để tạm số 0 hoặc query bảng contracts trạng thái PENDING
        int pendingRequests = 0;
        // int pendingRequests = incidentService.countByStatus("NEW");

        List<Contract> recentContracts = contractService.findRecent(5);

        req.setAttribute("activeCount", activeContracts);
        req.setAttribute("expiringCount", expiringContracts);
        req.setAttribute("productCount", totalProducts);
        req.setAttribute("pendingCount", pendingRequests);

        req.setAttribute("recentContracts", recentContracts);

        req.getRequestDispatcher("/views/manager/home.jsp").forward(req, resp);
    }
}