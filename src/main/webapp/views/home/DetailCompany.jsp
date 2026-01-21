<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sơ lược hệ thống | Gen-CMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    :root {
      --primary-color: #4e73df;
      --secondary-color: #224abe;
    }
    body { font-family: 'Segoe UI', sans-serif; background-color: #f8f9fa; color: #333; }

    .about-header {
      background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
      color: white;
      padding: 100px 0 60px;
      text-align: center;
      clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
    }

    .section-title { position: relative; padding-bottom: 15px; margin-bottom: 30px; font-weight: 700; }
    .section-title::after {
      content: '';
      position: absolute;
      left: 0;
      bottom: 0;
      width: 50px;
      height: 3px;
      background-color: var(--primary-color);
    }
    .text-center .section-title::after { left: 50%; transform: translateX(-50%); }

    .info-card {
      background: white;
      border: none;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
      height: 100%;
      transition: 0.3s;
    }
    .info-card:hover { transform: translateY(-5px); }

    .entity-icon {
      width: 60px;
      height: 60px;
      background: #eef2fd;
      color: var(--primary-color);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      margin: 0 auto 20px;
    }

    .system-highlight {
      border-left: 5px solid var(--primary-color);
      background: #fff;
      padding: 25px;
      border-radius: 0 15px 15px 0;
      box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }

    .btn-back {
      background-color: white;
      color: var(--primary-color);
      border: 2px solid white;
      font-weight: 600;
      padding: 10px 25px;
      border-radius: 50px;
      transition: 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn-back:hover {
      background-color: transparent;
      color: white;
    }

    footer { background: #333; color: #aaa; padding: 30px 0; margin-top: 60px; }
  </style>
</head>
<body>

<header class="about-header">
  <div class="container">
    <h1 class="display-4 fw-bold">Về Hệ Thống GMS</h1>
    <p class="lead opacity-75">Giải pháp quản trị máy phát điện kỷ nguyên số</p>
    <div class="mt-4">
      <a href="<c:url value='/home'/>" class="btn btn-primary">
        <i class="fas fa-arrow-left me-2"></i>Quay lại Trang chủ
      </a>
    </div>
  </div>
</header>

<main class="container my-5">
  <section class="row align-items-center mb-5">
    <div class="col-lg-6">
      <h2 class="section-title">Tổng quan hệ thống</h2>
      <p><strong>Generator Management System (GMS)</strong> là một ứng dụng web tiên tiến được phát triển nhằm tối ưu hóa quy trình quản lý thông tin và bảo trì máy phát điện. Hệ thống ra đời nhằm thay thế hoàn toàn các phương thức truyền thống như ghi chép sổ sách thủ công hay lưu trữ rời rạc.</p>
      <div class="system-highlight mt-4">
        <h5 class="fw-bold text-primary"><i class="fas fa-bullseye me-2"></i>Mục tiêu chính</h5>
        <p class="mb-0">Xây dựng nền tảng quản lý tập trung, giúp người dùng theo dõi dữ liệu thiết bị, lịch bảo trì, báo cáo sự cố và hồ sơ vận hành một cách chính xác, nhanh chóng và hiệu quả nhất.</p>
      </div>
    </div>
    <div class="col-lg-6 text-center mt-4 mt-lg-0">
      <img src="https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&w=600&q=80" alt="GMS System" class="img-fluid rounded-4 shadow-lg">
    </div>
  </section>

  <section class="mb-5">
    <div class="text-center mb-5">
      <h2 class="section-title">Các bên tương tác</h2>
      <p class="text-muted">Hệ thống kết nối các vai trò quan trọng trong quy trình vận hành</p>
    </div>
    <div class="row g-4">
      <div class="col-md-3">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-user-shield"></i></div>
          <h5 class="fw-bold">Quản trị viên</h5>
          <p class="small text-muted">Quản lý tài khoản, danh mục máy phát và cấu hình toàn bộ hệ thống.</p>
        </div>
      </div>
      <div class="col-md-3">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-tools"></i></div>
          <h5 class="fw-bold">Kỹ thuật viên</h5>
          <p class="small text-muted">Cập nhật thông tin bảo trì, tạo báo cáo sự cố và theo dõi lịch sử sửa chữa.</p>
        </div>
      </div>
      <div class="col-md-3">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-chart-line"></i></div>
          <h5 class="fw-bold">Người quản lý</h5>
          <p class="small text-muted">Giám sát trạng thái tổng thể và xem các báo cáo phân tích vận hành.</p>
        </div>
      </div>
      <div class="col-md-3">
        <div class="info-card text-center">
          <div class="entity-icon"><i class="fas fa-server"></i></div>
          <h5 class="fw-bold">Hệ thống Dữ liệu</h5>
          <p class="small text-muted">Lưu trữ tập trung mọi dữ liệu về thiết bị, người dùng và lịch sử hoạt động.</p>
        </div>
      </div>
    </div>
  </section>

  <section class="bg-white p-5 rounded-4 shadow-sm border">
    <div class="row justify-content-center text-center">
      <div class="col-lg-10">
        <h2 class="section-title">Nguyên lý Hoạt động</h2>
        <p class="lead">Dữ liệu được luân chuyển thông qua việc nhập liệu, cập nhật và truy xuất trực tiếp từ người dùng trên giao diện web.</p>
        <div class="alert alert-warning border-0 py-3 mt-4">
          <i class="fas fa-exclamation-triangle me-2"></i>
          <strong>Lưu ý kỹ thuật:</strong> Hệ thống đóng vai trò là công cụ quản lý và lưu trữ dữ liệu thông minh. GMS <strong>không</strong> can thiệp hoặc kết nối trực tiếp vào phần cứng vật lý của máy phát điện.
        </div>
        <div class="mt-5">

        </div>
      </div>
    </div>
  </section>
</main>

<footer class="text-center">
  <div class="container">
    <p class="mb-0">&copy; 2024 Gen-CMS Corporation. Bảo lưu mọi quyền.</p>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>