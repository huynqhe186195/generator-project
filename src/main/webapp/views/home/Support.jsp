<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hỗ trợ khách hàng | Gen-CMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; }

    .navbar-landing { background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); padding: 15px 0; }
    .navbar-brand { font-weight: 800; font-size: 1.8rem; color: #fff !important; }
    .nav-link { color: rgba(255,255,255,0.8) !important; font-weight: 500; }

    .support-header {
      background-color: white;
      padding: 60px 0;
      border-bottom: 1px solid #dee2e6;
      text-align: center;
    }

    .support-card {
      border: none;
      border-radius: 15px;
      padding: 40px;
      transition: 0.3s;
      background: white;
      box-shadow: 0 5px 15px rgba(0,0,0,0.05);
      height: 100%;
    }
    .support-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
    .support-icon { font-size: 3rem; color: #4e73df; margin-bottom: 20px; }

    .contact-form {
      background: white;
      padding: 40px;
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }

    .accordion-button:not(.collapsed) {
      background-color: #eef2fd;
      color: #4e73df;
      font-weight: 700;
    }

    footer { background-color: #333; color: #aaa; padding: 40px 0; margin-top: 60px; }
  </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-landing shadow-sm">
  <div class="container">
    <a class="navbar-brand" href="<c:url value='/'/>"><i class="fas fa-bolt me-2"></i>Gen-CMS</a>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-center">
        <li class="nav-item"><a class="nav-link" href="<c:url value='/'/>">Trang chủ</a></li>
        <li class="nav-item"><a class="nav-link active fw-bold" href="#">Hỗ trợ</a></li>
        <c:if test="${not empty user}">
          <li class="nav-item ms-lg-3">
            <span class="badge bg-light text-primary p-2 px-3 rounded-pill">Chào, ${user.fullName}</span>
          </li>
        </c:if>
      </ul>
    </div>
  </div>
</nav>

<header class="support-header">
  <div class="container">
    <h1 class="fw-bold">Trung tâm Trợ giúp Gen-CMS</h1>
    <p class="text-muted lead">Mọi thắc mắc của bạn sẽ được giải đáp nhanh chóng</p>
  </div>
</header>

<div class="container my-5">
  <div class="row g-4 mb-5 justify-content-center">
    <div class="col-md-5">
      <div class="support-card text-center">
        <i class="fas fa-phone-alt support-icon"></i>
        <h4 class="fw-bold">Hotline Kỹ thuật</h4>
        <p class="text-muted">Hỗ trợ khẩn cấp 24/7</p>
        <a href="tel:1900123456" class="text-decoration-none"><h3 class="text-primary fw-bold">1900-123-456</h3></a>
      </div>
    </div>
    <div class="col-md-5">
      <div class="support-card text-center">
        <i class="fas fa-envelope-open-text support-icon"></i>
        <h4 class="fw-bold">Gửi Email</h4>
        <p class="text-muted">Gửi phản hồi hoặc yêu cầu tài liệu</p>
        <a href="mailto:support@gen-cms.com" class="text-decoration-none"><h3 class="text-primary fw-bold">support@gen-cms.com</h3></a>
      </div>
    </div>
  </div>

  <div class="row g-5">
    <div class="col-lg-7">
      <div class="contact-form">
        <h3 class="fw-bold mb-4"><i class="fas fa-paper-plane me-2 text-primary"></i>Gửi yêu cầu hỗ trợ</h3>
        <form action="#" method="POST">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label small fw-bold">Họ và tên</label>
              <input type="text" class="form-control border-0 bg-light p-3" placeholder="Nhập họ tên..." required>
            </div>
            <div class="col-md-6">
              <label class="form-label small fw-bold">Email</label>
              <input type="email" class="form-control border-0 bg-light p-3" placeholder="name@example.com" required>
            </div>
            <div class="col-md-12">
              <label class="form-label small fw-bold">Loại vấn đề</label>
              <select class="form-select border-0 bg-light p-3">
                <option>Lỗi tài khoản & Đăng nhập</option>
                <option>Sửa đổi thông tin máy phát điện</option>
                <option>Báo cáo sự cố kỹ thuật</option>
                <option>Góp ý tính năng</option>
                <option>Khác</option>
              </select>
            </div>
            <div class="col-md-12">
              <label class="form-label small fw-bold">Nội dung chi tiết</label>
              <textarea class="form-control border-0 bg-light p-3" rows="5" placeholder="Mô tả vấn đề bạn đang gặp phải..."></textarea>
            </div>
            <div class="col-md-12 mt-4">
              <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">Gửi yêu cầu</button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <div class="col-lg-5">
      <h3 class="fw-bold mb-4"><i class="fas fa-question-circle me-2 text-primary"></i>Câu hỏi thường gặp</h3>
      <div class="accordion accordion-flush" id="faqAccordion">

        <div class="accordion-item border-0 mb-3 shadow-sm rounded">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed rounded" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
              Làm sao để thêm máy phát điện mới?
            </button>
          </h2>
          <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
            <div class="accordion-body text-muted">
              Bạn cần đăng nhập với quyền <strong>Quản trị viên</strong>, vào mục Dashboard và chọn "Thêm thiết bị".
            </div>
          </div>
        </div>

        <div class="accordion-item border-0 mb-3 shadow-sm rounded">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed rounded" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
              Hệ thống có cảnh báo qua điện thoại không?
            </button>
          </h2>
          <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
            <div class="accordion-body text-muted">
              Hiện tại Gen-CMS hỗ trợ gửi cảnh báo tức thì qua Email.
            </div>
          </div>
        </div>

        <div class="accordion-item border-0 mb-3 shadow-sm rounded">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed rounded" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
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
  <div class="container text-center">
    <p class="small mb-0">&copy; 2024 Gen-CMS Corporation. All rights reserved.</p>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>