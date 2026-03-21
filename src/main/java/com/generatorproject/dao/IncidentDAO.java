package com.generatorproject.dao;

import com.generatorproject.mapper.IncidentMapper;
import com.generatorproject.mapper.UserMapper;
import com.generatorproject.model.Incident;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class IncidentDAO extends GenericDAO<Incident> {
    public Long insertIncident(Incident incident) {
        String sql = """
                INSERT INTO incidents
                (product_id, reported_by, title, description, priority, status, preferred_date,
                 preferred_time_from, preferred_time_to, preferred_time_slot, is_flexible_time,
                 urgency_level, customer_note, location_snapshot, contract_id, input_serial_number)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        return insert(sql,
                incident.getProductId(),
                incident.getReportedBy(),
                incident.getTitle(),
                incident.getDescription(),
                incident.getPriority(),
                incident.getStatus(),
                incident.getPreferredDate(),
                incident.getPreferredTimeFrom(),
                incident.getPreferredTimeTo(),
                incident.getPreferredTimeSlot(),
                incident.isFlexibleTime(),
                incident.getUrgencyLevel(),
                incident.getCustomerNote(),
                incident.getLocationSnapshot(),
                incident.getContractId() == 0 ? null : incident.getContractId(),
                incident.getInputSerialNumber());
    }

    public Incident findById(long id) {
        String sql = """
                SELECT i.*,
                       p.serial_number AS product_name,
                       u1.full_name AS reporter_name,
                       u2.full_name AS technician_name
                FROM incidents i
                LEFT JOIN products p ON i.product_id = p.id
                LEFT JOIN users u1 ON i.reported_by = u1.id
                LEFT JOIN users u2 ON i.technician_id = u2.id
                WHERE i.id = ?
                """;
        List<Incident> results = query(sql, new IncidentMapper(), id);
        return results == null || results.isEmpty() ? null : results.get(0);
    }

    public void updateStatus(long id, String status) {
        String sql = "UPDATE incidents SET status = ? WHERE id = ?";
        update(sql, status, id);
    }

    public List<Incident> getAllIncident(){
        String sql = "select * from incidents";
        return query(sql, new IncidentMapper());
    }
    public int countIncidentsByFilter(Date fromDate, Date toDate, String status) {
        // 1. Khởi tạo câu SQL cơ bản
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM incidents WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // 2. Điều kiện: Từ ngày (fromDate)
        if (fromDate != null) {
            // Dùng hàm DATE() của MySQL để chỉ so sánh ngày, bỏ qua giờ phút giây
            sql.append(" AND DATE(created_at) >= ?");
            params.add(fromDate);
        }

        // 3. Điều kiện: Đến ngày (toDate)
        if (toDate != null) {
            sql.append(" AND DATE(created_at) <= ?");
            params.add(toDate);
        }

        // 4. Điều kiện: Trạng thái (status)

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        // 5. Thực thi và trả về kết quả

        return count(sql.toString(), params.toArray());
    }
    public List<Incident> getIncidentByFilter(Date fromDate, Date toDate, String status, int page, int pageSize) {
        // 1. Sử dụng JOIN để lấy thêm tên Product, Reporter, Technician cho Model
        StringBuilder sql = new StringBuilder(
                "SELECT i.*, " +
                        "p.serial_number AS product_name, " +  // <-- SỬA TẠI ĐÂY
                        "u1.full_name AS reporter_name, " +
                        "u2.full_name AS technician_name " +
                        "FROM incidents i " +
                        "LEFT JOIN products p ON i.product_id = p.id " +
                        "LEFT JOIN users u1 ON i.reported_by = u1.id " +
                        "LEFT JOIN users u2 ON i.technician_id = u2.id " +
                        "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // 2. Lọc theo Từ ngày (So sánh phần ngày của created_at)
        if (fromDate != null) {
            sql.append(" AND DATE(i.created_at) >= ?");
            params.add(fromDate);
        }

        // 3. Lọc theo Đến ngày
        if (toDate != null) {
            sql.append(" AND DATE(i.created_at) <= ?");
            params.add(toDate);
        }

        // 4. Lọc theo Trạng thái (NEW, ASSIGNED,...)
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND i.status = ?");
            params.add(status);
        }

        // 5. Phân trang (Pagination)
        // Sắp xếp giảm dần theo ngày tạo (Mới nhất lên đầu)
        sql.append(" ORDER BY i.created_at DESC LIMIT ? OFFSET ?");

        int offset = (page - 1) * pageSize;
        params.add(pageSize);
        params.add(offset);

        // 6. Trả về kết quả dùng IncidentMapper
        return query(sql.toString(), new IncidentMapper(), params.toArray());
    }


}
