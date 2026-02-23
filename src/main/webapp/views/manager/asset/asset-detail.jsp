<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <title>Hồ sơ máy: ${p.modelName}</title>
</head>
<body>
    <div class="container mt-4">

        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="assets">Tài sản</a></li>
                <li class="breadcrumb-item active" aria-current="page">${p.serialNumber}</li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card shadow border-0 text-center p-3">
                    <div class="bg-light rounded-circle mx-auto d-flex align-items-center justify-content-center mb-3"
                         style="width: 120px; height: 120px;">
                        <i class="fa fa-bolt text-warning fa-4x"></i>
                    </div>
                    <h5 class="fw-bold text-primary mb-1">${p.modelName}</h5>
                    <p class="text-muted small mb-2">${p.serialNumber}</p>

                    <div class="mb-3">
                        <c:choose>
                            <c:when test="${p.status == 'RUNNING' || p.status == 'READY'}">
                                <span class="badge bg-success px-3 py-2 rounded-pill">Đang hoạt động</span>
                            </c:when>
                            <c:when test="${p.status == 'MAINTENANCE'}">
                                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Đang bảo trì</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger px-3 py-2 rounded-pill">Gặp sự cố</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#updateHoursModal">
                            <i class="fa fa-tachometer-alt"></i> Cập nhật Giờ chạy
                        </button>
                    </div>
                </div>

                <div class="card shadow border-0 mt-3">
                    <div class="card-body">
                        <h6 class="text-muted text-uppercase small fw-bold">Tổng giờ vận hành</h6>
                        <h2 class="mb-0 text-dark fw-bold">${p.totalRunningHours} <small class="fs-6 text-muted">giờ</small></h2>
                        <div class="progress mt-2" style="height: 5px;">
                            <div class="progress-bar bg-info" style="width: 75%"></div>
                        </div>
                        <small class="text-muted mt-2 d-block">Cập nhật lần cuối: Hôm nay</small>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow border-0 h-100">
                    <div class="card-header bg-white border-bottom-0 pt-3 ps-3">
                        <ul class="nav nav-tabs card-header-tabs" id="assetTabs" role="tablist">
                            <li class="nav-item">
                                <button class="nav-link active fw-bold" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button">
                                    <i class="fa fa-info-circle"></i> Thông tin chung
                                </button>
                            </li>
                            <li class="nav-item">
                                <button class="nav-link fw-bold" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button">
                                    <i class="fa fa-history"></i> Lịch sử hoạt động
                                </button>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body">
                        <div class="tab-content" id="assetTabsContent">

                            <div class="tab-pane fade show active" id="info" role="tabpanel">
                                <h6 class="text-primary border-bottom pb-2 mb-3">Thông tin Sở hữu & Vị trí</h6>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Chủ sở hữu:</div>
                                    <div class="col-md-8 fw-bold">${p.customerName}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Vị trí hiện tại:</div>
                                    <div class="col-md-8">
                                        <i class="fa fa-map-marker-alt text-danger"></i>
                                        ${p.currentLocation != null ? p.currentLocation : 'Chưa cập nhật'}
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Email:</div>
                                    <div class="col-md-8">
                                        ${p.customerEmail != null ? p.customerEmail : 'Chưa cập nhật'}
                                        </div>
                                </div>

                                <h6 class="text-primary border-bottom pb-2 mb-3 mt-4">Thông số Kỹ thuật</h6>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Năm sản xuất:</div>
                                    <div class="col-md-8">${p.manufactureYear}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Serial Number:</div>
                                    <div class="col-md-8 font-monospace">${p.serialNumber}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Ngày mua:</div>
                                    <div class="col-md-8">
                                        <fmt:formatDate value="${p.purchaseDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="history" role="tabpanel">
                                <div class="text-center py-5 text-muted">
                                    <i class="fa fa-clipboard-list fa-3x mb-3 opacity-50"></i>
                                    <p>Chưa có dữ liệu lịch sử bảo trì/sự cố.</p>
                                    <button class="btn btn-sm btn-outline-primary">Thêm nhật ký mới</button>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updateHoursModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="assets" method="post">
                <input type="hidden" name="action" value="update_hours">
                <input type="hidden" name="id" value="${p.id}">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật Giờ chạy</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Số giờ chạy hiện tại</label>
                            <input type="number" step="0.1" name="runningHours" class="form-control" value="${p.totalRunningHours}">
                            <small class="text-muted">Nhập số giờ hiển thị trên đồng hồ máy.</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu cập nhật</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

</body>