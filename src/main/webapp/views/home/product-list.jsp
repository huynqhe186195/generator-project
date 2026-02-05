<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

                <c:choose>
                    <c:when test="${empty user}">
                        <li class="nav-item">
                            <a class="nav-link px-3" href="#/">Tin tức</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link px-3" href="<c:url value='product-list'/>">Sản phẩm</a>
                        </li>
                    </c:otherwise>
                </c:choose>

                <li class="nav-item"><a class="nav-link px-3" href="<c:url value='/'/>#features">Tính năng</a></li>
                <li class="nav-item"><a class="nav-link px-3" href="<c:url value='/'/>#brands">Thương hiệu</a></li>

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
        <p class="hero-desc">
            Quản lý, theo dõi và tra cứu thiết bị nhanh — lọc theo thương hiệu hoặc tìm theo tên máy / serial.
        </p>
    </div>
</section>

<main>
    <div class="container" data-aos="fade-up">
        <div class="main-card">

            <div class="card-header-soft">
                <h5 class="section-title">
                    <i class="fas fa-list"></i> Danh sách thiết bị
                </h5>
                <p class="section-sub">Dùng bộ lọc để tìm thiết bị theo Brand hoặc Từ khóa.</p>
            </div>

            <!-- FILTER -->
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

            <!-- TABLE -->
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
                                <span class="fw-bold">${p.serialNumber}</span>
                            </td>

                            <td>
                                <p class="name mb-1">${p.modelName}</p>
                                <div class="meta">
                                    <span class="fw-bold">${p.brandName}</span>
                                    <c:if test="${not empty p.currentLocation}">
                                        &nbsp;•&nbsp; <span>${p.currentLocation}</span>
                                    </c:if>
                                </div>
                            </td>

                            <td>
                                <span class="product-badge">${p.status}</span>
                            </td>

                            <td class="text-end pe-3">
                                <form action="<c:url value='/product/report-error'/>" method="post" class="d-inline">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="btn btn-sm btn-danger btn-pill px-3">
                                        <i class="fas fa-triangle-exclamation me-1"></i>Báo lỗi
                                    </button>
                                </form>
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
                </table>
            </div>

            <!-- PAGINATION -->
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    AOS.init({ duration: 800, once: true });
</script>

</body>
</html>
