<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Đăng nhập hệ thống</title>

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
			margin-bottom: 30px;
		}

		/* --- SỬA LỖI FONT ALERT TẠI ĐÂY --- */
		.alert {
			font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important; /* Buộc dùng font đẹp */
			font-size: 0.95rem;
			border-radius: 15px; /* Bo tròn alert cho hợp với giao diện */
			box-shadow: 0 2px 5px rgba(0,0,0,0.05);
		}

		.form-control {
			height: 50px;
			padding-left: 20px;
			border-radius: 30px;
			background: #f7f7f7;
			border: none;
			font-family: inherit; /* Kế thừa font từ body */
		}

		.form-control:focus {
			background: #fff;
			box-shadow: 0 0 0 2px #84fab0;
			outline: none;
		}

		.btn-login {
			border-radius: 30px;
			padding: 12px;
			font-weight: bold;
			background: linear-gradient(to right, #4facfe 0%, #00f2fe 100%);
			border: none;
			color: white;
			transition: all 0.3s ease;
			font-family: inherit;
		}

		.btn-login:hover {
			transform: translateY(-2px);
			box-shadow: 0 5px 15px rgba(0, 242, 254, 0.4);
			color: white;
		}

		.input-icon-wrapper {
			position: relative;
			margin-bottom: 20px;
		}

		.input-icon-wrapper i {
			position: absolute;
			right: 20px;
			top: 50%;
			transform: translateY(-50%);
			color: #aaa;
			pointer-events: none;
		}

		.forgot-link {
			color: #666;
			text-decoration: none;
			font-size: 0.9rem;
			font-family: inherit;
		}

		.forgot-link:hover {
			color: #4facfe;
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
						<h2 class="form-title">Welcome Back!</h2>
					</div>

					<c:if test="${not empty message}">
						<div class="alert ${alert == 'success' ? 'alert-success' : 'alert-danger'} alert-dismissible fade show d-flex align-items-center" role="alert">
							<i class="${alert == 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle'} me-2"></i>
							<div>
									${message}
							</div>
							<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
						</div>
					</c:if>

					<c:if test="${not empty param.message}">
						<div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
							<i class="fas fa-check-circle me-2"></i>
							<div>
								<c:choose>
									<c:when test="${param.message == 'reset_success'}">Cập nhật mật khẩu thành công!</c:when>
									<c:when test="${param.message == 'token_invalid'}">Link đã hết hạn hoặc không hợp lệ!</c:when>
									<c:otherwise>${param.message}</c:otherwise>
								</c:choose>
							</div>
							<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
						</div>
					</c:if>

					<form method="POST" action="<c:url value='/hanldeLogin'/>" id="login-form">

						<div class="input-icon-wrapper">
							<input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required />
							<i class="fas fa-user"></i>
						</div>

						<div class="input-icon-wrapper">
							<input type="password" name="password" class="form-control" placeholder="Mật khẩu" required />
							<i class="fas fa-lock"></i>
						</div>

						<div class="d-flex justify-content-between align-items-center mb-4">
							<div class="form-check">
								<input type="checkbox" name="remember-me" class="form-check-input" id="remember-me">
								<label class="form-check-label text-muted" for="remember-me" style="font-size: 0.9rem;">Ghi nhớ đăng nhập</label>
							</div>
							<a href="<c:url value='/account/forgot-password'/>" class="forgot-link">Quên mật khẩu?</a>
						</div>

						<div class="d-grid">
							<button type="submit" name="signin" class="btn btn-login btn-block">Đăng Nhập</button>
						</div>

					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>