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
                            <h6 class="text-secondary fw-bold mb-3 border-bottom pb-2">Đề xuất phương án xử lý</h6>

                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label fw-bold">Chỉ định Kỹ thuật viên <span class="text-danger">*</span></label>
                                    <select name="technician_id" class="form-select py-2" required>
                                        <option value="">-- Chọn nhân viên phụ trách --</option>
                                        <c:forEach items="${listTechnicians}" var="tech">
                                            <option value="${tech.id}">${tech.fullName} - ${tech.email}</option>
                                        </c:forEach>
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
                                    <label class="form-label fw-bold">Loại hình xử lý</label>
                                    <select name="type" class="form-select">
                                        <option value="REPAIR">Sửa chữa (Repair)</option>
                                        <option value="INSPECTION">Kiểm tra hiện trường (Inspection)</option>
                                        <option value="PERIODIC">Bảo trì định kỳ (Maintenance)</option>

                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Ngày hẹn sửa <span class="text-danger">*</span></label>
                                    <input type="date" name="preferredDate" class="form-control"
                                           value="${req.info.preferredDate}" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Giờ bắt đầu</label>
                                    <input type="time" name="startTime" class="form-control"
                                           value="${req.info.startTime}">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Giờ kết thúc</label>
                                    <input type="time" name="endTime" class="form-control"
                                           value="${req.info.endTime}">
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