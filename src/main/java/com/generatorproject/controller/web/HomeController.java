package com.generatorproject.controller.web;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Brand;
import com.generatorproject.model.HomeStats;
import com.generatorproject.model.Users;

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
        // 1. Khởi tạo các DAO
        BrandDAO bDao = new BrandDAO();
        ProductDAO pDao = new ProductDAO();
        UserDao uDao = new UserDao();

        // 2. Lấy thông tin người dùng (nếu cần)
        Users user = new Users();
        // user.setFullName("Nguyễn Quang Huy");
        req.setAttribute("userInfo", user);

        // 3. Tiêu đề dashboard
        String dashboardTitle = "Hệ Thống Quản Lý Máy Phát Điện (Gen-CMS)";
        req.setAttribute("title", dashboardTitle);

        // 4. Gom dữ liệu thống kê vào HomeStats
        HomeStats stats = new HomeStats();
        stats.setTotalProducts(pDao.countProducts());
        stats.setTotalHours((int) pDao.sumRunningHours());
        stats.setTotalUsers(uDao.countUsers());
        req.setAttribute("stats", stats);

        // 5. Thống kê trạng thái máy phát điện (giả lập hoặc lấy từ DB)
        int totalGenerators = pDao.countProducts(); // Có thể dùng từ stats
        int runningGenerators = 18; // Có thể thêm method trong ProductDAO
        int maintenanceGenerators = 5;
        int errorGenerators = 2;

        req.setAttribute("total", totalGenerators);
        req.setAttribute("running", runningGenerators);
        req.setAttribute("maintenance", maintenanceGenerators);
        req.setAttribute("error", errorGenerators);

        // 6. Lấy danh sách thương hiệu
        List<Brand> brands = bDao.findAll();
        req.setAttribute("brands", brands);

        // 7. Chuyển hướng về trang chủ
        RequestDispatcher rd = req.getRequestDispatcher("/views/home/home.jsp");
        // Hoặc: req.getRequestDispatcher("/index.jsp").forward(req, resp);
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}