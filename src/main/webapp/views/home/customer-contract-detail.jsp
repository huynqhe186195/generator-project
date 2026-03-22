<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Hợp đồng | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

    <style>
        :root{
            --primary:#4e73df;
            --secondary:#224abe;
            --ink:#101828;
            --muted:#667085;
            --bg:#f6f7fb;
        }

        html, body { height: 100%; }
        body{
            min-height: 100vh;
            display:flex;
            flex-direction:column;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: var(--bg);
            color: var(--ink);
            overflow-x:hidden;
        }

        .navbar-landing{
            position: sticky;
            top: 0;
            z-index: 1050;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 14px 0;
            box-shadow: 0 10px 25px rgba(0,0,0,.08);
        }
        .navbar-brand{
            font-weight: 900;
            letter-spacing: .2px;
            font-size: 1.6rem;
            color:#fff !important;
        }
        .nav-link{
            color: rgba(255,255,255,.92) !important;
            font-weight: 600;
            transition: .2s;
        }
        .nav-link:hover{ opacity: .9; transform: translateY(-1px); }

        .btn-white{
            background:#fff;
            color: var(--primary);
            font-weight: 800;
            border-radius: 999px;
            padding: 10px 22px;
            border: none;
            transition: .2s;
            text-decoration:none;
            display:inline-block;
            box-shadow: 0 10px 20px rgba(0,0,0,.10);
        }
        .btn-white:hover{
            transform: translateY(-1px);
            box-shadow: 0 14px 26px rgba(0,0,0,.14);
            color: var(--secondary);
        }

        .user-dropdown-toggle{
            background: rgba(255,255,255,.16);
            color: #fff !important;
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 999px;
            padding: 8px 14px !important;
        }

        .hero-section{
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color:#fff;
            padding: 46px 0 64px;
            position:relative;
            overflow:hidden;
        }
        .hero-section:before{
            content:"";
            position:absolute;
            width:520px;height:520px;
            right:-220px; top:-220px;
            background: rgba(255,255,255,.12);
            border-radius: 50%;
        }
        .hero-section:after{
            content:"";
            position:absolute;
            width:420px;height:420px;
            left:-220px; bottom:-240px;
            background: rgba(255,255,255,.10);
            border-radius: 50%;
        }
        .hero-title{
            font-weight: 900;
            font-size: 2.5rem;
            line-height: 1.15;
            margin:0 0 10px;
        }
        .hero-desc{ opacity:.92; margin:0; max-width: 720px; }

        main{ flex:1; padding: 18px 0 60px; }

        .main-card{
            border-radius: 22px;
            background:#fff;
            box-shadow: 0 18px 40px rgba(16,24,40,.08);
            border: 1px solid rgba(16,24,40,.06);
            overflow:hidden;
        }

        .card-header-soft{
            padding: 18px 18px 12px;
            border-bottom: 1px solid rgba(16,24,40,.06);
            background: linear-gradient(180deg, rgba(78,115,223,.06), rgba(255,255,255,0));
        }

        .section-title{
            margin:0;
            font-weight: 900;
            color: var(--primary);
            display:flex;
            align-items:center;
            gap:10px;
        }
        .section-sub{
            margin:6px 0 0;
            color: var(--muted);
            font-size: .92rem;
        }

        .detail-wrap{ padding: 18px; }

        .info-grid{
            display:grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap:14px;
        }

        @media (max-width: 992px){
            .info-grid{ grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }

        @media (max-width: 576px){
            .hero-title{ font-size: 1.9rem; }
            .info-grid{ grid-template-columns: 1fr; }
        }

        .info-card{
            background:#f8fafc;
            border: 1px solid #eaecf0;
            border-radius: 18px;
            padding: 16px;
            height:100%;
        }

        .info-label{
            font-size:.78rem;
            text-transform:uppercase;
            letter-spacing:.4px;
            color: var(--muted);
            font-weight:900;
            margin-bottom:6px;
        }

        .info-value{
            font-size:1rem;
            font-weight:900;
            color: var(--ink);
            line-height:1.4;
        }

        .status-badge{
            border-radius:999px;
            padding:8px 14px;
            font-weight:900;
            display:inline-flex;
            align-items:center;
            gap:6px;
        }

        .table thead th{
            background: #f8fafc;
            font-weight: 900;
            font-size: .78rem;
            letter-spacing: .5px;
            text-transform: uppercase;
            color: #475467;
            border-bottom: 1px solid #eaecf0;
        }
        .table td{ border-color:#f1f3f6; }
        .table-hover tbody tr:hover{ background: #fafbff; }

        .name{
            font-weight: 900;
            margin:0;
            color: #111827;
        }
        .meta{
            color: var(--muted);
            font-size: .9rem;
        }

        .btn-pill{
            border-radius: 999px;
            padding: 10px 16px;
            font-weight: 800;
        }

        .timeline{
            list-style:none;
            margin:0;
            padding:0;
        }
        .timeline li{
            position:relative;
            padding-left:22px;
            margin-bottom:18px;
        }
        .timeline li:before{
            content:"";
            width:10px;
            height:10px;
            border-radius:50%;
            background: var(--primary);
            position:absolute;
            left:0;
            top:7px;
        }
        .timeline-time{
            color: var(--muted);
            font-size:.88rem;
            margin-bottom:2px;
        }
        .timeline-title{
            font-weight:900;
            color: var(--ink);
        }
        .timeline-note{
            color: var(--muted);
            font-size:.92rem;
            margin-top:3px;
            white-space:pre-line;
        }

        .terminated-modal-note{
            background: #fff5f5;
            border: 1px solid #fecaca;
            color: #991b1b;
            border-radius: 12px;
            padding: 10px 12px;
            font-size: .9rem;
            line-height: 1.5;
        }

        .empty-state{
            text-align:center;
            color:var(--muted);
            padding:40px 20px;
        }

        footer{
            margin-top:auto;
            background:#111827;
            color:#9ca3af;
            padding: 26px 0;
        }
        footer a{ color:#fff; }
        footer a:hover{ opacity:.9; }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-landing" id="mainNav">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>">
            <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link px-3" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công ty</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3" href="<c:url value='/news'/>">Tin tức</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
                </li>
                <c:if test="${not empty user}">
                    <li class="nav-item">
                        <a class="nav-link px-3" href="<c:url value='/views/home/Support.jsp'/>">Chăm sóc khách hàng</a>
                    </li>
                </c:if>

                <c:choose>
                    <c:when test="${empty user}">
                        <li class="nav-item ms-lg-3">
                            <a href="<c:url value='/account/login'/>" class="btn btn-white">Đăng nhập</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown ms-lg-3">
                            <a class="nav-link dropdown-toggle user-dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i> ${user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-3">
                                <li>
                                    <a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>">
                                        <i class="fas fa-id-card me-2"></i>Hồ sơ
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="<c:url value='/account/hanldeChangePassword'/>">
                                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger fw-bold" href="<c:url value='/account/logout'/>">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<section class="hero-section">
    <div class="container position-relative" data-aos="fade-right">
        <h1 class="hero-title">Chi tiết hợp đồng</h1>
        <p class="hero-desc">Khách hàng có thể xem đầy đủ thông tin hợp đồng và thiết bị thuộc hợp đồng, nhưng không chỉnh sửa.</p>
    </div>
</section>

<main>
    <div class="container" data-aos="fade-up">

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-warning alert-dismissible fade show mb-4">
                <i class="fas fa-triangle-exclamation me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty contract}">
                <div class="main-card mb-4">
                    <div class="card-header-soft d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
                        <div>
                            <h5 class="section-title">
                                <i class="fas fa-file-contract"></i> Thông tin hợp đồng
                            </h5>
                            <p class="section-sub">
                                Chi tiết hiển thị tương tự manager, nhưng ở chế độ chỉ xem.
                            </p>
                        </div>

                        <div class="d-flex gap-2 flex-wrap">
                            <a href="<c:url value='/product-list'/>" class="btn btn-outline-secondary btn-pill">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                            </a>

                            <c:if test="${contract.status == 'TERMINATED'}">
                                <button type="button"
                                        class="btn btn-outline-danger btn-pill"
                                        onclick="openTerminatedContractModal()">
                                    <i class="fas fa-circle-info me-1"></i>Chi tiết hủy
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <div class="detail-wrap">
                        <div class="info-grid">
                            <div class="info-card">
                                <div class="info-label">Số hợp đồng</div>
                                <div class="info-value">${contract.contractNumber}</div>
                            </div>

                            <div class="info-card">
                                <div class="info-label">Ngày ký</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty contract.signedDate}">
                                            <fmt:formatDate value="${contract.signedDate}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-card">
                                <div class="info-label">Ngày hiệu lực</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty contract.startDate}">
                                            <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-card">
                                <div class="info-label">Ngày hết hiệu lực</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty contract.endDate}">
                                            <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-card">
                                <div class="info-label">Trạng thái</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${contract.status == 'ACTIVE'}">
                                            <span class="status-badge bg-success bg-opacity-10 text-success">
                                                <i class="fas fa-circle-check"></i>Đang hiệu lực
                                            </span>
                                        </c:when>
                                        <c:when test="${contract.status == 'PENDING_SERIAL'}">
                                            <span class="status-badge bg-warning text-dark">
                                                <i class="fas fa-clock"></i>Chờ gán thiết bị
                                            </span>
                                        </c:when>
                                        <c:when test="${contract.status == 'EXPIRED'}">
                                            <span class="status-badge bg-secondary text-white">
                                                <i class="fas fa-hourglass-end"></i>Hết hiệu lực
                                            </span>
                                        </c:when>
                                        <c:when test="${contract.status == 'TERMINATED'}">
                                            <span class="status-badge bg-danger text-white">
                                                <i class="fas fa-circle-xmark"></i>Đã chấm dứt
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge bg-secondary bg-opacity-10 text-secondary">
                                                ${contract.status}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-card">
                                <div class="info-label">Thiết bị đang xem</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty product}">
                                            ${product.serialNumber}
                                        </c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-card">
                                <div class="info-label">Tổng số thiết bị</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty products}">
                                            ${fn:length(products)} thiết bị
                                        </c:when>
                                        <c:otherwise>0 thiết bị</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="info-card">
                                <div class="info-label">Ngày chấm dứt</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty contract.terminatedAt}">
                                            <fmt:formatDate value="${contract.terminatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>Chưa chấm dứt</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <c:if test="${contract.status == 'TERMINATED'}">
                            <div class="alert alert-danger mt-4 mb-0">
                                <div class="fw-bold mb-1">
                                    <i class="fas fa-file-circle-xmark me-2"></i>Hợp đồng đã chấm dứt
                                </div>
                                <div class="small">
                                    Bạn chỉ có thể xem thông tin hợp đồng. Vui lòng liên hệ quản trị/CSKH nếu cần hỗ trợ thêm.
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="main-card mb-4">
                    <div class="card-header-soft">
                        <h5 class="section-title">
                            <i class="fas fa-server"></i> Thiết bị thuộc hợp đồng
                        </h5>
                        <p class="section-sub">Danh sách sản phẩm thuộc cùng hợp đồng này.</p>
                    </div>

                    <div class="table-responsive px-3 pb-3">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-3">Serial</th>
                                <th>Model / Brand</th>
                                <th>Vị trí</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${products}" var="p">
                                <tr>
                                    <td class="ps-3">
                                        <span class="fw-bold text-dark font-monospace">${p.serialNumber}</span>
                                    </td>

                                    <td>
                                        <p class="name mb-1 text-primary">${p.modelName}</p>
                                        <div class="meta">
                                            <span class="fw-bold">${p.brandName}</span>
                                        </div>
                                    </td>

                                    <td>
                                        <span class="meta">
                                            <c:choose>
                                                <c:when test="${not empty p.currentLocation}">
                                                    <i class="fas fa-map-marker-alt me-1"></i>${p.currentLocation}
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'RUNNING'}">
                                                <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2">Đang hoạt động</span>
                                            </c:when>
                                            <c:when test="${p.status == 'MAINTENANCE'}">
                                                <span class="badge bg-warning text-dark rounded-pill px-3 py-2">
                                                    <i class="fas fa-clock me-1"></i>Chờ phản hồi
                                                </span>
                                            </c:when>
                                            <c:when test="${p.status == 'BROKEN'}">
                                                <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-2">Hỏng hóc</span>
                                            </c:when>
                                            <c:when test="${p.status == 'RECEIVED_QUOTE'}">
                                                <span class="badge bg-primary text-white rounded-pill px-3 py-2 shadow-sm">
                                                    <i class="fas fa-file-invoice-dollar me-1"></i>Có báo giá mới
                                                </span>
                                            </c:when>
                                            <c:when test="${p.status == 'READY'}">
                                                <span class="badge bg-info bg-opacity-10 text-info rounded-pill px-3 py-2">Sẵn sàng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary rounded-pill px-3 py-2">${p.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty products}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted">
                                        <i class="fas fa-box-open fa-3x mb-3 opacity-50"></i>
                                        <p class="mb-1 fw-bold">Chưa có thiết bị nào thuộc hợp đồng này.</p>
                                        <small>Thông tin thiết bị sẽ hiển thị khi được gán vào hợp đồng.</small>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="main-card">
                    <div class="card-header-soft">
                        <h5 class="section-title">
                            <i class="fas fa-clock-rotate-left"></i> Lịch sử hợp đồng
                        </h5>
                        <p class="section-sub">Các mốc cập nhật và sự kiện liên quan đến hợp đồng.</p>
                    </div>

                    <div class="p-4">
                        <c:choose>
                            <c:when test="${not empty contractEvents}">
                                <ul class="timeline">
                                    <c:forEach items="${contractEvents}" var="ev">
                                        <li>
                                            <div class="timeline-time">
                                                <c:choose>
                                                    <c:when test="${not empty ev.createdAt}">
                                                        <fmt:formatDate value="${ev.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </c:when>
                                                    <c:otherwise>Không rõ thời gian</c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="timeline-title">
                                                <c:choose>
                                                    <c:when test="${ev.eventType == 'CREATED'}">Tạo hợp đồng</c:when>
                                                    <c:when test="${ev.eventType == 'UPDATED'}">Cập nhật hợp đồng</c:when>
                                                    <c:when test="${ev.eventType == 'STATUS_CHANGED'}">Thay đổi trạng thái</c:when>
                                                    <c:when test="${ev.eventType == 'TERMINATED'}">Chấm dứt hợp đồng</c:when>
                                                    <c:when test="${ev.eventType == 'REACTIVATED'}">Kích hoạt lại hợp đồng</c:when>
                                                    <c:when test="${ev.eventType == 'NOTE'}">Ghi chú hợp đồng</c:when>
                                                    <c:otherwise>${ev.eventType}</c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="timeline-note">
                                                <c:choose>
                                                    <c:when test="${not empty ev.note}">
                                                        ${ev.note}
                                                    </c:when>
                                                    <c:when test="${not empty ev.terminatedReason}">
                                                        ${ev.terminatedReason}
                                                    </c:when>
                                                    <c:otherwise>Không có ghi chú bổ sung.</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>

                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-clock-rotate-left fa-2x mb-3 opacity-50"></i>
                                    <p class="mb-1 fw-bold">Chưa có lịch sử cập nhật.</p>
                                    <small>Các sự kiện hợp đồng sẽ hiển thị tại đây khi phát sinh.</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="main-card">
                    <div class="empty-state">
                        <i class="fas fa-file-circle-xmark fa-3x mb-3 opacity-50"></i>
                        <p class="mb-1 fw-bold">Không tìm thấy hợp đồng.</p>
                        <small>Vui lòng quay lại danh sách thiết bị để chọn hợp đồng cần xem.</small>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<footer>
    <div class="container">
        <div class="row gy-3 align-items-center">
            <div class="col-lg-6 text-center text-lg-start">
                <a href="#" class="text-decoration-none fw-bold fs-5">
                    <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
                </a>
                <div class="small mt-2">Giải pháp số hóa hệ thống năng lượng dự phòng.</div>
            </div>
            <div class="col-lg-6 text-center text-lg-end">
                <div class="small">&copy; 2024 Gen-CMS Corporation. Bảo lưu mọi quyền.</div>
                <div class="mt-2">
                    <a href="#" class="me-3"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-linkedin"></i></a>
                    <a href="#"><i class="fas fa-envelope"></i></a>
                </div>
            </div>
        </div>
    </div>
