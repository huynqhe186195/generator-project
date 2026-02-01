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
        :root {
            --primary: #4e73df;
            --secondary: #224abe;
            --dark-blue: #1a3a91;
        }

        html, body { height: 100%; }

        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
            background-color: #fdfdfd;
        }

        main {
            flex: 1;
            padding-bottom: 120px; /* tránh dính footer */
        }

        /* NAVBAR (TÁCH HẲN, KHÔNG CHE NỘI DUNG) */
        .navbar-landing {
            /* Không fixed-top nữa */
            position: sticky; /* nếu không muốn sticky thì đổi thành: position: relative; */
            top: 0;
            z-index: 1050;

            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 14px 0;
            transition: all 0.25s ease;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 1.8rem;
            color: #fff !important;
            transition: 0.3s;
        }

        .nav-link {
            color: rgba(255,255,255,0.92) !important;
            font-weight: 500;
            transition: 0.3s;
        }
        .nav-link:hover { opacity: .9; }

        .btn-white {
            background: white;
            color: var(--primary);
            font-weight: 700;
            border-radius: 50px;
            padding: 12px 35px;
            border: none;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-white:hover {
            transform: scale(1.03);
            box-shadow: 0 10px 20px rgba(0,0,0,0.18);
            color: var(--secondary);
        }

        .user-dropdown-toggle {
            background: rgba(255,255,255,0.18);
            color: white !important;
            border: 1px solid rgba(255,255,255,0.35);
            border-radius: 50px;
        }

        /* HERO */
        .hero-section {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 70px 0 70px; /* giảm vì navbar đã chiếm chỗ thật */
            clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
            position: relative;
        }
        .hero-title { font-weight: 800; font-size: 3rem; line-height: 1.2; margin-bottom: 15px; }
        .hero-desc { font-size: 1.1rem; opacity: 0.9; margin-bottom: 0; }

        /* CARD + TABLE */
        .main-card {
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,.08);
            background: white;
            overflow: hidden;
        }

        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,.15);
            background: #f1f1f1;
        }

        .table thead th {
            background-color: #f8f9fc;
            font-weight: 700;
            font-size: .85rem;
            text-transform: uppercase;
            color: #5a5c69;
        }

        /* FOOTER */
        footer {
            margin-top: auto;
            background: #1a1a1a;
            color: #888;
            padding: 30px 0 15px;
        }

        /* Mobile: tránh bị sát quá */
        @media (max-width: 576px) {
            .hero-title { font-size: 2rem; }
        }
    </style>
</head>

<body>

<!-- NAVBAR (KHÔNG FIXED-TOP) -->
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
                            <a href="<c:url value='/account/login'/>" class="btn btn-white px-4 shadow-sm">Đăng nhập</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown ms-lg-3">
                            <a class="nav-link dropdown-toggle px-3 user-dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
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

<!-- HERO -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8" data-aos="fade-right">
                <h1 class="hero-title">Danh sách Máy phát điện</h1>
                <p class="hero-desc">Quản lý, theo dõi và tra cứu thông tin các máy phát điện của bạn</p>
            </div>
        </div>
    </div>
</section>

