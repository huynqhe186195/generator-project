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
                    <c:choose>
                        <c:when test="${user.avatarUrl != null && user.avatarUrl.startsWith('http')}">
                            <img src="${user.avatarUrl}" class="rounded-circle img-thumbnail" width="150" height="150" style="object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <img src="<c:url value='/${user.avatarUrl}'/>" class="rounded-circle img-thumbnail" width="150" height="150" style="object-fit: cover;" onerror="this.src='https://via.placeholder.com/150'">
                        </c:otherwise>
                    </c:choose>
                </div>

                <h4 class="mb-1">${user.fullName}</h4>

                <p class="mb-3">
                    <c:choose>
                        <c:when test="${user.roleId == 1}"><span class="badge bg-danger">Quản trị viên (Admin)</span></c:when>
                        <c:when test="${user.roleId == 2}"><span class="badge bg-info text-dark">Nhân viên kỹ thuật</span></c:when>
                        <c:when test="${user.roleId == 3}"><span class="badge bg-secondary">Khách hàng</span></c:when>
                    </c:choose>
                </p>

                <div>
                    <c:if test="${user.status == 1}">
                        <span class="badge bg-success px-3 py-2 rounded-pill"><i class="fas fa-check-circle me-1"></i> Đang hoạt động</span>
                    </c:if>
                    <c:if test="${user.status != 1}">
                        <span class="badge bg-secondary px-3 py-2 rounded-pill"><i class="fas fa-lock me-1"></i> Đã bị khóa</span>
                    </c:if>
                </div>

                <div class="mt-4 d-grid gap-2">
                    <c:if test="${user.roleId != 1}">
                        <button class="btn btn-outline-danger"><i class="fas fa-trash-alt me-2"></i> Xóa tài khoản</button>
                    </c:if>
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
                        <div class="col-sm-9 text-dark">#${user.id}</div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Họ và tên:</label>
                        <div class="col-sm-9 fw-bold">${user.fullName}</div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Email:</label>
                        <div class="col-sm-9"><a href="mailto:${user.email}" class="text-decoration-none">${user.email}</a></div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Số điện thoại:</label>
                        <div class="col-sm-9">${user.phone}</div>
                    </div>
                    <hr class="my-2">

                    <div class="row mb-3">
                        <label class="col-sm-3 fw-bold text-secondary">Ngày tạo:</label>
                        <div class="col-sm-9">${user.createdAt}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>