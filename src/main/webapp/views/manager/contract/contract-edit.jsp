<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <title>Chỉnh sửa Hợp đồng</title>
</head>
<body>
    <div class="container mt-4">
        <div class="card shadow-sm border-warning">

            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">
                    <i class="fa fa-edit"></i> CẬP NHẬT HỢP ĐỒNG
                </h4>
            </div>

            <div class="card-body">
                <form action="contracts" method="post">

                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${contract.id}">

                    <h6 class="text-muted border-bottom pb-2 mb-3"><i class="fa fa-file-contract"></i> Thông tin chung</h6>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Số Hợp Đồng (*)</label>
                            <input type="text" name="contractNumber" class="form-control" required
                                   value="${contract.contractNumber}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="ACTIVE" ${contract.status == 'ACTIVE' ? 'selected' : ''}>Hiệu lực (Active)</option>
                                <option value="EXPIRED" ${contract.status == 'EXPIRED' ? 'selected' : ''}>Hết hạn (Expired)</option>
                                <option value="TERMINATED" ${contract.status == 'TERMINATED' ? 'selected' : ''}>Đã hủy (Terminated)</option>
                            </select>
                        </div>
                    </div>

                    <h6 class="text-muted border-bottom pb-2 mb-3 mt-4"><i class="fa fa-server"></i> Máy phát điện & Chủ sở hữu</h6>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Khách hàng (*)</label>
                            <select name="customerId" class="form-select" required>
                                <c:forEach var="u" items="${customers}">
                                    <option value="${u.id}" ${contract.customerId == u.id ? 'selected' : ''}>
                                        ${u.fullName} (${u.email})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Tên máy phát điện (*)</label>

                            <input id="inputModelNameField" type="text" class="form-control" name="inputModelName"
                                   list="modelSuggestions"
                                   value="${contract.productModelName}"
                                   required autocomplete="off">

                            <datalist id="modelSuggestions">
                                <c:forEach items="${models}" var="m">
                                    <option value="${m.name}"></option>
                                </c:forEach>
                            </datalist>
                            <small class="text-muted">Có thể sửa tên máy nếu trước đó nhập sai.</small>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Số Serial (*)</label>
                            <select id="serialNumberSelect" name="serialNumber" class="form-select" required>
                                <c:forEach var="cp" items="${contractProducts}">
                                    <option value="${cp.serialNumber}"
                                            data-model="${cp.modelName}"
                                            data-year="${cp.manufactureYear}"
                                            data-location="${cp.currentLocation}"
                                            ${contract.productSerial == cp.serialNumber ? 'selected' : ''}>
                                            ${cp.serialNumber}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-muted">Nếu hợp đồng có nhiều máy, chọn đúng serial cần chỉnh sửa.</small>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Năm sản xuất</label>
                            <input id="manufactureYearInput" type="number" name="manufactureYear" class="form-control"
                                   min="1990" max="2100"
                                   value="${contract.productManufactureYear}">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Vị trí lắp đặt</label>
                            <input id="currentLocationInput" type="text" name="currentLocation" class="form-control"
                                   value="">
                        </div>
                    </div>

                    <h6 class="text-muted border-bottom pb-2 mb-3 mt-4"><i class="fa fa-calendar-alt"></i> Thời gian hiệu lực</h6>

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

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger mt-3">
                            <i class="fa fa-exclamation-triangle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                        <a href="contracts" class="btn btn-secondary me-2">
                            <i class="fa fa-arrow-left"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-warning px-4 text-dark fw-bold">
                            <i class="fa fa-save"></i> Lưu thay đổi
                        </button>
                    </div>

                </form>
            </div>
        </div>
    </div>

<script>
    (function () {
        const serialSelect = document.getElementById('serialNumberSelect');
        const modelField = document.getElementById('inputModelNameField');
        const yearField = document.getElementById('manufactureYearInput');
        const locationField = document.getElementById('currentLocationInput');

        if (!serialSelect) return;

        const syncBySerial = () => {
            const opt = serialSelect.options[serialSelect.selectedIndex];
            if (!opt) return;

            const model = opt.getAttribute('data-model');
            const year = opt.getAttribute('data-year');
            const location = opt.getAttribute('data-location');

            if (modelField && model) modelField.value = model;
            if (yearField) yearField.value = (year && year !== 'null') ? year : '';
            if (locationField) locationField.value = (location && location !== 'null') ? location : '';
        };

        serialSelect.addEventListener('change', syncBySerial);
        syncBySerial();
    })();
</script>

</body>