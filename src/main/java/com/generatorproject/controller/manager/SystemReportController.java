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
public class SystemReportController extends HttpServlet{

    private final IReportService reportService = new ReportService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        int year = parseYear(req.getParameter("year"), currentYear);

        String section = normalizeSection(req.getParameter("section"));
        if(section == null){
            section = "inventory";
        }

        req.setAttribute("section", section);
        req.setAttribute("selectedYear", year);
        req.setAttribute("currentYear", currentYear);
        req.setAttribute("yearFrom", currentYear - 3);
        req.setAttribute("yearTo", currentYear + 3);

        if("inventory".equals(section)){
            loadInventory(req, year);
        }else if("service".equals(section)){
            loadServices(req, year);
        }else if("financial".equals(section)){
            loadFinancial(req, year);
        }else if("risk".equals(section)){
            loadRisk(req, year);
        }else if("contracts".equals(section)){
            loadContracts(req, year);
        }else {
            req.setAttribute("section", "inventory");
            loadInventory(req, year);
        }

        req.getRequestDispatcher("/views/manager/system-report.jsp").forward(req, resp);
    }

    private int parseYear(String yearParam, int defaultYear){
        if(yearParam == null || yearParam.trim().isEmpty()){
            return defaultYear;
        }
        try {
            return Integer.parseInt(yearParam.trim());
        }catch (NumberFormatException ex){
            return defaultYear;
        }
    }

    private String normalizeSection(String raw){
        if(raw == null){
            return null;
        }
        String s = raw.trim().toLowerCase();
        if(s.isEmpty()){
            return null;
        }
        if("inventory".equals(s) || "service".equals(s)
                || "financial".equals(s) || "risk".equals(s)
                || "contracts".equals(s)){
            return s;
        }
        return null;
    }

    private void loadInventory(HttpServletRequest req, int year){
        //KPI
        req.setAttribute("invTotalCustomers", reportService.countCustomers());
        req.setAttribute("invTotalDevices", reportService.countDevices());
        req.setAttribute("invActiveContracts", reportService.countActiveContracts());
        req.setAttribute("invDevicesRunning", reportService.countDevicesByStatus("RUNNING"));
        req.setAttribute("invDevicesMaintenance", reportService.countDevicesByStatus("MAINTENANCE"));
        req.setAttribute("invDevicesBroken", reportService.countDevicesBrokenLike());

        //Charts (JSON)
        req.setAttribute("devicesByBrandJson", gson.toJson(reportService.getDevicesByBrand()));
        req.setAttribute("devicesByCategoryJson", gson.toJson(reportService.getDevicesByCategory()));
        req.setAttribute("devicesByKvaBucketJson", gson.toJson(reportService.getDevicesByKvaBucket()));
        req.setAttribute("devicesByLocationJson", gson.toJson(reportService.getDevicesByCurrentLocationAsOfYear(year)));

        //Table (JSON)
        req.setAttribute("topModelsJson", gson.toJson(reportService.getTopModels(10)));
    }

    private void loadServices(HttpServletRequest req, int year){
        //KPI
        req.setAttribute("svcPendingIncidents", reportService.countPendingIncidents());
        req.setAttribute("svcIncidentsInWarranty",
                reportService.countIncidentsInWarrantyByYear(year));
        req.setAttribute("svcIncidentsOutWarranty",
                reportService.countIncidentsOutWarrantyByYear(year));

        req.setAttribute("svcMaintInWarranty",
                reportService.countMaintenancesInWarrantyByYear(year));
        req.setAttribute("svcMaintOutWarranty",
                reportService.countMaintenancesOutWarrantyByYear(year));

        req.setAttribute("svcDevicesBroken",
                reportService.countDevicesBrokenLike());

        // Charts JSON
        req.setAttribute("svcIncidentsWarrantyByMonthJson",
                gson.toJson(reportService.getIncidentsWarrantyByMonth(year)));
        req.setAttribute("svcMaintWarrantyByMonthJson",
                gson.toJson(reportService.getMaintenancesWarrantyByMonth(year)));
        req.setAttribute("svcIncidentPriorityJson",
                gson.toJson(reportService.getIncidentsByPriority(year)));
    }

    /// financial module
    private void loadFinancial(HttpServletRequest req, int year){
        //KPI
        req.setAttribute("finAvgTicket", reportService.getAverageTicketValueByYear(year));
        req.setAttribute("finTotalRevenue", reportService.getTotalServiceRevenueByYear(year));
        req.setAttribute("finTotalPartsQty", reportService.getTotalPartsQuantityUsedByYear(year));

        //Charts JSON
        req.setAttribute("finRevenueByMonthJson", gson.toJson(reportService.getServiceRevenueByMonth(year)));
        req.setAttribute("finTopPartsByQtyJson", gson.toJson(reportService.getTopPartsByQuantity(year, 5)));
        req.setAttribute("finTopPartsByValueJson", gson.toJson(reportService.getTopPartsByValue(year, 5)));

        //Table JSON
        req.setAttribute("finTopTicketsJson", gson.toJson(reportService.getTopMaintenanceTickets(year, 10)));
    }

    /// Risk module
    private void loadRisk(HttpServletRequest req, int year){
        //KPI
        req.setAttribute("riskRedZoneDevices", reportService.countRedZoneDevices(12));
        req.setAttribute("riskServicePenetrationRate", reportService.getServicePenetrationRateByYear(year));
        req.setAttribute("riskFirstTimeFixRate", reportService.getFirstTimeFixRateByYear(year));

        //Charts JSON
        req.setAttribute("riskRedZoneByCategoryJson", gson.toJson(reportService.getRedZoneDevicesByCategory(12)));

        //Table JSON
        req.setAttribute("riskRedZoneListJson", gson.toJson(reportService.getRedZoneDeviceList(12, 20)));
    }

    /// Contract module
    private void loadContracts(HttpServletRequest req, int year){
        //KPI
        req.setAttribute("ctrActive", reportService.countContractsByStatus("ACTIVE"));
        req.setAttribute("ctrPending", reportService.countContractsByStatus("PENDING_SERIAL"));
        req.setAttribute("ctrExpired", reportService.countContractsByStatus("EXPIRED"));
        req.setAttribute("ctrTerminated", reportService.countContractsByStatus("TERMINATED"));
        req.setAttribute("ctrExpiring30Days", reportService.countContractsExpiringInDays(30));

        //end_date < today nhưng status vẫn ACTIVE/PENDING...
        req.setAttribute("ctrDataMismatch", reportService.countContractsDateMismatch());

        //Chart JSON
        req.setAttribute("ctrStatusJson", gson.toJson(reportService.getContractsStatusDistribution()));
        req.setAttribute("ctrExpiringByMonthJson", gson.toJson(reportService.getContractsEndingByMonth(year)));

        //Table JSON
        req.setAttribute("ctrExpiringListJson", gson.toJson(reportService.getContractsExpiringList(30, 20)));
        req.setAttribute("ctrPendingListJson", gson.toJson(reportService.getPendingContractsList(20)));
    }
}