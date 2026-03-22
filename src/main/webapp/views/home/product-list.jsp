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
    <title>Tra cứu hợp đồng | Gen-CMS</title>

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
            padding: 46px 0 88px;
            position:relative;
            overflow:hidden;
        }
        .hero-section .container{
            position:relative;
            z-index:1;
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
        .hero-desc{
            opacity:.92;
            margin:0;
            max-width: 760px;
            line-height: 1.7;
            padding-bottom: 28px;
        }

        main{ flex:1; padding: 18px 0 60px; }

        .main-card,
        .lookup-card,
        .device-card{
            border-radius: 22px;
            background:#fff;
            box-shadow: 0 18px 40px rgba(16,24,40,.08);
            border: 1px solid rgba(16,24,40,.06);
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

        .lookup-card{ padding: 24px; }
        .lookup-form{
            display:grid;
            grid-template-columns: minmax(0, 1fr) auto auto;
            gap: 12px;
            align-items:end;
        }
        .lookup-hint{
            background:#eef4ff;
            border:1px solid #dbe7ff;
            color:#224abe;
            border-radius:16px;
            padding:14px 16px;
            margin-top:16px;
        }
        .detail-grid{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            padding: 20px;
        }
        .detail-item{
            background:#f8fafc;
            border:1px solid #eaecf0;
            border-radius:18px;
            padding:16px;
        }
        .detail-item .label{
            color: var(--muted);
            font-size:.84rem;
            text-transform:uppercase;
            letter-spacing:.06em;
            margin-bottom:6px;
            font-weight:700;
        }
        .detail-item .value{
            font-weight:800;
            color:#0f172a;
            word-break:break-word;
        }

        .device-grid{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 18px;
            padding: 0 0 8px;
        }
        .device-card{ padding: 20px; cursor:pointer; transition: transform .2s ease, box-shadow .2s ease, border-color .2s ease; }
        .device-card:hover{
            transform: translateY(-4px);
            box-shadow: 0 22px 45px rgba(16,24,40,.12);
            border-color: rgba(78,115,223,.25);
        }
        .device-card:focus-visible{
            outline: 3px solid rgba(78,115,223,.25);
            outline-offset: 3px;
        }
        .device-head{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap: 12px;
            margin-bottom: 16px;
        }
        .device-name{
            font-size: 1.05rem;
            font-weight: 900;
            color:#111827;
            margin:0;
        }
        .serial-pill{
            display:inline-flex;
            align-items:center;
            gap: 8px;
            border-radius: 999px;
            background:#eef2ff;
            color:#3730a3;
            padding: 8px 14px;
            font-weight: 800;
            font-size: .92rem;
        }
        .info-list{
            display:grid;
            gap: 12px;
        }
        .info-row{
            display:flex;
            justify-content:space-between;
            gap: 16px;
            border-bottom:1px dashed #e5e7eb;
            padding-bottom:10px;
        }
        .info-row:last-child{
            border-bottom:none;
            padding-bottom:0;
        }
        .info-label{
            color:var(--muted);
            font-weight:700;
        }
        .info-value{
            color:#0f172a;
            font-weight:700;
            text-align:right;
        }

        .btn-pill{
            border-radius: 999px;
            padding: 10px 16px;
            font-weight: 800;
        }

        .status-badge{
            border-radius:999px;
            padding:8px 12px;
            font-weight:800;
            display:inline-flex;
            align-items:center;
            gap:8px;
        }
        .detail-actions{
            display:flex;
            flex-wrap:wrap;
            gap:12px;
        }

        footer{
            margin-top:auto;
            background:#111827;
            color:#9ca3af;
            padding: 26px 0;
        }
        footer a{ color:#fff; }
        footer a:hover{ opacity:.9; }

        @media (max-width: 992px){
            .lookup-form{ grid-template-columns: 1fr; }
            .hero-title{ font-size: 2rem; }
        }
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
                    <a class="nav-link nav-pill px-3" href="<c:url value='/news'/>">Tin tức</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-pill px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
                </li>
                <c:if test="${not empty user}">
                    <li class="nav-item">
                        <a class="nav-link px-3" href="<c:url value='/product-list'/>">Hợp đồng</a>
                    </li>
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
        <h1 class="hero-title">Tra cứu hợp đồng khách hàng</h1>
        <p class="hero-desc">Khách hàng không xem danh sách toàn bộ hợp đồng. Để xem chi tiết, vui lòng nhập chính xác mã hợp đồng đang sở hữu để tra cứu thông tin hợp đồng và các thiết bị thuộc hợp đồng đó.</p>
    </div>
</section>

<main>
    <div class="container" data-aos="fade-up">
        <div class="lookup-card mb-4">
            <div class="d-flex flex-column flex-lg-row justify-content-between gap-3 align-items-lg-center mb-3">
                <div>
                    <h5 class="section-title mb-2"><i class="fas fa-magnifying-glass"></i> Nhập mã hợp đồng</h5>
                    <p class="section-sub mb-0">Hệ thống chỉ hiển thị hợp đồng khi mã hợp đồng chính xác và thuộc quyền sở hữu của bạn.</p>
                </div>
            </div>

            <form method="get" action="<c:url value='/product-list'/>" class="lookup-form">
                <div>
                    <label class="form-label fw-bold mb-2">Mã hợp đồng</label>
                    <input type="text"
                           name="contractNumber"
                           class="form-control form-control-lg"
                           placeholder="Ví dụ: HD-2026-001"
                           value="${contractNumber != null ? contractNumber : ''}">
                </div>
                <button type="submit" class="btn btn-primary btn-pill btn-lg">
                    <i class="fas fa-search me-2"></i>Tra cứu
                </button>
                <a class="btn btn-outline-secondary btn-pill btn-lg" href="<c:url value='/product-list'/>">
                    Xóa
                </a>
            </form>
        </div>

        <c:if test="${lookupPerformed and not empty lookupError}">
            <div class="alert alert-danger shadow-sm border-0 rounded-4 mb-4">
                <i class="fas fa-circle-exclamation me-2"></i>${lookupError}
            </div>
        </c:if>

        <c:if test="${lookupPerformed and empty lookupError and not empty contract}">
            <div class="main-card mb-4">
                <div class="card-header-soft">
                    <h5 class="section-title"><i class="fas fa-file-contract"></i> Thông tin hợp đồng</h5>
                    <p class="section-sub">Chi tiết tổng quan của hợp đồng được tra cứu.</p>
                </div>

                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="label">Mã hợp đồng</div>
                        <div class="value">${contract.contractNumber}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Khách hàng</div>
                        <div class="value">${not empty contract.customerName ? contract.customerName : user.fullName}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Trạng thái</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${contract.status == 'ACTIVE'}">
                                    <span class="status-badge bg-success bg-opacity-10 text-success"><i class="fas fa-circle-check"></i>Đang hiệu lực</span>
                                </c:when>
                                <c:when test="${contract.status == 'PENDING_SERIAL'}">
                                    <span class="status-badge bg-warning bg-opacity-10 text-warning"><i class="fas fa-hourglass-half"></i>Chờ gán thiết bị</span>
                                </c:when>
                                <c:when test="${contract.status == 'TERMINATED'}">
                                    <span class="status-badge bg-danger bg-opacity-10 text-danger"><i class="fas fa-circle-xmark"></i>Đã chấm dứt</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge bg-secondary bg-opacity-10 text-secondary"><i class="fas fa-circle-info"></i>${contract.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Ngày ký</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty contract.signedDate}">
                                    <fmt:formatDate value="${contract.signedDate}" pattern="dd/MM/yyyy" />
                                </c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Ngày bắt đầu</div>
                        <div class="value"><fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy" /></div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Ngày kết thúc</div>
                        <div class="value"><fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy" /></div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Tệp hợp đồng</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty contract.filePath}">
                                    <div class="d-flex flex-wrap gap-2">
                                        <a class="btn btn-sm btn-outline-primary btn-pill"
                                           href="<c:url value='/${contract.filePath}'/>"
                                           target="_blank" rel="noopener noreferrer">
                                            <i class="fas fa-eye me-1"></i>Xem hợp đồng
                                        </a>
                                        <a class="btn btn-sm btn-primary btn-pill"
                                           href="<c:url value='/${contract.filePath}'/>"
                                           download>
                                            <i class="fas fa-download me-1"></i>Tải file
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>Chưa có file hợp đồng</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Ngày tạo</div>
                        <div class="value"><fmt:formatDate value="${contract.createdAt}" pattern="dd/MM/yyyy HH:mm" /></div>
                    </div>
                </div>
            </div>

            <div class="main-card">
                <div class="card-header-soft">
                    <h5 class="section-title"><i class="fas fa-microchip"></i> Thiết bị thuộc hợp đồng</h5>
                    <p class="section-sub">Danh sách thiết bị, thông tin vận hành và các hành động liên quan đến từng thiết bị trong hợp đồng này.</p>
                </div>

                <div class="p-4">
                    <c:choose>
                        <c:when test="${not empty contractDevices}">
                            <div class="device-grid">
                                <c:forEach items="${contractDevices}" var="p">
                                    <div class="device-card"
                                         role="button"
                                         tabindex="0"
                                         onclick="openDeviceDetail(this)"
                                         onkeydown="handleDeviceCardKeydown(event, this)"
                                         data-product-id="${p.id}"
                                         data-model-name="${fn:escapeXml(not empty p.modelName ? p.modelName : 'Chưa có tên model')}"
                                         data-brand-name="${fn:escapeXml(not empty p.brandName ? p.brandName : 'Chưa cập nhật thương hiệu')}"
                                         data-serial-number="${fn:escapeXml(p.serialNumber)}"
                                         data-status="${fn:escapeXml(p.status)}"
                                         data-location="${fn:escapeXml(not empty p.currentLocation ? p.currentLocation : 'Chưa cập nhật')}"
                                         data-manufacture-year="${p.manufactureYear != null ? p.manufactureYear : 'Chưa cập nhật'}"
                                         data-purchase-date="${not empty p.purchaseDate ? fn:escapeXml(p.purchaseDate) : ''}"
                                         data-running-hours="${p.totalRunningHours != null ? p.totalRunningHours : 0}"
                                         data-category-name="${fn:escapeXml(not empty p.categoryName ? p.categoryName : 'Chưa cập nhật')}"
                                         data-contract-status="${fn:escapeXml(contract.status)}">
                                        <div class="device-head">
                                            <div>
                                                <div class="serial-pill mb-3"><i class="fas fa-barcode"></i>${p.serialNumber}</div>
                                                <h6 class="device-name">${not empty p.modelName ? p.modelName : 'Chưa có tên model'}</h6>
                                                <div class="text-muted small mt-1">${not empty p.brandName ? p.brandName : 'Chưa cập nhật thương hiệu'}</div>
                                            </div>
                                            <c:choose>
                                                <c:when test="${p.status == 'RUNNING'}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle">Đang hoạt động</span>
                                                </c:when>
                                                <c:when test="${p.status == 'MAINTENANCE'}">
                                                    <span class="badge bg-warning-subtle text-warning border border-warning-subtle">Đang bảo trì</span>
                                                </c:when>
                                                <c:when test="${p.status == 'BROKEN'}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Hỏng hóc</span>
                                                </c:when>
                                                <c:when test="${p.status == 'RECEIVED_QUOTE'}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">Có báo giá</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">${p.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="info-list mb-4">
                                            <div class="info-row">
                                                <span class="info-label">Địa điểm hiện tại</span>
                                                <span class="info-value">${not empty p.currentLocation ? p.currentLocation : 'Chưa cập nhật'}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Năm sản xuất</span>
                                                <span class="info-value">${p.manufactureYear != null ? p.manufactureYear : 'Chưa cập nhật'}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Ngày mua</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty p.purchaseDate}">
                                                            <fmt:formatDate value="${p.purchaseDate}" pattern="dd/MM/yyyy" />
                                                        </c:when>
                                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Tổng giờ chạy</span>
                                                <span class="info-value">${p.totalRunningHours != null ? p.totalRunningHours : 0} giờ</span>
                                            </div>
                                        </div>

                                        <div class="text-primary fw-bold small d-flex align-items-center gap-2 mt-4">
                                            <i class="fas fa-circle-info"></i>
                                            Nhấn để xem chi tiết thiết bị
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center text-muted py-5">
                                <i class="fas fa-box-open fa-3x mb-3 opacity-50"></i>
                                <p class="mb-1 fw-bold">Hợp đồng này hiện chưa có thiết bị nào được gán.</p>
                                <small>Vui lòng liên hệ bộ phận quản lý nếu bạn cần kiểm tra thêm.</small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <c:if test="${not lookupPerformed}">
            <div class="main-card p-5 text-center text-muted">
                <i class="fas fa-file-magnifying-glass fa-3x mb-3 opacity-50"></i>
                <h5 class="fw-bold text-dark">Chưa có dữ liệu hợp đồng để hiển thị</h5>
                <p class="mb-0">Hãy nhập mã hợp đồng ở phía trên để xem thông tin chi tiết hợp đồng và toàn bộ thiết bị liên quan.</p>
            </div>
        </c:if>
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

<div class="modal fade" id="deviceDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <div>
                    <div class="small text-uppercase opacity-75 fw-bold">Chi tiết thiết bị</div>
                    <h5 class="modal-title fw-bold mb-0" id="deviceDetailName">-</h5>
                    <div class="small mt-1">Serial: <span class="font-monospace fw-bold" id="deviceDetailSerial"></span></div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                    <div>
                        <div class="text-muted small text-uppercase fw-bold mb-1">Thương hiệu</div>
                        <div class="fw-bold fs-5" id="deviceDetailBrand">-</div>
                    </div>
                    <div id="deviceDetailStatus"></div>
                </div>

                <div class="detail-grid p-0">
                    <div class="detail-item">
                        <div class="label">Model thiết bị</div>
                        <div class="value" id="deviceDetailModel">-</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Danh mục</div>
                        <div class="value" id="deviceDetailCategory">-</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Địa điểm hiện tại</div>
                        <div class="value" id="deviceDetailLocation">-</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Năm sản xuất</div>
                        <div class="value" id="deviceDetailManufactureYear">-</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Ngày mua</div>
                        <div class="value" id="deviceDetailPurchaseDate">-</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">Tổng giờ chạy</div>
                        <div class="value" id="deviceDetailRunningHours">-</div>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light justify-content-between gap-2">
                <div class="detail-actions">
                    <a href="#" id="deviceHistoryButton" class="btn btn-outline-info btn-pill">
                        <i class="fas fa-history me-1"></i>Lịch sử báo giá
                    </a>
                    <span id="deviceActionContainer"></span>
                </div>
                <button type="button" class="btn btn-light btn-pill" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="reportModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg">
            <form action="<c:url value='/report-incident'/>" method="POST">

                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold">
                        <i class="fas fa-exclamation-triangle me-2"></i>Báo Cáo Sự Cố
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="alert alert-warning d-flex align-items-center" role="alert">
                        <i class="fas fa-server fa-2x me-3 opacity-50"></i>
                        <div>
                            <div class="small text-uppercase fw-bold opacity-75">Thiết bị gặp lỗi:</div>
                            <div class="fs-5 fw-bold text-dark" id="modalProductName"></div>
                            <div class="small">Serial: <span class="font-monospace fw-bold" id="modalProductSerial"></span></div>
                        </div>
                    </div>

                    <input type="hidden" name="productId" id="modalProductId" />

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Loại sự cố <span class="text-danger">*</span></label>
                            <select name="issueType" class="form-select py-2" required>
                                <option value="">-- Chọn loại yêu cầu --</option>
                                <option value="MAINTENANCE">Bảo dưỡng định kỳ</option>
                                <option value="REPLACEMENT">Thay thế phụ tùng</option>
                                <option value="BROKEN">Báo Lỗi / Hỏng hóc</option>
                                <option value="OTHER">Vấn đề khác</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày đề xuất kiểm tra</label>
                            <input type="date" name="preferredDate" id="preferredDateInput" class="form-control">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Khung giờ khách có thể tiếp nhận kiểm tra</label>
                            <select name="preferredTimeSlot" class="form-select py-2">
                                <option value="">-- Chọn khung giờ 120 phút --</option>
                                <option value="08:00|10:00|MORNING">08:00 - 10:00</option>
                                <option value="10:00|12:00|MORNING">10:00 - 12:00</option>
                                <option value="12:00|14:00|AFTERNOON">12:00 - 14:00</option>
                                <option value="14:00|16:00|AFTERNOON">14:00 - 16:00</option>
                                <option value="16:00|18:00|AFTERNOON">16:00 - 18:00</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold">Tiêu đề ngắn <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" placeholder="VD: Máy không đề nổ được..." required>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold">Mô tả chi tiết</label>
                            <textarea name="description" class="form-control" rows="4" placeholder="Mô tả kỹ hơn về hiện tượng..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-danger px-4 fw-bold">
                        <i class="fas fa-paper-plane me-2"></i> Gửi Báo Cáo
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    AOS.init({ duration: 800, once: true });

    function getStatusBadgeMarkup(status) {
        switch (status) {
            case 'RUNNING':
                return '<span class="badge bg-success-subtle text-success border border-success-subtle">Đang hoạt động</span>';
            case 'MAINTENANCE':
                return '<span class="badge bg-warning-subtle text-warning border border-warning-subtle">Đang bảo trì</span>';
            case 'BROKEN':
                return '<span class="badge bg-danger-subtle text-danger border border-danger-subtle">Hỏng hóc</span>';
            case 'RECEIVED_QUOTE':
                return '<span class="badge bg-primary-subtle text-primary border border-primary-subtle">Có báo giá</span>';
            default:
                return '<span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">' + (status || 'Chưa cập nhật') + '</span>';
        }
    }

    function formatDisplayDate(rawDate) {
        if (!rawDate) {
            return 'Chưa cập nhật';
        }
        const parsedDate = new Date(rawDate);
        if (Number.isNaN(parsedDate.getTime())) {
            return rawDate;
        }
        const day = String(parsedDate.getDate()).padStart(2, '0');
        const month = String(parsedDate.getMonth() + 1).padStart(2, '0');
        const year = parsedDate.getFullYear();
        return day + '/' + month + '/' + year;
    }

    function openDeviceDetail(card) {
        const data = card.dataset;
        document.getElementById('deviceDetailName').innerText = data.modelName;
        document.getElementById('deviceDetailSerial').innerText = data.serialNumber;
        document.getElementById('deviceDetailBrand').innerText = data.brandName;
        document.getElementById('deviceDetailModel').innerText = data.modelName;
        document.getElementById('deviceDetailCategory').innerText = data.categoryName;
        document.getElementById('deviceDetailLocation').innerText = data.location;
        document.getElementById('deviceDetailManufactureYear').innerText = data.manufactureYear;
        document.getElementById('deviceDetailPurchaseDate').innerText = formatDisplayDate(data.purchaseDate);
        document.getElementById('deviceDetailRunningHours').innerText = (data.runningHours || 0) + ' giờ';
        document.getElementById('deviceDetailStatus').innerHTML = getStatusBadgeMarkup(data.status);

        const historyButton = document.getElementById('deviceHistoryButton');
        historyButton.href = '<c:url value="/user/quote-history"/>' + '?productId=' + data.productId;

        const actionContainer = document.getElementById('deviceActionContainer');
        if (data.contractStatus === 'TERMINATED') {
            actionContainer.innerHTML = '<button type="button" class="btn btn-outline-danger btn-pill" disabled><i class="fas fa-ban me-1"></i>Hợp đồng đã dừng</button>';
        } else if (data.status === 'RECEIVED_QUOTE') {
            actionContainer.innerHTML = '<a href="' + '<c:url value="/user/view-quote"/>' + '?productId=' + data.productId + '" class="btn btn-primary btn-pill"><i class="fas fa-file-invoice-dollar me-1"></i>Xem báo giá</a>';
        } else if (data.status === 'MAINTENANCE') {
            actionContainer.innerHTML = '<button type="button" class="btn btn-secondary btn-pill" disabled><i class="fas fa-hourglass-half me-1"></i>Đã gửi yêu cầu</button>';
        } else {
            actionContainer.innerHTML = '<button type="button" class="btn btn-outline-danger btn-pill"><i class="fas fa-triangle-exclamation me-1"></i>Báo sự cố</button>';
            actionContainer.querySelector('button').addEventListener('click', function () {
                openReportModal(data.productId, data.modelName, data.serialNumber);
            }, { once: true });
        }

        var detailModal = new bootstrap.Modal(document.getElementById('deviceDetailModal'));
        detailModal.show();
    }

    function handleDeviceCardKeydown(event, element) {
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            openDeviceDetail(element);
        }
    }

    function openReportModal(id, name, serial) {
        document.getElementById('modalProductId').value = id;
        document.getElementById('modalProductName').innerText = name;
        document.getElementById('modalProductSerial').innerText = serial;

        var detailModalElement = document.getElementById('deviceDetailModal');
        var detailModalInstance = bootstrap.Modal.getInstance(detailModalElement);
        if (detailModalInstance) {
            detailModalInstance.hide();
        }

        var myModal = new bootstrap.Modal(document.getElementById('reportModal'));
        myModal.show();
    }

    document.addEventListener("DOMContentLoaded", function() {
        const dateInput = document.getElementById('preferredDateInput');
        if (dateInput) {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            dateInput.min = year + "-" + month + "-" + day;
        }
    });
</script>

<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>