<!-- MAIN -->
<main>
    <div class="container mt-4" data-aos="fade-up">
        <div class="main-card p-4">

            <!-- HEADER + FILTER -->
            <div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-3">
                <div>
                    <h5 class="fw-bold text-primary m-0">
                        <i class="fas fa-list me-2"></i>Danh sách thiết bị của bạn
                    </h5>
                    
                </div>

                <!-- FILTER FORM -->
                <form class="row g-2 align-items-center" method="get" action="<c:url value='/product-list'/>">

                    <!-- Keyword -->
                    <div class="col-auto">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text"
                                   name="keyword"
                                   class="form-control bg-light border-0"
                                   placeholder="Tìm theo tên máy..."
                                   value="${keyword != null ? keyword : ''}">
                        </div>
                    </div>

                    <!-- Brand -->
                    <div class="col-auto">
                        <select class="form-select" name="brandId">
                            <option value="">-- Thương hiệu --</option>
                            <c:forEach items="${brands}" var="b">
                                <option value="${b.id}" ${brandId != null && brandId == b.id ? 'selected' : ''}>
                                        ${b.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Fuel type -->
                    <div class="col-auto">
                        <select class="form-select" name="fuelType">
                            <option value="">-- Nhiên liêụ --</option>
                            <option value="DIESEL" ${fuelType == 'DIESEL' ? 'selected' : ''}>Diesel</option>
                            <option value="GASOLINE" ${fuelType == 'GASOLINE' ? 'selected' : ''}>Gasoline</option>
                        </select>
                    </div>

                    <!-- Min Power -->
                    <div class="col-auto">
                        <input type="number" step="0.1" class="form-control" name="minPower"
                               placeholder="Min kVA"
                               value="${minPower != null ? minPower : ''}">
                    </div>

                    <!-- Max Power -->
                    <div class="col-auto">
                        <input type="number" step="0.1" class="form-control" name="maxPower"
                               placeholder="Max kVA"
                               value="${maxPower != null ? maxPower : ''}">
                    </div>

                    <!-- Buttons -->
                    <div class="col-auto d-flex gap-2">
                        <button type="submit" class="btn btn-primary rounded-pill px-3">
                            <i class="fas fa-filter me-1"></i>Lọc
                        </button>
                        <a class="btn btn-outline-secondary rounded-pill px-3" href="<c:url value='/product-list'/>">
                            Xóa lọc
                        </a>
                    </div>

                </form>
            </div>

            <!-- TABLE -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th class="ps-3">Hình ảnh</th>
                        <th>Thông tin máy</th>
                        <th>Công suất</th>
                        <th>Nhiên Liệu</th>
                        <th class="text-end pe-3">Báo lỗi</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach items="${products}" var="p">
                        <tr>
                            <!-- Image -->
                            <td class="ps-3">
                                <c:choose>
                                    <c:when test="${not empty p.imageUrl and p.imageUrl.startsWith('http')}">
                                        <img src="${p.imageUrl}" class="product-img" alt="Generator">
                                    </c:when>
                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="<c:url value='/${p.imageUrl}'/>" class="product-img" alt="Generator">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/assets/img/default-generator.png'/>" class="product-img" alt="No image">
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- NAME + BRAND + MODEL -->
                            <td>
                                <div class="fw-bold text-dark">${p.name}</div>
                                <div class="text-muted small">
                                    <span class="fw-semibold">${p.brand.name}</span>
                                    &nbsp;•&nbsp;
                                    <span>${p.model}</span>
                                </div>
                            </td>

                            <!-- Power -->
                            <td>
                                <strong>${p.powerPrime}</strong>
                                <span class="text-muted small">kVA</span>
                            </td>

                            <!-- Fuel type -->
                            <td>
                                <c:choose>
                                    <c:when test="${p.fuelType == 'DIESEL'}">
                                        <span class="badge bg-warning text-dark">Diesel</span>
                                    </c:when>
                                    <c:when test="${p.fuelType == 'GASOLINE'}">
                                        <span class="badge bg-info text-dark">Gasoline</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${p.fuelType}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Report -->
                            <td class="text-end pe-3">
                                <form action="<c:url value='/product/report-error'/>" method="post">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="btn btn-sm btn-danger rounded-pill px-3">
                                        <i class="fas fa-triangle-exclamation me-1"></i>
                                        Báo lỗi
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">
                                <i class="fas fa-box-open fa-3x mb-3 opacity-50"></i>
                                <p class="mb-1">Không có máy phù hợp bộ lọc.</p>
                                <small>Hãy thử bỏ bớt điều kiện lọc hoặc nhấn “Xóa lọc”.</small>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</main>

<!-- FOOTER -->
<footer>
    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-6 text-center text-lg-start">
                <a href="#" class="text-white text-decoration-none fw-bold fs-4">
                    <i class="fas fa-bolt me-2"></i>Gen-CMS
                </a>
                <p class="mt-3">Giải pháp số hóa hệ thống năng lượng dự phòng hàng đầu.</p>
            </div>
            <div class="col-lg-6 text-center text-lg-end">
                <p class="small mb-0">&copy; 2024 Gen-CMS Corporation. Bảo lưu mọi quyền.</p>
                <div class="mt-2">
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-linkedin"></i></a>
                    <a href="#" class="text-white"><i class="fas fa-envelope"></i></a>
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
