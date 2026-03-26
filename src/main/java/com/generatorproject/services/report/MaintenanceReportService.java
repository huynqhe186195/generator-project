package com.generatorproject.services.report;

import com.generatorproject.dao.report.MaintenanceReportDAO;
import com.generatorproject.model.reports.MaintenanceKpi;
import com.generatorproject.model.reports.MaintenanceReportFilter;
import com.generatorproject.model.reports.MaintenanceReportRow;

import java.util.List;
import java.util.Map;

public class MaintenanceReportService {
    private final MaintenanceReportDAO dao = new MaintenanceReportDAO();

    public MaintenanceKpi kpis(MaintenanceReportFilter f) {
        return dao.loadKpis(f);
    }

    public Map<String, Integer> breakdownType(MaintenanceReportFilter f) {
        return dao.breakdownByType(f);
    }

    public Map<String, Integer> breakdownPower(MaintenanceReportFilter f) {
        return dao.breakdownByPowerBucket(f);
    }

    public Map<String, Integer> breakdownCustomerSite(MaintenanceReportFilter f) {
        return dao.breakdownByCustomerSite(f);
    }

    public Map<String, Integer> breakdownTechnician(MaintenanceReportFilter f) {
        return dao.breakdownByTechnician(f);
    }

    public int countRows(MaintenanceReportFilter f) {
        return dao.countRows(f);
    }

    public List<MaintenanceReportRow> findRows(MaintenanceReportFilter f, int page, int pageSize) {
        return dao.findRows(f, page, pageSize);
    }
}