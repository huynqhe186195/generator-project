package com.generatorproject.controller.manager.report;

import com.generatorproject.model.Users;
import com.generatorproject.model.report.AssetReportFilter;
import com.generatorproject.services.report.AssetReportService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/manager/reports/assets"})
public class ManagerAssetReportController extends HttpServlet {

    private final AssetReportService service = new AssetReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        if (manager == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        AssetReportFilter f = new AssetReportFilter();
        f.setKeyword(nz(req.getParameter("keyword")));
        f.setStatus(nz(req.getParameter("status")));
        f.setCustomerId(parseIntObj(req.getParameter("customerId")));
        f.setModelId(parseIntObj(req.getParameter("modelId")));
        f.setBrandId(parseIntObj(req.getParameter("brandId")));
        f.setWarrantyScope(nz(req.getParameter("warrantyScope"))); // EXPIRING_30
        f.setManufactureYear(parseIntObj(req.getParameter("year")));
        f.setCostBucket(nz(req.getParameter("costBucket")));
        f.setPeriodicScope(nz(req.getParameter("periodicScope")));

        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = 10;

        int total = service.countAssets(f);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / pageSize));
        if (page > totalPages) page = totalPages;

        req.setAttribute("customers", service.customers());
        req.setAttribute("models", service.models());

        req.setAttribute("filter", f);
        req.setAttribute("kpi", service.kpis(f));
        req.setAttribute("rows", service.findAssets(f, page, pageSize));

        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);

        // Phase 1: dropdown brand/model/customer có thể bổ sung sau bằng options service
        req.getRequestDispatcher("/views/manager/reports/assets.jsp").forward(req, resp);
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