</footer>

<div class="modal fade" id="terminatedContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title fw-bold">
                    <i class="fas fa-file-circle-xmark me-2"></i>Chi tiết chấm dứt hợp đồng
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="terminated-modal-note">
                    <div><strong>Notice:</strong> Hợp đồng đã chấm dứt, vui lòng liên hệ quản trị/CSKH.</div>

                    <div class="mt-2">
                        <strong>Lý do:</strong>
                        <span>
                            <c:choose>
                                <c:when test="${not empty terminatedEvent and not empty terminatedEvent.terminatedReason}">
                                    ${terminatedEvent.terminatedReason}
                                </c:when>
                                <c:otherwise>Không có thông tin.</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="mt-1">
                        <strong>Hủy lúc:</strong>
                        <span>
                            <c:choose>
                                <c:when test="${not empty contract.terminatedAt}">
                                    <fmt:formatDate value="${contract.terminatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:when>
                                <c:otherwise>Không rõ thời điểm.</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:if test="${not empty terminatedEvent and not empty terminatedEvent.note}">
                        <div class="mt-1">
                            <strong>Ghi chú:</strong> ${terminatedEvent.note}
                        </div>
                    </c:if>

                    <c:if test="${not empty terminatedEvent and not empty terminatedEvent.decisionDoc}">
                        <div class="mt-1">
                            <strong>Quyết định:</strong> ${terminatedEvent.decisionDoc}
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    AOS.init({ duration: 800, once: true });

    function openTerminatedContractModal() {
        const modal = new bootstrap.Modal(document.getElementById('terminatedContractModal'));
        modal.show();
    }
</script>

</body>
</html>