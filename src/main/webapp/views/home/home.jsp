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
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <style>
    :root{
      --primary:#4e73df;
      --secondary:#224abe;
      --ink:#0f172a;
      --muted:#64748b;
      --card:#ffffff;
      --bg:#f6f8ff;
      --ring: rgba(78,115,223,.22);
    }

    body{
      font-family:'Plus Jakarta Sans', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      overflow-x:hidden;
      background: radial-gradient(1200px 600px at 10% -10%, rgba(78,115,223,.20), transparent 55%),
                  radial-gradient(900px 500px at 95% 0%, rgba(34,74,190,.18), transparent 60%),
                  var(--bg);
      color: var(--ink);
    }

    /* Navbar */
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
      color: #fff !important;
      transition: .3s;
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
    .navbar-scrolled .nav-pill:hover{
      background: rgba(78,115,223,.08);
    }

    /* Hero Slider */
    .hero-section{
      position: relative;
      overflow: hidden;
    }

    .hero-slide{
      position: relative;
      min-height: 100vh;
      padding: 170px 0 110px;
      color: #fff;
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      overflow: hidden;
    }

    .hero-slide::before{
      content:"";
      position:absolute;
      inset:-2px;
      background:
        linear-gradient(135deg, rgba(78,115,223,.72) 0%, rgba(34,74,190,.76) 55%, rgba(22,45,111,.80) 100%),
        radial-gradient(800px 300px at 15% 20%, rgba(255,255,255,.10), transparent 60%),
        radial-gradient(700px 250px at 80% 15%, rgba(255,255,255,.06), transparent 60%);
      opacity: .95;
      pointer-events:none;
    }

    .hero-content{
      position: relative;
      z-index: 1;
    }

    .hero-title{
      font-weight: 900;
      font-size: clamp(2.2rem, 4vw, 3.6rem);
      line-height: 1.12;
      margin-bottom: 18px;
    }

    .hero-desc{
      font-size: 1.12rem;
      opacity: .92;
      max-width: 46ch;
      margin-bottom: 34px;
    }

    /* Stats */
    .stat-badge{
      background: rgba(255,255,255,.14);
      padding: 18px 16px;
      border-radius: 18px;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,.22);
      text-align:center;
      transition: .28s ease;
      box-shadow: 0 12px 30px rgba(0,0,0,.10);
    }
    .stat-badge:hover{
      background: rgba(255,255,255,.22);
      transform: translateY(-6px);
    }
    .stat-number{
      font-size: 2rem;
      font-weight: 900;
      display:block;
      letter-spacing: .2px;
    }
    .stat-label{
      font-size: .78rem;
      text-transform: uppercase;
      letter-spacing: 1.2px;
      opacity:.9;
    }

    /* Buttons */
    .btn-white{
      background: #fff;
      color: var(--primary);
      font-weight: 800;
      border-radius: 999px;
      padding: 12px 28px;
      border: none;
      transition: .25s;
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
      color: #fff;
    }

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

    /* Sections */
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

    /* Feature cards */
    .feature-card{
      border: 1px solid rgba(15,23,42,.06);
      border-radius: 22px;
      padding: 34px 28px;
      background: var(--card);
      box-shadow: 0 12px 30px rgba(15,23,42,.06);
      transition: .32s;
      height: 100%;
      position: relative;
      overflow:hidden;
    }
    .feature-card::before{
      content:"";
      position:absolute;
      inset:-2px;
      background: radial-gradient(500px 140px at 20% 0%, rgba(78,115,223,.10), transparent 60%);
      opacity: .9;
      pointer-events:none;
    }
    .feature-card:hover{
      transform: translateY(-10px);
      box-shadow: 0 18px 50px rgba(15,23,42,.10);
      border-color: rgba(78,115,223,.18);
    }
    .feature-icon{
      width: 72px;
      height: 72px;
      border-radius: 18px;
      display:flex;
      align-items:center;
      justify-content:center;
      font-size: 1.9rem;
      margin: 0 auto 18px;
      background: rgba(78,115,223,.10);
      color: var(--primary);
      box-shadow: 0 10px 20px rgba(78,115,223,.18);
      border: 1px solid rgba(78,115,223,.12);
    }

    /* Brands */
    .brand-item{
      padding: 18px 16px;
      background: #fff;
      border-radius: 999px;
      border: 1px solid rgba(15,23,42,.08);
      transition: .25s;
      text-align:center;
      box-shadow: 0 10px 25px rgba(15,23,42,.05);
    }
    .brand-item:hover{
      border-color: rgba(78,115,223,.35);
      transform: translateY(-4px);
      box-shadow: 0 16px 40px rgba(15,23,42,.10);
    }

    /* Carousel */
    .carousel-item{
      transition: transform 1s ease-in-out, opacity 1s ease-in-out;
    }

    .carousel-control-prev,
    .carousel-control-next{
      width: 6%;
      z-index: 5;
    }

    .carousel-indicators{
      z-index: 6;
      margin-bottom: 2rem;
    }

    .carousel-indicators [data-bs-target]{
      width: 10px;
      height: 10px;
      border-radius: 50%;
    }

    /* Footer */
    footer{
      background: #0b1224;
      color: rgba(255,255,255,.70);
      padding: 58px 0 26px;
      border-top: 1px solid rgba(255,255,255,.06);
    }
    .footer-link{ color: rgba(255,255,255,.75); }
    .footer-link:hover{ color: #fff; }

    .shadow-2xl{ box-shadow: 0 22px 70px rgba(0,0,0,.22) !important; }

    @media (max-width: 991.98px){
      .hero-slide{
        min-height: 88vh;
        padding: 140px 0 90px;
        clip-path: none;
      }

      .stat-number{
        font-size: 1.5rem;
      }

      .hero-desc{
        font-size: 1rem;
      }
    }
  </style>
</head>

<body>

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
          <a class="nav-link nav-pill px-3" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công ty</a>
        </li>

        <li class="nav-item">
          <a class="nav-link nav-pill px-3" href="#news">Tin tức</a>
        </li>

        <li class="nav-item">
          <a class="nav-link nav-pill px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
        </li>

        <c:choose>
          <c:when test="${empty user}">
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link nav-pill px-3" href="<c:url value='/product-list'/>">Sản phẩm</a>
            </li>
          </c:otherwise>
        </c:choose>

        <li class="nav-item">
          <a class="nav-link nav-pill px-3" href="#brands">Thương hiệu</a>
        </li>

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
                <li><a class="dropdown-item py-2" href="<c:url value='/account/change-password'/>"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
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

<section class="hero-section p-0">
  <div id="heroCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="4000">

    <div class="carousel-indicators">
      <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
      <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
      <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
    </div>

    <div class="carousel-inner">

      <!-- Slide 1 -->
      <div class="carousel-item active">
        <div class="hero-slide" style="background-image: url('<c:url value="/template/images/slide1.jpg"/>');">
          <div class="container position-relative hero-content">
            <div class="row align-items-center">
              <div class="col-lg-12" data-aos="fade-right">
                <h1 class="hero-title">Quản lý hệ thống máy phát điện thông minh</h1>
                <p class="hero-desc">Theo dõi, cảnh báo và tối ưu hóa quy trình bảo trì chuyên nghiệp với công nghệ IoT thời gian thực.</p>

                <div class="row g-3 mb-4">
                  <div class="col-4">
                    <div class="stat-badge">
                      <span class="stat-number">
                        <c:choose>
                          <c:when test="${not empty stats}">
                            ${stats.totalProductModels}
                          </c:when>
                          <c:otherwise>150</c:otherwise>
                        </c:choose>
                      </span>
                      <span class="stat-label">Máy phát</span>
                    </div>
                  </div>

                  <div class="col-4">
                    <div class="stat-badge">
                      <span class="stat-number">
                        <c:choose>
                          <c:when test="${not empty stats}">
                            ${stats.totalHours}
                          </c:when>
                          <c:otherwise>1200</c:otherwise>
                        </c:choose>
                      </span>
                      <span class="stat-label">Giờ chạy</span>
                    </div>
                  </div>

                  <div class="col-4">
                    <div class="stat-badge">
                      <span class="stat-number">
                        <c:choose>
                          <c:when test="${not empty stats}">
                            ${stats.totalUsers}
                          </c:when>
                          <c:otherwise>45</c:otherwise>
                        </c:choose>
                      </span>
                      <span class="stat-label">Người dùng</span>
                    </div>
                  </div>
                </div>

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

                  <a href="#features" class="btn-ghost">
                    <i class="fa-solid fa-circle-info"></i> Xem tính năng
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 2 -->
      <div class="carousel-item">
        <div class="hero-slide" style="background-image: url('<c:url value="/template/images/slide2.jpg"/>');">
          <div class="container position-relative hero-content">
            <div class="row align-items-center">
              <div class="col-lg-12" data-aos="fade-right">
                <h1 class="hero-title">Giám sát thiết bị theo thời gian thực</h1>
                <p class="hero-desc">Theo dõi trạng thái hoạt động của từng máy 24/7, phát hiện sự cố sớm và hỗ trợ vận hành ổn định hơn.</p>

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

                  <a href="#features" class="btn-ghost">
                    <i class="fa-solid fa-circle-info"></i> Xem tính năng
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 3 -->
      <div class="carousel-item">
        <div class="hero-slide" style="background-image: url('<c:url value="/template/images/slide3.jpg"/>');">
          <div class="container position-relative hero-content">
            <div class="row align-items-center">
              <div class="col-lg-12" data-aos="fade-right">
                <h1 class="hero-title">Tối ưu bảo trì và cảnh báo tức thì</h1>
                <p class="hero-desc">Lên lịch bảo trì, quản lý lịch sử sửa chữa và nhận cảnh báo nhanh khi hệ thống phát sinh lỗi.</p>

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

                  <a href="#features" class="btn-ghost">
                    <i class="fa-solid fa-circle-info"></i> Xem tính năng
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>

    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
      <span class="carousel-control-prev-icon"></span>
      <span class="visually-hidden">Previous</span>
    </button>

    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
      <span class="carousel-control-next-icon"></span>
      <span class="visually-hidden">Next</span>
    </button>
  </div>
</section>

<section id="features" class="py-5">
  <div class="container py-5">
    <div class="text-center mb-5" data-aos="fade-up">
      <h2 class="section-title display-6">Tính năng vượt trội</h2>
      <p class="section-sub">Đem lại hiệu quả tối đa cho việc vận hành trạm máy</p>
    </div>

    <div class="row g-4">
      <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
        <div class="feature-card text-center">
          <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
          <h4 class="fw-bold mb-2">Giám sát thời gian thực</h4>
          <p class="text-secondary-emphasis mb-0" style="color: var(--muted)!important;">Theo dõi trạng thái hoạt động của từng máy 24/7.</p>
        </div>
      </div>

      <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
        <div class="feature-card text-center">
          <div class="feature-icon"><i class="fas fa-exclamation-triangle"></i></div>
          <h4 class="fw-bold mb-2">Cảnh báo tức thì</h4>
          <p class="text-secondary-emphasis mb-0" style="color: var(--muted)!important;">Nhận thông báo tức thời qua Email/SMS khi có sự cố phát sinh.</p>
        </div>
      </div>

      <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
        <div class="feature-card text-center">
          <div class="feature-icon"><i class="fas fa-tasks"></i></div>
          <h4 class="fw-bold mb-2">Quản lý bảo trì</h4>
          <p class="text-secondary-emphasis mb-0" style="color: var(--muted)!important;">Lên lịch bảo trì, lưu lịch sử sửa chữa và quản lý đội ngũ kỹ thuật hiệu quả.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<section id="brands" class="py-5">
  <div class="container py-4">
    <div class="text-center mb-5" data-aos="fade-up">
      <h2 class="section-title">Đối tác Thương hiệu</h2>
      <p class="section-sub">Hỗ trợ kết nối với hầu hết các dòng máy phát điện hiện nay</p>
    </div>

    <div class="row g-3 justify-content-center">
      <c:choose>
        <c:when test="${not empty brands}">
          <c:forEach var="brand" items="${brands}">
            <div class="col-6 col-md-3 col-lg-2" data-aos="zoom-in">
              <div class="brand-item">
                <i class="fas fa-industry me-2 text-primary"></i>
                <span class="fw-bold">${brand.name}</span>
              </div>
            </div>
          </c:forEach>
        </c:when>

        <c:otherwise>
          <div class="col-6 col-md-3 col-lg-2" data-aos="zoom-in"><div class="brand-item"><i class="fas fa-industry me-2 text-primary"></i><b>CUMMINS</b></div></div>
          <div class="col-6 col-md-3 col-lg-2" data-aos="zoom-in"><div class="brand-item"><i class="fas fa-industry me-2 text-primary"></i><b>PERKINS</b></div></div>
          <div class="col-6 col-md-3 col-lg-2" data-aos="zoom-in"><div class="brand-item"><i class="fas fa-industry me-2 text-primary"></i><b>DENYO</b></div></div>
          <div class="col-6 col-md-3 col-lg-2" data-aos="zoom-in"><div class="brand-item"><i class="fas fa-industry me-2 text-primary"></i><b>MITSUBISHI</b></div></div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</section>

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
        <p class="small mb-2">&copy; 2026 Gen-CMS Corporation. Bảo lưu mọi quyền.</p>
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
</body>
</html>