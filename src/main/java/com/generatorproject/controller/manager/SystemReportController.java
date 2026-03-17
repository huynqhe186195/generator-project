package com.generatorproject.controller.manager;

import com.generatorproject.services.IReportService;
import com.generatorproject.services.ReportService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Calendar;

@WebServlet("/manager/system-report")
public class SystemReportController extends HttpServlet {

    private final IReportService reportService = new ReportService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        int year = currentYear;

        String yearParam = req.getParameter("year");
        if (yearParam != null && !yearParam.isEmpty()) {
            try {
                year = Integer.parseInt(yearParam);
            } catch (NumberFormatException ignored) {}
        }

        // KPI cards
        req.setAttribute("kpiActiveContracts",      reportService.countActiveContracts());
        req.setAttribute("kpiNewCustomers",         reportService.countNewCustomersThisMonth());
        req.setAttribute("kpiPendingIncidents",     reportService.countPendingIncidents());
        req.setAttribute("kpiMaintenanceThisMonth", reportService.countMaintenanceThisMonth());

        // Chart data (JSON)
        req.setAttribute("selectedYear",          year);
        req.setAttribute("currentYear",           currentYear);
        req.setAttribute("newCustomersJson",      gson.toJson(reportService.getNewCustomersByMonth(year)));
        req.setAttribute("maintenanceStatusJson", gson.toJson(reportService.getMaintenanceStatusCount(year)));
        req.setAttribute("renewRateJson",         gson.toJson(reportService.getContractRenewRateByMonth(year)));
        req.setAttribute("incidentPriorityJson",  gson.toJson(reportService.getIncidentsByPriority(year)));
        req.setAttribute("topSparePartsJson",     gson.toJson(reportService.getTopSpareParts(5)));

        req.getRequestDispatcher("/views/manager/system-report.jsp").forward(req, resp);
    }
}
