<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gen-CMS | Nền tảng điều phối vận hành máy phát điện</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <style>
    :root {
      --bg: #081120;
      --bg-soft: #0f1b31;
      --surface: rgba(9, 18, 33, 0.78);
      --surface-2: rgba(255, 255, 255, 0.06);
      --card: #ffffff;
      --text: #e5eefc;
      --muted: #9cb0cc;
      --dark: #081120;
      --line: rgba(255, 255, 255, 0.08);
      --primary: #4f8cff;
      --primary-2: #6d5efc;
      --accent: #2dd4bf;
      --warning: #fbbf24;
      --shadow: 0 30px 80px rgba(3, 8, 20, 0.35);
      --radius-xl: 32px;
      --radius-lg: 24px;
      --radius-md: 18px;
    }

    * {
      box-sizing: border-box;
    }

    html {
      scroll-behavior: smooth;
    }

    body {
      margin: 0;
      font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at top left, rgba(79, 140, 255, 0.28), transparent 28%),
        radial-gradient(circle at 85% 10%, rgba(45, 212, 191, 0.14), transparent 24%),
        linear-gradient(180deg, #081120 0%, #0b1730 44%, #eef4ff 44%, #f4f7fb 100%);
      overflow-x: hidden;
    }

    a {
      text-decoration: none;
    }

    .page-shell {
      position: relative;
      isolation: isolate;
    }

    .page-shell::before,
    .page-shell::after {
      content: "";
      position: fixed;
      width: 340px;
      height: 340px;
      border-radius: 50%;
      filter: blur(24px);
      opacity: 0.35;
      z-index: -1;
    }

    .page-shell::before {
      background: rgba(79, 140, 255, 0.36);
      top: -120px;
      left: -80px;
    }

    .page-shell::after {
      background: rgba(109, 94, 252, 0.28);
      top: 180px;
      right: -110px;
    }

    .navbar-landing {
      padding: 22px 0;
      transition: all 0.28s ease;
      background: transparent;
    }

    .navbar-landing.navbar-scrolled {
      background: rgba(8, 17, 32, 0.84);
      backdrop-filter: blur(18px);
      box-shadow: 0 18px 50px rgba(0, 0, 0, 0.18);
      padding: 14px 0;
      border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }

    .navbar-brand {
      font-weight: 900;
      font-size: 1.35rem;
      letter-spacing: -0.03em;
      color: #fff !important;
    }

    .navbar-brand-mark {
      width: 40px;
      height: 40px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 14px;
      background: linear-gradient(135deg, var(--primary), var(--primary-2));
      box-shadow: 0 16px 34px rgba(79, 140, 255, 0.35);
    }

    .nav-link {
      color: rgba(229, 238, 252, 0.78) !important;
      font-weight: 600;
      padding: 0.75rem 1rem !important;
      border-radius: 999px;
      transition: all 0.24s ease;
    }

    .nav-link:hover,
    .nav-link:focus {
      color: #fff !important;
      background: rgba(255, 255, 255, 0.08);
    }

    .nav-cta,
    .user-chip {
      border-radius: 999px;
      padding: 0.8rem 1.2rem !important;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 0.6rem;
    }

    .nav-cta {
      color: var(--dark) !important;
      background: linear-gradient(135deg, #fff, #d9e7ff);
      box-shadow: 0 16px 28px rgba(255, 255, 255, 0.16);
    }

    .user-chip {
      background: rgba(255, 255, 255, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.1);
      color: #fff !important;
    }

    .hero-section {
      padding: 132px 0 88px;
      position: relative;
    }

    .hero-panel {
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: var(--radius-xl);
      background:
        linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03)),
        rgba(10, 20, 37, 0.72);
      backdrop-filter: blur(20px);
      box-shadow: var(--shadow);
      padding: 28px;
      overflow: hidden;
      position: relative;
    }

    .hero-panel::before {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(120deg, rgba(79, 140, 255, 0.16), transparent 36%, rgba(45, 212, 191, 0.1) 100%);
      pointer-events: none;
    }

    .hero-copy,
    .hero-visual {
      position: relative;
      z-index: 1;
    }

    .eyebrow {
      display: inline-flex;
      align-items: center;
      gap: 0.55rem;
      padding: 0.55rem 0.9rem;
      border-radius: 999px;
      background: rgba(255, 255, 255, 0.08);
      color: #cfe0ff;
      font-size: 0.86rem;
      font-weight: 700;
      letter-spacing: 0.03em;
      text-transform: uppercase;
      margin-bottom: 1.1rem;
    }

    .hero-title {
      font-size: clamp(2.75rem, 5vw, 5.2rem);
      line-height: 0.98;
      font-weight: 900;
      letter-spacing: -0.05em;
      margin-bottom: 1.35rem;
      max-width: 10.5ch;
    }

    .hero-title .highlight {
      color: #8db6ff;
    }

    .hero-desc {
      color: var(--muted);
      font-size: 1.08rem;
      line-height: 1.8;
      max-width: 62ch;
      margin-bottom: 1.8rem;
    }

    .hero-actions {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
      margin-bottom: 2rem;
    }

    .btn-primary-gradient,
    .btn-secondary-ghost {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.7rem;
      border-radius: 999px;
      padding: 0.95rem 1.5rem;
      font-weight: 800;
      transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
    }

    .btn-primary-gradient {
      color: #fff;
      background: linear-gradient(135deg, var(--primary), var(--primary-2));
      box-shadow: 0 18px 40px rgba(79, 140, 255, 0.34);
    }

    .btn-primary-gradient:hover,
    .btn-secondary-ghost:hover {
      transform: translateY(-2px);
    }

    .btn-secondary-ghost {
      color: #fff;
      border: 1px solid rgba(255, 255, 255, 0.12);
      background: rgba(255, 255, 255, 0.05);
    }

    .mini-proof {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .mini-proof-item {
      min-width: 170px;
      padding: 0.95rem 1rem;
      border-radius: var(--radius-md);
      border: 1px solid rgba(255, 255, 255, 0.08);
      background: rgba(255, 255, 255, 0.04);
    }

    .mini-proof-item strong {
      display: block;
      font-size: 1.1rem;
      color: #fff;
    }

    .mini-proof-item span {
      color: var(--muted);
      font-size: 0.92rem;
    }

    .status-board {
      background: linear-gradient(180deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.04));
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 28px;
      padding: 1.4rem;
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06);
    }

    .live-badge {
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
      font-size: 0.82rem;
      font-weight: 700;
      color: #d8fff9;
      padding: 0.45rem 0.8rem;
      border-radius: 999px;
      background: rgba(45, 212, 191, 0.12);
      margin-bottom: 1rem;
    }

    .pulse {
      width: 9px;
      height: 9px;
      border-radius: 50%;
      background: var(--accent);
      box-shadow: 0 0 0 0 rgba(45, 212, 191, 0.65);
      animation: pulse 1.8s infinite;
    }

    @keyframes pulse {
      0% { box-shadow: 0 0 0 0 rgba(45, 212, 191, 0.65); }
      70% { box-shadow: 0 0 0 15px rgba(45, 212, 191, 0); }
      100% { box-shadow: 0 0 0 0 rgba(45, 212, 191, 0); }
    }

    .status-top {
      display: flex;
      justify-content: space-between;
      gap: 1rem;
      align-items: flex-start;
      margin-bottom: 1.4rem;
    }

    .status-top h3 {
      font-size: 1.25rem;
      margin: 0 0 0.35rem;
      font-weight: 800;
    }

    .status-top p {
      color: var(--muted);
      margin: 0;
      line-height: 1.7;
    }

    .status-chip {
      border-radius: 16px;
      padding: 0.8rem 0.95rem;
      background: rgba(255, 255, 255, 0.08);
      text-align: center;
      min-width: 96px;
    }

    .status-chip strong {
      display: block;
      font-size: 1.2rem;
      color: #fff;
    }

    .status-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 1rem;
      margin-bottom: 1rem;
    }

    .metric-card {
      border-radius: 22px;
      padding: 1.15rem;
      background: rgba(255, 255, 255, 0.06);
      border: 1px solid rgba(255, 255, 255, 0.08);
    }

    .metric-card .label {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 0.5rem;
      color: #d6e4ff;
      font-weight: 700;
      margin-bottom: 0.65rem;
    }

    .metric-card .value {
      font-size: 1.95rem;
      font-weight: 900;
      margin-bottom: 0.65rem;
    }

    .progress-track {
      height: 10px;
      border-radius: 999px;
      background: rgba(255, 255, 255, 0.08);
      overflow: hidden;
    }

    .progress-fill {
      height: 100%;
      border-radius: inherit;
    }

    .glass-list {
      display: grid;
      gap: 0.8rem;
    }

    .glass-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 1rem;
      padding: 0.95rem 1rem;
      border-radius: 18px;
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.05);
      color: #dbe7fa;
    }

    .glass-row small {
      display: block;
      color: var(--muted);
      margin-top: 0.1rem;
    }

    .section-block {
      padding: 96px 0;
      color: var(--dark);
    }

    .section-kicker {
      display: inline-flex;
      align-items: center;
      gap: 0.55rem;
      color: var(--primary);
      font-size: 0.92rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      margin-bottom: 1rem;
    }

    .section-title {
      font-size: clamp(2rem, 4vw, 3.4rem);
      font-weight: 900;
      letter-spacing: -0.045em;
      margin-bottom: 1rem;
      color: #081120;
    }

    .section-subtitle {
      color: #5c6e8a;
      font-size: 1.04rem;
      line-height: 1.8;
      max-width: 62ch;
      margin: 0;
    }

    .feature-card,
    .insight-card,
    .brand-card,
    .cta-panel {
      background: rgba(255, 255, 255, 0.86);
      border: 1px solid rgba(8, 17, 32, 0.06);
      border-radius: 28px;
      box-shadow: 0 18px 55px rgba(15, 23, 42, 0.07);
    }

    .feature-card {
      padding: 2rem;
      height: 100%;
      transition: transform 0.22s ease, box-shadow 0.22s ease;
    }

    .feature-card:hover,
    .brand-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 24px 60px rgba(15, 23, 42, 0.12);
    }

    .feature-icon {
      width: 60px;
      height: 60px;
      border-radius: 18px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 1.35rem;
      color: #fff;
      margin-bottom: 1.2rem;
      background: linear-gradient(135deg, var(--primary), var(--primary-2));
      box-shadow: 0 18px 35px rgba(79, 140, 255, 0.28);
    }

    .feature-card p,
    .insight-card p,
    .brand-card p {
      color: #5c6e8a;
      line-height: 1.75;
      margin-bottom: 0;
    }

    .insight-card {
      padding: 2rem;
      height: 100%;
    }

    .insight-stat {
      font-size: 2.7rem;
      font-weight: 900;
      letter-spacing: -0.05em;
      color: #081120;
      line-height: 1;
      margin-bottom: 0.7rem;
    }

    .brand-card {
      padding: 1.4rem;
      height: 100%;
      display: flex;
      align-items: center;
      gap: 1rem;
      transition: transform 0.22s ease, box-shadow 0.22s ease;
    }

    .brand-mark {
      width: 52px;
      height: 52px;
      border-radius: 16px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      background: rgba(79, 140, 255, 0.1);
      font-size: 1.2rem;
      flex-shrink: 0;
    }

    .cta-wrap {
      padding-bottom: 110px;
    }

    .cta-panel {
      padding: 2.2rem;
      background: linear-gradient(135deg, #081120, #0f2245);
      color: #fff;
      overflow: hidden;
      position: relative;
    }

    .cta-panel::before {
      content: "";
      position: absolute;
      inset: auto -10% -50% auto;
      width: 320px;
      height: 320px;
      border-radius: 50%;
      background: rgba(79, 140, 255, 0.18);
      filter: blur(8px);
    }

    .cta-panel > * {
      position: relative;
      z-index: 1;
    }

    .cta-note {
      color: rgba(229, 238, 252, 0.72);
      line-height: 1.8;
      margin: 0;
    }

    .footer {
      background: #07101f;
      color: rgba(229, 238, 252, 0.72);
      padding: 36px 0 46px;
      border-top: 1px solid rgba(255, 255, 255, 0.08);
    }

    .footer a {
      color: rgba(229, 238, 252, 0.82);
    }

    .footer a:hover {
      color: #fff;
    }

    @media (max-width: 991.98px) {
      .hero-section {
        padding-top: 110px;
      }

      .hero-title {
        max-width: none;
      }

      .status-top {
        flex-direction: column;
      }

      .status-grid {
        grid-template-columns: 1fr;
      }

      .navbar-collapse {
        background: rgba(8, 17, 32, 0.94);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 24px;
        padding: 1rem;
        margin-top: 1rem;
      }
    }

    @media (max-width: 767.98px) {
      .hero-panel {
        padding: 20px;
      }

      .section-block {
        padding: 78px 0;
      }

      .feature-card,
      .insight-card,
      .brand-card,
      .cta-panel {
        border-radius: 22px;
      }

      .mini-proof-item,
      .glass-row,
      .metric-card {
        padding: 0.9rem;
      }
    }
  </style>
</head>
<body>
  <div class="page-shell">
    <nav class="navbar navbar-expand-lg navbar-dark navbar-landing fixed-top" id="mainNav">
      <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-3" href="<c:url value='/'/>">
          <span class="navbar-brand-mark"><i class="fas fa-bolt"></i></span>
          <span>Gen-CMS</span>
        </a>

        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">
            <li class="nav-item"><a class="nav-link" href="#overview">Tổng quan</a></li>
            <li class="nav-item"><a class="nav-link" href="#solutions">Giải pháp</a></li>
            <li class="nav-item"><a class="nav-link" href="#brands">Thương hiệu</a></li>
            <li class="nav-item"><a class="nav-link" href="<c:url value='/news'/>">Tin tức</a></li>
            <li class="nav-item"><a class="nav-link" href="<c:url value='/products'/>">Sản phẩm mẫu</a></li>

            <c:if test="${not empty user}">
              <li class="nav-item"><a class="nav-link" href="<c:url value='/product-list'/>">Sản phẩm của tôi</a></li>
            </c:if>

            <c:choose>
              <c:when test="${empty user}">
                <li class="nav-item ms-lg-2">
                  <a href="<c:url value='/account/login'/>" class="nav-link nav-cta">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i>
                    Đăng nhập hệ thống
                  </a>
                </li>
              </c:when>
              <c:otherwise>
                <li class="nav-item dropdown ms-lg-2">
                  <a class="nav-link dropdown-toggle user-chip" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle"></i>
                    ${user.fullName}
                  </a>
                  <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg mt-3">
                    <li><a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>"><i class="fas fa-id-card me-2"></i>Hồ sơ</a></li>
                    <li><a class="dropdown-item py-2" href="<c:url value='/account/change-password'/>"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
                    <c:if test="${not empty user.roleUrl}">
                      <li><a class="dropdown-item py-2" href="<c:url value='${user.roleUrl}'/>"><i class="fas fa-gauge-high me-2"></i>Vào trang quản trị</a></li>
                    </c:if>
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

    <main>
      <section class="hero-section">
        <div class="container">
          <div class="hero-panel">
            <div class="row align-items-center g-4 g-xl-5">
              <div class="col-lg-7 hero-copy">
                <span class="eyebrow"><i class="fas fa-satellite-dish"></i> Nền tảng vận hành thế hệ mới</span>
                <h1 class="hero-title">Xây trạm điều phối <span class="highlight">máy phát điện</span> rõ ràng, hiện đại và dễ dùng.</h1>
                <p class="hero-desc">
                  Gen-CMS gom toàn bộ dữ liệu vận hành, lịch bảo trì, cảnh báo sự cố và chăm sóc khách hàng vào một giao diện duy nhất để đội kỹ thuật và quản lý ra quyết định nhanh hơn.
                </p>

                <div class="hero-actions">
                  <c:choose>
                    <c:when test="${empty user}">
                      <a href="<c:url value='/account/login'/>" class="btn-primary-gradient">
                        <i class="fas fa-rocket"></i>
                        Truy cập hệ thống
                      </a>
                    </c:when>
                    <c:when test="${not empty user.roleUrl}">
                      <a href="<c:url value='${user.roleUrl}'/>" class="btn-primary-gradient">
                        <i class="fas fa-gauge-high"></i>
                        Mở dashboard của tôi
                      </a>
                    </c:when>
                    <c:otherwise>
                      <a href="<c:url value='/product-list'/>" class="btn-primary-gradient">
                        <i class="fas fa-boxes-stacked"></i>
                        Xem sản phẩm của tôi
                      </a>
                    </c:otherwise>
                  </c:choose>

                  <a href="#solutions" class="btn-secondary-ghost">
                    <i class="fas fa-circle-play"></i>
                    Xem giải pháp mới
                  </a>
                </div>

                <div class="mini-proof">
                  <div class="mini-proof-item">
                    <strong>1 giao diện</strong>
                    <span>Cho kỹ thuật, quản lý và khách hàng phối hợp mượt hơn.</span>
                  </div>
                  <div class="mini-proof-item">
                    <strong>24/7 sẵn sàng</strong>
                    <span>Theo dõi chỉ số vận hành và nhắc lịch bảo trì liên tục.</span>
                  </div>
                  <div class="mini-proof-item">
                    <strong>Dễ mở rộng</strong>
                    <span>Tích hợp dữ liệu sản phẩm, thương hiệu và hỗ trợ khách hàng.</span>
                  </div>
                </div>
              </div>

              <div class="col-lg-5 hero-visual">
                <div class="status-board">
                  <span class="live-badge"><span class="pulse"></span> Live system status</span>

                  <div class="status-top">
                    <div>
                      <h3>Điều phối tập trung</h3>
                      <p>Giao diện mới ưu tiên khả năng đọc nhanh trạng thái, truy cập tác vụ quan trọng và nhìn ra điểm nghẽn vận hành ngay lập tức.</p>
                    </div>
                    <div class="status-chip">
                      <strong><c:out value="${total}" default="0" /></strong>
                      <span>Tổng máy</span>
                    </div>
                  </div>

                  <div class="status-grid">
                    <div class="metric-card">
                      <div class="label"><span>Đang hoạt động</span><i class="fas fa-circle text-success"></i></div>
                      <div class="value"><c:out value="${running}" default="0" /></div>
                      <div class="progress-track"><div class="progress-fill bg-success" style="width: 82%"></div></div>
                    </div>
                    <div class="metric-card">
                      <div class="label"><span>Đang bảo trì</span><i class="fas fa-screwdriver-wrench text-warning"></i></div>
                      <div class="value"><c:out value="${maintenance}" default="0" /></div>
                      <div class="progress-track"><div class="progress-fill" style="width: 36%; background: linear-gradient(90deg, #f59e0b, #fbbf24)"></div></div>
                    </div>
                    <div class="metric-card">
                      <div class="label"><span>Sự cố cần xử lý</span><i class="fas fa-triangle-exclamation text-danger"></i></div>
                      <div class="value"><c:out value="${error}" default="0" /></div>
                      <div class="progress-track"><div class="progress-fill bg-danger" style="width: 18%"></div></div>
                    </div>
                    <div class="metric-card">
                      <div class="label"><span>Giờ vận hành</span><i class="fas fa-clock text-info"></i></div>
                      <div class="value"><c:out value="${stats.totalHours}" default="0" /></div>
                      <div class="progress-track"><div class="progress-fill" style="width: 74%; background: linear-gradient(90deg, #38bdf8, #6366f1)"></div></div>
                    </div>
                  </div>

                  <div class="glass-list">
                    <div class="glass-row">
                      <div>
                        <strong>Danh mục thiết bị</strong>
                        <small><c:out value="${stats.totalProductModels}" default="0" /> model đang sẵn sàng quản lý</small>
                      </div>
                      <i class="fas fa-microchip"></i>
                    </div>
                    <div class="glass-row">
                      <div>
                        <strong>Người dùng đang khai thác</strong>
                        <small><c:out value="${stats.totalUsers}" default="0" /> tài khoản kết nối hệ thống</small>
                      </div>
                      <i class="fas fa-users"></i>
                    </div>
                    <div class="glass-row">
                      <div>
                        <strong>Hỗ trợ khách hàng</strong>
                        <small>Liên kết quy trình báo giá, hỗ trợ và theo dõi yêu cầu trong một luồng.</small>
                      </div>
                      <i class="fas fa-headset"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="section-block" id="overview">
        <div class="container">
          <div class="row align-items-end g-4 mb-4">
            <div class="col-lg-7">
              <span class="section-kicker"><i class="fas fa-layer-group"></i> Tổng quan nền tảng</span>
              <h2 class="section-title">Giao diện mới tập trung vào thông tin quan trọng thay vì làm người dùng bị ngợp.</h2>
              <p class="section-subtitle">Bố cục được làm lại theo hướng dashboard landing hiện đại: có chiều sâu thị giác, phân tầng nội dung rõ ràng và đặt các CTA quan trọng đúng nơi người dùng cần.</p>
            </div>
          </div>

          <div class="row g-4">
            <div class="col-md-6 col-xl-3">
              <div class="insight-card">
                <div class="insight-stat"><c:out value="${stats.totalProductModels}" default="0" /></div>
                <h5 class="fw-bold mb-2">Model thiết bị</h5>
                <p>Tập trung dữ liệu các dòng máy phát để tra cứu và quản trị nhất quán.</p>
              </div>
            </div>
            <div class="col-md-6 col-xl-3">
              <div class="insight-card">
                <div class="insight-stat"><c:out value="${stats.totalUsers}" default="0" /></div>
                <h5 class="fw-bold mb-2">Người dùng hệ thống</h5>
                <p>Phân quyền linh hoạt cho admin, manager, kỹ thuật viên và khách hàng.</p>
              </div>
            </div>
            <div class="col-md-6 col-xl-3">
              <div class="insight-card">
                <div class="insight-stat"><c:out value="${running}" default="0" /></div>
                <h5 class="fw-bold mb-2">Máy đang hoạt động</h5>
                <p>Nhìn nhanh nhóm thiết bị ổn định để tối ưu nhân lực giám sát mỗi ngày.</p>
              </div>
            </div>
            <div class="col-md-6 col-xl-3">
              <div class="insight-card">
                <div class="insight-stat"><c:out value="${maintenance}" default="0" /></div>
                <h5 class="fw-bold mb-2">Ca bảo trì hiện tại</h5>
                <p>Nhắc việc đúng thời điểm để hạn chế downtime ngoài kế hoạch.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="section-block pt-0" id="solutions">
        <div class="container">
          <div class="row align-items-end g-4 mb-4">
            <div class="col-lg-7">
              <span class="section-kicker"><i class="fas fa-wand-magic-sparkles"></i> Giải pháp</span>
              <h2 class="section-title">Một landing page mang cảm giác sản phẩm công nghệ chứ không còn là giao diện cũ đơn điệu.</h2>
              <p class="section-subtitle">Tôi đã thay hướng thiết kế bằng các khối nội dung giàu tương phản, card bo tròn lớn và bảng trạng thái trực quan để trang chủ trông cao cấp hơn ngay từ lần nhìn đầu tiên.</p>
            </div>
          </div>

          <div class="row g-4">
            <div class="col-md-6 col-xl-3">
              <div class="feature-card">
                <div class="feature-icon"><i class="fas fa-gauge-high"></i></div>
                <h5 class="fw-bold mb-3">Hero đậm chất dashboard</h5>
                <p>Khối mở đầu thể hiện ngay trạng thái hệ thống, số liệu chính và hành động tiếp theo cho từng loại người dùng.</p>
              </div>
            </div>
            <div class="col-md-6 col-xl-3">
              <div class="feature-card">
                <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
                <h5 class="fw-bold mb-3">Thông tin có thứ bậc rõ</h5>
                <p>Tách phần số liệu, năng lực nền tảng và đối tác để người xem đọc nhanh mà không bị rối mắt.</p>
              </div>
            </div>
            <div class="col-md-6 col-xl-3">
              <div class="feature-card">
                <div class="feature-icon"><i class="fas fa-bell"></i></div>
                <h5 class="fw-bold mb-3">Cảm giác realtime</h5>
                <p>Badge live, progress bar và trạng thái hoạt động giúp homepage trông sống động và hiện đại hơn.</p>
              </div>
            </div>
            <div class="col-md-6 col-xl-3">
              <div class="feature-card">
                <div class="feature-icon"><i class="fas fa-mobile-screen-button"></i></div>
                <h5 class="fw-bold mb-3">Responsive tốt hơn</h5>
                <p>Bố cục được tổ chức lại để hiển thị ổn trên mobile mà vẫn giữ cảm giác premium.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="section-block pt-0" id="brands">
        <div class="container">
          <div class="row align-items-end g-4 mb-4">
            <div class="col-lg-7">
              <span class="section-kicker"><i class="fas fa-handshake-angle"></i> Thương hiệu tương thích</span>
              <h2 class="section-title">Hệ thống sẵn sàng làm việc cùng nhiều dòng máy phát điện phổ biến.</h2>
              <p class="section-subtitle">Phần thương hiệu được chuyển sang dạng card hiện đại để bớt cảm giác khô cứng và tăng độ tin cậy cho trang giới thiệu.</p>
            </div>
          </div>

          <div class="row g-4">
            <c:choose>
              <c:when test="${not empty brands}">
                <c:forEach var="brand" items="${brands}">
                  <div class="col-sm-6 col-lg-4 col-xl-3">
                    <div class="brand-card">
                      <div class="brand-mark"><i class="fas fa-industry"></i></div>
                      <div>
                        <h6 class="fw-bold mb-1">${brand.name}</h6>
                        <p>Tối ưu quản trị, bảo trì và đồng bộ dữ liệu vận hành trên cùng nền tảng.</p>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div class="col-sm-6 col-lg-4 col-xl-3">
                  <div class="brand-card">
                    <div class="brand-mark"><i class="fas fa-industry"></i></div>
                    <div>
                      <h6 class="fw-bold mb-1">Cummins</h6>
                      <p>Tương thích tốt với nhu cầu theo dõi, bảo trì và chăm sóc khách hàng hiện đại.</p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6 col-lg-4 col-xl-3">
                  <div class="brand-card">
                    <div class="brand-mark"><i class="fas fa-industry"></i></div>
                    <div>
                      <h6 class="fw-bold mb-1">Perkins</h6>
                      <p>Tương thích tốt với nhu cầu theo dõi, bảo trì và chăm sóc khách hàng hiện đại.</p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6 col-lg-4 col-xl-3">
                  <div class="brand-card">
                    <div class="brand-mark"><i class="fas fa-industry"></i></div>
                    <div>
                      <h6 class="fw-bold mb-1">Denyo</h6>
                      <p>Tương thích tốt với nhu cầu theo dõi, bảo trì và chăm sóc khách hàng hiện đại.</p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6 col-lg-4 col-xl-3">
                  <div class="brand-card">
                    <div class="brand-mark"><i class="fas fa-industry"></i></div>
                    <div>
                      <h6 class="fw-bold mb-1">Mitsubishi</h6>
                      <p>Tương thích tốt với nhu cầu theo dõi, bảo trì và chăm sóc khách hàng hiện đại.</p>
                    </div>
                  </div>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </section>

      <section class="cta-wrap">
        <div class="container">
          <div class="cta-panel">
            <div class="row align-items-center g-4">
              <div class="col-lg-8">
                <span class="section-kicker text-white-50 mb-3"><i class="fas fa-sparkles"></i> Sẵn sàng nâng cấp trải nghiệm</span>
                <h2 class="fw-bold display-6 mb-3">Trang chủ mới đã gọn hơn, sang hơn và có định hướng hành động rõ ràng hơn.</h2>
                <p class="cta-note">Nếu muốn, bước tiếp theo tôi có thể làm tiếp các trang con như danh sách sản phẩm, tin tức hoặc dashboard quản trị để đồng bộ cùng phong cách này.</p>
              </div>
              <div class="col-lg-4 text-lg-end">
                <c:choose>
                  <c:when test="${empty user}">
                    <a href="<c:url value='/account/login'/>" class="btn-primary-gradient">
                      <i class="fas fa-arrow-right"></i>
                      Bắt đầu ngay
                    </a>
                  </c:when>
                  <c:otherwise>
                    <a href="<c:url value='/news'/>" class="btn-primary-gradient">
                      <i class="fas fa-newspaper"></i>
                      Xem cập nhật mới
                    </a>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="footer">
      <div class="container">
        <div class="row gy-4 align-items-center">
          <div class="col-lg-6 text-center text-lg-start">
            <a href="<c:url value='/'/>" class="d-inline-flex align-items-center gap-3 fw-bold fs-4">
              <span class="navbar-brand-mark"><i class="fas fa-bolt"></i></span>
              <span>Gen-CMS</span>
            </a>
            <p class="mt-3 mb-0">Giải pháp số hóa vận hành máy phát điện với trải nghiệm giao diện hiện đại và trực quan hơn.</p>
          </div>
          <div class="col-lg-6 text-center text-lg-end">
            <p class="mb-2">© 2026 Gen-CMS. Tối ưu vận hành, bảo trì và hỗ trợ khách hàng trên một nền tảng.</p>
            <div class="d-inline-flex gap-3 fs-5">
              <a href="<c:url value='/news'/>"><i class="fas fa-newspaper"></i></a>
              <a href="<c:url value='/products'/>"><i class="fas fa-box-open"></i></a>
              <a href="<c:url value='/account/login'/>"><i class="fas fa-right-to-bracket"></i></a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    const mainNav = document.getElementById('mainNav');
    window.addEventListener('scroll', function () {
      if (window.scrollY > 24) {
        mainNav.classList.add('navbar-scrolled');
      } else {
        mainNav.classList.remove('navbar-scrolled');
      }
    });
  </script>
  <jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>
