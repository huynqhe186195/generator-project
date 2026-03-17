package com.generatorproject.controller.vnpay;



import com.generatorproject.services.InvoiceService;
import com.generatorproject.utils.VNPayConfig;
// Import các class Service và DAO của bạn ở đây...

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


     private InvoiceService invoiceService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String fieldName = URLEncoder.encode(params.nextElement(), StandardCharsets.US_ASCII.toString());
            String fieldValue = URLEncoder.encode(req.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = req.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // Băm lại dữ liệu để kiểm tra chữ ký
        String signValue = VNPayConfig.hashAllFields(fields);

        // Lấy thông tin mã hóa đơn và trạng thái giao dịch
        String invoiceCode = req.getParameter("vnp_TxnRef"); // Lúc gửi đi bạn nối thêm timestamp, giờ cần tách ra
        if(invoiceCode != null && invoiceCode.contains("_")) {
            invoiceCode = invoiceCode.split("_")[0]; // Lấy lại đúng mã INV-123
        }
        String responseCode = req.getParameter("vnp_ResponseCode"); // Mã 00 là thành công
        String transactionNo = req.getParameter("vnp_TransactionNo"); // Mã giao dịch của VNPay

        if (signValue.equals(vnp_SecureHash)) {
            // CHỮ KÝ HỢP LỆ
            if ("00".equals(responseCode)) {
                // 1. THANH TOÁN THÀNH CÔNG -> Cập nhật Database
                invoiceService.updatePaymentStatusByCode(invoiceCode, "PAID", "VNPay", transactionNo);

                req.setAttribute("status", "success");
                req.setAttribute("message", "Thanh toán thành công hóa đơn " + invoiceCode);
                req.setAttribute("transactionNo", transactionNo);
            } else {
                // 2. THANH TOÁN THẤT BẠI (Hoặc khách bấm Hủy)
                req.setAttribute("status", "failed");
                req.setAttribute("message", "Giao dịch không thành công hoặc đã bị hủy.");
            }
        } else {
            // CHỮ KÝ KHÔNG HỢP LỆ (Có dấu hiệu can thiệp URL)
            req.setAttribute("status", "error");
            req.setAttribute("message", "Dữ liệu không hợp lệ. Vui lòng liên hệ quản trị viên!");
        }

        // Chuyển hướng sang trang giao diện thông báo cho khách hàng
        req.getRequestDispatcher("/views/vnpay/vnpay-result.jsp").forward(req, resp);
    }
}