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
        .lookup-card{
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

        .device-browser{
            display:grid;
            grid-template-columns: minmax(240px, 0.95fr) minmax(300px, 1.15fr) minmax(320px, 1.3fr);
            gap:20px;
        }
        .device-pane{
            background:#f8fafc;
            border:1px solid #e5e7eb;
            border-radius:20px;
            padding:18px;
            min-height: 100%;
        }
        .device-pane-head{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap:12px;
            margin-bottom:16px;
        }
        .device-pane-title{
            font-size:1rem;
            font-weight:900;
            color:#0f172a;
            margin:0;
        }
        .device-pane-sub{
            margin:4px 0 0;
            color:var(--muted);
            font-size:.85rem;
        }
        .device-count-badge{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            min-width:36px;
            height:36px;
            border-radius:999px;
            background:#e0e7ff;
            color:#3730a3;
            font-weight:900;
            padding:0 12px;
        }
        .device-model-list,
        .device-serial-list{
            display:grid;
            gap:12px;
        }
        .device-model-card,
        .device-serial-card{
            width:100%;
            border:1px solid #e5e7eb;
            border-radius:18px;
            background:#fff;
            padding:16px;
            text-align:left;
            transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease, background .18s ease;
            box-shadow: 0 10px 22px rgba(15,23,42,.05);
        }
        .device-model-card:hover,
        .device-serial-card:hover{
            transform: translateY(-2px);
            border-color: rgba(78,115,223,.28);
            box-shadow: 0 16px 28px rgba(15,23,42,.10);
        }
        .device-model-card.is-active,
        .device-serial-card.is-active{
            border-color: rgba(78,115,223,.45);
            background: linear-gradient(180deg, rgba(78,115,223,.10), rgba(255,255,255,.96));
            box-shadow: 0 20px 34px rgba(78,115,223,.14);
        }
        .device-model-card:focus-visible,
        .device-serial-card:focus-visible{
            outline: 3px solid rgba(78,115,223,.22);
            outline-offset: 3px;
        }
        .device-model-top,
        .device-serial-top{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap:12px;
        }
        .device-model-name,
        .device-serial-name{
            font-size:1rem;
            font-weight:900;
            color:#111827;
            margin:0;
        }
        .device-model-brand,
        .device-serial-meta,
        .device-empty-text{
            color:var(--muted);
            font-size:.88rem;
        }
        .device-qty-pill,
        .serial-pill{
            display:inline-flex;
            align-items:center;
            gap:8px;
            border-radius:999px;
            background:#eef2ff;
            color:#3730a3;
            padding:8px 14px;
            font-weight:800;
            font-size:.88rem;
        }
        .device-meta-list{
            display:grid;
            gap:10px;
            margin-top:14px;
        }
        .device-meta-row{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:16px;
            border-top:1px dashed #e5e7eb;
            padding-top:10px;
        }
        .device-meta-label{
            color:var(--muted);
            font-weight:700;
        }
        .device-meta-value{
            color:#0f172a;
            font-weight:800;
            text-align:right;
        }
        .device-detail-card{
            background:#fff;
            border:1px solid #e5e7eb;
            border-radius:18px;
            padding:20px;
            min-height:100%;
            box-shadow: 0 14px 30px rgba(15,23,42,.06);
        }
        .device-detail-hero{
            display:flex;
            flex-wrap:wrap;
            align-items:flex-start;
            justify-content:space-between;
            gap:14px;
            margin-bottom:18px;
        }
        .device-detail-title{
            font-size:1.2rem;
            font-weight:900;
            margin:0;
            color:#0f172a;
        }
        .device-detail-subtitle{
            margin:6px 0 0;
            color:var(--muted);
        }
        .device-detail-grid{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap:14px;
        }
        .device-detail-field{
            background:#f8fafc;
            border:1px solid #eaecf0;
            border-radius:16px;
            padding:14px;
        }
        .device-detail-field .label{
            color:var(--muted);
            font-size:.8rem;
            text-transform:uppercase;
            letter-spacing:.05em;
            margin-bottom:6px;
            font-weight:700;
        }
        .device-detail-field .value{
            color:#0f172a;
            font-weight:800;
            word-break:break-word;
        }
        .device-empty-state{
            display:grid;
            place-items:center;
            min-height:220px;
            text-align:center;
            color:var(--muted);
            border:1px dashed #d0d5dd;
            border-radius:18px;
            padding:24px;
            background:rgba(255,255,255,.75);
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

        @media (max-width: 1200px){
            .device-browser{
                grid-template-columns: 1fr 1fr;
            }
            .device-pane.device-detail-pane{
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 992px){
            .lookup-form{ grid-template-columns: 1fr; }
            .hero-title{ font-size: 2rem; }
            .device-browser{ grid-template-columns: 1fr; }
            .device-pane.device-detail-pane{ grid-column: auto; }
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
                            <div class="device-browser" id="deviceBrowser">
                                <div class="device-pane">
                                    <div class="device-pane-head">
                                        <div>
                                            <h6 class="device-pane-title">Tên máy phát điện</h6>
                                            <p class="device-pane-sub">Nhóm theo model thiết bị customer đang sở hữu trong hợp đồng.</p>
                                        </div>
                                        <span class="device-count-badge" id="deviceModelCount">0</span>
                                    </div>
                                    <div class="device-model-list" id="deviceModelList"></div>
                                </div>

                                <div class="device-pane">
                                    <div class="device-pane-head">
                                        <div>
                                            <h6 class="device-pane-title">Serial number thuộc máy</h6>
                                            <p class="device-pane-sub">Chọn một máy để xem các serial tương ứng cùng trạng thái và thương hiệu.</p>
                                        </div>
                                        <span class="device-count-badge" id="deviceSerialCount">0</span>
                                    </div>
                                    <div class="device-serial-list" id="deviceSerialList">
                                        <div class="device-empty-state">
                                            <div>
                                                <i class="fas fa-arrow-left-long fa-2x mb-3 opacity-50"></i>
                                                <div class="fw-bold text-dark mb-1">Chưa chọn dòng máy</div>
                                                <div class="device-empty-text">Hãy chọn tên máy ở cột bên trái để hệ thống hiển thị danh sách serial.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="device-pane device-detail-pane">
                                    <div class="device-pane-head">
                                        <div>
                                            <h6 class="device-pane-title">Chi tiết serial được chọn</h6>
                                            <p class="device-pane-sub">Thông tin vận hành chi tiết và các thao tác liên quan tới thiết bị.</p>
                                        </div>
                                    </div>
                                    <div class="device-detail-card" id="deviceDetailPanel">
                                        <div class="device-empty-state">
                                            <div>
                                                <i class="fas fa-microchip fa-2x mb-3 opacity-50"></i>
                                                <div class="fw-bold text-dark mb-1">Chưa chọn serial number</div>
                                                <div class="device-empty-text">Sau khi chọn một serial ở cột giữa, thông số chi tiết và các nút thao tác sẽ hiển thị tại đây.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-none" id="deviceDataStore">
                                <c:forEach items="${contractDevices}" var="p">
                                    <div class="js-device-record"
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
                                         data-contract-status="${fn:escapeXml(contract.status)}"></div>
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

    function escapeHtml(value) {
        return String(value || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function formatModelCount(count) {
        return count + ' thiết bị';
    }

    function getStatusText(status) {
        switch (status) {
            case 'RUNNING': return 'Đang hoạt động';
            case 'MAINTENANCE': return 'Đang bảo trì';
            case 'BROKEN': return 'Hỏng hóc';
            case 'RECEIVED_QUOTE': return 'Có báo giá';
            default: return status || 'Chưa cập nhật';
        }
    }

    function renderDeviceBrowser() {
        const browser = document.getElementById('deviceBrowser');
        const modelList = document.getElementById('deviceModelList');
        const serialList = document.getElementById('deviceSerialList');
        const detailPanel = document.getElementById('deviceDetailPanel');
        const modelCount = document.getElementById('deviceModelCount');
        const serialCount = document.getElementById('deviceSerialCount');
        const recordNodes = Array.from(document.querySelectorAll('.js-device-record'));

        if (!browser || !modelList || !serialList || !detailPanel || !recordNodes.length) {
            return;
        }

        const records = recordNodes.map(function (node, index) {
            return Object.assign({ modelKey: '', recordIndex: index }, node.dataset);
        });

        const grouped = [];
        const groupedMap = new Map();
        records.forEach(function (record) {
            const key = [record.modelName || '', record.brandName || '', record.categoryName || ''].join('||');
            record.modelKey = key;
            if (!groupedMap.has(key)) {
                groupedMap.set(key, {
                    key: key,
                    modelName: record.modelName,
                    brandName: record.brandName,
                    categoryName: record.categoryName,
                    items: []
                });
                grouped.push(groupedMap.get(key));
            }
            groupedMap.get(key).items.push(record);
        });

        let activeModelKey = grouped.length ? grouped[0].key : null;
        let activeProductId = grouped.length && grouped[0].items.length ? grouped[0].items[0].productId : null;

        function renderModels() {
            modelList.innerHTML = grouped.map(function (group) {
                return '' +
                    '<button type="button" class="device-model-card ' + (group.key === activeModelKey ? 'is-active' : '') + '" data-model-key="' + escapeHtml(group.key) + '">' +
                        '<div class="device-model-top">' +
                            '<div>' +
                                '<h6 class="device-model-name">' + escapeHtml(group.modelName) + '</h6>' +
                                '<div class="device-model-brand mt-1">' + escapeHtml(group.brandName) + '</div>' +
                            '</div>' +
                            '<span class="device-qty-pill"><i class="fas fa-layer-group"></i>' + group.items.length + '</span>' +
                        '</div>' +
                        '<div class="device-meta-list">' +
                            '<div class="device-meta-row"><span class="device-meta-label">Số lượng sở hữu</span><span class="device-meta-value">' + formatModelCount(group.items.length) + '</span></div>' +
                            '<div class="device-meta-row"><span class="device-meta-label">Danh mục</span><span class="device-meta-value">' + escapeHtml(group.categoryName) + '</span></div>' +
                        '</div>' +
                    '</button>';
            }).join('');
            modelCount.textContent = grouped.length;

            modelList.querySelectorAll('.device-model-card').forEach(function (button) {
                button.addEventListener('click', function () {
                    activeModelKey = button.dataset.modelKey;
                    const group = groupedMap.get(activeModelKey);
                    activeProductId = group && group.items.length ? group.items[0].productId : null;
                    renderModels();
                    renderSerials();
                    renderDetail();
                });
            });
        }

        function renderSerials() {
            const group = groupedMap.get(activeModelKey);
            if (!group || !group.items.length) {
                serialCount.textContent = '0';
                serialList.innerHTML = '<div class="device-empty-state"><div><i class="fas fa-microchip fa-2x mb-3 opacity-50"></i><div class="fw-bold text-dark mb-1">Không có serial</div><div class="device-empty-text">Dòng máy này hiện chưa có serial được gán.</div></div></div>';
                return;
            }

            if (!group.items.some(function (item) { return item.productId === activeProductId; })) {
                activeProductId = group.items[0].productId;
            }

            serialCount.textContent = group.items.length;
            serialList.innerHTML = group.items.map(function (item) {
                return '' +
                    '<button type="button" class="device-serial-card ' + (item.productId === activeProductId ? 'is-active' : '') + '" data-product-id="' + escapeHtml(item.productId) + '">' +
                        '<div class="device-serial-top">' +
                            '<div>' +
                                '<div class="serial-pill mb-3"><i class="fas fa-barcode"></i>' + escapeHtml(item.serialNumber) + '</div>' +
                                '<h6 class="device-serial-name">' + escapeHtml(item.modelName) + '</h6>' +
                                '<div class="device-serial-meta mt-1">' + escapeHtml(item.brandName) + '</div>' +
                            '</div>' +
                            getStatusBadgeMarkup(item.status) +
                        '</div>' +
                        '<div class="device-meta-list">' +
                            '<div class="device-meta-row"><span class="device-meta-label">Trạng thái</span><span class="device-meta-value">' + escapeHtml(getStatusText(item.status)) + '</span></div>' +
                            '<div class="device-meta-row"><span class="device-meta-label">Thương hiệu</span><span class="device-meta-value">' + escapeHtml(item.brandName) + '</span></div>' +
                        '</div>' +
                    '</button>';
            }).join('');

            serialList.querySelectorAll('.device-serial-card').forEach(function (button) {
                button.addEventListener('click', function () {
                    activeProductId = button.dataset.productId;
                    renderSerials();
                    renderDetail();
                });
            });
        }

        function renderDetail() {
            const record = records.find(function (item) { return item.productId === activeProductId; });
            if (!record) {
                detailPanel.innerHTML = '<div class="device-empty-state"><div><i class="fas fa-microchip fa-2x mb-3 opacity-50"></i><div class="fw-bold text-dark mb-1">Chưa chọn serial number</div><div class="device-empty-text">Sau khi chọn một serial ở cột giữa, thông số chi tiết và các nút thao tác sẽ hiển thị tại đây.</div></div></div>';
                return;
            }

            let incidentAction = '';
            if (record.contractStatus === 'TERMINATED') {
                incidentAction = '<button type="button" class="btn btn-outline-danger btn-pill" disabled><i class="fas fa-ban me-1"></i>Hợp đồng đã dừng</button>';
            } else if (record.status === 'MAINTENANCE') {
                incidentAction = '<button type="button" class="btn btn-secondary btn-pill" disabled><i class="fas fa-hourglass-half me-1"></i>Đang bảo trì</button>';
            } else {
                incidentAction = '<button type="button" class="btn btn-outline-danger btn-pill" id="detailReportButton"><i class="fas fa-triangle-exclamation me-1"></i>Báo cáo sự cố</button>';
            }

            const quoteAction = record.status === 'RECEIVED_QUOTE'
                ? '<a href="<c:url value="/user/view-quote"/>?productId=' + encodeURIComponent(record.productId) + '" class="btn btn-primary btn-pill"><i class="fas fa-file-invoice-dollar me-1"></i>Xem báo giá</a>'
                : '';

            detailPanel.innerHTML = '' +
                '<div class="device-detail-hero">' +
                    '<div>' +
                        '<div class="serial-pill mb-3"><i class="fas fa-barcode"></i>' + escapeHtml(record.serialNumber) + '</div>' +
                        '<h5 class="device-detail-title">' + escapeHtml(record.modelName) + '</h5>' +
                        '<p class="device-detail-subtitle">Thương hiệu ' + escapeHtml(record.brandName) + ' · Danh mục ' + escapeHtml(record.categoryName) + '</p>' +
                    '</div>' +
                    '<div>' + getStatusBadgeMarkup(record.status) + '</div>' +
                '</div>' +
                '<div class="device-detail-grid mb-4">' +
                    '<div class="device-detail-field"><div class="label">Serial number</div><div class="value">' + escapeHtml(record.serialNumber) + '</div></div>' +
                    '<div class="device-detail-field"><div class="label">Model thiết bị</div><div class="value">' + escapeHtml(record.modelName) + '</div></div>' +
                    '<div class="device-detail-field"><div class="label">Thương hiệu</div><div class="value">' + escapeHtml(record.brandName) + '</div></div>' +
                    '<div class="device-detail-field"><div class="label">Trạng thái</div><div class="value">' + escapeHtml(getStatusText(record.status)) + '</div></div>' +
                    '<div class="device-detail-field"><div class="label">Địa điểm hiện tại</div><div class="value">' + escapeHtml(record.location) + '</div></div>' +
                    '<div class="device-detail-field"><div class="label">Năm sản xuất</div><div class="value">' + escapeHtml(record.manufactureYear) + '</div></div>' +
                    '<div class="device-detail-field"><div class="label">Ngày mua</div><div class="value">' + escapeHtml(formatDisplayDate(record.purchaseDate)) + '</div></div>' +
                    '<div class="device-detail-field"><div class="label">Tổng giờ chạy</div><div class="value">' + escapeHtml((record.runningHours || 0) + ' giờ') + '</div></div>' +
                '</div>' +
                '<div class="detail-actions">' +
                    '<a href="<c:url value="/user/quote-history"/>?productId=' + encodeURIComponent(record.productId) + '" class="btn btn-outline-info btn-pill"><i class="fas fa-history me-1"></i>Lịch sử báo giá</a>' +
                    incidentAction +
                    quoteAction +
                '</div>';

            const reportButton = document.getElementById('detailReportButton');
            if (reportButton) {
                reportButton.addEventListener('click', function () {
                    openReportModal(record.productId, record.modelName, record.serialNumber);
                });
            }
        }

        renderModels();
        renderSerials();
        renderDetail();
    }

    function openReportModal(id, name, serial) {
        document.getElementById('modalProductId').value = id;
        document.getElementById('modalProductName').innerText = name;
        document.getElementById('modalProductSerial').innerText = serial;

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

        renderDeviceBrowser();
    });
</script>

<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>
