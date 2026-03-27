package com.generatorproject.controller.manager.report;

import com.generatorproject.model.Users;
import com.generatorproject.model.report.TicketReportFilter;
import com.generatorproject.services.report.TicketReportService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet(urlPatterns = {"/manager/reports/tickets"})
public class ManagerTicketReportController extends HttpServlet {

    private final TicketReportService reportService = new TicketReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        if (manager == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        TicketReportFilter filter = new TicketReportFilter();

        String scope = req.getParameter("scope");
        String from = req.getParameter("from");
        String to = req.getParameter("to");
        if ("today".equalsIgnoreCase(scope)) {
            String today = LocalDate.now().toString();
            if (from == null || from.isBlank()) from = today;
            if (to == null || to.isBlank()) to = today;
        }

        filter.setFrom(normalizeDate(from));
        filter.setTo(normalizeDate(to));
        filter.setStatus(normalizeEnum(req.getParameter("status")));
        filter.setPriority(normalizeEnum(req.getParameter("priority")));
        filter.setKeyword(normalizeKeyword(req.getParameter("keyword")));

        filter.setCustomerId(parseIntObj(req.getParameter("customerId")));
        filter.setTechnicianId(parseIntObj(req.getParameter("technicianId")));
        filter.setModelId(parseIntObj(req.getParameter("modelId")));

        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = 10;

        int total = reportService.countTickets(filter);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / pageSize));
        if (page > totalPages) page = totalPages;

        req.setAttribute("filter", filter);
        req.setAttribute("page", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("total", total);
        req.setAttribute("totalPages", totalPages);

        req.setAttribute("kpiTotal", total);
        req.setAttribute("kpiOpen", reportService.countOpenTickets(filter));
        req.setAttribute("byStatus", reportService.countByStatus(filter));
        req.setAttribute("byPriority", reportService.countByPriority(filter));
        req.setAttribute("tickets", reportService.findTickets(filter, page, pageSize));

        // dropdown data
        req.setAttribute("customers", reportService.listCustomers());
        req.setAttribute("technicians", reportService.listTechnicians());
        req.setAttribute("models", reportService.listModels());

        req.getRequestDispatcher("/views/manager/reports/tickets.jsp").forward(req, resp);
    }

    private String normalizeDate(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private String normalizeEnum(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private String normalizeKeyword(String s) {
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