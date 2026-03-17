package com.generatorproject.services;

import com.generatorproject.dao.InvoiceDAO;
import com.generatorproject.dao.QuoteDAO;
import com.generatorproject.model.Invoice;
import com.generatorproject.model.Quote;
import com.generatorproject.model.Users;

import java.util.List;

public class InvoiceService implements IInvoiceService {

    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private QuoteDAO quoteDAO = new QuoteDAO();


    @Override
    public boolean createInvoiceFromRequest(Long requestId, Integer staffId, double taxRate) {
        return invoiceDAO.createInvoiceFromRequest(requestId,staffId,taxRate);
    }

    @Override
    public boolean hasInvoiceByRequest(Long requestId) {
        return invoiceDAO.hasInvoiceByRequest(requestId);
    }

    @Override
    public Invoice getInvoiceById(Long id) {
        return invoiceDAO.findById(id);
    }

    @Override
    public List<Invoice> getAllInvoices(String keyword, String status, int page, int pageSize) {
        // Gọi hàm DAO tìm kiếm (bạn cần triển khai thêm trong InvoiceDAO)
        return invoiceDAO.findAll(keyword, status, page, pageSize);
    }

    /**
     * LOGIC XÁC NHẬN THANH TOÁN
     * Khi khách chuyển khoản xong, Staff vào bấm "Xác nhận đã thu tiền"
     */
    @Override
    public boolean confirmPayment(Long invoiceId, String paymentMethod, String note, Users staff) throws Exception {
        // 1. Lấy hóa đơn hiện tại
        Invoice invoice = invoiceDAO.findById(invoiceId);
        if (invoice == null) throw new Exception("Không tìm thấy hóa đơn!");

        if ("PAID".equalsIgnoreCase(invoice.getPaymentStatus())) {
            throw new Exception("Hóa đơn này đã được thanh toán rồi!");
        }

        if ("CANCELLED".equalsIgnoreCase(invoice.getPaymentStatus())) {
            throw new Exception("Hóa đơn này đã bị hủy, không thể thanh toán!");
        }

        // 2. Cập nhật trạng thái
        // Sử dụng Builder nếu cần tạo object mới, hoặc gọi hàm updateStatus của DAO
        // Ở đây ta gọi hàm DAO chuyên dụng
        return invoiceDAO.updatePaymentStatus(invoiceId, "PAID", paymentMethod, note, staff.getId());
    }

    @Override
    public boolean cancelInvoice(Long invoiceId, String reason, Users staff) throws Exception {
        Invoice invoice = invoiceDAO.findById(invoiceId);
        if (invoice == null) throw new Exception("Không tìm thấy hóa đơn!");

        if ("PAID".equalsIgnoreCase(invoice.getPaymentStatus())) {
            throw new Exception("Hóa đơn đã thanh toán, cần quy trình hoàn tiền (Refund) thay vì hủy ngang!");
        }

        return invoiceDAO.updatePaymentStatus(invoiceId, "CANCELLED", null, reason, staff.getId());
    }
    @Override
    public int countInvoices(String keyword, String status) {
        return invoiceDAO.countAll(keyword, status); // Hàm này bạn đã có ở InvoiceDAO
    }

    @Override
    public boolean updateTaxRate(Long invoiceId, double newTaxRate) {
        return invoiceDAO.updateTaxRate(invoiceId,newTaxRate);
    }

    @Override
    public boolean updatePaymentStatusByCode(String invoiceCode, String paymentStatus, String paymentMethod, String transactionNo) {
        return invoiceDAO.updatePaymentStatusByCode(invoiceCode,paymentStatus,paymentMethod,transactionNo);
    }
}