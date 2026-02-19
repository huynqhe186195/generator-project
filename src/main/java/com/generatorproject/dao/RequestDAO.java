package com.generatorproject.dao;

import com.generatorproject.mapper.SystemRequestMapper;
import com.generatorproject.model.SystemRequest;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class RequestDAO extends GenericDAO<SystemRequest> {

    public Long save(SystemRequest request) {
        String sql = "INSERT INTO system_requests (sender_id, receiver_role, request_type, request_data, status, created_at) "
                +
                "VALUES (?, ?, ?, ?, ?, NOW())";

        return insert(sql,
                request.getSenderId(),
                request.getReceiverRole(),
                request.getRequestType(),
                request.getRequestData(),
                request.getStatus() != null ? request.getStatus() : "PENDING");
    }

    public void update(SystemRequest request) {
        // Cập nhật tất cả các trường có thể thay đổi
        String sql = "UPDATE system_requests SET " +
                "sender_id = ?, " +
                "receiver_role = ?, " +
                "request_type = ?, " +
                "request_data = ?, " +
                "status = ?, " +
                "response_message = ?, " +
                "updated_at = NOW() " + // Tự động cập nhật thời gian
                "WHERE id = ?";

        // Truyền tham số theo đúng thứ tự trong câu SQL
        update(sql,
                request.getSenderId(),      // 1. sender_id
                request.getReceiverRole(),  // 2. receiver_role
                request.getRequestType(),   // 3. request_type
                request.getRequestData(),   // 4. request_data
                request.getStatus(),        // 5. status
                request.getResponseMessage(), // 6. response_message
                request.getId());           // 7. WHERE id
    }

    // Hàm tìm tất cả request gửi cho một Role cụ thể (Ví dụ: Admin vào xem danh
    // sách cần duyệt)
    public List<SystemRequest> findByReceiverRole(String role, String status) {
        String sql = "SELECT * FROM system_requests WHERE receiver_role = ? AND status = ? ORDER BY created_at DESC";
        return query(sql, new SystemRequestMapper(), role, status);
    }

    // Hàm tìm request theo ID (Để xem chi tiết trước khi duyệt)
    public SystemRequest findById(Long id) {
        String sql = "SELECT * FROM system_requests WHERE id = ?";
        List<SystemRequest> list = query(sql, new SystemRequestMapper(), id);
        return list.isEmpty() ? null : list.get(0);
    }

    // Kiểm tra xem Email này đã có request nào đang CHỜ chưa?
    // Áp dụng cho logic: Manager request tạo account
    public boolean isRequestPending(String email) {
        // Vì request_data là JSON, ta dùng LIKE để tìm chuỗi email bên trong.
        // VD: request_data = {"email":"huy@gmail.com", ...}
        // Logic: Tìm request loại CREATE_USER, đang PENDING, và JSON có chứa email này

        String sql = "SELECT * FROM system_requests WHERE request_type = 'CREATE_USER' " +
                "AND status = 'PENDING' AND request_data LIKE ?";

        List<SystemRequest> list = query(sql, new SystemRequestMapper(), "%" + email + "%");
        return list != null && !list.isEmpty();
    }

    // Tìm các request do chính người dùng này gửi đi (để hiện lịch sử)
    public List<SystemRequest> findBySenderId(Long senderId) {
        String sql = "SELECT * FROM system_requests WHERE sender_id = ? ORDER BY created_at DESC";
        return query(sql, new SystemRequestMapper(), senderId);
    }
    public int countByFilter(Date fromDate, Date toDate, String status, String requestType) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM system_requests WHERE request_type = ?");
        List<Object> params = new ArrayList<>();
        params.add(requestType);

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        if (fromDate != null) {
            sql.append(" AND DATE(created_at) >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND DATE(created_at) <= ?");
            params.add(toDate);
        }

        // Gọi hàm count của GenericDAO (trả về int hoặc long)
        return count(sql.toString(), params.toArray());
    }

    /**
     * Hàm lấy danh sách request có phân trang
     */
    public List<SystemRequest> findByFilter(Date fromDate, Date toDate, String status, String requestType, int page,
            int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM system_requests WHERE request_type = ?");
        List<Object> params = new ArrayList<>();
        params.add(requestType);

        // 1. Xây dựng câu SQL động dựa trên tham số
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        if (fromDate != null) {
            sql.append(" AND DATE(created_at) >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND DATE(created_at) <= ?");
            params.add(toDate);
        }

        // 2. Thêm sắp xếp và phân trang (LIMIT, OFFSET)
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");

        // Tính vị trí bắt đầu (offset)
        int offset = (page - 1) * pageSize;

        params.add(pageSize);
        params.add(offset);

        return query(sql.toString(), new SystemRequestMapper(), params.toArray());
    }

    public void updateStatus(int id, String status){
        String sql = "UPDATE system_requests SET status = ?, updated_at = NOW() WHERE id = ?";
        update(sql, status, id);
    }

    //lấy tất cả request gửi cho role (status có thể null/blank)
    public List<SystemRequest> findInboxByRole(String role, String status) {
        StringBuilder sql = new StringBuilder("SELECT * FROM system_requests WHERE receiver_role = ? ");
        List<Object> params = new ArrayList<>();
        params.add(role);

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status.trim());
        }

        sql.append("ORDER BY created_at DESC");
        return query(sql.toString(), new SystemRequestMapper(), params.toArray());
    }

    public void approve(long id, String responseMessage) {
        String sql = "UPDATE system_requests " +
                "SET status = 'APPROVED', response_message = ?, updated_at = NOW() " +
                "WHERE id = ?";
        update(sql, responseMessage, id);
    }

    public void reject(long id, String responseMessage) {
        String sql = "UPDATE system_requests " +
                "SET status = 'REJECTED', response_message = ?, updated_at = NOW() " +
                "WHERE id = ?";
        update(sql, responseMessage, id);
    }

}