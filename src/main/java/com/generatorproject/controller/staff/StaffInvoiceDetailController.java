package com.generatorproject.controller.staff;

import com.generatorproject.model.Invoice;
import com.generatorproject.model.QuoteDetail;
import com.generatorproject.model.Users;
import com.generatorproject.services.IInvoiceService;
import com.generatorproject.services.IQuoteDetailService;
import com.generatorproject.services.InvoiceService;
import com.generatorproject.services.QuoteDetailService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet(urlPatterns = {"/staff/invoice/detail"})
public class StaffInvoiceDetailController extends HttpServlet {

    private final IInvoiceService invoiceService;
    private final IQuoteDetailService quoteDetailService;

    public StaffInvoiceDetailController() {
        this.invoiceService = new InvoiceService();
        quoteDetailService = new QuoteDetailService();
    }

    // HIỂN THỊ TRANG CHI TIẾT
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // ... (các code kiểm tra đăng nhập giữ nguyên)

        try {
            Long invoiceId = Long.parseLong(req.getParameter("id"));
            Invoice invoice = invoiceService.getInvoiceById(invoiceId);

            if (invoice == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/management?action=invoice-list&message=not_found");
                return;
            }

            // ==========================================
            // THÊM ĐOẠN NÀY ĐỂ LẤY CHI TIẾT VẬT TƯ THAY THẾ
            // ==========================================
            // Giả sử model Invoice của bạn có hàm getQuoteId()
            if (invoice.getQuoteId() != null && invoice.getQuoteId() > 0) {
                List<QuoteDetail> quoteDetails = quoteDetailService.findByQuoteId(invoice.getQuoteId());
                req.setAttribute("quoteDetails", quoteDetails);
            }
            // ==========================================

            req.setAttribute("invoice", invoice);
            req.getRequestDispatcher("/views/staff/invoice-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra log để dễ debug
            resp.sendRedirect(req.getContextPath() + "/staff/management?action=invoice-list&message=error");
        }
    }

    // XỬ LÝ CÁC FORM POST (CẬP NHẬT THUẾ HOẶC THANH TOÁN)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Users staff = (Users) req.getSession().getAttribute("USERMODEL");

        String action = req.getParameter("action");
        Long invoiceId = Long.parseLong(req.getParameter("invoiceId"));

        try {
            if ("update_tax".equals(action)) {
                // XỬ LÝ CẬP NHẬT THUẾ VAT
                double newTaxRate = Double.parseDouble(req.getParameter("taxRate"));

                // Gọi service update (Bạn cần viết hàm này ở DAO nhé)
                invoiceService.updateTaxRate(invoiceId, newTaxRate);

                resp.sendRedirect(req.getContextPath() + "/staff/invoice/detail?id=" + invoiceId + "&message=tax_updated");

            } else if ("confirm_payment".equals(action)) {
                // XỬ LÝ THU TIỀN
                String paymentMethod = req.getParameter("paymentMethod");
                String note = req.getParameter("note");

                boolean success = invoiceService.confirmPayment(invoiceId, paymentMethod, note, staff);

                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/staff/invoice/detail?id=" + invoiceId + "&message=payment_success");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/staff/invoice/detail?id=" + invoiceId + "&message=payment_failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/invoice/detail?id=" + invoiceId + "&message=error");
        }
    }
}