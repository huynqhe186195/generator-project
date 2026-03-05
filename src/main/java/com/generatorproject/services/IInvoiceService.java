package com.generatorproject.services;

import com.generatorproject.model.Invoice;
import com.generatorproject.model.Users;
import java.util.List;

public interface IInvoiceService {

    // Tạo hóa đơn mới từ Báo giá
    boolean createInvoice(Long quoteId, double taxRate, Users currentUser) throws Exception;

    // Lấy chi tiết hóa đơn
    Invoice getInvoiceById(Long id);

    // Lấy danh sách hóa đơn (có phân trang/lọc)
    List<Invoice> getAllInvoices(String keyword, String status, int page, int pageSize);

    // Cập nhật trạng thái thanh toán (Staff xác nhận tiền về)
    boolean confirmPayment(Long invoiceId, String paymentMethod, String note, Users staff) throws Exception;

    // Hủy hóa đơn (nếu có sai sót)
    boolean cancelInvoice(Long invoiceId, String reason, Users staff) throws Exception;
    int countInvoices(String keyword, String status);
}