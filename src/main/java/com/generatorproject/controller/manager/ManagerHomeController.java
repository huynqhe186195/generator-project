package com.generatorproject.controller.manager;

import com.generatorproject.model.Users;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/manager", "/manager/home"})
public class ManagerHomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. (Optional) Nếu muốn load số liệu thống kê thật thì gọi Service ở đây
        // Ví dụ: req.setAttribute("totalContracts", contractService.countAll());

        // 2. Forward sang trang Dashboard
        // Đường dẫn này phải khớp với nơi bạn lưu file home.jsp
        req.getRequestDispatcher("/views/manager/home.jsp").forward(req, resp);
    }
}