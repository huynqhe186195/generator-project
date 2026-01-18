<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quên mật khẩu - Generator CMS</title>

  <link rel="stylesheet" href="<c:url value='/template/account/fonts/material-icon/css/material-design-iconic-font.min.css'/>">
  <link rel="stylesheet" href="<c:url value='/template/account/css/login-style.css'/>">
</head>
<body>

<div class="main">
  <section class="sign-in">
    <div class="container">
      <div class="signin-content no-image">

        <div class="signin-form">
          <h2 class="form-title">Quên mật khẩu</h2>

          <p class="text-center" style="margin-bottom: 20px; font-size: 14px; color: #666;">
            Nhập email của bạn để nhận liên kết đặt lại mật khẩu.
          </p>

          <c:if test="${not empty message}">
            <div class="text-center" style="color: ${alert == 'success' ? 'green' : 'red'}; margin-bottom: 15px; font-size: 14px; font-weight: bold;">
                ${message}
            </div>
          </c:if>

          <form method="POST" action="<c:url value='/handleForgotPassword'/>" class="register-form" id="forgot-form">
            <div class="form-group">
              <label for="email"><i class="zmdi zmdi-email"></i></label>
              <input type="email" name="email" id="email" placeholder="Email của bạn" required/>
            </div>

            <div class="form-group form-button text-center">
              <input type="submit" name="submit" id="submit" class="form-submit" value="Gửi yêu cầu"/>
            </div>
          </form>

          <a href="<c:url value='/account/login'/>" class="back-link">
            <i class="zmdi zmdi-arrow-left"></i> Quay lại Đăng nhập
          </a>
        </div>
      </div>
    </div>
  </section>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="<c:url value='/template/account/js/main.js'/>"></script>
</body>
</html>