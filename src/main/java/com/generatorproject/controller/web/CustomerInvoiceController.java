package com.generatorproject.controller.web;



import com.generatorproject.model.Invoice;

import com.generatorproject.model.Users;
import com.generatorproject.services.InvoiceService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/invoice-list")
public class CustomerInvoiceController extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Kiểm tra đăng nhập (Lấy từ session theo key USERMODEL bạn đã đặt ở Header)
        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("USERMODEL");

        if (user == null) {
            // Nếu chưa đăng nhập, đá về trang login
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        // 2. Lấy các tham số lọc từ Request (Search & Filter)
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");

        // Xử lý phân trang cơ bản
        int page = 1;
        int pageSize = 10;
        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
        } catch (Exception e) {
            page = 1;
        }

        // 3. Gọi Service lấy dữ liệu của chính khách hàng đó
        List<Invoice> list = invoiceService.getInvoicesByCustomer((long)user.getId(), keyword, status, page, pageSize);

        // 4. Đẩy dữ liệu ra JSP
        req.setAttribute("invoiceList", list);
        // Gửi lại các tham số lọc để giữ trạng thái trên Form
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);

        req.getRequestDispatcher("/views/home/invoice-list.jsp").forward(req, resp);
    }
}
