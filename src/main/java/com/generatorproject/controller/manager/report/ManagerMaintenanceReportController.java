package com.generatorproject.controller.manager.report;

import com.generatorproject.model.Users;
import com.generatorproject.model.reports.MaintenanceReportFilter;
import com.generatorproject.services.report.MaintenanceReportService;
import com.generatorproject.services.report.TicketReportService; // reuse dropdown option lists

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/manager/reports/maintenance-periodic"})
public class ManagerMaintenanceReportController extends HttpServlet {

    private final MaintenanceReportService service = new MaintenanceReportService();
    private final TicketReportService optionService = new TicketReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        if (manager == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        MaintenanceReportFilter f = new MaintenanceReportFilter();
        f.setFrom(nz(req.getParameter("from")));
        f.setTo(nz(req.getParameter("to")));
        f.setCustomerId(parseIntObj(req.getParameter("customerId")));
        f.setTechnicianId(parseIntObj(req.getParameter("technicianId")));
        f.setModelId(parseIntObj(req.getParameter("modelId")));
        f.setSiteKeyword(nz(req.getParameter("site")));

        // onlyPeriodic: ALL / PERIODIC / NON
        String only = nz(req.getParameter("only"));
        if ("PERIODIC".equalsIgnoreCase(only)) f.setOnlyPeriodic(true);
        else if ("NON".equalsIgnoreCase(only)) f.setOnlyPeriodic(false);
        else f.setOnlyPeriodic(null);

        // onTimeMode: DONE_BASED / PLANNED_BASED
        String onTimeMode = nz(req.getParameter("onTimeMode"));
        if (onTimeMode == null) onTimeMode = "DONE_BASED";
        req.setAttribute("onTimeMode", onTimeMode);

        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = 10;

        int total = service.countRows(f);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / pageSize));
        if (page > totalPages) page = totalPages;

        req.setAttribute("filter", f);

        req.setAttribute("kpi", service.kpis(f));

        req.setAttribute("bdType", service.breakdownType(f));
        req.setAttribute("bdPower", service.breakdownPower(f));
        req.setAttribute("bdSite", service.breakdownCustomerSite(f));
        req.setAttribute("bdTech", service.breakdownTechnician(f));

        req.setAttribute("rows", service.findRows(f, page, pageSize));
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);

        // dropdowns
        req.setAttribute("customers", optionService.listCustomers());
        req.setAttribute("technicians", optionService.listTechnicians());
        req.setAttribute("models", optionService.listModels());

        req.getRequestDispatcher("/views/manager/reports/maintenance-periodic.jsp").forward(req, resp);
    }

    private String nz(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private int parseInt(String raw, int def) {
        try {
            if (raw == null || raw.isBlank()) return def;
            return Integer.parseInt(raw.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private Integer parseIntObj(String raw) {
        try {
            if (raw == null || raw.isBlank()) return null;
            int v = Integer.parseInt(raw.trim());
            return v > 0 ? v : null;
        } catch (Exception e) {
            return null;
        }
    }
}