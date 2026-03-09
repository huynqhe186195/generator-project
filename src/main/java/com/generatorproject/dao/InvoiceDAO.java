package com.generatorproject.dao;

import com.generatorproject.mapper.InvoiceMapper;
import com.generatorproject.model.Invoice;
import com.generatorproject.model.Quote; // Giả sử bạn đã có model Quote
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

public class InvoiceDAO extends GenericDAO<Invoice> {

    // Hàm sinh mã hóa đơn ngẫu nhiên: INV-20260304-1234
    private String generateInvoiceCode() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        int randomNum = new Random().nextInt(9000) + 1000; // Số từ 1000-9999
        return "INV-" + dateStr + "-" + randomNum;
    }

    /**
     * TẠO HÓA ĐƠN TỪ BÁO GIÁ
     * @param quoteId: ID của báo giá đã được duyệt
     * @param staffId: ID của nhân viên tạo hóa đơn
     * @param taxRate: Thuế VAT (VD: 8.0 cho 8%)
     */
    public boolean createInvoiceFromQuote(Long quoteId, Integer staffId, double taxRate) {


        // Để code ngắn gọn, tôi viết logic query lồng vào insert luôn:
        // Lấy dữ liệu từ bảng quotes insert thẳng sang invoices
        String sqlSmartInsert =
                "INSERT INTO invoices (invoice_code, customer_id, quote_id, maintenance_id, created_by, subtotal, tax_rate, tax_amount, total_amount, payment_status, issued_date, due_date) " +
                        "SELECT " +
                        "   CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', FLOOR(RAND()*(9999-1000)+1000)), " + // Sinh mã
                        "   q.customer_id, " +
                        "   q.id, " +
                        "   q.maintenance_id, " +
                        "   ?, " +   // Staff ID
                        "   q.total_amount, " + // Subtotal
                        "   ?, " +   // Tax Rate (VD: 8)
                        "   (q.total_amount * ? / 100), " + // Tax Amount
                        "   (q.total_amount + (q.total_amount * ? / 100)), " + // Total Amount
                        "   'UNPAID', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY) " +
                        "FROM quotes q WHERE q.id = ?";

        // Gọi hàm update của GenericDAO
        // Thứ tự tham số: staffId, taxRate, taxRate, taxRate, quoteId
        try {
            update(sqlSmartInsert, staffId, taxRate, taxRate, taxRate, quoteId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hàm kiểm tra xem báo giá này đã có hóa đơn chưa
    public boolean hasInvoice(Long quoteId) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE quote_id = ?";
        return count(sql, quoteId) > 0;
    }
    // Trong InvoiceDAO.java

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

        // Lưu ý: Nếu status là CANCELLED thì paid_at nên để NULL hoặc giữ nguyên, tùy logic.
        // Ở đây tôi viết đơn giản cho trường hợp PAID.
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

        // SELECT có JOIN để lấy thông tin phụ hiển thị
        sql.append("SELECT i.*, u.full_name AS customer_name, u.email AS customer_email, s.full_name AS created_by_name ");
        sql.append("FROM invoices i ");
        sql.append("JOIN users u ON i.customer_id = u.id "); // Join lấy tên khách
        sql.append("LEFT JOIN users s ON i.created_by = s.id "); // Join lấy tên nhân viên (Left Join vì có thể null)
        sql.append("WHERE 1=1 "); // Mẹo để dễ nối chuỗi AND

        // 1. Xử lý tìm kiếm từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.invoice_code LIKE ? OR u.full_name LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // 2. Xử lý lọc trạng thái
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.payment_status = ? ");
            params.add(status);
        }

        // 3. Sắp xếp (Mới nhất lên đầu)
        sql.append("ORDER BY i.issued_date DESC ");

        // 4. Phân trang
        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        // Gọi hàm query của GenericDAO
        return query(sql.toString(), new InvoiceMapper(), params.toArray());
    }

    /**
     * Hàm đếm tổng số dòng (Dùng để tính tổng số trang cho phân trang)
     */
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
}