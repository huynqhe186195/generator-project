<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
    rel="stylesheet">

  <style>
    :root {
      --primary: #4f46e5;
      --primary-dark: #312e81;
      --secondary: #0f172a;
      --accent: #06b6d4;
      --success: #22c55e;
      --warning: #f59e0b;
      --bg: #f8fafc;
      --surface: rgba(255, 255, 255, 0.88);
      --card: #ffffff;
      --ink: #0f172a;
      --muted: #64748b;
      --line: rgba(15, 23, 42, 0.08);
      --shadow: 0 24px 60px rgba(15, 23, 42, 0.12);
      --radius-xl: 28px;
      --radius-lg: 22px;
      --radius-md: 18px;
    }

    * {
      box-sizing: border-box;
    }

    html {
      scroll-behavior: smooth;
    }

    body {
      font-family: 'Plus Jakarta Sans', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      overflow-x: hidden;
      color: var(--ink);
      background:
        radial-gradient(circle at top left, rgba(79, 70, 229, 0.18), transparent 30%),
        radial-gradient(circle at top right, rgba(6, 182, 212, 0.14), transparent 28%),
        linear-gradient(180deg, #eef4ff 0%, #f8fafc 24%, #f8fafc 100%);
    }

    a {
      text-decoration: none;
    }

    .section-shell {
      position: relative;
      padding: 104px 0;
    }

    .section-shell::before {
      content: "";
      position: absolute;
      inset: 0;
      pointer-events: none;
    }

    .eyebrow {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 10px 16px;
      border-radius: 999px;
      background: rgba(79, 70, 229, 0.08);
      color: var(--primary);
      font-size: 0.82rem;
      font-weight: 800;
      letter-spacing: 0.08em;
      text-transform: uppercase;
    }

    .eyebrow i {
      color: var(--accent);
    }

    .section-title {
      font-size: clamp(2rem, 4vw, 3.2rem);
      font-weight: 800;
      letter-spacing: -0.04em;
      margin: 18px 0 16px;
    }

    .section-subtitle {
      color: var(--muted);
      font-size: 1.04rem;
      line-height: 1.8;
      max-width: 62ch;
    }

    .navbar-landing {
      padding: 18px 0;
      background: transparent;
      transition: all 0.3s ease;
      z-index: 1050;
    }

    .navbar-scrolled {
      background: rgba(255, 255, 255, 0.88) !important;
      backdrop-filter: blur(18px);
      border-bottom: 1px solid rgba(255, 255, 255, 0.6);
      box-shadow: 0 10px 40px rgba(15, 23, 42, 0.08);
      padding: 12px 0;
    }

    .navbar-brand {
      color: #ffffff !important;
      font-size: 1.55rem;
      font-weight: 800;
      letter-spacing: -0.03em;
    }

    .navbar-scrolled .navbar-brand {
      color: var(--primary) !important;
    }

    .navbar-toggler {
      border: 0;
      box-shadow: none !important;
      background: rgba(255, 255, 255, 0.14);
      border-radius: 14px;
      padding: 10px 12px;
    }

    .navbar-toggler-icon {
      filter: brightness(0) invert(1);
    }

    .navbar-scrolled .navbar-toggler {
      background: rgba(79, 70, 229, 0.08);
    }

    .navbar-scrolled .navbar-toggler-icon {
      filter: none;
    }

    .nav-link {
      color: rgba(255, 255, 255, 0.92) !important;
      font-weight: 600;
      transition: all 0.25s ease;
    }

    .navbar-scrolled .nav-link {
      color: rgba(15, 23, 42, 0.78) !important;
    }

    .nav-link:hover,
    .nav-link:focus {
      color: #ffffff !important;
      transform: translateY(-1px);
    }

    .navbar-scrolled .nav-link:hover,
    .navbar-scrolled .nav-link:focus {
      color: var(--primary) !important;
    }

    .nav-pill {
      padding: 0.72rem 1rem !important;
      border-radius: 999px;
    }

    .navbar-scrolled .nav-pill:hover {
      background: rgba(79, 70, 229, 0.08);
    }

    .user-dropdown-toggle {
      background: rgba(255, 255, 255, 0.12);
      border: 1px solid rgba(255, 255, 255, 0.18);
      border-radius: 999px;
      padding: 0.72rem 1rem !important;
    }

    .navbar-scrolled .user-dropdown-toggle {
      background: rgba(79, 70, 229, 0.08);
      border-color: rgba(79, 70, 229, 0.16);
      color: var(--primary) !important;
    }

    .btn-hero,
    .btn-soft,
    .btn-white,
    .btn-ghost {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      font-weight: 700;
      border-radius: 999px;
      transition: all 0.28s ease;
    }

    .btn-white,
    .btn-hero {
      background: linear-gradient(135deg, #ffffff 0%, #eef2ff 100%);
      color: var(--primary);
      padding: 14px 28px;
      border: 0;
      box-shadow: 0 18px 40px rgba(15, 23, 42, 0.18);
    }

    .btn-white:hover,
    .btn-hero:hover {
      color: var(--primary-dark);
      transform: translateY(-3px);
      box-shadow: 0 22px 46px rgba(15, 23, 42, 0.2);
    }

    .btn-ghost {
      color: #ffffff;
      padding: 14px 24px;
      border: 1px solid rgba(255, 255, 255, 0.24);
      background: rgba(255, 255, 255, 0.08);
      backdrop-filter: blur(14px);
    }

    .btn-ghost:hover {
      color: #ffffff;
      background: rgba(255, 255, 255, 0.16);
      transform: translateY(-3px);
    }

    .btn-soft {
      background: rgba(79, 70, 229, 0.08);
      color: var(--primary);
      padding: 12px 22px;
    }

    .btn-soft:hover {
      color: var(--primary-dark);
      transform: translateY(-2px);
      background: rgba(79, 70, 229, 0.12);
    }

    .hero-section {
      position: relative;
      overflow: hidden;
      padding: 18px 18px 0;
    }

    #heroCarousel {
      border-radius: 34px;
      overflow: hidden;
      box-shadow: 0 30px 90px rgba(15, 23, 42, 0.18);
    }

    .hero-section::before {
      content: "";
      position: absolute;
      inset: 0;
      background: radial-gradient(circle at 15% 20%, rgba(255, 255, 255, 0.08), transparent 22%);
      pointer-events: none;
      z-index: 1;
    }

    .hero-slide {
      min-height: clamp(720px, 88vh, 860px);
      position: relative;
      display: flex;
      align-items: center;
      padding: 138px 0 94px;
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
    }

    .hero-slide::before {
      content: "";
      position: absolute;
      inset: 0;
      background:
        linear-gradient(120deg, rgba(2, 6, 23, 0.78) 0%, rgba(30, 41, 59, 0.52) 35%, rgba(79, 70, 229, 0.56) 100%),
        radial-gradient(circle at 82% 18%, rgba(255, 255, 255, 0.16), transparent 25%);
    }

    .hero-slide-generator {
      background-size: auto 84%;
      background-position: right 4% center;
      background-color: #13192a;
    }

    .hero-content {
      position: relative;
      z-index: 2;
      color: #ffffff;
      padding-left: 10px;
      padding-right: 10px;
    }

    .hero-grid {
      align-items: center;
    }

    .hero-copy {
      max-width: 700px;
    }

    .hero-title {
      font-size: clamp(2.6rem, 5vw, 5rem);
      line-height: 1.02;
      font-weight: 800;
      letter-spacing: -0.05em;
      margin: 22px 0 18px;
    }

    .hero-desc {
      max-width: 58ch;
      font-size: 1.06rem;
      line-height: 1.85;
      color: rgba(255, 255, 255, 0.88);
      margin-bottom: 28px;
    }

    .hero-actions {
      display: flex;
      flex-wrap: wrap;
      gap: 14px;
      margin-bottom: 34px;
    }

    .hero-bullets {
      display: flex;
      flex-wrap: wrap;
      gap: 14px 22px;
      margin-bottom: 40px;
      padding: 0;
      list-style: none;
    }

    .hero-bullets li {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.9);
    }

    .hero-bullets i {
      color: #86efac;
    }

    .hero-panel {
      position: relative;
      z-index: 2;
      margin-left: auto;
      width: min(100%, 470px);
      border-radius: var(--radius-xl);
      background: rgba(255, 255, 255, 0.12);
      border: 1px solid rgba(255, 255, 255, 0.18);
      box-shadow: var(--shadow);
      backdrop-filter: blur(18px);
      padding: 26px;
      color: #ffffff;
    }

    .panel-badge {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 10px 14px;
      border-radius: 999px;
      background: rgba(255, 255, 255, 0.14);
      font-size: 0.82rem;
      font-weight: 700;
      color: rgba(255, 255, 255, 0.92);
      margin-bottom: 18px;
    }

    .hero-panel h3 {
      font-size: 1.5rem;
      font-weight: 800;
      margin-bottom: 10px;
    }

    .hero-panel p {
      color: rgba(255, 255, 255, 0.78);
      line-height: 1.75;
      margin-bottom: 22px;
    }

    .hero-panel-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 14px;
      margin-bottom: 18px;
    }

    .panel-card,
    .stat-card,
    .feature-card,
    .overview-card,
    .journey-card,
    .brand-card,
    .cta-card {
      border-radius: var(--radius-lg);
      background: var(--card);
      border: 1px solid var(--line);
      box-shadow: 0 16px 40px rgba(15, 23, 42, 0.07);
    }

    .panel-card {
      background: rgba(255, 255, 255, 0.1);
      border-color: rgba(255, 255, 255, 0.12);
      padding: 18px;
    }

    .panel-card .label {
      display: block;
      color: rgba(255, 255, 255, 0.7);
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      margin-bottom: 8px;
    }

    .panel-card strong {
      display: block;
      font-size: 1.45rem;
      font-weight: 800;
      margin-bottom: 6px;
    }

    .panel-card span {
      color: rgba(255, 255, 255, 0.72);
      font-size: 0.92rem;
    }

    .hero-mini-list {
      list-style: none;
      padding: 0;
      margin: 0;
      display: grid;
      gap: 12px;
    }

    .hero-mini-list li {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      padding: 13px 15px;
      border-radius: 16px;
      background: rgba(255, 255, 255, 0.08);
    }

    .hero-mini-list .status {
      font-weight: 700;
      color: #bfdbfe;
    }

    .stats-band {
      position: relative;
      margin-top: -42px;
      z-index: 4;
    }

    .stats-wrap {
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(18px);
      border: 1px solid rgba(255, 255, 255, 0.78);
      border-radius: 30px;
      padding: 22px;
      box-shadow: 0 24px 70px rgba(15, 23, 42, 0.14);
    }

    .stat-card {
      padding: 20px 22px;
      height: 100%;
      background: linear-gradient(180deg, rgba(255, 255, 255, 1) 0%, rgba(247, 249, 255, 1) 100%);
    }

    .stat-icon {
      width: 54px;
      height: 54px;
      border-radius: 18px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      background: rgba(79, 70, 229, 0.1);
      color: var(--primary);
      font-size: 1.2rem;
      margin-bottom: 18px;
    }

    .stat-value {
      display: block;
      font-size: 2rem;
      font-weight: 800;
      letter-spacing: -0.04em;
      margin-bottom: 8px;
    }

    .stat-caption {
      color: var(--muted);
      line-height: 1.7;
      margin-bottom: 0;
    }

    .overview-card {
      padding: 28px;
      height: 100%;
      background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
    }

    .overview-icon,
    .feature-icon,
    .journey-icon {
      width: 62px;
      height: 62px;
      border-radius: 20px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 1.4rem;
      margin-bottom: 20px;
      color: var(--primary);
      background: rgba(79, 70, 229, 0.1);
      box-shadow: inset 0 0 0 1px rgba(79, 70, 229, 0.05);
    }

    .overview-card h4,
    .feature-card h4,
    .journey-card h4 {
      font-weight: 800;
      margin-bottom: 14px;
    }

    .overview-card p,
    .feature-card p,
    .journey-card p,
    .brand-card p {
      color: var(--muted);
      line-height: 1.8;
      margin-bottom: 0;
    }

    .feature-card {
      height: 100%;
      padding: 30px;
      position: relative;
      overflow: hidden;
      transition: transform 0.28s ease, box-shadow 0.28s ease;
    }

    .feature-card::before {
      content: "";
      position: absolute;
      inset: 0;
      background: radial-gradient(circle at top right, rgba(79, 70, 229, 0.12), transparent 28%);
      pointer-events: none;
    }

    .feature-card:hover,
    .journey-card:hover,
    .brand-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 24px 55px rgba(15, 23, 42, 0.12);
    }

    .feature-list {
      list-style: none;
      padding: 0;
      margin: 18px 0 0;
      display: grid;
      gap: 12px;
    }

    .feature-list li {
      display: flex;
      gap: 12px;
      color: var(--secondary);
      font-weight: 600;
    }

    .feature-list i {
      color: var(--success);
      margin-top: 4px;
    }

    .journey-card {
      padding: 28px;
      height: 100%;
      position: relative;
      transition: transform 0.28s ease, box-shadow 0.28s ease;
    }

    .journey-step {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: rgba(79, 70, 229, 0.1);
      color: var(--primary);
      font-weight: 800;
      margin-bottom: 16px;
    }

    .brand-card {
      padding: 26px 22px;
      text-align: center;
      height: 100%;
      transition: transform 0.28s ease, box-shadow 0.28s ease;
      background: linear-gradient(180deg, #ffffff 0%, #fbfdff 100%);
    }

    .brand-logo {
      width: 68px;
      height: 68px;
      border-radius: 22px;
      margin: 0 auto 18px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(6, 182, 212, 0.1);
      color: var(--accent);
      font-size: 1.45rem;
    }

    .cta-section {
      padding: 0 0 104px;
    }

    .cta-card {
      position: relative;
      overflow: hidden;
      background: linear-gradient(135deg, #0f172a 0%, #312e81 55%, #2563eb 100%);
      border: 0;
      color: #ffffff;
      padding: 42px;
      box-shadow: 0 28px 80px rgba(15, 23, 42, 0.22);
    }

    .cta-card::before,
    .cta-card::after {
      content: "";
      position: absolute;
      border-radius: 50%;
      pointer-events: none;
    }

    .cta-card::before {
      width: 280px;
      height: 280px;
      background: rgba(255, 255, 255, 0.08);
      top: -100px;
      right: -70px;
    }

    .cta-card::after {
      width: 180px;
      height: 180px;
      background: rgba(6, 182, 212, 0.18);
      bottom: -60px;
      left: -40px;
    }

    .cta-card>* {
      position: relative;
      z-index: 1;
    }

    .cta-points {
      list-style: none;
      margin: 26px 0 0;
      padding: 0;
      display: grid;
      gap: 14px;
    }

    .cta-points li {
      display: flex;
      align-items: center;
      gap: 12px;
      color: rgba(255, 255, 255, 0.9);
      font-weight: 600;
    }

    .cta-points i {
      color: #fde68a;
    }

    .footer {
      background: #08111f;
      color: rgba(255, 255, 255, 0.72);
      padding: 62px 0 26px;
    }

    .footer-brand {
      color: #ffffff;
      font-size: 1.6rem;
      font-weight: 800;
    }

    .footer-link {
      color: rgba(255, 255, 255, 0.72);
      transition: color 0.2s ease;
    }

    .footer-link:hover {
      color: #ffffff;
    }

    .footer-list {
      list-style: none;
      padding: 0;
      margin: 0;
      display: grid;
      gap: 10px;
    }

    .footer-list a {
      color: rgba(255, 255, 255, 0.75);
    }

    .footer-list a:hover {
      color: #ffffff;
    }

    .carousel-item {
      transition: opacity 1s ease-in-out;
    }

    .carousel-fade .carousel-item {
      opacity: 0;
      transition-property: opacity;
      transform: none;
    }

    .carousel-fade .carousel-item.active,
    .carousel-fade .carousel-item-next.carousel-item-start,
    .carousel-fade .carousel-item-prev.carousel-item-end {
      opacity: 1;
    }

    .carousel-control-prev,
    .carousel-control-next {
      width: 8%;
      opacity: 1;
      z-index: 6;
    }

    .carousel-control-prev-icon,
    .carousel-control-next-icon {
      width: 3rem;
      height: 3rem;
      border-radius: 50%;
      background-color: rgba(255, 255, 255, 0.14);
      backdrop-filter: blur(12px);
      background-size: 45% 45%;
    }

    .carousel-indicators {
      margin-bottom: 32px;
      z-index: 6;
    }

    .carousel-indicators [data-bs-target] {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      border: 0;
      margin: 0 6px;
      background-color: rgba(255, 255, 255, 0.42);
    }

    .carousel-indicators .active {
      background-color: #ffffff;
      transform: scale(1.15);
    }

    @media (max-width: 991.98px) {
      .hero-section {
        padding: 14px 14px 0;
      }

      #heroCarousel {
        border-radius: 28px;
      }

      .hero-slide {
        min-height: auto;
        padding: 124px 0 86px;
      }

      .hero-slide-generator {
        background-size: auto 78%;
        background-position: center right;
      }

      .hero-title {
        font-size: clamp(2.35rem, 7vw, 4rem);
      }

      .hero-panel {
        margin-top: 28px;
        width: 100%;
      }

      .stats-band {
        margin-top: -24px;
      }

      .cta-card {
        padding: 34px 28px;
      }
    }

    @media (max-width: 767.98px) {
      .section-shell {
        padding: 82px 0;
      }

      .hero-section {
        padding: 10px 10px 0;
      }

      #heroCarousel {
        border-radius: 22px;
      }

      .hero-slide {
        padding: 112px 0 76px;
      }

      .hero-slide-generator {
        background-size: cover;
        background-position: center;
      }

      .hero-actions,
      .hero-bullets {
        gap: 12px;
      }

      .hero-panel-grid {
        grid-template-columns: 1fr;
      }

      .stats-wrap {
        padding: 16px;
        border-radius: 24px;
      }

      .feature-card,
      .overview-card,
      .journey-card,
      .brand-card {
        padding: 24px;
      }

      .carousel-control-prev,
      .carousel-control-next {
        display: none;
      }

      .footer {
        text-align: center;
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

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">
          <li class="nav-item">
            <a class="nav-link nav-pill" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công ty</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-pill" href="<c:url value='/news'/>">Tin tức</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-pill" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
          </li>
          <c:if test="${not empty user}">
            <li class="nav-item">
              <a class="nav-link nav-pill" href="<c:url value='/product-list'/>">Sản phẩm</a>
            </li>
          </c:if>
          <li class="nav-item">
            <a class="nav-link nav-pill" href="#features">Giải pháp</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-pill" href="#brands">Thương hiệu</a>
          </li>
          <c:if test="${not empty user}">
            <li class="nav-item">
              <a class="nav-link nav-pill" href="<c:url value='/views/home/Support.jsp'/>">Chăm sóc khách hàng</a>
            </li>
          </c:if>

          <c:choose>
            <c:when test="${empty user}">
              <li class="nav-item ms-lg-3 mt-3 mt-lg-0">
                <a href="<c:url value='/account/login'/>" class="btn btn-white px-4">
                  <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
                </a>
              </li>
            </c:when>
            <c:otherwise>
              <li class="nav-item dropdown ms-lg-3 mt-3 mt-lg-0">
                <a class="nav-link dropdown-toggle user-dropdown-toggle" href="#" role="button"
                  data-bs-toggle="dropdown" aria-expanded="false">
                  <i class="fas fa-user-circle me-1"></i> ${user.fullName}
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-3">
                  <li><a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>"><i
                        class="fas fa-id-card me-2"></i>Hồ sơ</a></li>
                  <li><a class="dropdown-item py-2" href="<c:url value='/account/change-password'/>"><i
                        class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
                  <li>
                    <hr class="dropdown-divider">
                  </li>
                  <li><a class="dropdown-item py-2 text-danger fw-bold" href="<c:url value='/account/logout'/>"><i
                        class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                </ul>
              </li>
            </c:otherwise>
          </c:choose>
        </ul>
      </div>
    </div>
  </nav>

  <section class="hero-section p-0">
    <div id="heroCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="5500"
      data-bs-pause="false">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"
          aria-current="true" aria-label="Slide 1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
      </div>

      <div class="carousel-inner">
        <div class="carousel-item active">
          <div class="hero-slide hero-slide-generator" style="background-image: url('<c:url value='/template/images/slide1.jpg'/>');">
            <div class="container hero-content">
              <div class="row g-4 hero-grid">
                <div class="col-lg-7">
                  <div class="hero-copy" data-aos="fade-right">
                    <span class="eyebrow"><i class="fas fa-wave-square"></i>Nền tảng quản trị thế hệ mới</span>
                    <h1 class="hero-title">Điều hành toàn bộ hệ sinh thái máy phát điện trên một giao diện đẳng cấp.</h1>
                    <p class="hero-desc">Gen-CMS giúp doanh nghiệp theo dõi thiết bị, điều phối bảo trì, quản lý lịch sử
                      sửa chữa và chăm sóc khách hàng tập trung trong một hệ thống trực quan, hiện đại và dễ mở rộng.</p>

                    <ul class="hero-bullets">
                      <li><i class="fas fa-circle-check"></i> Dữ liệu tập trung theo thời gian thực</li>
                      <li><i class="fas fa-circle-check"></i> Tự động hóa cảnh báo vận hành</li>
                      <li><i class="fas fa-circle-check"></i> Tối ưu phối hợp IT - kỹ thuật - khách hàng</li>
                    </ul>

                    <div class="hero-actions">
                      <c:choose>
                        <c:when test="${empty user}">
                          <a href="<c:url value='/account/login'/>" class="btn btn-white">
                            <i class="fa-solid fa-rocket"></i> Trải nghiệm ngay
                          </a>
                        </c:when>
                        <c:otherwise>
                          <a href="<c:url value='/admin/dashboard'/>" class="btn btn-white">
                            <i class="fa-solid fa-gauge-high"></i> Vào Dashboard
                          </a>
                        </c:otherwise>
                      </c:choose>
                      <a href="#features" class="btn-ghost">
                        <i class="fa-solid fa-layer-group"></i> Khám phá giải pháp
                      </a>
                    </div>
                  </div>
                </div>

                <div class="col-lg-5">
                  <div class="hero-panel" data-aos="fade-left">
                    <span class="panel-badge"><i class="fas fa-signal"></i>Trung tâm vận hành thông minh</span>
                    <h3>Bức tranh tổng thể rõ ràng trong vài giây</h3>
                    <p>Từ số lượng model, khối lượng vận hành đến người dùng đang hoạt động - mọi thông tin quan trọng
                      đều được cô đọng trên giao diện nổi bật và dễ quan sát.</p>

                    <div class="hero-panel-grid">
                      <div class="panel-card">
                        <span class="label">Thiết bị quản lý</span>
                        <strong>
                          <c:choose>
                            <c:when test="${not empty stats}">${stats.totalProductModels}</c:when>
                            <c:otherwise>150</c:otherwise>
                          </c:choose>
                        </strong>
                        <span>Model đang được theo dõi</span>
                      </div>
                      <div class="panel-card">
                        <span class="label">Người dùng</span>
                        <strong>
                          <c:choose>
                            <c:when test="${not empty stats}">${stats.totalUsers}</c:when>
                            <c:otherwise>45</c:otherwise>
                          </c:choose>
                        </strong>
                        <span>Nhân sự & khách hàng</span>
                      </div>
                    </div>

                    <ul class="hero-mini-list">
                      <li>
                        <span>Giám sát hệ thống 24/7</span>
                        <span class="status">Live</span>
                      </li>
                      <li>
                        <span>Nhắc bảo trì & xử lý sự cố</span>
                        <span class="status">Tự động</span>
                      </li>
                      <li>
                        <span>Hỗ trợ đội ngũ chăm sóc khách hàng</span>
                        <span class="status">Đồng bộ</span>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="carousel-item">
          <div class="hero-slide" style="background-image: url('<c:url value='/template/images/slide2.jpg'/>');">
            <div class="container hero-content">
              <div class="row g-4 hero-grid">
                <div class="col-lg-7">
                  <div class="hero-copy" data-aos="fade-right">
                    <span class="eyebrow"><i class="fas fa-tower-broadcast"></i>Giám sát liên tục</span>
                    <h2 class="hero-title">Nắm trạng thái thiết bị 24/7 và hành động trước khi sự cố xảy ra.</h2>
                    <p class="hero-desc">Thiết kế màn hình trực quan giúp đội ngũ vận hành nhìn thấy nhanh thông số, cảnh
                      báo và xu hướng sử dụng để đưa ra quyết định kịp thời.</p>
                    <div class="hero-actions">
                      <a href="#overview" class="btn btn-white"><i class="fas fa-chart-pie"></i> Xem tổng quan</a>
                      <a href="#journey" class="btn-ghost"><i class="fas fa-diagram-project"></i> Quy trình vận hành</a>
                    </div>
                  </div>
                </div>
                <div class="col-lg-5">
                  <div class="hero-panel" data-aos="fade-left">
                    <span class="panel-badge"><i class="fas fa-bell"></i>Cảnh báo chủ động</span>
                    <h3>Giảm thời gian phản hồi khi có bất thường</h3>
                    <p>Hệ thống nhấn mạnh các mốc vận hành quan trọng để doanh nghiệp ưu tiên nguồn lực đúng lúc, đúng nơi.</p>
                    <div class="hero-panel-grid">
                      <div class="panel-card">
                        <span class="label">Giờ hoạt động</span>
                        <strong>
                          <c:choose>
                            <c:when test="${not empty stats}">${stats.totalHours}</c:when>
                            <c:otherwise>1200</c:otherwise>
                          </c:choose>
                        </strong>
                        <span>Tổng giờ chạy ghi nhận</span>
                      </div>
                      <div class="panel-card">
                        <span class="label">Độ ổn định</span>
                        <strong>99.9%</strong>
                        <span>Vận hành liên tục</span>
                      </div>
                    </div>
                    <ul class="hero-mini-list">
                      <li><span>Theo dõi hiệu suất theo cụm máy</span><span class="status">Realtime</span></li>
                      <li><span>Thông báo sự cố ưu tiên cao</span><span class="status">Nhanh</span></li>
                      <li><span>Lưu lịch sử để phân tích dài hạn</span><span class="status">Insight</span></li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="carousel-item">
          <div class="hero-slide" style="background-image: url('<c:url value='/template/images/slide3.jpg'/>');">
            <div class="container hero-content">
              <div class="row g-4 hero-grid">
                <div class="col-lg-7">
                  <div class="hero-copy" data-aos="fade-right">
                    <span class="eyebrow"><i class="fas fa-screwdriver-wrench"></i>Bảo trì tối ưu</span>
                    <h2 class="hero-title">Biến quy trình bảo trì thành trải nghiệm chuyên nghiệp và có thể mở rộng.</h2>
                    <p class="hero-desc">Từ lập lịch, phân công kỹ thuật viên tới xác nhận hoàn thành, Gen-CMS giúp quy
                      trình sau bán hàng mượt mà, minh bạch và đáng tin cậy hơn.</p>
                    <div class="hero-actions">
                      <c:if test="${not empty user}">
                        <a href="<c:url value='/views/home/Support.jsp'/>" class="btn btn-white">
                          <i class="fas fa-headset"></i> Gửi yêu cầu hỗ trợ
                        </a>
                      </c:if>
                      <a href="#brands" class="btn-ghost"><i class="fas fa-industry"></i> Xem thương hiệu</a>
                    </div>
                  </div>
                </div>
                <div class="col-lg-5">
                  <div class="hero-panel" data-aos="fade-left">
                    <span class="panel-badge"><i class="fas fa-handshake-angle"></i>Dịch vụ sau bán hàng</span>
                    <h3>Đem lại cảm giác tin cậy cho khách hàng</h3>
                    <p>Giao diện mới nhấn mạnh tốc độ, độ minh bạch và khả năng phối hợp giữa các bộ phận để khách hàng
                      luôn được hỗ trợ rõ ràng.</p>
                    <ul class="hero-mini-list">
                      <li><span>Lên lịch định kỳ theo vòng đời thiết bị</span><span class="status">Chủ động</span></li>
                      <li><span>Theo dõi trạng thái xử lý yêu cầu</span><span class="status">Minh bạch</span></li>
                      <li><span>Báo cáo lịch sử sửa chữa đầy đủ</span><span class="status">Tin cậy</span></li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
      </button>
    </div>
  </section>

  <section class="stats-band">
    <div class="container">
      <div class="stats-wrap">
        <div class="row g-4">
          <div class="col-md-4" data-aos="fade-up">
            <div class="stat-card">
              <div class="stat-icon"><i class="fas fa-microchip"></i></div>
              <span class="stat-value">
                <c:choose>
                  <c:when test="${not empty stats}">${stats.totalProductModels}</c:when>
                  <c:otherwise>150</c:otherwise>
                </c:choose>
              </span>
              <p class="stat-caption">Model máy phát đang được quản lý tập trung trên toàn hệ thống.</p>
            </div>
          </div>
          <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
            <div class="stat-card">
              <div class="stat-icon"><i class="fas fa-clock-rotate-left"></i></div>
              <span class="stat-value">
                <c:choose>
                  <c:when test="${not empty stats}">${stats.totalHours}</c:when>
                  <c:otherwise>1200</c:otherwise>
                </c:choose>
              </span>
              <p class="stat-caption">Tổng thời gian vận hành được ghi nhận để dự báo và lập lịch bảo trì.</p>
            </div>
          </div>
          <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
            <div class="stat-card">
              <div class="stat-icon"><i class="fas fa-users"></i></div>
              <span class="stat-value">
                <c:choose>
                  <c:when test="${not empty stats}">${stats.totalUsers}</c:when>
                  <c:otherwise>45</c:otherwise>
                </c:choose>
              </span>
              <p class="stat-caption">Người dùng, kỹ thuật viên và khách hàng được kết nối trên cùng một nền tảng.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section id="overview" class="section-shell pb-0">
    <div class="container">
      <div class="row align-items-center g-4 mb-5">
        <div class="col-lg-6" data-aos="fade-right">
          <span class="eyebrow"><i class="fas fa-sparkles"></i>Thiết kế lại trải nghiệm trang chủ</span>
          <h2 class="section-title">Trang chủ mới sang trọng hơn, rõ ràng hơn và truyền cảm hứng hơn.</h2>
          <p class="section-subtitle">Bố cục được tái cấu trúc để nhấn mạnh lợi ích cốt lõi của sản phẩm: trực quan khi nhìn,
            dễ hiểu khi đọc và mạnh mẽ khi thuyết phục khách hàng ngay từ màn hình đầu tiên.</p>
        </div>
        <div class="col-lg-6" data-aos="fade-left">
          <div class="row g-4">
            <div class="col-sm-6">
              <div class="overview-card">
                <div class="overview-icon"><i class="fas fa-palette"></i></div>
                <h4>Phong cách hiện đại</h4>
                <p>Màu sắc chiều sâu, hiệu ứng kính mờ và thẻ nội dung bo tròn giúp giao diện trông cao cấp hơn.</p>
              </div>
            </div>
            <div class="col-sm-6">
              <div class="overview-card">
                <div class="overview-icon"><i class="fas fa-object-group"></i></div>
                <h4>Bố cục có điểm nhấn</h4>
                <p>Phân tầng thông tin rõ ràng để người xem nhanh chóng nắm được giá trị sản phẩm.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section id="features" class="section-shell">
    <div class="container">
      <div class="text-center mb-5" data-aos="fade-up">
        <span class="eyebrow"><i class="fas fa-grid-2"></i>Giải pháp cốt lõi</span>
        <h2 class="section-title">Tính năng được trình bày trực quan và đủ chiều sâu để thuyết phục người xem.</h2>
        <p class="section-subtitle mx-auto">Mỗi khối nội dung tập trung vào một lợi ích quan trọng giúp doanh nghiệp vận
          hành hệ thống máy phát điện hiệu quả hơn, ít rủi ro hơn và chuyên nghiệp hơn.</p>
      </div>

      <div class="row g-4">
        <div class="col-lg-4" data-aos="fade-up">
          <div class="feature-card">
            <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
            <h4>Giám sát thời gian thực</h4>
            <p>Theo dõi tình trạng hoạt động của từng máy mọi lúc để nắm nhanh hiệu suất, tải vận hành và xu hướng bất thường.</p>
            <ul class="feature-list">
              <li><i class="fas fa-circle-check"></i><span>Quan sát dữ liệu tổng quan trên một màn hình</span></li>
              <li><i class="fas fa-circle-check"></i><span>Ra quyết định nhanh hơn nhờ thông tin tập trung</span></li>
            </ul>
          </div>
        </div>
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
          <div class="feature-card">
            <div class="feature-icon"><i class="fas fa-bell"></i></div>
            <h4>Cảnh báo ưu tiên cao</h4>
            <p>Thông báo sự cố và nhắc lịch bảo trì theo cách rõ ràng, giúp đội ngũ xử lý nhanh ngay khi hệ thống có dấu hiệu bất thường.</p>
            <ul class="feature-list">
              <li><i class="fas fa-circle-check"></i><span>Rút ngắn thời gian phản hồi đối với lỗi nghiêm trọng</span></li>
              <li><i class="fas fa-circle-check"></i><span>Giảm nguy cơ bỏ sót công việc cần thực hiện</span></li>
            </ul>
          </div>
        </div>
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
          <div class="feature-card">
            <div class="feature-icon"><i class="fas fa-screwdriver-wrench"></i></div>
            <h4>Quản lý bảo trì có hệ thống</h4>
            <p>Tổ chức lịch bảo trì, lịch sử sửa chữa và phối hợp đội ngũ kỹ thuật bằng một luồng xử lý rõ ràng, thuận tiện cho mở rộng.</p>
            <ul class="feature-list">
              <li><i class="fas fa-circle-check"></i><span>Lưu vết quy trình hỗ trợ và sửa chữa đầy đủ</span></li>
              <li><i class="fas fa-circle-check"></i><span>Tăng độ chuyên nghiệp trong dịch vụ sau bán hàng</span></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section id="journey" class="section-shell pt-0">
    <div class="container">
      <div class="row align-items-end g-4 mb-5">
        <div class="col-lg-7" data-aos="fade-right">
          <span class="eyebrow"><i class="fas fa-route"></i>Quy trình vận hành</span>
          <h2 class="section-title">Một luồng trải nghiệm mượt mà cho cả doanh nghiệp lẫn khách hàng.</h2>
          <p class="section-subtitle">Trang chủ mới không chỉ đẹp hơn mà còn kể được câu chuyện sản phẩm: từ quan sát dữ
            liệu, phát hiện sự cố đến chăm sóc sau bán hàng.</p>
        </div>
        <div class="col-lg-5 text-lg-end" data-aos="fade-left">
          <a href="<c:url value='/products'/>" class="btn-soft"><i class="fas fa-box-open"></i> Khám phá sản phẩm mẫu</a>
        </div>
      </div>

      <div class="row g-4">
        <div class="col-md-4" data-aos="fade-up">
          <div class="journey-card">
            <div class="journey-step">01</div>
            <div class="journey-icon"><i class="fas fa-satellite-dish"></i></div>
            <h4>Thu thập và hiển thị dữ liệu</h4>
            <p>Thiết bị, trạng thái và số liệu vận hành được đưa lên giao diện với cấu trúc dễ đọc, dễ theo dõi.</p>
          </div>
        </div>
        <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
          <div class="journey-card">
            <div class="journey-step">02</div>
            <div class="journey-icon"><i class="fas fa-triangle-exclamation"></i></div>
            <h4>Phát hiện và cảnh báo sớm</h4>
            <p>Hệ thống làm nổi bật các điểm cần chú ý để đội ngũ ưu tiên xử lý đúng vấn đề, đúng thời điểm.</p>
          </div>
        </div>
        <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
          <div class="journey-card">
            <div class="journey-step">03</div>
            <div class="journey-icon"><i class="fas fa-headset"></i></div>
            <h4>Hỗ trợ và duy trì tin cậy</h4>
            <p>Kết nối quy trình hậu mãi, hỗ trợ kỹ thuật và theo dõi lịch sử để nâng cao trải nghiệm khách hàng.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section id="brands" class="section-shell pt-0">
    <div class="container">
      <div class="text-center mb-5" data-aos="fade-up">
        <span class="eyebrow"><i class="fas fa-industry"></i>Hệ sinh thái thương hiệu</span>
        <h2 class="section-title">Sẵn sàng đồng hành cùng nhiều dòng máy phát điện phổ biến.</h2>
        <p class="section-subtitle mx-auto">Khu vực thương hiệu được làm mới thành dạng card hiện đại để tăng cảm giác uy tín,
          chuyên nghiệp và dễ nhìn hơn so với kiểu hiển thị cũ.</p>
      </div>

      <div class="row g-4 justify-content-center">
        <c:choose>
          <c:when test="${not empty brands}">
            <c:forEach var="brand" items="${brands}">
              <div class="col-6 col-md-4 col-lg-3" data-aos="zoom-in">
                <div class="brand-card">
                  <div class="brand-logo"><i class="fas fa-bolt"></i></div>
                  <h5 class="fw-bold mb-2">${brand.name}</h5>
                  <p>Tương thích với quy trình quản lý và bảo trì tập trung của Gen-CMS.</p>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div class="col-6 col-md-4 col-lg-3" data-aos="zoom-in">
              <div class="brand-card">
                <div class="brand-logo"><i class="fas fa-bolt"></i></div>
                <h5 class="fw-bold mb-2">CUMMINS</h5>
                <p>Tương thích với quy trình quản lý và bảo trì tập trung của Gen-CMS.</p>
              </div>
            </div>
            <div class="col-6 col-md-4 col-lg-3" data-aos="zoom-in" data-aos-delay="100">
              <div class="brand-card">
                <div class="brand-logo"><i class="fas fa-bolt"></i></div>
                <h5 class="fw-bold mb-2">PERKINS</h5>
                <p>Tương thích với quy trình quản lý và bảo trì tập trung của Gen-CMS.</p>
              </div>
            </div>
            <div class="col-6 col-md-4 col-lg-3" data-aos="zoom-in" data-aos-delay="200">
              <div class="brand-card">
                <div class="brand-logo"><i class="fas fa-bolt"></i></div>
                <h5 class="fw-bold mb-2">DENYO</h5>
                <p>Tương thích với quy trình quản lý và bảo trì tập trung của Gen-CMS.</p>
              </div>
            </div>
            <div class="col-6 col-md-4 col-lg-3" data-aos="zoom-in" data-aos-delay="300">
              <div class="brand-card">
                <div class="brand-logo"><i class="fas fa-bolt"></i></div>
                <h5 class="fw-bold mb-2">MITSUBISHI</h5>
                <p>Tương thích với quy trình quản lý và bảo trì tập trung của Gen-CMS.</p>
              </div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </section>

  <section class="cta-section">
    <div class="container" data-aos="fade-up">
      <div class="cta-card">
        <div class="row align-items-center g-4">
          <div class="col-lg-7">
            <span class="eyebrow bg-white text-primary"><i class="fas fa-rocket"></i>Sẵn sàng nâng cấp trải nghiệm</span>
            <h2 class="section-title text-white mb-3">Biến trang home thành điểm chạm gây ấn tượng mạnh ngay lần đầu truy cập.</h2>
            <p class="mb-0" style="color: rgba(255,255,255,0.82); line-height: 1.85;">Thiết kế mới giúp trang chủ nổi bật
              hơn về thẩm mỹ, rõ ràng hơn về nội dung và chuyên nghiệp hơn trong cách trình bày giải pháp Gen-CMS.</p>
          </div>
          <div class="col-lg-5">
            <div class="d-flex flex-wrap gap-3 justify-content-lg-end">
              <c:choose>
                <c:when test="${empty user}">
                  <a href="<c:url value='/account/login'/>" class="btn btn-white"><i class="fas fa-right-to-bracket"></i> Đăng nhập ngay</a>
                </c:when>
                <c:otherwise>
                  <a href="<c:url value='/views/home/Support.jsp'/>" class="btn btn-white"><i class="fas fa-headset"></i> Liên hệ hỗ trợ</a>
                </c:otherwise>
              </c:choose>
              <a href="<c:url value='/news'/>" class="btn-ghost"><i class="fas fa-newspaper"></i> Xem tin tức</a>
            </div>
            <ul class="cta-points">
              <li><i class="fas fa-star"></i> Tăng cảm nhận cao cấp cho thương hiệu.</li>
              <li><i class="fas fa-star"></i> Làm nổi bật lợi ích sản phẩm ngay phía trên màn hình.</li>
              <li><i class="fas fa-star"></i> Tạo hành trình khám phá nội dung mạch lạc hơn.</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </section>

  <footer class="footer">
    <div class="container">
      <div class="row g-4 align-items-start">
        <div class="col-lg-5">
          <a href="<c:url value='/'/>" class="footer-brand d-inline-flex align-items-center gap-2">
            <i class="fas fa-bolt text-warning"></i>Gen-CMS
          </a>
          <p class="mt-3 mb-0">Giải pháp số hóa quản lý máy phát điện với giao diện hiện đại, trực quan và giàu cảm hứng
            hơn cho người dùng cuối.</p>
        </div>
        <div class="col-sm-6 col-lg-3">
          <h6 class="text-white fw-bold mb-3">Điều hướng</h6>
          <ul class="footer-list">
            <li><a href="#features">Giải pháp</a></li>
            <li><a href="#brands">Thương hiệu</a></li>
            <li><a href="<c:url value='/products'/>">Sản phẩm mẫu</a></li>
          </ul>
        </div>
        <div class="col-sm-6 col-lg-4 text-lg-end">
          <h6 class="text-white fw-bold mb-3">Kết nối</h6>
          <div class="d-inline-flex gap-3 fs-5">
            <a href="#" class="footer-link"><i class="fab fa-facebook"></i></a>
            <a href="#" class="footer-link"><i class="fab fa-linkedin"></i></a>
            <a href="#" class="footer-link"><i class="fas fa-envelope"></i></a>
          </div>
          <p class="small mt-3 mb-0">&copy; 2026 Gen-CMS Corporation. Bảo lưu mọi quyền.</p>
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
      if (window.scrollY > 40) {
        mainNav.classList.add('navbar-scrolled');
      } else {
        mainNav.classList.remove('navbar-scrolled');
      }
    });
  </script>
  <jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>

</html>
