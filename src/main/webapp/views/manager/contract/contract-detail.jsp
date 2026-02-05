<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <title>Chi tiết Hợp đồng #${c.contractNumber}</title>
</head>

<body>
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-0 text-primary">
                <i class="fa fa-file-contract"></i> Hợp đồng: ${c.contractNumber}
            </h3>
            <span class="text-muted small">Ngày tạo: <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
        </div>
        <div>
            <a href="contracts" class="btn btn-secondary">
                <i class="fa fa-arrow-left"></i> Danh sách
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-5">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light fw-bold">
                    <i class="fa fa-info-circle text-primary"></i> Thông tin chung
                </div>
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr>
                            <td class="text-muted w-50">Trạng thái:</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'ACTIVE'}">
                                        <span class="badge bg-success px-3 py-2">HIỆU LỰC (ACTIVE)</span>
                                    </c:when>
                                    <c:when test="${c.status == 'EXPIRED'}">
                                        <span class="badge bg-danger px-3 py-2">HẾT HẠN (EXPIRED)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary px-3 py-2">${c.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Ngày bắt đầu:</td>
                            <td class="fw-bold"><fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Ngày kết thúc:</td>
                            <td class="fw-bold text-danger"><fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-light fw-bold">
                    <i class="fa fa-user-tie text-success"></i> Khách hàng / Chủ sở hữu
                </div>
                <div class="card-body">
                    <h5 class="card-title text-success">${u.fullName}</h5>
                    <p class="card-text mb-1"><i class="fa fa-envelope w-25 text-center"></i> ${u.email}</p>
                    <p class="card-text mb-1"><i class="fa fa-phone w-25 text-center"></i> ${u.phone != null ? u.phone : 'Chưa cập nhật'}</p>
                </div>
            </div>
        </div>

        <div class="col-md-7">
            <div class="card shadow border-primary h-100">
                <div class="card-header bg-primary text-white d-flex justify-content-between">
                    <span class="fw-bold"><i class="fa fa-server"></i> HỒ SƠ THIẾT BỊ</span>
                    <span class="badge bg-white text-primary">Serial: ${c.productSerial}</span>
                </div>
                <div class="card-body">

                    <div class="row text-center mb-4">
                        <div class="col-4 border-end">
                            <h2 class="text-primary mb-0"><i class="fa fa-bolt"></i></h2>
                            <small class="text-muted">Dòng máy</small>
                            <div class="fw-bold text-truncate" title="${c.productModelName}">${c.productModelName}</div>
                        </div>
                        <div class="col-4 border-end">
                            <h2 class="text-warning mb-0"><i class="fa fa-clock"></i></h2>
                            <small class="text-muted">Giờ chạy</small>
                            <div class="fw-bold">${p.totalRunningHours}h</div>
                        </div>
                        <div class="col-4">
                            <h2 class="text-info mb-0"><i class="fa fa-calendar-check"></i></h2>
                            <small class="text-muted">Năm SX</small>
                            <div class="fw-bold">${p.manufactureYear != null ? p.manufactureYear : 'N/A'}</div>
                        </div>
                    </div>

                    <h6 class="border-bottom pb-2">Thông tin vận hành hiện tại</h6>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex justify-content-between">
                            <span>Vị trí lắp đặt:</span>
                            <span class="fw-bold">${p.currentLocation != null ? p.currentLocation : 'Chưa cập nhật'}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between">
                            <span>Trạng thái máy:</span>
                            <span class="fw-bold text-${p.status == 'RUNNING' ? 'success' : 'warning'}">
                                ${p.status}
                            </span>
                        </li>
                         <li class="list-group-item d-flex justify-content-between">
                            <span>Lần bảo trì gần nhất:</span>
                            <span class="text-muted">--/--/----</span> </li>
                    </ul>

                    <div class="mt-4 text-end">
                        <a href="#" class="btn btn-outline-danger btn-sm">
                            <i class="fa fa-exclamation-circle"></i> Xem lịch sử báo hỏng
                        </a>
                        <a href="#" class="btn btn-outline-success btn-sm">
                            <i class="fa fa-tools"></i> Lịch sử bảo trì
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>