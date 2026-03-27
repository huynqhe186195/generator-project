package com.generatorproject.controller.vnpay;

import com.generatorproject.model.Invoice;
import com.generatorproject.services.InvoiceService;
import com.generatorproject.utils.VNPayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/vnpay-return")
public class VNPayReturnController extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    try{
        // 1. Lấy tham số đưa vào Map (Vừa lấy gốc, vừa encode chuẩn VNPay)
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = req.getParameter(fieldName);

            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                String encodedKey = URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString());
                String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                fields.put(encodedKey, encodedValue);
            }
        }

        // 2. Tách chữ ký ra khỏi Map
        String vnp_SecureHash = req.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // 3. Tính toán chữ ký phía Server
        String signValue = VNPayConfig.hashAllFields(fields);

        // Lấy thông tin cơ bản
        String txnRef = req.getParameter("vnp_TxnRef");
        String invoiceCode = (txnRef != null && txnRef.contains("_")) ? txnRef.split("_")[0] : txnRef;
        String responseCode = req.getParameter("vnp_ResponseCode");
        String transactionStatus = req.getParameter("vnp_TransactionStatus");
        String transactionNo = req.getParameter("vnp_TransactionNo");

        // 4. KIỂM TRA BẢO MẬT
        if (signValue != null && signValue.equals(vnp_SecureHash)) {
            // ---- CHỮ KÝ HỢP LỆ ----

            if ("00".equals(responseCode) && "00".equals(transactionStatus)) {

                long amountPaid = Long.parseLong(req.getParameter("vnp_Amount")) / 100;
                Invoice invoice = invoiceService.getInvoiceByCode(invoiceCode);

                if (invoice != null) {
                    if ("PAID".equals(invoice.getPaymentStatus())) {
                        // Trường hợp 1: Đã thanh toán (F5 lại)
                        req.setAttribute("status", "paid");
                        req.setAttribute("message", "Hóa đơn này đã được thanh toán từ trước.");
                        req.setAttribute("transactionNo", transactionNo);

                    } else if (invoice.getTotalAmount().longValue() == amountPaid) {
                        // Trường hợp 2: Đúng tiền -> CẬP NHẬT DATABASE
                        invoiceService.updatePaymentStatusByCode(invoiceCode, "PAID", "VNPay", transactionNo);
                        req.setAttribute("status", "success");
                        req.setAttribute("message", "Thanh toán thành công hóa đơn " + invoiceCode);
                        req.setAttribute("transactionNo", transactionNo);

                    } else {
                        // Trường hợp 3: Sai số tiền
                        req.setAttribute("status", "error");
                        req.setAttribute("message", "Thanh toán thành công nhưng SỐ TIỀN KHÔNG KHỚP. Vui lòng đối soát lại!");
                    }
                } else {
                    req.setAttribute("status", "error");
                    req.setAttribute("message", "Không tìm thấy hóa đơn trên hệ thống!");
                }

            } else {
                // Khách hủy giao dịch hoặc lỗi thẻ
                req.setAttribute("status", "failed");
                req.setAttribute("message", "Giao dịch không thành công hoặc khách hàng đã hủy.");
            }

        } else {
            // ---- CHỮ KÝ KHÔNG HỢP LỆ (Hacker can thiệp) ----
            req.setAttribute("status", "error");
            req.setAttribute("message", "Cảnh báo: Dữ liệu giao dịch không hợp lệ.");
        }

        // 5. Chuyển hướng ra giao diện (Tạm thời vẫn dùng forward)
        req.getRequestDispatcher("/views/vnpay/vnpay-result.jsp").forward(req, resp);
    } catch (Exception e) {
        // Bắt mọi lỗi và in thẳng ra màn hình trắng để xem
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().print("<h2 style='color:red;'>Hệ thống bị sập do lỗi Code (Exception):</h2><pre>");
        e.printStackTrace(resp.getWriter());
        resp.getWriter().print("</pre>");
    }
    }
}