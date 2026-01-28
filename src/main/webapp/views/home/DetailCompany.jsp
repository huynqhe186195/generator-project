<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gen-CMS | Sơ lược công ty</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

  <style>
    :root {
      --primary: #4e73df;
      --secondary: #224abe;
      --dark-blue: #1a3a91;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      overflow-x: hidden;
      background-color: #fdfdfd;
      color: #333;
    }

    /* ===== NAVBAR (COPY từ HOME) ===== */
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
      transform: scale(1.05);
      box-shadow: 0 10px 20px rgba(0,0,0,0.2);
      color: var(--secondary);
    }

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

    /* ===== HERO (đồng bộ form Home) ===== */
    .hero-section {
      background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
      color: white;
      padding: 180px 0 120px;
      clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
      position: relative;
    }
    .hero-title { font-weight: 800; font-size: 3.2rem; line-height: 1.2; margin-bottom: 18px; }
    .hero-desc { font-size: 1.15rem; opacity: 0.92; margin-bottom: 28px; }

    /* ===== SECTION / CARD style (đồng bộ Home vibe) ===== */
    .section-wrap { padding: 80px 0; }
    .section-heading h2 { font-weight: 800; font-size: 2.2rem; }
    .section-heading p { color: #6c757d; }

    .info-card {
      border: none;
      border-radius: 20px;
      padding: 35px;
      background: #fff;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
      transition: 0.4s;
      height: 100%;
    }
    .info-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 20px 40px rgba(0,0,0,0.1);
    }

    .entity-icon {
      width: 70px; height: 70px;
      background: #eef2fd;
      color: var(--primary);
      border-radius: 15px;
      display: flex; align-items: center; justify-content: center;
      font-size: 2rem;
      margin: 0 auto 20px;
    }

    .highlight-box {
      background: #fff;
      border-radius: 20px;
      padding: 28px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
      border-left: 6px solid var(--primary);
    }

    /* ===== FOOTER (COPY từ HOME) ===== */
    footer { background: #1a1a1a; color: #888; padding: 60px 0 30px; }
  </style>
</head>

<body>

<!-- NAVBAR: dùng y hệt Home + scroll effect -->
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
              <!-- bạn có thể thay link tin tức thật ở đây -->
              <a class="nav-link px-3" href="#">Tin tức</a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link px-3" href="<c:url value='/product-list'/>">Sản phẩm</a>
            </li>
          </c:otherwise>
        </c:choose>

        <li class="nav-item"><a class="nav-link px-3" href="<c:url value='/?#features'/>">Tính năng</a></li>
        <li class="nav-item"><a class="nav-link px-3" href="<c:url value='/?#brands'/>">Thương hiệu</a></li>

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

<!-- HERO: cùng form Home -->
<section class="hero-section">
  <div class="container">
    <div class="row align-items-center">
      <div class="col-lg-7" data-aos="fade-right">
        <h1 class="hero-title">Sơ lược công ty & hệ thống Gen-CMS</h1>
        <p class="hero-desc">
          Giải pháp số hoá quản trị máy phát điện, giúp theo dõi thiết bị, lịch bảo trì và vận hành tập trung – nhanh, chuẩn, dễ mở rộng.
        </p>

        <div class="d-flex gap-3">
          <c:choose>
            <c:when test="${empty user}">
              <a href="<c:url value='/account/login'/>" class="btn btn-white py-3 px-5 shadow-lg">Bắt đầu ngay</a>
            </c:when>
            <c:otherwise>
              <a href="<c:url value='/admin/dashboard'/>" class="btn btn-white py-3 px-5 shadow-lg">Vào Dashboard</a>
            </c:otherwise>
          </c:choose>
          <a href="<c:url value='/?#features'/>" class="btn btn-outline-light rounded-pill px-4 py-3">Xem tính năng</a>
        </div>
      </div>

      <div class="col-lg-5 d-none d-lg-block" data-aos="zoom-in">
        <img
                src="https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&w=900&q=80"
                class="img-fluid rounded-4 shadow-2xl"
                alt="Gen-CMS Overview">
      </div>
    </div>
  </div>
</section>

<!-- CONTENT -->
<section class="section-wrap">
  <div class="container">
    <div class="row align-items-center g-5">
      <div class="col-lg-6" data-aos="fade-up">
        <div class="section-heading mb-4">
          <h2>Tổng quan hệ thống</h2>
          <p>Generator Management System (GMS) hỗ trợ tối ưu quy trình quản lý và bảo trì máy phát điện.</p>
        </div>

        <p>
          <strong>Gen-CMS (GMS)</strong> là ứng dụng web giúp thay thế các phương pháp quản lý thủ công,
          tập trung hoá dữ liệu thiết bị, lịch bảo trì, báo cáo sự cố và hồ sơ vận hành.
        </p>

        <div class="highlight-box mt-4">
          <h5 class="fw-bold text-primary mb-2"><i class="fas fa-bullseye me-2"></i>Mục tiêu chính</h5>
          <p class="mb-0">
            Xây dựng nền tảng quản lý tập trung, giúp người dùng theo dõi dữ liệu thiết bị,
            lịch bảo trì và báo cáo sự cố một cách chính xác – nhanh chóng – hiệu quả.
          </p>
        </div>
      </div>

      <div class="col-lg-6" data-aos="fade-up" data-aos-delay="100">
        <div class="bg-white p-4 rounded-4 shadow-sm border">
          <h4 class="fw-bold mb-3">Điểm nổi bật</h4>
          <ul class="mb-0">
            <li class="mb-2">Quản lý danh mục máy phát, thương hiệu và thông số vận hành.</li>
            <li class="mb-2">Theo dõi lịch bảo trì, lịch sử sửa chữa và báo cáo sự cố.</li>
            <li class="mb-2">Phân quyền người dùng theo vai trò (Admin/Manager/Technician...).</li>
            <li>Hỗ trợ mở rộng tích hợp dữ liệu/thiết bị theo từng giai đoạn.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section-wrap bg-light">
  <div class="container">
    <div class="text-center mb-5" data-aos="fade-up">
      <h2 class="fw-bold fs-1">Các bên tương tác</h2>
      <p class="text-muted">Hệ thống kết nối các vai trò quan trọng trong quy trình vận hành</p>
    </div>

    <div class="row g-4">
      <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-user-shield"></i></div>
          <h5 class="fw-bold">Quản trị viên</h5>
          <p class="small text-muted mb-0">Quản lý tài khoản, danh mục máy phát và cấu hình toàn hệ thống.</p>
        </div>
      </div>

      <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-tools"></i></div>
          <h5 class="fw-bold">Kỹ thuật viên</h5>
          <p class="small text-muted mb-0">Cập nhật bảo trì, tạo báo cáo sự cố và theo dõi lịch sử sửa chữa.</p>
        </div>
      </div>

      <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-chart-line"></i></div>
          <h5 class="fw-bold">Người quản lý</h5>
          <p class="small text-muted mb-0">Giám sát tổng thể và xem báo cáo phân tích vận hành.</p>
        </div>
      </div>

      <div class="col-md-3" data-aos="fade-up" data-aos-delay="400">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-database"></i></div>
          <h5 class="fw-bold">Hệ thống dữ liệu</h5>
          <p class="small text-muted mb-0">Lưu trữ tập trung dữ liệu thiết bị, người dùng và lịch sử hoạt động.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section-wrap">
  <div class="container">
    <div class="bg-white p-5 rounded-4 shadow-sm border" data-aos="fade-up">
      <div class="row justify-content-center text-center">
        <div class="col-lg-10">
          <h2 class="fw-bold mb-3">Nguyên lý hoạt động</h2>
          <p class="lead mb-4">
            Dữ liệu được luân chuyển qua việc nhập liệu, cập nhật và truy xuất trực tiếp từ người dùng trên giao diện web.
          </p>
          <div class="alert alert-warning border-0 py-3 mb-0">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Lưu ý kỹ thuật:</strong> Hệ thống đóng vai trò là công cụ quản lý và lưu trữ dữ liệu.
            GMS <strong>không</strong> can thiệp hoặc kết nối trực tiếp vào phần cứng vật lý của máy phát điện.
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER: giống Home -->
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
  // AOS giống Home
  AOS.init({ duration: 800, once: true });

  // Navbar đổi màu khi cuộn giống Home
  const mainNav = document.getElementById('mainNav');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      mainNav.classList.add('navbar-scrolled');
    } else {
      mainNav.classList.remove('navbar-scrolled');
    }
  });
</script>
</body>
</html>
