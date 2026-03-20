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
    <title>Danh sách Máy phát điện | Gen-CMS</title>

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

        /* NAVBAR */
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

        /* HERO */
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

        /* MAIN */
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

        /* FILTER */
        .filter-wrap{ padding: 12px 18px 18px; }
        .filter-grid{
            display:grid;
            grid-template-columns: 1.4fr .9fr auto;
            gap: 10px;
            align-items:end;
        }
        @media (max-width: 992px){
            .filter-grid{ grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 576px){
            .hero-title{ font-size: 1.9rem; }
            .filter-grid{ grid-template-columns: 1fr; }
        }

        .input-group-text{
            background: #f2f4f7 !important;
            border: 1px solid #eaecf0 !important;
        }
        .form-control, .form-select{
            border-radius: 14px;
            border: 1px solid #eaecf0;
            background:#fff;
            padding: 10px 12px;
        }
        .form-control:focus, .form-select:focus{
            border-color: rgba(78,115,223,.45);
            box-shadow: 0 0 0 .25rem rgba(78,115,223,.15);
        }

        .btn-pill{
            border-radius: 999px;
            padding: 10px 16px;
            font-weight: 800;
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

        /* TABLE */
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

        .product-badge{
            border-radius: 999px;
            padding: 8px 12px;
            font-weight: 900;
            letter-spacing: .2px;
            display:inline-block;
            background: rgba(148,163,184,.22);
            color:#334155;
        }

        .name{
            font-weight: 900;
            margin:0;
            color: #111827;
        }
        .meta{
            color: var(--muted);
            font-size: .9rem;
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
                          <a class="nav-link nav-pill px-3" href="<c:url value='/news'/>">Tin tức</a>
                        </li>
                <li class="nav-item">
                          <a class="nav-link nav-pill px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
                        </li>

                <c:choose>
                    <c:when test="${empty user}">
                    </c:when>
                    <c:otherwise>
                    </c:otherwise>
                </c:choose>
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
        <h1 class="hero-title">Danh sách Máy phát điện</h1>
    </div>
</section>

<main>
    <div class="container" data-aos="fade-up">

        <c:if test="${param.message == 'success'}">
            <div class="alert alert-success alert-dismissible fade show mb-4">
                <i class="fas fa-check-circle me-2"></i>Gửi báo cáo sự cố thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="main-card">

            <div class="card-header-soft">
                <h5 class="section-title">
                    <i class="fas fa-list"></i> Danh sách thiết bị
                </h5>
                <p class="section-sub">Dùng bộ lọc để tìm thiết bị theo Brand hoặc Từ khóa.</p>
            </div>

            <div class="filter-wrap">
                <form method="get" action="<c:url value='/product-list'/>">
                    <div class="filter-grid">

                        <div>
                            <label class="form-label fw-bold mb-1">Từ khóa</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-search text-muted"></i></span>
                                <input type="text"
                                       name="keyword"
                                       class="form-control"
                                       placeholder="Tìm theo serial / tên máy / brand..."
                                       value="${keyword != null ? keyword : ''}">
                            </div>
                        </div>

                        <div>
                            <label class="form-label fw-bold mb-1">Thương hiệu</label>
                            <select class="form-select" name="brandId">
                                <option value="">-- Tất cả --</option>
                                <c:forEach items="${brands}" var="b">
                                    <option value="${b.id}" ${brandId != null && brandId == b.id ? 'selected' : ''}>
                                            ${b.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-pill w-100">
                                <i class="fas fa-filter me-1"></i>Lọc
                            </button>
                            <a class="btn btn-outline-secondary btn-pill w-100" href="<c:url value='/product-list'/>">
                                Xóa
                            </a>
                        </div>

                    </div>
                </form>
            </div>

            <div class="table-responsive px-3 pb-3">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th class="ps-3">Serial</th>
                        <th>Model / Brand</th>
                        <th>Trạng thái</th>
                        <th class="text-end pe-3">Báo lỗi</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach items="${products}" var="p">
                        <tr>
                            <td class="ps-3">
                                <span class="fw-bold text-dark font-monospace">${p.serialNumber}</span>
                            </td>

                            <td>
                                <a href="<c:url value='/products/detail'><c:param name='id' value='${p.modelId}'/></c:url>"
                                   class="text-decoration-none">
                                    <p class="name mb-1 fw-bold text-primary">${p.modelName}</p>
                                </a>
                                <div class="meta text-muted small">
                                    <span class="fw-bold">${p.brandName}</span>
                                    <c:if test="${not empty p.currentLocation}">
                                        &nbsp;•&nbsp; <i class="fas fa-map-marker-alt me-1"></i>${p.currentLocation}
                                    </c:if>
                                </div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${p.status == 'MAINTENANCE'}">
                                        <span class="badge bg-warning text-dark rounded-pill px-3 py-2">
                                            <i class="fas fa-clock me-1"></i>Chờ phản hồi
                                        </span>
                                    </c:when>
                                    <c:when test="${p.status == 'RUNNING'}">
                                        <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2">Đang hoạt động</span>
                                    </c:when>
                                    <c:when test="${p.status == 'BROKEN'}">
                                        <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-2">Hỏng hóc</span>
                                    </c:when>

                                    <%-- THÊM MỚI: Trạng thái Đã nhận báo giá --%>
                                    <c:when test="${p.status == 'RECEIVED_QUOTE'}">
                                        <span class="badge bg-primary text-white rounded-pill px-3 py-2 shadow-sm">
                                            <i class="fas fa-file-invoice-dollar me-1"></i>Có báo giá mới
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge bg-secondary bg-opacity-10 text-secondary rounded-pill px-3 py-2">${p.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td class="text-end pe-3">
                                <div class="d-flex justify-content-end gap-2 align-items-center">

                                        <%-- NÚT XEM LỊCH SỬ BÁO GIÁ (Luôn hiển thị cho mọi máy) --%>
                                    <a href="<c:url value='/user/quote-history?productId=${p.id}'/>"
                                       class="btn btn-sm btn-outline-info btn-pill px-3 shadow-sm"
                                       title="Xem lịch sử các báo giá trước đây">
                                        <i class="fas fa-history me-1"></i>Lịch sử
                                    </a>

                                        <%-- CÁC NÚT HÀNH ĐỘNG CHÍNH (Dựa theo trạng thái) --%>
                                    <c:choose>
                                        <c:when test="${p.contractStatus == 'TERMINATED'}">
                                            <fmt:formatDate value="${p.terminatedAt}" pattern="dd/MM/yyyy HH:mm" var="terminatedAtText"/>
                                            <button type="button"
                                                    class="btn btn-sm btn-danger btn-pill px-3"
                                                    onclick="openTerminatedContractModal(this)"
                                                    data-reason="${fn:escapeXml(p.latestTerminatedEvent)}"
                                                    data-terminated-at="${terminatedAtText}">
                                                Contract terminated <i class="fas fa-circle-info ms-1"></i>
                                            </button>

                                            <span data-bs-toggle="tooltip" title="Hợp đồng đã chấm dứt, vui lòng liên hệ quản trị/CSKH.">
                                                <button type="button" class="btn btn-sm btn-outline-danger btn-pill px-3" disabled>
                                                    <i class="fas fa-triangle-exclamation me-1"></i>Báo sự cố
                                                </button>
                                            </span>
                                            <span data-bs-toggle="tooltip" title="Hợp đồng đã chấm dứt, vui lòng liên hệ quản trị/CSKH.">
                                                <button type="button" class="btn btn-sm btn-secondary btn-pill px-3" disabled>
                                                    <i class="fas fa-file-invoice-dollar me-1"></i>Xem báo giá
                                                </button>
                                            </span>
                                        </c:when>

                                        <%-- Có báo giá mới -> Nút nổi bật --%>
                                        <c:when test="${p.status == 'RECEIVED_QUOTE'}">
                                            <a href="<c:url value='/user/view-quote?productId=${p.id}'/>"
                                               class="btn btn-sm btn-primary btn-pill px-3 shadow-sm">
                                                <i class="fas fa-file-invoice-dollar me-1"></i>Xem báo giá
                                            </a>
                                        </c:when>

                                        <%-- Đang chờ xử lý -> Nút Disable --%>
                                        <c:when test="${p.status == 'MAINTENANCE'}">
                                            <button type="button" class="btn btn-sm btn-secondary btn-pill px-3" disabled
                                                    title="Bạn đã gửi báo cáo cho máy này rồi">
                                                <i class="fas fa-hourglass-half me-1"></i>Đã báo cáo
                                            </button>
                                        </c:when>

                                        <%-- Máy đang hỏng -> Báo tiếp (Nút đỏ) --%>
                                        <c:when test="${p.status == 'BROKEN'}">
                                            <button type="button" class="btn btn-sm btn-outline-danger btn-pill px-3"
                                                    onclick="openReportModal('${p.id}', '${p.modelName}', '${p.serialNumber}')">
                                                <i class="fas fa-triangle-exclamation me-1"></i>Báo tiếp
                                            </button>
                                        </c:when>

                                        <%-- Máy bình thường -> Báo sự cố --%>
                                        <c:otherwise>
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-danger btn-pill px-3"
                                                    onclick="openReportModal('${p.id}', '${p.modelName}', '${p.serialNumber}')">
                                                <i class="fas fa-triangle-exclamation me-1"></i>Báo sự cố
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="4" class="text-center py-5 text-muted">
                                <i class="fas fa-box-open fa-3x mb-3 opacity-50"></i>
                                <p class="mb-1 fw-bold">Không có máy phù hợp bộ lọc.</p>
                                <small>Hãy thử bỏ bớt điều kiện hoặc nhấn “Xóa”.</small>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>

                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="4" class="text-center py-5 text-muted">
                                <i class="fas fa-box-open fa-3x mb-3 opacity-50"></i>
                                <p class="mb-1 fw-bold">Không có máy phù hợp bộ lọc.</p>
                                <small>Hãy thử bỏ bớt điều kiện hoặc nhấn “Xóa”.</small>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="px-3 pb-4">
                    <nav>
                        <ul class="pagination justify-content-end mb-0">

                            <c:set var="kw" value="${keyword != null ? keyword : ''}" />

                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="<c:url value='/product-list'>
                                            <c:param name='page' value='${currentPage - 1}'/>
                                            <c:if test='${not empty brandId}'><c:param name='brandId' value='${brandId}'/></c:if>
                                            <c:if test='${not empty kw}'><c:param name='keyword' value='${kw}'/></c:if>
                                         </c:url>">
                                    Prev
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="<c:url value='/product-list'>
                                                <c:param name='page' value='${i}'/>
                                                <c:if test='${not empty brandId}'><c:param name='brandId' value='${brandId}'/></c:if>
                                                <c:if test='${not empty kw}'><c:param name='keyword' value='${kw}'/></c:if>
                                             </c:url>">
                                            ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="<c:url value='/product-list'>
                                            <c:param name='page' value='${currentPage + 1}'/>
                                            <c:if test='${not empty brandId}'><c:param name='brandId' value='${brandId}'/></c:if>
                                            <c:if test='${not empty kw}'><c:param name='keyword' value='${kw}'/></c:if>
                                         </c:url>">
                                    Next
                                </a>
                            </li>

                        </ul>
                    </nav>
                </div>
            </c:if>

        </div>
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
                <h5 class="modal-title fw-bold"><i class="fas fa-file-circle-xmark me-2"></i>Chi tiết hủy hợp đồng</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="terminated-modal-note">
                    <div><strong>Notice:</strong> Hợp đồng đã chấm dứt, vui lòng liên hệ quản trị/CSKH.</div>
                    <div class="mt-2"><strong>Lý do:</strong> <span id="terminatedReasonText">Không có thông tin.</span></div>
                    <div class="mt-1"><strong>Hủy lúc:</strong> <span id="terminatedAtText">Không rõ thời điểm.</span></div>
                </div>
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
                                <option value="PERIODIC">Bảo dưỡng định kỳ</option>
                                <option value="REPAIR">Thay thế phụ tùng</option>
                                <option value="INSPECTION">Báo Lỗi / Hỏng hóc</option>

                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày đề xuất kiểm tra</label>
                            <input type="date" name="preferredDate" id="preferredDateInput" class="form-control">
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

    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
        new bootstrap.Tooltip(tooltipTriggerEl);
    });

        function openTerminatedContractModal(trigger) {
        const reason = trigger.getAttribute('data-reason');
        const terminatedAt = trigger.getAttribute('data-terminated-at');

        document.getElementById('terminatedReasonText').innerText = reason && reason.trim()
            ? reason
            : 'Không có thông tin.';
        document.getElementById('terminatedAtText').innerText = terminatedAt && terminatedAt.trim()
            ? terminatedAt
            : 'Không rõ thời điểm.';

        const modal = new bootstrap.Modal(document.getElementById('terminatedContractModal'));
        modal.show();
    }

    // HÀM MỞ MODAL VÀ ĐIỀN DỮ LIỆU TỰ ĐỘNG
    function openReportModal(id, name, serial) {
        document.getElementById('modalProductId').value = id;
        document.getElementById('modalProductName').innerText = name;
        document.getElementById('modalProductSerial').innerText = serial;

        var myModal = new bootstrap.Modal(document.getElementById('reportModal'));
        myModal.show();
    }
    // HÀM CHẶN CHỌN NGÀY QUÁ KHỨ
    document.addEventListener("DOMContentLoaded", function() {
        const dateInput = document.getElementById('preferredDateInput');
        if (dateInput) {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');

            // SỬ DỤNG DẤU + ĐỂ NỐI CHUỖI, TRÁNH XUNG ĐỘT VỚI JSP
            dateInput.min = year + "-" + month + "-" + day;
        }
    });
</script>

<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>