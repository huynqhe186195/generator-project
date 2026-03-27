package com.generatorproject.controller.web;


import com.generatorproject.model.Invoice;
import com.generatorproject.model.QuoteDetail;
import com.generatorproject.services.InvoiceService;
import com.generatorproject.services.QuoteDetailService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/guest/invoice/view")
public class GuestInvoiceViewController extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();
    private final QuoteDetailService quoteDetailService = new QuoteDetailService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");

        if (code == null || code.trim().isEmpty()) {
            resp.getWriter().write("Mã hóa đơn không hợp lệ!");
            return;
        }

        // Lấy thông tin hóa đơn từ Database
        Invoice invoice = invoiceService.getInvoiceByCode(code);

        if (invoice == null) {
            resp.getWriter().write("Không tìm thấy hóa đơn trên hệ thống!");
            return;
        }

        // Lấy chi tiết vật tư/phụ tùng
        if (invoice.getQuoteId() != null && invoice.getQuoteId() > 0) {
            List<QuoteDetail> details = quoteDetailService.findByQuoteId(invoice.getQuoteId());
            req.setAttribute("details", details);
        }

        req.setAttribute("invoice", invoice);

        // Chuyển hướng sang trang giao diện in Hóa đơn
        req.getRequestDispatcher("/views/home/invoice-print.jsp").forward(req, resp);
    }
}