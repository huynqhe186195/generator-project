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
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/vnpay-return")
public class VNPayReturnController extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. Lấy tham số đưa vào Map (KHÔNG DÙNG URLEncoder ở đây)
        // 1. Lấy tham số đưa vào Map (VỪA LẤY GỐC, VỪA ENCODE ĐÚNG CHUẨN VNPAY)
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {

            String fieldName = params.nextElement(); // Tên biến gốc (VD: vnp_OrderInfo)
            String fieldValue = req.getParameter(fieldName); // Giá trị đã bị Java decode (VD: Thanh toan hoa don)

            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                // Ép mã hóa lại sang chuẩn US-ASCII trước khi nhét vào Map để băm chữ ký
                String encodedKey = java.net.URLEncoder.encode(fieldName, java.nio.charset.StandardCharsets.US_ASCII.toString());
                String encodedValue = java.net.URLEncoder.encode(fieldValue, java.nio.charset.StandardCharsets.US_ASCII.toString());

                fields.put(encodedKey, encodedValue);
            }
        }


        // 2. Tách chữ ký ra khỏi Map
        String vnp_SecureHash = req.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // 3. Băm lại dữ liệu để kiểm tra chữ ký (Hàm này bên trong đã tự xử lý URLEncoder rồi)
        String signValue = VNPayConfig.hashAllFields(fields);


        System.out.println("Chữ ký VNPay gửi về : " + vnp_SecureHash);
        System.out.println("Chữ ký Server tính ra: " + signValue);
        // Lấy thông tin cơ bản
        String txnRef = req.getParameter("vnp_TxnRef");
        String invoiceCode = (txnRef != null && txnRef.contains("_")) ? txnRef.split("_")[0] : txnRef;
        String responseCode = req.getParameter("vnp_ResponseCode");
        String transactionStatus = req.getParameter("vnp_TransactionStatus");
        String transactionNo = req.getParameter("vnp_TransactionNo");

        // 4. KIỂM TRA BẢO MẬT
        if (signValue.equals(vnp_SecureHash)) {
            // ---- CHỮ KÝ HỢP LỆ ----

            if ("00".equals(responseCode) && "00".equals(transactionStatus)) {

                // 1. Lấy số tiền khách đã trả (Chia 100 để ra tiền thật)
                long amountPaid = Long.parseLong(req.getParameter("vnp_Amount")) / 100;

                // 2. Gọi Database lấy Hóa đơn ra kiểm tra
                Invoice invoice = invoiceService.getInvoiceByCode(invoiceCode);

                if (invoice != null) {
                    // 1. KIỂM TRA: Nếu hóa đơn ĐÃ THANH TOÁN rồi thì không làm gì cả
                    if ("PAID".equals(invoice.getPaymentStatus())) {
                        req.setAttribute("status", "paid");
                        req.setAttribute("message", "Hóa đơn này đã được thanh toán trước đó.");
                        // Chuyển hướng luôn, không chạy xuống lệnh update phía dưới nữa
                        req.getRequestDispatcher("/views/vnpay/vnpay-result.jsp").forward(req, resp);
                        return;
                    }

                    // 2. Nếu vẫn là UNPAID thì mới kiểm tra tiền và update
                    if (invoice.getTotalAmount().longValue() == amountPaid) {
                        invoiceService.updatePaymentStatusByCode(invoiceCode, "PAID", "VNPay", transactionNo);

                        req.setAttribute("status", "success");
                        req.setAttribute("message", "Thanh toán thành công hóa đơn " + invoiceCode);
                    }

                if (invoice != null) {
                    // 3. SO SÁNH TIỀN
                    if (invoice.getTotalAmount().longValue() == amountPaid) {

                        // ĐÚNG TIỀN -> Cập nhật trạng thái PAID
                        invoiceService.updatePaymentStatusByCode(invoiceCode, "PAID", "VNPay", transactionNo);

                        // TRẢ VỀ THÔNG BÁO THÀNH CÔNG (Chỉ đặt ở trong đây thôi)
                        req.setAttribute("status", "success");
                        req.setAttribute("message", "Thanh toán thành công hóa đơn " + invoiceCode);
                        req.setAttribute("transactionNo", transactionNo);

                    } else {
                        // SAI TIỀN
                        req.setAttribute("status", "error");
                        req.setAttribute("message", "Thanh toán thành công nhưng SỐ TIỀN KHÔNG KHỚP. Vui lòng đối soát lại!");
                    }
                } else {
                    // KHÔNG TÌM THẤY HÓA ĐƠN
                    req.setAttribute("status", "error");
                    req.setAttribute("message", "Không tìm thấy hóa đơn trên hệ thống!");
                }

            } else {
                // THANH TOÁN THẤT BẠI (Hoặc khách bấm Hủy)
                req.setAttribute("status", "failed");
                req.setAttribute("message", "Giao dịch không thành công hoặc khách hàng đã hủy thanh toán.");
            }

        } else {
            // ---- CHỮ KÝ KHÔNG HỢP LỆ (Bị sửa URL) ----
            req.setAttribute("status", "error");
            req.setAttribute("message", "Cảnh báo: Dữ liệu giao dịch không hợp lệ. Vui lòng liên hệ quản trị viên!");
        }

        // Chuyển hướng sang trang giao diện thông báo cho khách hàng
        req.getRequestDispatcher("/views/vnpay/vnpay-result.jsp").forward(req, resp);
    }
}}