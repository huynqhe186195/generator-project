package com.generatorproject.services.report;

import com.generatorproject.dao.report.TicketReportDAO;
import com.generatorproject.model.report.IdNameOption;
import com.generatorproject.model.report.TicketReportFilter;
import com.generatorproject.model.report.TicketReportRow;

import java.util.List;
import java.util.Map;

public class TicketReportService {
    private final TicketReportDAO dao;

    public TicketReportService() {
        this.dao = new TicketReportDAO();
    }

    public List<IdNameOption> listCustomers() { return dao.listCustomers(); }
    public List<IdNameOption> listTechnicians() { return dao.listTechnicians(); }
    public List<IdNameOption> listModels() { return dao.listModels(); }

    public int countTickets(TicketReportFilter f) { return dao.countTickets(f); }
    public int countOpenTickets(TicketReportFilter f) { return dao.countOpenTickets(f); }

    public Map<String, Integer> countByStatus(TicketReportFilter f) { return dao.countByStatus(f); }
    public Map<String, Integer> countByPriority(TicketReportFilter f) { return dao.countByPriority(f); }

    public List<TicketReportRow> findTickets(TicketReportFilter f, int page, int pageSize) {
        return dao.findTickets(f, page, pageSize);
    }
}