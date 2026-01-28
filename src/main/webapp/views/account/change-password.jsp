<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .navbar-custom { background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); padding: 15px 0; }
        .navbar-brand { font-weight: 800; font-size: 1.5rem; color: #fff !important; }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }
        .card-custom { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>"><i class="fas fa-bolt me-2"></i>Gen-CMS</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="<c:url value='/home'/>">Trang chủ</a></li>
                <li class="nav-item ms-3">
                    <span class="text-white fw-bold"><i class="fas fa-user-circle me-1"></i> ${user.fullName}</span>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">

            <div class="card card-custom p-4">
                <div class="card-body">
                    <h3 class="text-center fw-bold text-primary mb-4">Đổi mật khẩu</h3>

                    <c:if test="${not empty mess}">
                        <div class="alert alert-${alert} alert-dismissible fade show" role="alert">
                            <i class="fas ${alert == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} me-2"></i>
                            <strong>${mess}</strong>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="<c:url value='/hanldeChangePassword'/>" method="POST">

                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary">Mật khẩu hiện tại</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-lock"></i></span>
                                <input type="password" name="oldPassword" class="form-control" required placeholder="Nhập mật khẩu cũ">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary">Mật khẩu mới</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-key"></i></span>
                                <input type="password" name="newPassword" class="form-control" required placeholder="Nhập mật khẩu mới">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-secondary">Nhập lại mật khẩu mới</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-check-circle"></i></span>
                                <input type="password" name="confirmPassword" class="form-control" required placeholder="Xác nhận mật khẩu">
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-bold shadow-sm">
                                Lưu thay đổi
                            </button>

                            <a href="<c:url value='/home'/>" class="btn btn-outline-secondary rounded-pill">
                                Hủy bỏ
                            </a>
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