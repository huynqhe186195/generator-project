<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        /* Navbar */
        .navbar-landing { background-color: transparent; padding-top: 20px; position: absolute; width: 100%; z-index: 10; }
        .navbar-brand { font-weight: 800; font-size: 1.8rem; color: #fff !important; }
        .nav-link { color: rgba(255,255,255,0.8) !important; font-weight: 500; }
        .nav-link:hover { color: #fff !important; }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            color: white;
            padding-top: 150px;
            padding-bottom: 100px;
            clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
        }

        .hero-title { font-weight: 800; font-size: 3.5rem; line-height: 1.2; margin-bottom: 20px; }
        .hero-desc { font-size: 1.25rem; margin-bottom: 40px; color: rgba(255,255,255,0.8); }

        .btn-white { background-color: white; color: #4e73df; font-weight: 700; padding: 12px 30px; border-radius: 50px; transition: all 0.3s; }
        .btn-white:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.2); background-color: #f8f9fa; color: #224abe; }

        .btn-outline-light-custom { border: 2px solid rgba(255,255,255,0.3); color: white; border-radius: 50px; padding: 12px 30px; font-weight: 600; margin-left: 15px; }
        .btn-outline-light-custom:hover { background-color: rgba(255,255,255,0.1); color: white; border-color: #fff; }

        /* Features Section */
        .features-section { padding: 80px 0; background-color: #f8f9fa; }
        .feature-card { background: white; padding: 40px 30px; border-radius: 15px; border: none; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: 0.3s; height: 100%; }
        .feature-card:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        .feature-icon { width: 60px; height: 60px; background-color: #eef2fd; color: #4e73df; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 20px; }

        .hero-image {
            width: 400px;
            height: 300px;
            background-image: url('${pageContext.request.contextPath}/template/images/img.png');
            background-size: cover;
            background-position: center;
            border-radius: 12px;
        }

        footer { background-color: #333; color: #aaa; padding: 40px 0; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-landing">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>"><i class="fas fa-bolt me-2"></i>Gen-CMS</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="#features">Tính năng</a></li>
                <li class="nav-item"><a class="nav-link" href="#about">Về chúng tôi</a></li>
                <li class="nav-item ms-3">
                    <!-- ✅ THAY ĐỔI: Gọi qua servlet thay vì JSP trực tiếp -->
                    <a href="<c:url value='/login'/>" class="btn btn-sm btn-light fw-bold text-primary px-3 rounded-pill">Đăng nhập</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">

            <!-- BÊN TRÁI -->
            <div class="col-lg-6">
                <h1 class="hero-title">Quản lý hệ thống máy phát điện thông minh</h1>
                <p class="hero-desc">
                    Quản lý giám sát, cảnh báo sự cố và tối ưu hóa quy trình bảo trì cho máy phát điện của bạn.
                </p>
                <div class="d-flex gap-3">
                    <!-- ✅ THAY ĐỔI: Gọi qua servlet -->
                    <a href="<c:url value='/login'/>" class="btn btn-white shadow-lg">
                        <i class="fas fa-sign-in-alt me-2"></i> Truy cập hệ thống
                    </a>
                    <a href="#features" class="btn btn-outline-light-custom">Tìm hiểu thêm</a>
                </div>
            </div>

            <!-- BÊN PHẢI -->
            <div class="col-lg-6 d-flex justify-content-center">
                <div class="hero-image"></div>
            </div>

        </div>
    </div>
</section>

<section id="features" class="features-section">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Tính năng vượt trội</h2>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="d-flex justify-content-center">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                    </div>
                    <h4 class="fw-bold mb-3">Giám sát thời gian thực</h4>
                    <p class="text-muted">Theo dõi trạng thái hoạt động của từng máy 24/7.</p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="d-flex justify-content-center">
                        <div class="feature-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                    </div>
                    <h4 class="fw-bold mb-3">Cảnh báo thông minh</h4>
                    <p class="text-muted">Nhận thông báo tức thời qua Email/SMS khi có sự cố phát sinh.</p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="d-flex justify-content-center">
                        <div class="feature-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                    </div>
                    <h4 class="fw-bold mb-3">Quản lý bảo trì</h4>
                    <p class="text-muted">Lên lịch bảo trì, lưu trữ lịch sử sửa chữa và quản lý đội ngũ kỹ thuật hiệu quả.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="py-5 bg-white text-center">
    <div class="container">
        <!-- ✅ THAY ĐỔI: Gọi qua servlet -->
        <a href="<c:url value='/login'/>" class="btn btn-primary btn-lg rounded-pill px-5 shadow">
            Đăng nhập ngay
        </a>
    </div>
</section>

<footer>
    <div class="container text-center">
        <div class="mb-3">
            <a href="<c:url value='/'/>" class="text-white text-decoration-none mx-2 fw-bold fs-5"><i class="fas fa-bolt me-1"></i>Gen-CMS</a>
        </div>
        <p class="small mb-0">&copy; 2024 Gen-CMS Corporation. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> //oke