<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quên mật khẩu - Generator CMS</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    body {
      background: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .login-card {
      border: none;
      border-radius: 20px;
      box-shadow: 0 15px 35px rgba(0,0,0,0.1);
      background: white;
      width: 100%;
    }

    .form-side {
      padding: 40px 40px;
    }

    .form-title {
      font-weight: 700;
      color: #333;
      margin-bottom: 10px;
    }

    .form-subtitle {
      font-size: 0.9rem;
      color: #6c757d;
      margin-bottom: 30px;
    }

    .form-control {
      height: 50px;
      padding-left: 20px;
      border-radius: 30px;
      background: #f7f7f7;
      border: none;
    }

    .form-control:focus {
      background: #fff;
      box-shadow: 0 0 0 2px #84fab0;
      outline: none;
    }

    .btn-submit {
      border-radius: 30px;
      padding: 12px;
      font-weight: bold;
      background: linear-gradient(to right, #4facfe 0%, #00f2fe 100%);
      border: none;
      color: white;
      transition: all 0.3s ease;
    }

    .btn-submit:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(0, 242, 254, 0.4);
      color: white;
    }

    .input-icon-wrapper {
      position: relative;
      margin-bottom: 25px;
    }

    .input-icon-wrapper i {
      position: absolute;
      right: 20px;
      top: 50%;
      transform: translateY(-50%);
      color: #aaa;
      pointer-events: none;
    }

    .back-link {
      display: block;
      margin-top: 20px;
      color: #666;
      text-decoration: none;
      font-size: 0.9rem;
      transition: color 0.3s;
    }

    .back-link:hover {
      color: #4facfe;
      text-decoration: none;
    }
  </style>
</head>
<body>

<div class="container">
  <div class="row justify-content-center">
    <div class="col-xl-4 col-lg-5 col-md-7 col-sm-10">
      <div class="card login-card">
        <div class="form-side">
          <div class="text-center">
            <h2 class="form-title">Quên mật khẩu?</h2>
            <p class="form-subtitle">Nhập email của bạn để nhận liên kết đặt lại mật khẩu.</p>
          </div>

          <c:if test="${not empty message}">
            <div class="alert ${alert == 'success' ? 'alert-success' : 'alert-danger'} alert-dismissible fade show" role="alert">
                ${message}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
          </c:if>

          <form method="POST" action="<c:url value='/handleForgotPassword'/>" id="forgot-form">

            <div class="input-icon-wrapper">
              <input type="email" name="email" id="email" class="form-control" placeholder="Email của bạn" required />
              <i class="fas fa-envelope"></i>
            </div>

            <div class="d-grid">
              <button type="submit" name="submit" class="btn btn-submit btn-block">Gửi yêu cầu</button>
            </div>

          </form>

          <div class="text-center">
            <a href="<c:url value='/account/login'/>" class="back-link">
              <i class="fas fa-arrow-left me-1"></i> Quay lại Đăng nhập
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>