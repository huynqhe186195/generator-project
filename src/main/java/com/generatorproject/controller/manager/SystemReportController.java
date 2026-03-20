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

        int year = parseYear(req.getParameter("year"), currentYear);

        String section = normalizeSection(req.getParameter("section"));
        if (section == null) {
            section = "inventory";
        }

        req.setAttribute("section", section);
        req.setAttribute("selectedYear", year);
        req.setAttribute("currentYear", currentYear);
        req.setAttribute("yearFrom", currentYear - 3);
        req.setAttribute("yearTo", currentYear + 3);

        if ("inventory".equals(section)) {
            loadInventory(req, year);
        } else if ("service".equals(section)) {
            // TODO: bước sau
        } else if ("financial".equals(section)) {
            // TODO: bước sau
        } else if ("risk".equals(section)) {
            // TODO: bước sau
        } else {
            // fallback an toàn
            req.setAttribute("section", "inventory");
            loadInventory(req, year);
        }

        req.getRequestDispatcher("/views/manager/system-report.jsp")
                .forward(req, resp);
    }

    private int parseYear(String yearParam, int defaultYear) {
        if (yearParam == null || yearParam.trim().isEmpty()) {
            return defaultYear;
        }
        try {
            return Integer.parseInt(yearParam.trim());
        } catch (NumberFormatException ex) {
            return defaultYear;
        }
    }

    private String normalizeSection(String raw) {
        if (raw == null) {
            return null;
        }
        String s = raw.trim().toLowerCase();
        if (s.isEmpty()) {
            return null;
        }
        if ("inventory".equals(s)
                || "service".equals(s)
                || "financial".equals(s)
                || "risk".equals(s)) {
            return s;
        }
        return null;
    }

    private void loadInventory(HttpServletRequest req, int year) {
        // KPI
        req.setAttribute("invTotalCustomers",
                reportService.countCustomers());
        req.setAttribute("invTotalDevices",
                reportService.countDevices());
        req.setAttribute("invActiveContracts",
                reportService.countActiveContracts());
        req.setAttribute("invDevicesRunning",
                reportService.countDevicesByStatus("RUNNING"));
        req.setAttribute("invDevicesMaintenance",
                reportService.countDevicesByStatus("MAINTENANCE"));
        req.setAttribute("invDevicesBroken",
                reportService.countDevicesBrokenLike());

        // Charts (JSON)
        req.setAttribute("devicesByBrandJson",
                gson.toJson(reportService.getDevicesByBrand()));
        req.setAttribute("devicesByCategoryJson",
                gson.toJson(reportService.getDevicesByCategory()));
        req.setAttribute("devicesByKvaBucketJson",
                gson.toJson(reportService.getDevicesByKvaBucket()));

        // Table
        req.setAttribute("topModelsJson",
                gson.toJson(reportService.getTopModels(10)));
    }
}