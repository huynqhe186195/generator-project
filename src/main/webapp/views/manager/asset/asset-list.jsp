<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <title>Quản lý Tài sản Khách hàng</title>
</head>
<body>
    <div class="container-fluid mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="text-primary fw-bold mb-0"><i class="fa fa-server"></i> TÀI SẢN MÁY PHÁT ĐIỆN</h3>
                <p class="text-muted mb-0">Quản lý danh sách thiết bị và lịch sử vận hành</p>
            </div>
            <form action="assets" method="get" class="d-flex gap-2">
                <input type="hidden" name="action" value="list">

                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="fa fa-search text-muted"></i></span>
                    <input type="text" name="keyword" class="form-control" placeholder="Nhập Serial, Tên máy..." value="${param.keyword}">
                </div>

                <button type="submit" class="btn btn-primary px-4">
                    <i class="fa fa-filter"></i> Lọc
                </button>
            </form>
        </div>

        <div class="card shadow border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-uppercase text-muted small">
                            <tr>
                                <th class="py-3 ps-4">Hình ảnh</th>
                                <th class="py-3">Thông tin Máy</th>
                                <th class="py-3">Serial / ID</th>
                                <th class="py-3">Chủ sở hữu & Vị trí</th>
                                <th class="py-3 text-center">Giờ chạy</th>
                                <th class="py-3 text-center">Trạng thái</th>
                                <th class="py-3 text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty products}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <img src="https://cdn-icons-png.flaticon.com/512/7486/7486754.png" width="80" class="mb-3 opacity-50">
                                        <p class="text-muted mb-0">Không tìm thấy tài sản nào phù hợp.</p>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center justify-content-center bg-light rounded-3 border"
                                             style="width: 60px; height: 60px;">
                                            <i class="fa fa-bolt text-warning fa-2x"></i>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="assets?action=detail&id=${p.id}" class="fw-bold text-decoration-none text-dark">
                                            ${p.modelName}
                                        </a>
                                        <div class="small text-muted mt-1">
                                            <i class="fa fa-calendar-alt"></i> SX: ${p.manufactureYear != null ? p.manufactureYear : 'N/A'}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border px-2 py-1 font-monospace">
                                            ${p.serialNumber}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary mb-1">
                                            <i class="fa fa-user-tie"></i> ${p.customerName}
                                        </div>
                                        <small class="text-muted d-block text-truncate" style="max-width: 200px;" title="${p.currentLocation}">
                                            <i class="fa fa-map-marker-alt text-danger"></i>
                                            ${p.currentLocation != null ? p.currentLocation : '<span class="fst-italic">Chưa cập nhật</span>'}
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <span class="fw-bold text-dark">${p.totalRunningHours}</span> <small class="text-muted">giờ</small>
                                        <div class="progress mt-1" style="height: 4px; width: 80px; margin: 0 auto;">
                                            <div class="progress-bar bg-info" role="progressbar" style="width: 60%"></div>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${p.status == 'RUNNING'}">
                                                <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                                    <i class="fa fa-check-circle"></i> Hoạt động
                                                </span>
                                            </c:when>
                                            <c:when test="${p.status == 'MAINTENANCE'}">
                                                <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1">
                                                    <i class="fa fa-tools"></i> Bảo trì
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1">
                                                    <i class="fa fa-exclamation-triangle"></i> Sự cố
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <a href="assets?action=detail&id=${p.id}" class="btn btn-outline-primary btn-sm" title="Xem hồ sơ máy">
                                            <i class="fa fa-file-medical-alt"></i> Hồ sơ
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card-footer bg-white py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="small text-muted">
                        Hiển thị trang <b>${currentPage}</b> trên tổng số <b>${totalPages}</b> trang
                    </div>

                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="assets?page=${currentPage - 1}&keyword=${param.keyword}">
                                        <i class="fa fa-chevron-left"></i>
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="assets?page=${i}&keyword=${param.keyword}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="assets?page=${currentPage + 1}&keyword=${param.keyword}">
                                        <i class="fa fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>