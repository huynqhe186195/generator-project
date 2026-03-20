package com.generatorproject.dao;

import com.generatorproject.mapper.InvoiceMapper;
import com.generatorproject.model.Invoice;
import java.util.List;

public class InvoiceDAO extends GenericDAO<Invoice> {

    /**
     * TẠO HÓA ĐƠN KẾ THỪA TỪ BẢNG QUOTES (Đã fix lỗi quote_id bị null)
     */
    public boolean createInvoiceFromRequest(Long requestId, Integer staffId, double taxRate) {

        // CÂU LỆNH SQL MỚI: Đã bổ sung quote_id và trích xuất q.total_amount từ bảng quotes
        String sqlSmartInsert =
                "INSERT INTO invoices (invoice_code, customer_id, quote_id, maintenance_id, created_by, subtotal, tax_rate, tax_amount, total_amount, payment_status, issued_date, due_date) " +
                        "SELECT " +
                        "   CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', FLOOR(RAND()*(9999-1000)+1000)), " +
                        "   q.customer_id, " +
                        "   q.id, " +         // <--- QUAN TRỌNG: Lưu ID của báo giá vào cột quote_id
                        "   q.maintenance_id, " +
                        "   ?, " +            // Tham số 1: Staff ID
                        "   q.total_amount, " + // Lấy Tổng tiền từ Báo giá
                        "   ?, " +            // Tham số 2: Tax Rate
                        "   (q.total_amount * ? / 100), " + // Tham số 3: Tax Amount
                        "   (q.total_amount + (q.total_amount * ? / 100)), " + // Tham số 4: Total Amount
                        "   'UNPAID', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY) " +
                        "FROM system_requests sr " +
                        "JOIN quotes q ON q.maintenance_id = CAST(JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.maintenanceId')) AS UNSIGNED) " +
                        "WHERE sr.id = ? AND q.status = 'APPROVED' " + // Tham số 5: Request ID
                        "ORDER BY q.id DESC LIMIT 1";

        try {
            update(sqlSmartInsert, staffId, taxRate, taxRate, taxRate, requestId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hàm kiểm tra xem Yêu cầu này đã được xuất hóa đơn chưa
     */
    public boolean hasInvoiceByRequest(Long requestId) {
        String sql = "SELECT COUNT(*) FROM invoices i " +
                "JOIN quotes q ON i.quote_id = q.id " +
                "JOIN system_requests sr ON q.maintenance_id = CAST(JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.maintenanceId')) AS UNSIGNED) " +
                "WHERE sr.id = ?";
        return count(sql, requestId) > 0;
    }

    // 1. Hàm tìm theo ID
    public Invoice findById(Long id) {
        String sql = "SELECT i.*, u.full_name as customer_name, u.email as customer_email, s.full_name as created_by_name " +
                "FROM invoices i " +
                "JOIN users u ON i.customer_id = u.id " +
                "LEFT JOIN users s ON i.created_by = s.id " +
                "WHERE i.id = ?";
        List<Invoice> list = query(sql, new InvoiceMapper(), id);
        return list.isEmpty() ? null : list.get(0);
    }

    // 2. Hàm cập nhật trạng thái thanh toán
    public boolean updatePaymentStatus(Long invoiceId, String status, String method, String note, int staffId) {
        String sql = "UPDATE invoices SET payment_status = ?, payment_method = ?, note = ?, paid_at = NOW() WHERE id = ?";

        if ("CANCELLED".equals(status)) {
            sql = "UPDATE invoices SET payment_status = ?, note = ? WHERE id = ?";
            update(sql, status, note, invoiceId);
        } else {
            update(sql, status, method, note, invoiceId);
        }
        return true;
    }

    public List<Invoice> findAll(String keyword, String status, int page, int pageSize) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new java.util.ArrayList<>();

        sql.append("SELECT i.*, u.full_name AS customer_name, u.email AS customer_email, s.full_name AS created_by_name ");
        sql.append("FROM invoices i ");
        sql.append("JOIN users u ON i.customer_id = u.id ");
        sql.append("LEFT JOIN users s ON i.created_by = s.id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.invoice_code LIKE ? OR u.full_name LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.payment_status = ? ");
            params.add(status);
        }

        sql.append("ORDER BY i.issued_date DESC ");

        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        return query(sql.toString(), new InvoiceMapper(), params.toArray());
    }

    public int countAll(String keyword, String status) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new java.util.ArrayList<>();

        sql.append("SELECT COUNT(*) FROM invoices i ");
        sql.append("JOIN users u ON i.customer_id = u.id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.invoice_code LIKE ? OR u.full_name LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.payment_status = ? ");
            params.add(status);
        }

        return count(sql.toString(), params.toArray());
    }

    public boolean updateTaxRate(Long invoiceId, double newTaxRate) {
        String sql = "UPDATE invoices SET " +
                "tax_rate = ?, " +
                "tax_amount = (subtotal * ? / 100), " +
                "total_amount = (subtotal + (subtotal * ? / 100)) " +
                "WHERE id = ? AND payment_status = 'UNPAID'";

        try {
            update(sql, newTaxRate, newTaxRate, newTaxRate, invoiceId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * Cập nhật trạng thái thanh toán từ VNPay Return/IPN dựa vào Mã Hóa Đơn (invoice_code)
     */
    public boolean updatePaymentStatusByCode(String invoiceCode, String paymentStatus, String paymentMethod, String transactionNo) {
        String noteContent = (transactionNo != null && !transactionNo.isEmpty())
                ? "Thanh toán qua VNPay. Mã GD: " + transactionNo
                : "Cập nhật thanh toán hệ thống";

        String sql;
        try {
            if ("PAID".equalsIgnoreCase(paymentStatus)) {
                // Nếu thành công thì chốt luôn giờ thanh toán (paid_at = NOW())
                sql = "UPDATE invoices SET payment_status = ?, payment_method = ?, note = ?, paid_at = NOW() WHERE invoice_code = ?";
                update(sql, paymentStatus, paymentMethod, noteContent, invoiceCode);
            } else {
                // Nếu thất bại/hủy thì không cập nhật paid_at
                sql = "UPDATE invoices SET payment_status = ?, payment_method = ?, note = ? WHERE invoice_code = ?";
                update(sql, paymentStatus, paymentMethod, noteContent, invoiceCode);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}