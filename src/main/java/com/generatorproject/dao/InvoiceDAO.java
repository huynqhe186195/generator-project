package com.generatorproject.dao;

import com.generatorproject.mapper.InvoiceMapper;
import com.generatorproject.model.Invoice;
import com.generatorproject.model.Quote; // Giả sử bạn đã có model Quote
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

public class InvoiceDAO extends GenericDAO<Invoice> {



    public boolean createInvoiceFromRequest(Long requestId, Integer staffId, double taxRate) {

        String sqlSmartInsert =
                "INSERT INTO invoices (invoice_code, customer_id, maintenance_id, created_by, subtotal, tax_rate, tax_amount, total_amount, payment_status, issued_date, due_date) " +
                        "SELECT " +
                        "   CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', FLOOR(RAND()*(9999-1000)+1000)), " +
                        "   p.customer_id, " +
                        "   m.id, " +
                        "   ?, " +  // Tham số 1: Staff ID

                        // Lấy tổng tiền (Ưu tiên grandTotal, nếu không có thì lấy partsTotal)
                        "   CAST(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.partsTotal')), JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.partsTotal')), 0) AS DECIMAL(15,2)), " +

                        "   ?, " +  // Tham số 2: Tax Rate

                        // Tính Tiền Thuế = Tổng tiền * (taxRate / 100)
                        "   (CAST(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.partsTotal')), JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.partsTotal')), 0) AS DECIMAL(15,2)) * ? / 100), " +

                        // Tính Tổng Thanh Toán = Tổng tiền * (1 + taxRate / 100)
                        "   (CAST(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.partsTotal')), JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.partsTotal')), 0) AS DECIMAL(15,2)) * (1 + ? / 100)), " +

                        "   'UNPAID', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY) " +
                        "FROM system_requests sr " +
                        // Bóc mã maintenanceId từ JSON để nối bảng
                        "JOIN maintenances m ON m.id = CAST(JSON_UNQUOTE(JSON_EXTRACT(sr.request_data, '$.maintenanceId')) AS UNSIGNED) " +
                        "JOIN products p ON p.id = m.product_id " +
                        "WHERE sr.id = ?"; // Tham số 5: Request ID
        try {
            // Thứ tự truyền param: staffId, taxRate, taxRate, taxRate, requestId
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