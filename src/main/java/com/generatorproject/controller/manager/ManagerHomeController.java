package com.generatorproject.controller.manager;

import com.generatorproject.model.Contract;
import com.generatorproject.dao.ManagerReportDAO;
import com.generatorproject.model.ManagerReportStats;
import com.generatorproject.services.ContractServices;
import com.generatorproject.services.IContractServices;
import com.generatorproject.services.IProductServices;
import com.generatorproject.services.ProductServices;

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
    private final ManagerReportDAO reportDAO;

    public ManagerHomeController() {
        contractService = new ContractServices();
        productService = new ProductServices();
        reportDAO = new ManagerReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int activeContracts = contractService.countByStatus("ACTIVE");
        int expiringContracts = contractService.countExpiringSoon(30);
        int totalProducts = productService.countAll("");

        ManagerReportStats reportStats = reportDAO.getDashboardStats();
        int pendingRequests = reportStats.getWaitingRequests();

        List<Contract> recentContracts = contractService.findRecent(5);

        req.setAttribute("activeCount", activeContracts);
        req.setAttribute("expiringCount", expiringContracts);
        req.setAttribute("productCount", totalProducts);
        req.setAttribute("pendingCount", pendingRequests);

        req.setAttribute("recentContracts", recentContracts);
        req.setAttribute("overdueCount", reportStats.getOverdueRequests());

        req.getRequestDispatcher("/views/manager/home.jsp").forward(req, resp);
    }
}