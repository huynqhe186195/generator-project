package com.generatorproject.controller.manager;

import com.generatorproject.dao.ManagerReportDAO;
import com.generatorproject.model.ManagerReportStats;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/manager/reports"})
public class ManagerReportController extends HttpServlet {

    private final ManagerReportDAO reportDAO = new ManagerReportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ManagerReportStats stats = reportDAO.getDashboardStats();
        req.setAttribute("stats", stats);
        req.getRequestDispatcher("/views/manager/report/dashboard.jsp").forward(req, resp);
    }
}
