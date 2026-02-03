<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gen-CMS | Hệ thống Quản trị Máy phát điện</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

    <style>
        :root {
            --primary: #4e73df;
            --secondary: #224abe;
            --dark-blue: #1a3a91;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; overflow-x: hidden; background-color: #fdfdfd; }

        /* Navbar Styles */
        .navbar-landing {
            background: transparent;
            padding: 20px 0;
            transition: all 0.4s ease;
            z-index: 1050;
        }

        .navbar-scrolled {
            background: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(10px);
            padding: 10px 0;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .navbar-brand { font-weight: 800; font-size: 1.8rem; color: #fff !important; transition: 0.3s; }
        .navbar-scrolled .navbar-brand { color: var(--primary) !important; }

        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; transition: 0.3s; }
        .navbar-scrolled .nav-link { color: #444 !important; }
        .navbar-scrolled .nav-link:hover { color: var(--primary) !important; }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 180px 0 120px;
            clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
            position: relative;
        }

        .hero-title { font-weight: 800; font-size: 3.5rem; line-height: 1.2; margin-bottom: 25px; }
        .hero-desc { font-size: 1.2rem; opacity: 0.9; margin-bottom: 40px; }

        /* Stats & Badges */
        .stat-badge {
            background: rgba(255,255,255,0.15);
            padding: 20px;
            border-radius: 20px;
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.2);
            text-align: center;
            transition: 0.3s;
        }
        .stat-badge:hover { background: rgba(255,255,255,0.25); transform: translateY(-5px); }
        .stat-number { font-size: 2rem; font-weight: 800; display: block; }
        .stat-label { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; }

        /* Buttons */
        .btn-white { background: white; color: var(--primary); font-weight: 700; border-radius: 50px; padding: 12px 35px; border: none; transition: 0.3s; text-decoration: none; display: inline-block; }
        .btn-white:hover { transform: scale(1.05); box-shadow: 0 10px 20px rgba(0,0,0,0.2); color: var(--secondary); }

        .user-dropdown-toggle {
            background: rgba(255,255,255,0.2);
            color: white !important;
            border: 1px solid rgba(255,255,255,0.4);
            border-radius: 50px;
        }
        .navbar-scrolled .user-dropdown-toggle {
            color: var(--primary) !important;
            border-color: var(--primary);
        }

        /* Features */
        .feature-card {
            border: none;
            border-radius: 20px;
            padding: 40px;
            background: #fff;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: 0.4s;
            height: 100%;
        }
        .feature-card:hover { transform: translateY(-10px); box-shadow: 0 20px 40px rgba(0,0,0,0.1); }
        .feature-icon {
            width: 70px; height: 70px; background: #eef2fd; color: var(--primary);
            border-radius: 15px; display: flex; align-items: center; justify-content: center;
            font-size: 2rem; margin: 0 auto 25px;
        }

        /* Brands */
        .brand-item {
            padding: 25px; background: #fff; border-radius: 15px; border: 1px solid #eee;
            transition: 0.3s; text-align: center;
        }
        .brand-item:hover { border-color: var(--primary); color: var(--primary); transform: scale(1.05); }

        footer { background: #1a1a1a; color: #888; padding: 60px 0 30px; }

        /* CHỈNH ẢNH */
        .hero-img-col { padding-left: 64px; }
        .hero-img { transform: scale(1.15) translateX(12px); transform-origin: center right; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-landing fixed-top" id="mainNav">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>"><i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS</a>

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
                            <a class="nav-link px-3" href="#news">Tin tức</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link px-3" href="<c:url value='/product-list'/>">Sản phẩm</a>
                        </li>
                    </c:otherwise>
                </c:choose>

                <li class="nav-item"><a class="nav-link px-3" href="#features">Tính năng</a></li>
                <li class="nav-item"><a class="nav-link px-3" href="#brands">Thương hiệu</a></li>

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
                                <li><a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>"><i class="fas fa-id-card me-2"></i>Hồ sơ</a></li>
                                <li><a class="dropdown-item py-2" href="<c:url value='/account/change-password'/>"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
                                <li><a class="dropdown-item py-2 text-danger fw-bold" href="<c:url value='/account/logout'/>"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
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
            <div class="col-lg-7" data-aos="fade-right">
                <h1 class="hero-title">Quản lý hệ thống máy phát điện thông minh</h1>
                <p class="hero-desc">Theo dõi, cảnh báo và tối ưu hóa quy trình bảo trì chuyên nghiệp với công nghệ IoT thời gian thực.</p>

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
                            <a href="<c:url value='/login'/>" class="btn btn-white py-3 px-5 shadow-lg">Bắt đầu ngay</a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/admin/dashboard'/>" class="btn btn-white py-3 px-5 shadow-lg">Vào Dashboard</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="col-lg-5 d-none d-lg-block hero-img-col" data-aos="zoom-in">
                <img src="<c:url value='/template/images/img.png'/>"
                     class="img-fluid rounded-4 shadow-2xl hero-img"
                     alt="Gen-CMS"
                     onerror="this.src='https://via.placeholder.com/500x400?text=Gen-CMS+System'">
            </div>
        </div>
    </div>
</section>

<section id="features" class="py-5">
    <div class="container py-5">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="fw-bold fs-1">Tính năng vượt trội</h2>
            <p class="text-muted">Đem lại hiệu quả tối đa cho việc vận hành trạm máy</p>
        </div>
        <div class="row g-4">
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <div class="feature-card text-center">
                    <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
                    <h4 class="fw-bold mb-3">Giám sát thời gian thực</h4>
                    <p class="text-muted">Theo dõi trạng thái hoạt động của từng máy 24/7.</p>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="feature-card text-center">
                    <div class="feature-icon"><i class="fas fa-exclamation-triangle"></i></div>
                    <h4 class="fw-bold mb-3">Cảnh báo tức thì</h4>
                    <p class="text-muted">Nhận thông báo tức thời qua Email/SMS khi có sự cố phát sinh.</p>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                <div class="feature-card text-center">
                    <div class="feature-icon"><i class="fas fa-tasks"></i></div>
                    <h4 class="fw-bold mb-3">Quản lý bảo trì</h4>
                    <p class="text-muted">Lên lịch bảo trì, lưu trữ lịch sử sửa chữa và quản lý đội ngũ kỹ thuật hiệu quả.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="brands" class="py-5 bg-light">
    <div class="container py-4">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="fw-bold">Đối tác Thương hiệu</h2>
            <p class="text-muted">Hỗ trợ kết nối với hầu hết các dòng máy phát điện hiện nay</p>
        </div>
        <div class="row g-4 justify-content-center">
            <c:choose>
                <c:when test="${not empty brands}">
                    <c:forEach var="brand" items="${brands}">
                        <div class="col-6 col-md-3 col-lg-2" data-aos="zoom-in">
                            <div class="brand-item shadow-sm">
                                <i class="fas fa-industry mb-2 d-block text-primary"></i>
                                <span class="fw-bold">${brand.name}</span>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-4 col-md-2 brand-item"><i class="fas fa-industry fa-2x mb-2"></i><br>CUMMINS</div>
                    <div class="col-4 col-md-2 brand-item"><i class="fas fa-industry fa-2x mb-2"></i><br>PERKINS</div>
                    <div class="col-4 col-md-2 brand-item"><i class="fas fa-industry fa-2x mb-2"></i><br>DENYO</div>
                    <div class="col-4 col-md-2 brand-item"><i class="fas fa-industry fa-2x mb-2"></i><br>MITSUBISHI</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<footer>
    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-6 text-center text-lg-start">
                <a href="<c:url value='/'/>" class="text-white text-decoration-none fw-bold fs-4">
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

    const mainNav = document.getElementById('mainNav');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) mainNav.classList.add('navbar-scrolled');
        else mainNav.classList.remove('navbar-scrolled');
    });
</script>
</body>
</html>
