<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chăm sóc khách hàng | Gen-CMS</title>

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

    /* Navbar giống Home */
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

    /* Header/Hero giống Home */
    .hero-section {
      background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
      color: white;
      padding: 160px 0 90px;
      clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
      position: relative;
    }
    .hero-title { font-weight: 800; font-size: 3rem; line-height: 1.2; margin-bottom: 15px; }
    .hero-desc { font-size: 1.15rem; opacity: 0.9; margin-bottom: 0; }

    /* Cards/form/faq đồng bộ style Home */
    .feature-card {
      border: none;
      border-radius: 20px;
      padding: 35px;
      background: #fff;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
      transition: 0.4s;
      height: 100%;
    }
    .feature-card:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(0,0,0,0.1); }

    .support-icon {
      width: 70px; height: 70px; background: #eef2fd; color: var(--primary);
      border-radius: 15px; display: flex; align-items: center; justify-content: center;
      font-size: 2rem; margin: 0 auto 20px;
    }

    .contact-form {
      border: none;
      border-radius: 20px;
      padding: 40px;
      background: #fff;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }

    .accordion-item { border: none; border-radius: 16px; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
    .accordion-button:not(.collapsed) {
      background-color: #eef2fd;
      color: var(--primary);
      font-weight: 700;
    }

    footer { background: #1a1a1a; color: #888; padding: 60px 0 30px; margin-top: 60px; }
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
        <li class="nav-item"><a class="nav-link px-3" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công ty</a></li>

        <c:choose>
          <c:when test="${empty user}">
            <li class="nav-item">
              <a class="nav-link nav-pill px-3" href="<c:url value='/news'/>">Tin tức</a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link px-3" href="<c:url value='product-list'/>">Sản phẩm</a>
            </li>
          </c:otherwise>
        </c:choose>

        <li class="nav-item"><a class="nav-link px-3" href="<c:url value='/home#features'/>">Tính năng</a></li>
        <li class="nav-item"><a class="nav-link px-3" href="<c:url value='/home#brands'/>">Thương hiệu</a></li>

        <c:if test="${not empty user}">
          <li class="nav-item">
            <a class="nav-link px-3" href="<c:url value='/views/home/Support.jsp'/>">Chăm sóc khách hàng</a>
          </li>
        </c:if>

        <c:choose>
          <c:when test="${empty user}">
            <li class="nav-item ms-lg-3">
              <a href="<c:url value='/account/login'/>" class="btn btn-light px-4 shadow-sm rounded-pill fw-bold">Đăng nhập</a>
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
      <div class="col-lg-8" data-aos="fade-right">
        <h1 class="hero-title">Trung tâm Trợ giúp Gen-CMS</h1>
        <p class="hero-desc">Mọi thắc mắc của bạn sẽ được giải đáp nhanh chóng — hỗ trợ kỹ thuật, tài khoản và vận hành hệ thống.</p>
      </div>
    </div>
  </div>
</section>

<div class="container my-5">
  <c:if test="${param.message == 'request_sent'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="fas fa-check-circle me-2"></i>Yêu cầu của bạn đã được gửi tới bộ phận Staff. Chúng tôi sẽ phản hồi sớm.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${param.message == 'missing_fields'}">
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <i class="fas fa-triangle-exclamation me-2"></i>Vui lòng chọn loại yêu cầu và nhập nội dung chi tiết.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <div class="row g-4 mb-5 justify-content-center">
    <div class="col-md-5" data-aos="fade-up">
      <div class="feature-card text-center">
        <div class="support-icon"><i class="fas fa-phone-alt"></i></div>
        <h4 class="fw-bold">Hotline Kỹ thuật</h4>
        <p class="text-muted mb-2">Hỗ trợ khẩn cấp 24/7</p>
        <a href="tel:1900123456" class="text-decoration-none">
          <h3 class="text-primary fw-bold mb-0">1900-123-456</h3>
        </a>
      </div>
    </div>

    <div class="col-md-5" data-aos="fade-up" data-aos-delay="100">
      <div class="feature-card text-center">
        <div class="support-icon"><i class="fas fa-envelope-open-text"></i></div>
        <h4 class="fw-bold">Gửi Email</h4>
        <p class="text-muted mb-2">Gửi phản hồi hoặc yêu cầu tài liệu</p>
        <a href="mailto:support@gen-cms.com" class="text-decoration-none">
          <h3 class="text-primary fw-bold mb-0">support@gen-cms.com</h3>
        </a>
      </div>
    </div>
  </div>

  <div class="row g-5">
    <div class="col-lg-7" data-aos="fade-right">
      <div class="contact-form">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h3 class="fw-bold mb-0"><i class="fas fa-paper-plane me-2 text-primary"></i>Gửi yêu cầu hỗ trợ</h3>
          <a href="<c:url value='/customer/support-requests'/>" class="btn btn-outline-primary btn-sm rounded-pill">
            <i class="fas fa-clock-rotate-left me-1"></i>Kết quả phản hồi
          </a>
        </div>
        <form action="<c:url value='/customer/support-request'/>" method="POST">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label small fw-bold">Họ và tên</label>
              <input type="text" class="form-control border-0 bg-light p-3" value="${user.fullName}" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label small fw-bold">Email</label>
              <input type="email" class="form-control border-0 bg-light p-3" value="${user.email}" readonly>
            </div>
            <div class="col-md-12">
              <label class="form-label small fw-bold">Loại yêu cầu</label>
              <select class="form-select border-0 bg-light p-3" name="requestKind" required>
                <option value="">-- Chọn loại yêu cầu --</option>
                <option value="CONTRACT_TERMINATION_EXPLANATION">Giải thích lý do hủy hợp đồng</option>
                <option value="ACCOUNT_DELETE_REQUEST">Yêu cầu xóa tài khoản</option>
                <option value="ACCOUNT_LOCK_REQUEST">Yêu cầu khóa tài khoản</option>
                <option value="CONTRACT_RELATED_REQUEST">Yêu cầu liên quan hợp đồng</option>
                <option value="OTHER">Khác</option>
              </select>
            </div>
            <div class="col-md-12">
              <label class="form-label small fw-bold">Tiêu đề</label>
              <input type="text" class="form-control border-0 bg-light p-3" name="subject" placeholder="Ví dụ: Xin giải thích quyết định chấm dứt hợp đồng">
            </div>
            <div class="col-md-12">
              <label class="form-label small fw-bold">Nội dung chi tiết</label>
              <textarea class="form-control border-0 bg-light p-3" name="message" rows="5" placeholder="Mô tả vấn đề bạn đang gặp phải..." required></textarea>
            </div>
            <div class="col-md-12 mt-4">
              <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">
                Gửi yêu cầu
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <div class="col-lg-5" data-aos="fade-left">
      <h3 class="fw-bold mb-4"><i class="fas fa-question-circle me-2 text-primary"></i>Câu hỏi thường gặp</h3>

      <div class="accordion accordion-flush" id="faqAccordion">
        <div class="accordion-item mb-3">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
              Làm sao để thêm máy phát điện mới?
            </button>
          </h2>
          <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
            <div class="accordion-body text-muted">
              Bạn cần đăng nhập với quyền <strong>Quản trị viên</strong>, vào mục Dashboard và chọn "Thêm thiết bị".
            </div>
          </div>
        </div>

        <div class="accordion-item mb-3">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
              Hệ thống có cảnh báo qua điện thoại không?
            </button>
          </h2>
          <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
            <div class="accordion-body text-muted">
              Hiện tại Gen-CMS hỗ trợ gửi cảnh báo tức thì qua Email.
            </div>
          </div>
        </div>

        <div class="accordion-item mb-3">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
              Tôi quên mật khẩu thì phải làm sao?
            </button>
          </h2>
          <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
            <div class="accordion-body text-muted">
              Nhấn vào link "Quên mật khẩu" tại trang đăng nhập hoặc liên hệ quản trị viên hệ thống để cấp lại.
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<footer>
  <div class="container">
    <div class="row gy-4">
      <div class="col-lg-6 text-center text-lg-start">
        <a href="#" class="text-white text-decoration-none fw-bold fs-4"><i class="fas fa-bolt me-2"></i>Gen-CMS</a>
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

  // Navbar đổi màu khi scroll (giống Home)
  const mainNav = document.getElementById('mainNav');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) mainNav.classList.add('navbar-scrolled');
    else mainNav.classList.remove('navbar-scrolled');
  });
</script>
<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>
