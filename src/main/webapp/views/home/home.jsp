<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Lấy user từ session để kiểm tra trạng thái đăng nhập --%>
<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gen-CMS | Hệ thống Quản trị Máy phát điện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; overflow-x: hidden; }
        .navbar-landing { background-color: transparent; padding-top: 20px; position: absolute; width: 100%; z-index: 1000; }
        .navbar-brand { font-weight: 800; font-size: 1.8rem; color: #fff !important; }
        .nav-link { color: rgba(255,255,255,0.8) !important; font-weight: 500; }
        .nav-link:hover { color: #fff !important; }

        .hero-section {
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            color: white;
            padding-top: 150px;
            padding-bottom: 120px;
            clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
        }

        .hero-title { font-weight: 800; font-size: 3.5rem; line-height: 1.2; margin-bottom: 20px; }
        .hero-desc { font-size: 1.25rem; margin-bottom: 40px; color: rgba(255,255,255,0.8); }

        .stat-badge {
            background: rgba(255,255,255,0.15);
            padding: 15px 25px;
            border-radius: 15px;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255,255,255,0.2);
            text-align: center;
        }
        .stat-number { font-size: 1.8rem; font-weight: 800; display: block; }
        .stat-label { font-size: 0.85rem; text-transform: uppercase; opacity: 0.8; }

        .btn-white { background-color: white; color: #4e73df; font-weight: 700; padding: 12px 30px; border-radius: 50px; transition: 0.3s; text-decoration: none; display: inline-block; border: none; }
        .btn-white:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.2); color: #224abe; }

        .features-section { padding: 80px 0; background-color: #f8f9fa; }
        .feature-card { background: white; padding: 40px 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: 0.3s; height: 100%; border: none; }
        .feature-card:hover { transform: translateY(-10px); }
        .feature-icon { width: 60px; height: 60px; background-color: #eef2fd; color: #4e73df; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 20px; }

        .brand-item { padding: 20px; background: white; border-radius: 10px; text-align: center; border: 1px solid #eee; transition: 0.3s; }
        .brand-item:hover { border-color: #4e73df; color: #4e73df; }

        /* Sửa lỗi hiển thị dropdown */
        .user-dropdown-toggle { background: rgba(255,255,255,0.2); color: white !important; border: 1px solid rgba(255,255,255,0.4); }
        .dropdown-menu { z-index: 2000; }
        footer { background-color: #333; color: #aaa; padding: 40px 0; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-landing">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>"><i class="fas fa-bolt me-2"></i>Gen-CMS</a>

        <button class="navbar-toggler border-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="#">Sơ lược công ty</a></li>
                <li class="nav-item"><a class="nav-link" href="#">sản phâm</a></li>
                <li class="nav-item"><a class="nav-link" href="#features">Tính năng</a></li>
                <li class="nav-item"><a class="nav-link" href="#brands">Thương hiệu</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Chăm sóc khách hàng</a></li>
                <c:choose>
                    <c:when test="${empty user}">
                        <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                            <a href="<c:url value='/account/login'/>" class="btn btn-white px-4 py-2">Đăng nhập</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown ms-lg-3 mt-2 mt-lg-0">
                            <a class="nav-link dropdown-toggle btn btn-sm user-dropdown-toggle px-3 rounded-pill"
                               href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle me-1"></i> ${user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                <li><a class="dropdown-item" href="<c:url value='/account/user-profile'/>"><i class="fas fa-id-card me-2"></i>Hồ sơ cá nhân</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger fw-bold" href="<c:url value='/account/logout'/>"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <h1 class="hero-title">Quản lý hệ thống máy phát điện thông minh</h1>
                <p class="hero-desc">Theo dõi, cảnh báo và tối ưu hóa quy trình bảo trì chuyên nghiệp.</p>

                <div class="row g-3 mb-5">
                    <div class="col-4">
                        <div class="stat-badge">
                            <span class="stat-number">${not empty stats.totalProducts ? stats.totalProducts : '150'}</span>
                            <span class="stat-label">Máy phát</span>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="stat-badge">
                            <span class="stat-number">${not empty stats.totalHours ? stats.totalHours : '1.2k'}</span>
                            <span class="stat-label">Giờ chạy</span>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="stat-badge">
                            <span class="stat-number">${not empty stats.totalUsers ? stats.totalUsers : '45'}</span>
                            <span class="stat-label">Người dùng</span>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-3">
                    <c:choose>
                        <c:when test="${empty user}">
                            <a href="<c:url value='/account/login'/>" class="btn btn-white shadow-lg">Bắt đầu ngay</a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/admin/dashboard'/>" class="btn btn-white shadow-lg">Vào Dashboard</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-lg-5 text-center d-none d-lg-block">
                <%-- Sửa đường dẫn ảnh để đảm bảo luôn load được --%>
                <img src="<c:url value='/template/images/img.png'/>" class="img-fluid rounded-4 shadow-lg" alt="Gen-CMS" onerror="this.src='https://via.placeholder.com/500x400?text=Generator+System'">
            </div>
        </div>
    </div>
</section>

<section id="brands" class="py-5 bg-white">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Đối tác Thương hiệu</h2>
            <p class="text-muted">Chúng tôi hỗ trợ quản lý đa dạng các dòng máy từ các hãng lớn</p>
        </div>
        <div class="row g-4 justify-content-center">
            <c:choose>
                <c:when test="${not empty brands}">
                    <c:forEach var="brand" items="${brands}">
                        <div class="col-6 col-md-3 col-lg-2">
                            <div class="brand-item shadow-sm">
                                <i class="fas fa-industry mb-2 d-block text-primary"></i>
                                <span class="fw-bold">${brand.name}</span>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center text-muted">Đang cập nhật danh sách thương hiệu...</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<section id="features" class="features-section">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Tính năng vượt trội</h2>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card feature-card text-center">
                    <div class="d-flex justify-content-center"><div class="feature-icon"><i class="fas fa-chart-line"></i></div></div>
                    <h4 class="fw-bold mb-3">Giám sát 24/7</h4>
                    <p class="text-muted">Theo dõi trạng thái hoạt động của từng máy theo thời gian thực.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card text-center">
                    <div class="d-flex justify-content-center"><div class="feature-icon"><i class="fas fa-exclamation-triangle"></i></div></div>
                    <h4 class="fw-bold mb-3">Cảnh báo tức thì</h4>
                    <p class="text-muted">Nhận thông báo qua Email/SMS ngay khi phát hiện sự cố.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card text-center">
                    <div class="d-flex justify-content-center"><div class="feature-icon"><i class="fas fa-tasks"></i></div></div>
                    <h4 class="fw-bold mb-3">Lịch bảo trì</h4>
                    <p class="text-muted">Tự động nhắc lịch và quản lý lịch sử sửa chữa chi tiết.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="container text-center">
        <div class="mb-3">
            <a href="#" class="text-white text-decoration-none fw-bold fs-5"><i class="fas fa-bolt me-1"></i>Gen-CMS</a>
        </div>
        <p class="small mb-0">&copy; 2024 Gen-CMS Corporation. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>