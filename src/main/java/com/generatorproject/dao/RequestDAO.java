package com.generatorproject.dao;

import com.generatorproject.mapper.SystemRequestMapper;
import com.generatorproject.model.SystemRequest;

import java.util.List;

public class RequestDAO extends GenericDAO<SystemRequest> {

    public Long save(SystemRequest request) {
        String sql = "INSERT INTO system_requests (sender_id, receiver_role, request_type, request_data, status, created_at) " +
                "VALUES (?, ?, ?, ?, ?, NOW())";

        return insert(sql,
                request.getSenderId(),
                request.getReceiverRole(),
                request.getRequestType(),
                request.getRequestData(),
                request.getStatus() != null ? request.getStatus() : "PENDING"
        );
    }

    public void update(SystemRequest request) {
        String sql = "UPDATE system_requests SET status = ?, response_message = ?, updated_at = NOW() WHERE id = ?";
        update(sql, request.getStatus(), request.getResponseMessage(), request.getId());
    }

    // Hàm tìm tất cả request gửi cho một Role cụ thể (Ví dụ: Admin vào xem danh sách cần duyệt)
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
}