<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<title>Sign Up</title>

	<link rel="stylesheet" href="<c:url value='/template/account/fonts/material-icon/css/material-design-iconic-font.min.css'/>">
	<link rel="stylesheet" href="<c:url value='/template/account/css/login-style.css'/>">
</head>
<body>

<div class="main">
	<section class="sign-in">
		<div class="container">
			<div class="signin-content">
				<div class="signin-image">
					<figure>
						<img src="<c:url value='/template/images/signin-image.jpg'/>" alt="sing up image">
					</figure>

				</div>

				<div class="signin-form">
					<h2 class="form-title">Sign In</h2>

					<c:if test="${not empty message}">
						<div style="color: ${alert == 'success' ? '#28a745' : '#dc3545'};
								margin-bottom: 15px; font-size: 14px; font-weight: bold;">
								${message}
						</div>
					</c:if>

					<c:if test="${not empty param.message}">
						<div style="color: #28a745; margin-bottom: 15px; font-size: 14px; font-weight: bold;">
							<c:choose>
								<c:when test="${param.message == 'reset_success'}">Cập nhật mật khẩu thành công!</c:when>
								<c:when test="${param.message == 'token_invalid'}">Link đã hết hạn hoặc không hợp lệ!</c:when>
							</c:choose>
						</div>
					</c:if>
					<form method="POST" action="<c:url value='/hanldeLogin'/>" class="register-form" id="login-form">
					<div class="form-group">
						<label for="username"><i class="zmdi zmdi-account material-icons-name"></i></label>
						<input type="text" name="username" id="username" placeholder="Your Name" />
					</div>
					<div class="form-group">
						<label for="password"><i class="zmdi zmdi-lock"></i></label>
						<input type="password" name="password" id="password" placeholder="Password" />
					</div>
					<div class="form-group">
						<input type="checkbox" name="remember-me" id="remember-me" class="agree-term" />
						<a href="<c:url value='/forgot-password'/>" class="signup-image-link">Forgot password!</a>
					</div>
					<div class="form-group form-button">
						<input type="submit" name="signin" id="signin" class="form-submit" value="Log in" />
					</div>
				</form>


				</div>
			</div>
		</div>
	</section>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="<c:url value='/template/account/js/main.js'/>"></script>
</body>
</html>