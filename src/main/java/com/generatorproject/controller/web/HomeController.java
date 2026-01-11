package com.generatorproject.controller.web;

import com.generatorproject.model.Users;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Giả lập lấy dữ liệu từ Database
        String dashboardTitle = "Hệ Thống Quản Lý Máy Phát Điện (Gen-CMS)";
        int totalGenerators = 25; // Tổng số máy
        int runningGenerators = 18; // Đang chạy
        int maintenanceGenerators = 5; // Bảo trì
        int errorGenerators = 2; // Đang lỗi

        Users user = new Users();
//        user.setFullName("Nguyễn Quang Huy");
        req.setAttribute("userInfo", user);

        // 2. Đẩy dữ liệu sang trang JSP để hiển thị
        req.setAttribute("title", dashboardTitle);
        req.setAttribute("total", totalGenerators);
        req.setAttribute("running", runningGenerators);
        req.setAttribute("maintenance", maintenanceGenerators);
        req.setAttribute("error", errorGenerators);

        // 3. Chuyển hướng về giao diện
        // Lưu ý: Đường dẫn này phải đúng với nơi bạn đặt file jsp
        RequestDispatcher rd = req.getRequestDispatcher("/views/home/home.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}