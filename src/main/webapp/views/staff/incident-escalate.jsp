<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Gửi yêu cầu lên Manager</title>

<div class="container mt-4">
    <div class="mb-3">
        <a href="<c:url value='/staff/incident-list'/>" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="fas fa-paper-plane me-2"></i>BƯỚC 2: PHÂN CÔNG & GỬI MANAGER</h5>
                </div>

                <div class="card-body bg-light p-4">
                    <form action="<c:url value='/staff/request-manager'/>" method="POST">
                        <input type="hidden" name="incident_id" value="${req.id}" />

                        <div class="alert alert-primary d-flex align-items-center mb-4 border-0 shadow-sm">
                            <i class="fas fa-info-circle fa-2x me-3"></i>
                            <div>
                                <div class="text-uppercase small fw-bold opacity-75">Đang xử lý yêu cầu:</div>
                                <div class="fw-bold">${req.info.title}</div>
                                <div class="small">Thiết bị: <strong>${prod.modelName}</strong> (SN: ${prod.serialNumber})</div>
                            </div>
                        </div>

                        <div class="card bg-white border-0 shadow-sm p-3">
                            <h6 class="text-secondary fw-bold mb-3 border-bottom pb-2">Tạo phương án xử lý trình Manager</h6>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Loại hình xử lý</label>
                                    <select name="type" class="form-select">
                                        <option value="REPAIR">Sửa chữa (Repair)</option>
                                        <option value="REPLACEMENT">Thay thế phụ tùng</option>
                                        <option value="INSPECTION">Kiểm tra hiện trường (Inspection)</option>
                                        <option value="PERIODIC">Bảo trì định kỳ (Maintenance)</option>

                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Mức độ ưu tiên</label>
                                    <select name="priority" class="form-select">
                                        <option value="LOW">Thấp (Không gấp)</option>
                                        <option value="MEDIUM" selected>Trung bình</option>
                                        <option value="HIGH">Cao (Ưu tiên xử lý)</option>
                                        <option value="CRITICAL">Khẩn cấp (Xử lý ngay)</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Thời lượng dự kiến (phút)</label>
                                    <input type="number" name="estimated_duration_minutes" class="form-control" min="30" step="30" value="120" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Số kỹ thuật viên cần</label>
                                    <input type="number" name="required_technician_count" class="form-control" min="1" max="5" value="1" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Địa điểm xử lý</label>
                                    <input type="text" name="service_location" class="form-control" value="${not empty incidentEntity.locationSnapshot ? incidentEntity.locationSnapshot : prod.currentLocation}" placeholder="Địa điểm thực hiện sửa chữa">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold d-block">Cần chuẩn bị phụ tùng</label>
                                    <div class="form-check form-switch mt-2">
                                        <input class="form-check-input" type="checkbox" name="requires_parts_preparation" id="requiresPartsPreparation" value="1">
                                        <label class="form-check-label" for="requiresPartsPreparation">Có chuẩn bị vật tư/phụ tùng trước</label>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-bold">Ghi chú vật tư / kỹ năng cần</label>
                                    <textarea name="parts_note" class="form-control" rows="2" placeholder="Ví dụ: Kiểm tra ATS, chuẩn bị lọc gió và dây curoa nếu cần..."></textarea>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-bold">Ghi chú trình Manager</label>
                                    <textarea name="staff_note" class="form-control" rows="3" placeholder="Ví dụ: Khách báo cần xử lý gấp vào buổi sáng..."></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="text-end mt-4">
                            <button type="submit" class="btn btn-primary px-5 fw-bold shadow">
                                <i class="fas fa-paper-plane me-2"></i>Trình duyệt Manager
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
