<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Chi tiết người dùng</title>

<div class="container-fluid">
    <div class="mb-3">
        <a href="<c:url value='/admin/user-list'/>" class="text-decoration-none text-secondary">
            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card shadow border-0 text-center p-4 h-100">
                <div class="mb-3">
                    <img src="${avatarUrl}" class="rounded-circle img-thumbnail" width="150" height="150" alt="Avatar">
                </div>
                <h4 class="mb-1">${fullName}</h4>
                <p class="text-muted mb-3">${roleName}</p>

                <div>
                    <c:if test="${status == 1}">
                        <span class="badge bg-success px-3 py-2 rounded-pill">Đang hoạt động</span>
                    </c:if>
                    <c:if test="${status != 1}">
                        <span class="badge bg-danger px-3 py-2 rounded-pill">Đã bị khóa</span>
                    </c:if>
                </div>

                <div class="mt-4 d-grid gap-2">
                    <button class="btn btn-primary"><i class="fas fa-edit"></i> Chỉnh sửa thông tin</button>
                    <button class="btn btn-outline-danger"><i class="fas fa-key"></i> Đặt lại mật khẩu</button>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card shadow border-0 h-100">
                <div class="card-header bg-white py-3">
                    <h5 class="m-0 font-weight-bold text-primary">Thông tin hồ sơ</h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">ID Người dùng:</label>
                        <div class="col-sm-9 text-dark">#${userId}</div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Họ và tên:</label>
                        <div class="col-sm-9 fw-bold">${fullName}</div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Email:</label>
                        <div class="col-sm-9"><a href="mailto:${email}">${email}</a></div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Số điện thoại:</label>
                        <div class="col-sm-9">${phone}</div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Ngày tạo:</label>
                        <div class="col-sm-9">${createdAt}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>