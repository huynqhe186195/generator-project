package com.generatorproject.controller.manager.report;

import com.generatorproject.model.dashboard.ManagerDashboardKpi;
import com.generatorproject.services.ManagerDashboardService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/manager/dashboard"})
public class ManagerDashboardController extends HttpServlet {

    private final ManagerDashboardService dashboardService;

    public ManagerDashboardController() {
        dashboardService = new ManagerDashboardService();

    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // ===== A - vận hành dashboard KPI =====
        ManagerDashboardKpi kpi = dashboardService.loadKpis();
        req.setAttribute("opKpi", kpi);

        req.getRequestDispatcher("/views/manager/reports/dashboard.jsp").forward(req, resp);
    }
}
