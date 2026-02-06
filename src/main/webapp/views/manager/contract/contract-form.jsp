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

                    <h6 class="text-primary mb-3"><i class="fa fa-file-contract me-1"></i> Thông tin chung</h6>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Số Hợp Đồng (*)</label>
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

                    <hr class="my-4 opacity-25">

                    <h6 class="text-primary mb-3"><i class="fa fa-hdd me-1"></i> Thông tin Máy & Khách hàng</h6>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Khách hàng (*)</label>
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
                            <label class="form-label fw-bold">Tên máy phát điện (*)</label>

                            <input type="text" class="form-control" name="inputModelName"
                                   list="modelSuggestions"
                                   placeholder="Gõ tên máy để tìm (VD: Denyo...)"
                                   value="${contract.productModelName}"
                                   required autocomplete="off">

                            <datalist id="modelSuggestions">
                                <c:forEach items="${models}" var="m">
                                    <option value="${m.name}"></option>
                                </c:forEach>
                            </datalist>
                            <small class="text-muted fst-italic">
                                <i class="fa fa-search me-1"></i>Hệ thống sẽ tự tìm ID dựa trên tên bạn nhập.
                            </small>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Số Serial Máy (*)</label>
                            <input type="text" name="serialNumber" class="form-control" required
                                   placeholder="VD: SN-2026-8888"
                                   value="${contract.productSerial}">
                            <small class="text-muted">
                                Nếu là máy mới, hệ thống sẽ tự động tạo hồ sơ máy.
                            </small>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Năm sản xuất</label>
                            <input type="number" name="manufactureYear" class="form-control"
                                   placeholder="VD: 2025" min="1990" max="2100"
                                   value="${contract.productManufactureYear}">
                        </div>
                    </div>

                    <hr class="my-4 opacity-25">

                    <h6 class="text-primary mb-3"><i class="fa fa-calendar-alt me-1"></i> Thời hạn bảo hành</h6>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày bắt đầu</label>
                            <input type="date" name="startDate" class="form-control" required
                                   value="${contract.startDate}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày kết thúc</label>
                            <input type="date" name="endDate" class="form-control" required
                                   value="${contract.endDate}">
                        </div>
                    </div>

                    <div class="text-end mt-4">
                        <a href="contracts" class="btn btn-secondary me-2">
                            <i class="fa fa-arrow-left me-1"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="fa fa-save me-1"></i> Lưu Hợp Đồng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>