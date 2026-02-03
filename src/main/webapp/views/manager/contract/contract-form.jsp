<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <title>${not empty contract ? 'Chỉnh sửa Hợp đồng' : 'Tạo Hợp đồng Mới'}</title>
</head>
<body>
    <div class="container mt-4">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    <i class="fa ${not empty contract ? 'fa-edit' : 'fa-plus-circle'}"></i>
                    ${not empty contract ? 'Cập nhật Hợp đồng' : 'Thêm mới Hợp đồng'}
                </h4>
            </div>
            <div class="card-body">

                <form action="contracts" method="post">
                    <input type="hidden" name="action" value="${not empty contract ? 'update' : 'create'}">

                    <c:if test="${not empty contract}">
                        <input type="hidden" name="id" value="${contract.id}">
                    </c:if>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Số Hợp Đồng</label>
                            <input type="text" name="contractNumber" class="form-control" required
                                   value="${contract.contractNumber}" placeholder="VD: HD-2026-001">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="ACTIVE" ${contract.status == 'ACTIVE' ? 'selected' : ''}>Hiệu lực</option>
                                <option value="EXPIRED" ${contract.status == 'EXPIRED' ? 'selected' : ''}>Hết hạn</option>
                                <option value="TERMINATED" ${contract.status == 'TERMINATED' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Khách hàng</label>
                            <select name="customerId" class="form-select" required>
                                <option value="">-- Chọn khách hàng --</option>
                                <c:forEach var="u" items="${customers}">
                                    <option value="${u.id}" ${contract.customerId == u.id ? 'selected' : ''}>
                                        ${u.fullName} (${u.email})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Số Serial Máy (*)</label>
                            <input type="text" name="serialNumber" class="form-control" required
                                   placeholder="Nhập chính xác số Serial trên hợp đồng (VD: SN-2026-8888)"
                                   value="${contract.productSerial}"> <small class="text-muted">
                                <i class="fa fa-info-circle"></i> Nếu máy mới, hệ thống sẽ tự động tạo hồ sơ máy.
                            </small>
                        </div>

                        <div class="col-md-6">
                                <label class="form-label fw-bold">Năm sản xuất (Của máy)</label>
                                <input type="number" name="manufactureYear" class="form-control"
                                       placeholder="VD: 2025" min="1990" max="2100">
                                <small class="text-muted">Nếu máy mới, hệ thống sẽ lưu năm này vào hồ sơ.</small>
                            </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày bắt đầu</label>
                            <input type="date" name="startDate" class="form-control" required
                                   value="${contract.startDate}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày kết thúc (Hết bảo hành)</label>
                            <input type="date" name="endDate" class="form-control" required
                                   value="${contract.endDate}">
                        </div>
                    </div>

                    <div class="text-end mt-4">
                        <a href="contracts" class="btn btn-secondary me-2">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-save"></i> Lưu lại
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>