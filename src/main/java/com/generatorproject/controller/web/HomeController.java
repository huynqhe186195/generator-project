package com.generatorproject.controller.web;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.HomeStatsDAO;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Brand;
import com.generatorproject.model.HomeStats;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // DAO
        BrandDAO bDao = new BrandDAO();
        UserDao uDao = new UserDao();
        HomeStatsDAO hsDao = new HomeStatsDAO();

        // ===== STATS (KHÔNG DÙNG ProductDAO) =====
        HomeStats stats = hsDao.getStatsForHome();   // totalProducts + totalHours
        stats.setTotalUsers(uDao.countUsers());      // totalUsers vẫn dùng UserDao
        req.setAttribute("stats", stats);

        // ===== THỐNG KÊ TRẠNG THÁI (TẠM GIẢ LẬP) =====
        int totalGenerators = stats.getTotalProducts();
        int runningGenerators = 18;
        int maintenanceGenerators = 5;
        int errorGenerators = 2;

        req.setAttribute("total", totalGenerators);
        req.setAttribute("running", runningGenerators);
        req.setAttribute("maintenance", maintenanceGenerators);
        req.setAttribute("error", errorGenerators);

        // ===== BRANDS =====
        List<Brand> brands = bDao.getAllBrands();
        req.setAttribute("brands", brands);

        // Forward
        RequestDispatcher rd = req.getRequestDispatcher("/views/home/home.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
