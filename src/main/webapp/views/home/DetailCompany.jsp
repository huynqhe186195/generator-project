<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gen-CMS | Sơ lược công ty</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

  <!-- Font giống Home -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <style>
    :root{
      --primary:#4e73df;
      --secondary:#224abe;
      --ink:#0f172a;
      --muted:#64748b;
      --card:#ffffff;
      --bg:#f6f8ff;
    }

    body{
      font-family:'Plus Jakarta Sans', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      overflow-x:hidden;
      background: radial-gradient(1200px 600px at 10% -10%, rgba(78,115,223,.20), transparent 55%),
                  radial-gradient(900px 500px at 95% 0%, rgba(34,74,190,.18), transparent 60%),
                  var(--bg);
      color: var(--ink);
    }

    /* ===== NAVBAR giống Home ===== */
    .navbar-landing{
      background: transparent;
      padding: 18px 0;
      transition: all .35s ease;
      z-index: 1050;
    }
    .navbar-scrolled{
      background: rgba(255,255,255,.85) !important;
      backdrop-filter: blur(12px);
      padding: 10px 0;
      border-bottom: 1px solid rgba(15,23,42,.06);
      box-shadow: 0 10px 30px rgba(15,23,42,.10);
    }
    .navbar-brand{
      font-weight: 900;
      font-size: 1.7rem;
      letter-spacing: .2px;
      color:#fff !important;
      transition:.3s;
    }
    .navbar-scrolled .navbar-brand{ color: var(--primary) !important; }

    .nav-link{
      color: rgba(255,255,255,.92) !important;
      font-weight: 600;
      transition: .25s;
      position: relative;
    }
    .navbar-scrolled .nav-link{ color: rgba(15,23,42,.78) !important; }
    .navbar-scrolled .nav-link:hover{ color: var(--primary) !important; }
    .nav-link:hover{ transform: translateY(-1px); }

    .nav-pill{
      border-radius: 999px;
      padding: .55rem .95rem !important;
    }
    .navbar-scrolled .nav-pill:hover{ background: rgba(78,115,223,.08); }

    .user-dropdown-toggle{
      border-radius: 999px;
      padding: .55rem .95rem !important;
      background: rgba(255,255,255,.16);
      color:#fff !important;
      border: 1px solid rgba(255,255,255,.35);
    }
    .navbar-scrolled .user-dropdown-toggle{
      color: var(--primary) !important;
      border-color: rgba(78,115,223,.35);
      background: rgba(78,115,223,.06);
    }

    /* ===== BUTTONS giống Home ===== */
    .btn-white{
      background:#fff;
      color: var(--primary);
      font-weight: 800;
      border-radius: 999px;
      padding: 12px 28px;
      border:none;
      transition:.25s;
      text-decoration:none;
      display:inline-flex;
      align-items:center;
      gap:10px;
      box-shadow: 0 14px 30px rgba(0,0,0,.18);
    }
    .btn-white:hover{
      transform: translateY(-2px);
      box-shadow: 0 18px 40px rgba(0,0,0,.22);
      color: var(--secondary);
    }
    .btn-ghost{
      display:inline-flex;
      align-items:center;
      gap:10px;
      border-radius: 999px;
      padding: 12px 22px;
      font-weight: 700;
      color: rgba(255,255,255,.95);
      border: 1px solid rgba(255,255,255,.35);
      background: rgba(255,255,255,.10);
      text-decoration:none;
      transition:.25s;
    }
    .btn-ghost:hover{
      transform: translateY(-2px);
      background: rgba(255,255,255,.16);
      color:#fff;
    }

    /* ===== HERO giống Home ===== */
    .hero-section{
      position: relative;
      padding: 170px 0 110px;
      color:#fff;
      background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 55%, #162d6f 100%);
      clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
      overflow:hidden;
    }
    .hero-section::before{
      content:"";
      position:absolute; inset:-2px;
      background:
        radial-gradient(800px 300px at 15% 20%, rgba(255,255,255,.20), transparent 60%),
        radial-gradient(700px 250px at 80% 15%, rgba(255,255,255,.14), transparent 60%),
        url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='200'%3E%3Cg fill='none' stroke='rgba(255,255,255,.10)' stroke-width='1'%3E%3Cpath d='M0 40h200M0 100h200M0 160h200'/%3E%3Cpath d='M40 0v200M100 0v200M160 0v200'/%3E%3C/g%3E%3C/svg%3E");
      opacity:.7;
      pointer-events:none;
    }
    .hero-title{
      font-weight: 900;
      font-size: clamp(2.1rem, 4vw, 3.3rem);
      line-height: 1.12;
      margin-bottom: 16px;
    }
    .hero-desc{
      font-size: 1.12rem;
      opacity:.92;
      max-width: 56ch;
      margin-bottom: 28px;
    }

    .hero-img{
      border-radius: 26px !important;
      box-shadow: 0 26px 80px rgba(0,0,0,.30);
      border: 1px solid rgba(255,255,255,.18);
      transform: translateX(6px) scale(1.03);
      transform-origin: center right;
    }

    /* ===== SECTIONS giống Home ===== */
    .section-wrap{ padding: 78px 0; }
    .section-title{
      font-weight: 900;
      letter-spacing: -.2px;
      margin-bottom: 10px;
    }
    .section-sub{
      color: var(--muted);
      margin: 0 auto;
      max-width: 62ch;
    }

    /* Cards đồng bộ */
    .soft-card{
      border: 1px solid rgba(15,23,42,.06);
      border-radius: 22px;
      background: var(--card);
      box-shadow: 0 12px 30px rgba(15,23,42,.06);
      transition: .32s;
      overflow:hidden;
      height: 100%;
    }
    .soft-card:hover{
      transform: translateY(-10px);
      box-shadow: 0 18px 50px rgba(15,23,42,.10);
      border-color: rgba(78,115,223,.18);
    }

    .soft-card-body{ padding: 34px 28px; }

    .entity-icon{
      width: 72px; height: 72px;
      border-radius: 18px;
      display:flex; align-items:center; justify-content:center;
      font-size: 1.9rem;
      margin: 0 auto 18px;
      background: rgba(78,115,223,.10);
      color: var(--primary);
      box-shadow: 0 10px 20px rgba(78,115,223,.18);
      border: 1px solid rgba(78,115,223,.12);
    }

    .highlight-box{
      border-radius: 22px;
      padding: 22px 22px;
      background: #fff;
      border: 1px solid rgba(15,23,42,.06);
      box-shadow: 0 12px 30px rgba(15,23,42,.06);
      position: relative;
      overflow:hidden;
    }
    .highlight-box::before{
      content:"";
      position:absolute; left:0; top:0; bottom:0;
      width: 6px;
      background: linear-gradient(180deg, var(--primary), var(--secondary));
      border-top-left-radius: 22px;
      border-bottom-left-radius: 22px;
    }
    .highlight-box .inner{ padding-left: 14px; }

    /* Pill list style */
    .feature-list{
      list-style:none;
      padding-left:0;
      margin-bottom:0;
    }
    .feature-list li{
      display:flex;
      gap:10px;
      align-items:flex-start;
      padding: 10px 0;
      border-bottom: 1px dashed rgba(15,23,42,.10);
      color: rgba(15,23,42,.78);
    }
    .feature-list li:last-child{ border-bottom:0; }
    .feature-list i{ margin-top: 2px; color: var(--primary); }

    /* Callout */
    .callout{
      border-radius: 22px;
      border: 1px solid rgba(15,23,42,.06);
      background: #fff;
      box-shadow: 0 12px 30px rgba(15,23,42,.06);
      padding: 34px 28px;
    }
    .callout .alert{
      border-radius: 18px;
      background: rgba(245,158,11,.14);
      border: 1px solid rgba(245,158,11,.25);
      color: rgba(15,23,42,.85);
    }

    /* Footer giống Home */
    footer{
      background:#0b1224;
      color: rgba(255,255,255,.70);
      padding: 58px 0 26px;
      border-top: 1px solid rgba(255,255,255,.06);
    }
    .footer-link{ color: rgba(255,255,255,.75); }
    .footer-link:hover{ color:#fff; }
  </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-landing fixed-top" id="mainNav">
  <div class="container">
    <a class="navbar-brand" href="<c:url value='/'/>">
      <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-center gap-lg-1">

        <li class="nav-item">
                  <a class="nav-link nav-pill px-3" href="<c:url value='/news'/>">Tin tức</a>
                </li>
        <li class="nav-item"><a class="nav-link nav-pill px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a></li>

        <c:choose>
          <c:when test="${empty user}">
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link nav-pill px-3" href="<c:url value='/product-list'/>">Sản phẩm</a>
            </li>
          </c:otherwise>
        </c:choose>

        <c:if test="${not empty user}">
          <li class="nav-item">
            <a class="nav-link nav-pill px-3" href="<c:url value='/views/home/Support.jsp'/>">Chăm sóc khách hàng</a>
          </li>
        </c:if>

        <c:choose>
          <c:when test="${empty user}">
            <li class="nav-item ms-lg-3">
              <a href="<c:url value='/account/login'/>" class="btn btn-white px-4">
                <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
              </a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item dropdown ms-lg-3">
              <a class="nav-link dropdown-toggle user-dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                <i class="fas fa-user-circle me-1"></i> ${user.fullName}
              </a>
              <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-3">
                <li><a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>"><i class="fas fa-id-card me-2"></i>Hồ sơ</a></li>
                <li><a class="dropdown-item py-2" href="<c:url value='/account/hanldeChangePassword'/>"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item py-2 text-danger fw-bold" href="<c:url value='/account/logout'/>"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
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
  <div class="container position-relative" style="z-index:1;">
    <div class="row align-items-center g-4">
      <div class="col-lg-7" data-aos="fade-right">
        <h1 class="hero-title">Sơ lược công ty & hệ thống Gen-CMS</h1>
        <p class="hero-desc">
          Giải pháp số hoá quản trị máy phát điện, giúp theo dõi thiết bị, lịch bảo trì và vận hành tập trung — nhanh, chuẩn, dễ mở rộng.
        </p>

        <div class="d-flex flex-wrap gap-3">
          <c:choose>
            <c:when test="${empty user}">
              <a href="<c:url value='/account/login'/>" class="btn btn-white">
                <i class="fa-solid fa-rocket"></i> Bắt đầu ngay
              </a>
            </c:when>
            <c:otherwise>
              <a href="<c:url value='/admin/dashboard'/>" class="btn btn-white">
                <i class="fa-solid fa-gauge-high"></i> Vào Dashboard
              </a>
            </c:otherwise>
          </c:choose>

          <a href="#overview" class="btn-ghost">
            <i class="fa-solid fa-circle-info"></i> Xem tổng quan
          </a>
        </div>
      </div>

      <div class="col-lg-5 d-none d-lg-block" data-aos="zoom-in">
        <img
          src="https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&w=1100&q=80"
          class="img-fluid hero-img"
          alt="Gen-CMS Overview">
      </div>
    </div>
  </div>
</section>

<!-- OVERVIEW -->
<section id="overview" class="section-wrap">
  <div class="container">
    <div class="row align-items-center g-4 g-lg-5">
      <div class="col-lg-6" data-aos="fade-up">
        <div class="mb-4">
          <h2 class="section-title display-6">Tổng quan hệ thống</h2>
          <p class="section-sub">
            Generator Management System (GMS) hỗ trợ tối ưu quy trình quản lý và bảo trì máy phát điện.
          </p>
        </div>

        <p class="mb-3" style="color: rgba(15,23,42,.80);">
          <strong>Gen-CMS (GMS)</strong> là ứng dụng web giúp thay thế các phương pháp quản lý thủ công,
          tập trung hoá dữ liệu thiết bị, lịch bảo trì, báo cáo sự cố và hồ sơ vận hành.
        </p>

        <div class="highlight-box mt-4">
          <div class="inner">
            <h5 class="fw-bold mb-2" style="color: var(--primary);">
              <i class="fas fa-bullseye me-2"></i>Mục tiêu chính
            </h5>
            <p class="mb-0" style="color: rgba(15,23,42,.78);">
              Xây dựng nền tảng quản lý tập trung, giúp người dùng theo dõi dữ liệu thiết bị,
              lịch bảo trì và báo cáo sự cố một cách chính xác — nhanh chóng — hiệu quả.
            </p>
          </div>
        </div>
      </div>

      <div class="col-lg-6" data-aos="fade-up" data-aos-delay="100">
        <div class="soft-card">
          <div class="soft-card-body">
            <h4 class="fw-bold mb-3">Điểm nổi bật</h4>
            <ul class="feature-list">
              <li><i class="fa-solid fa-circle-check"></i><span>Quản lý danh mục máy phát, thương hiệu và thông số vận hành.</span></li>
              <li><i class="fa-solid fa-circle-check"></i><span>Theo dõi lịch bảo trì, lịch sử sửa chữa và báo cáo sự cố.</span></li>
              <li><i class="fa-solid fa-circle-check"></i><span>Phân quyền người dùng theo vai trò (Admin/Manager/Technician...).</span></li>
              <li><i class="fa-solid fa-circle-check"></i><span>Hỗ trợ mở rộng tích hợp dữ liệu/thiết bị theo từng giai đoạn.</span></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ACTORS -->
<section class="section-wrap" style="background: rgba(255,255,255,.55);">
  <div class="container">
    <div class="text-center mb-5" data-aos="fade-up">
      <h2 class="section-title display-6">Các bên tương tác</h2>
      <p class="section-sub">Hệ thống kết nối các vai trò quan trọng trong quy trình vận hành</p>
    </div>

    <div class="row g-4">
      <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
        <div class="soft-card text-center">
          <div class="soft-card-body">
            <div class="entity-icon"><i class="fas fa-user-shield"></i></div>
            <h5 class="fw-bold mb-1">Quản trị viên</h5>
            <p class="small mb-0" style="color: var(--muted);">Quản lý tài khoản, danh mục máy phát và cấu hình toàn hệ thống.</p>
          </div>
        </div>
      </div>

      <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
        <div class="soft-card text-center">
          <div class="soft-card-body">
            <div class="entity-icon"><i class="fas fa-tools"></i></div>
            <h5 class="fw-bold mb-1">Kỹ thuật viên</h5>
            <p class="small mb-0" style="color: var(--muted);">Cập nhật bảo trì, tạo báo cáo sự cố và theo dõi lịch sử sửa chữa.</p>
          </div>
        </div>
      </div>

      <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
        <div class="soft-card text-center">
          <div class="soft-card-body">
            <div class="entity-icon"><i class="fas fa-chart-line"></i></div>
            <h5 class="fw-bold mb-1">Người quản lý</h5>
            <p class="small mb-0" style="color: var(--muted);">Giám sát tổng thể và xem báo cáo phân tích vận hành.</p>
          </div>
        </div>
      </div>

      <div class="col-md-3" data-aos="fade-up" data-aos-delay="400">
        <div class="soft-card text-center">
          <div class="soft-card-body">
            <div class="entity-icon"><i class="fas fa-database"></i></div>
            <h5 class="fw-bold mb-1">Hệ thống dữ liệu</h5>
            <p class="small mb-0" style="color: var(--muted);">Lưu trữ tập trung dữ liệu thiết bị, người dùng và lịch sử hoạt động.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- PRINCIPLE -->
<section class="section-wrap">
  <div class="container">
    <div class="callout" data-aos="fade-up">
      <div class="row justify-content-center text-center">
        <div class="col-lg-10">
          <h2 class="section-title display-6 mb-2">Nguyên lý hoạt động</h2>
          <p class="lead mb-4" style="color: rgba(15,23,42,.72);">
            Dữ liệu được luân chuyển qua việc nhập liệu, cập nhật và truy xuất trực tiếp từ người dùng trên giao diện web.
          </p>
          <div class="alert py-3 mb-0">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Lưu ý kỹ thuật:</strong> Hệ thống đóng vai trò là công cụ quản lý và lưu trữ dữ liệu.
            GMS <strong>không</strong> can thiệp hoặc kết nối trực tiếp vào phần cứng vật lý của máy phát điện.
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="container">
    <div class="row gy-4 align-items-center">
      <div class="col-lg-6 text-center text-lg-start">
        <a href="<c:url value='/'/>" class="text-white text-decoration-none fw-bold fs-4">
          <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
        </a>
        <p class="mt-2 mb-0">Giải pháp số hóa hệ thống năng lượng dự phòng hàng đầu.</p>
      </div>

      <div class="col-lg-6 text-center text-lg-end">
        <p class="small mb-2">&copy; 2024 Gen-CMS Corporation. Bảo lưu mọi quyền.</p>
        <div class="d-inline-flex gap-3">
          <a href="#" class="footer-link"><i class="fab fa-facebook fs-5"></i></a>
          <a href="#" class="footer-link"><i class="fab fa-linkedin fs-5"></i></a>
          <a href="#" class="footer-link"><i class="fas fa-envelope fs-5"></i></a>
        </div>
      </div>
    </div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
  AOS.init({ duration: 850, once: true });

  const mainNav = document.getElementById('mainNav');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) mainNav.classList.add('navbar-scrolled');
    else mainNav.classList.remove('navbar-scrolled');
  });
</script>
<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>
