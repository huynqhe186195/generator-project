package com.generatorproject.controller.staff;

import com.generatorproject.model.Invoice;
import com.generatorproject.model.QuoteDetail;
import com.generatorproject.model.Users;
import com.generatorproject.services.*;
import com.generatorproject.utils.EmailUtil;

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
        String action = req.getParameter("action");

        // Khai báo Service (bạn có thể khai báo ở đầu class cũng được)
        VNPayService vnPayService = new VNPayService();
        Long invoiceId = Long.parseLong(req.getParameter("invoiceId"));
        if ("update_tax".equals(action)) {
            // ... (Code cập nhật thuế cũ của bạn giữ nguyên) ...

            double newTaxRate = Double.parseDouble(req.getParameter("taxRate"));

            // Gọi service update (Bạn cần viết hàm này ở DAO nhé)
            invoiceService.updateTaxRate(invoiceId, newTaxRate);

            resp.sendRedirect(req.getContextPath() + "/staff/invoice/detail?id=" + invoiceId + "&message=tax_updated");
        } else if ("send_vnpay".equals(action)) {
            try {


                // Lấy thông tin hóa đơn từ DB
                Invoice invoice = invoiceService.getInvoiceById(invoiceId);

                if (invoice != null) {
                    // BƯỚC 1: TẠO LINK VNPAY
                    long amountToPay = invoice.getTotalAmount().longValue(); // Chuyển tổng tiền thành số nguyên
                    String invoiceCode = invoice.getInvoiceCode();

                    // Gọi VNPayService để sinh link thanh toán
                    String vnpayLink = vnPayService.createPaymentUrl(req, amountToPay, invoiceCode);

                    // BƯỚC 2: TẠO LINK XEM/TẢI HÓA ĐƠN ONLINE DÀNH CHO KHÁCH (Cách 1)
                    // Hàm tự động lấy tên miền hiện tại (VD: http://localhost:8080/TenProject)
                    String domain = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
                    String pdfLink = domain + "/guest/invoice/view?code=" + invoiceCode;

                    // Lấy danh sách vật tư/dịch vụ để in ra bảng
                    // (Lưu ý: Nếu file này chưa khai báo biến quoteDetailService thì bạn nhớ thêm vào đầu class nhé)
                    List<QuoteDetail> details = null;
                    if (invoice.getQuoteId() != null && invoice.getQuoteId() > 0) {
                        details = quoteDetailService.findByQuoteId(invoice.getQuoteId());
                    }

                    // BƯỚC 3: SOẠN NỘI DUNG EMAIL (BẢNG CHI TIẾT + NÚT VNPAY + LINK PDF)
                    String toEmail = invoice.getCustomerEmail();
                    String subject = "[Gen-CMS] Chi tiết Hóa đơn " + invoiceCode + " & Yêu cầu thanh toán";

                    StringBuilder emailBody = new StringBuilder();
                    emailBody.append("<div style='font-family: Arial, sans-serif; max-width: 650px; margin: 0 auto; border: 1px solid #e2e8f0; border-radius: 8px; padding: 30px; color: #334155;'>");

                    // Header Email
                    emailBody.append("<div style='text-align: center; border-bottom: 2px solid #2563eb; padding-bottom: 20px; margin-bottom: 20px;'>");
                    emailBody.append("<h2 style='color: #2563eb; margin: 0;'>GEN-CMS CORPORATION</h2>");
                    emailBody.append("<p style='margin: 5px 0 0 0; color: #64748b;'>HÓA ĐƠN DỊCH VỤ SỬA CHỮA / BẢO TRÌ</p>");
                    emailBody.append("</div>");

                    // Lời chào & Thông tin Hóa đơn
                    emailBody.append("<p>Kính gửi Anh/Chị <strong>").append(invoice.getCustomerName()).append("</strong>,</p>");
                    emailBody.append("<p>Cảm ơn Quý khách đã tin tưởng sử dụng dịch vụ của chúng tôi. Dưới đây là chi tiết bảng kê cho hóa đơn mã số <strong>").append(invoiceCode).append("</strong>:</p>");

                    // Vẽ Bảng Chi Tiết Bằng HTML
                    emailBody.append("<table style='width: 100%; border-collapse: collapse; margin: 20px 0;'>");
                    emailBody.append("<thead><tr style='background-color: #f1f5f9; text-align: left;'>");
                    emailBody.append("<th style='padding: 12px; border: 1px solid #cbd5e1;'>Nội dung / Phụ tùng</th>");
                    emailBody.append("<th style='padding: 12px; border: 1px solid #cbd5e1; text-align: center;'>SL</th>");
                    emailBody.append("<th style='padding: 12px; border: 1px solid #cbd5e1; text-align: right;'>Thành tiền</th>");
                    emailBody.append("</tr></thead><tbody>");

                    // Đổ dữ liệu vật tư vào bảng
                    if (details != null && !details.isEmpty()) {
                        for (QuoteDetail item : details) {
                            emailBody.append("<tr>");
                            emailBody.append("<td style='padding: 12px; border: 1px solid #cbd5e1;'>").append(item.getDescription()).append("</td>");
                            emailBody.append("<td style='padding: 12px; border: 1px solid #cbd5e1; text-align: center;'>").append(item.getQuantity()).append("</td>");
                            emailBody.append("<td style='padding: 12px; border: 1px solid #cbd5e1; text-align: right; color: #0f172a; font-weight: bold;'>")
                                    .append(String.format("%,.0f", item.getTotalPrice())).append(" đ</td>");
                            emailBody.append("</tr>");
                        }
                    } else { // Nếu hóa đơn không có vật tư (Chỉ có tổng tiền)
                        emailBody.append("<tr>");
                        emailBody.append("<td style='padding: 12px; border: 1px solid #cbd5e1;'>Chi phí sửa chữa / Bảo trì thiết bị (Tham chiếu: #").append(invoice.getMaintenanceId()).append(")</td>");
                        emailBody.append("<td style='padding: 12px; border: 1px solid #cbd5e1; text-align: center;'>1</td>");
                        emailBody.append("<td style='padding: 12px; border: 1px solid #cbd5e1; text-align: right; color: #0f172a; font-weight: bold;'>")
                                .append(String.format("%,.0f", invoice.getSubtotal())).append(" đ</td>");
                        emailBody.append("</tr>");
                    }
                    emailBody.append("</tbody></table>");

                    // Phần Tổng Tiền
                    emailBody.append("<div style='text-align: right; margin-bottom: 30px; font-size: 15px;'>");
                    emailBody.append("<p>Cộng tiền dịch vụ: <strong>").append(String.format("%,.0f", invoice.getSubtotal())).append(" đ</strong></p>");
                    emailBody.append("<p>Thuế GTGT (VAT ").append(invoice.getTaxRate()).append("%): <strong>").append(String.format("%,.0f", invoice.getTaxAmount())).append(" đ</strong></p>");
                    emailBody.append("<h3 style='color: #dc2626; margin-top: 10px;'>TỔNG THANH TOÁN: ").append(String.format("%,.0f", invoice.getTotalAmount())).append(" VNĐ</h3>");
                    emailBody.append("</div>");

                    // Nút Thanh Toán VNPay nổi bật
                    emailBody.append("<div style='text-align: center; margin: 40px 0;'>");
                    emailBody.append("<a href='").append(vnpayLink).append("' style='background-color: #2563eb; color: #ffffff; padding: 14px 30px; text-decoration: none; border-radius: 6px; font-weight: bold; font-size: 16px; display: inline-block; box-shadow: 0 4px 6px rgba(37,99,235,0.2);'>THANH TOÁN QUA VNPAY NGAY</a>");
                    emailBody.append("<p style='font-size: 12px; color: #94a3b8; margin-top: 15px;'>Link thanh toán bảo mật, có hiệu lực trong 15 phút.</p>");
                    emailBody.append("</div>");

                    // ==========================================
                    // Link Xem/Tải PDF bản gốc
                    // ==========================================
                    emailBody.append("<div style='text-align: center; margin-top: 15px; padding: 15px; background-color: #f8fafc; border-radius: 6px;'>");
                    emailBody.append("<a href='").append(pdfLink).append("' style='color: #475569; text-decoration: underline; font-size: 14px; font-weight: 500;'>");
                    emailBody.append("📄 Nhấn vào đây để xem chi tiết và tải bản PDF của Hóa đơn");
                    emailBody.append("</a>");
                    emailBody.append("</div>");

                    // Footer Email
                    emailBody.append("<hr style='border: none; border-top: 1px solid #e2e8f0; margin: 30px 0;'>");
                    emailBody.append("<p style='font-size: 13px; color: #64748b; text-align: center;'>Nếu Quý khách có thắc mắc, vui lòng liên hệ Hotline: 1900 8888 hoặc Email: support@gen-cms.vn</p>");
                    emailBody.append("</div>");

                    // Gọi tiện ích Email của bạn (đã sửa lại dùng hàm EmailUtil.sendEmail như mẫu của bạn)
                    EmailUtil.sendEmail(toEmail, subject, emailBody.toString());

                    // BƯỚC 4: CHUYỂN HƯỚNG VỀ GIAO DIỆN VÀ BÁO THÀNH CÔNG
                    resp.sendRedirect(req.getContextPath() + "/staff/invoice/detail?id=" + invoiceId + "&message=vnpay_sent");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/staff/management?action=invoice-list&message=error");
            }
        }
    }
}