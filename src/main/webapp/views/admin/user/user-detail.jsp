<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Chi tiết người dùng</title>

<div class="container-fluid">

    <!-- Back + Edit -->
    <div class="d-flex align-items-center justify-content-between mb-3">
        <a href="<c:url value='/admin/user/user-list'/>"
           class="text-decoration-none text-secondary">
            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
        </a>

        <a class="btn btn-outline-primary btn-sm"
           href="<c:url value='/admin/user/updateUser?id=${user.id}'/>">
            <i class="fas fa-pen me-1"></i> Chỉnh sửa
        </a>
    </div>

    <div class="row g-4">

        <!-- LEFT: Profile Card -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body text-center p-4">

                    <!-- Avatar -->
                    <div class="mb-3">
                        <c:choose>
                            <c:when test="${user.avatarUrl != null && fn:startsWith(user.avatarUrl,'http')}">
                                <img src="${user.avatarUrl}"
                                     class="rounded-circle img-thumbnail"
                                     width="140" height="140"
                                     style="object-fit:cover;"
                                     alt="${user.fullName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${user.avatarUrl}"
                                     class="rounded-circle img-thumbnail"
                                     width="140" height="140"
                                     style="object-fit:cover;"
                                     alt="${user.fullName}"
                                     onerror="this.src='https://ui-avatars.com/api/?name=${fn:escapeXml(user.fullName)}&background=0D6EFD&color=fff&size=140'">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Name -->
                    <h4 class="mb-1">${user.fullName}</h4>
                    <div class="text-muted small mb-3">
                        ID: <span class="fw-semibold">#${user.id}</span>
                    </div>

                    <!-- Role Badge -->
                    <div class="mb-3">
                        <c:choose>
                            <c:when test="${user.roleId == 1}">
                                <span class="badge bg-danger px-3 py-2">
                                    <i class="fas fa-shield-alt me-1"></i> Quản trị viên
                                </span>
                            </c:when>
                            <c:when test="${user.roleId == 2}">
                                <span class="badge bg-info text-dark px-3 py-2">
                                    <i class="fas fa-user-tie me-1"></i> Quản lý
                                </span>
                            </c:when>
                            <c:when test="${user.roleId == 5}">
                                <span class="badge bg-secondary px-3 py-2">
                                    <i class="fas fa-user-tag me-1"></i> Khách hàng
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-light text-dark px-3 py-2">
                                    Người dùng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Status -->
                    <div class="mb-4">
                        <c:choose>
                            <c:when test="${user.status == 1}">
                                <span class="badge bg-success px-3 py-2 rounded-pill">
                                    <i class="fas fa-check-circle me-1"></i> Active
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-dark px-3 py-2 rounded-pill">
                                    <i class="fas fa-lock me-1"></i> Deactive
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Actions: ONLY DELETE -->
                    <div class="d-grid gap-2">

                        <!-- Delete only if not Admin -->
                        <c:if test="${canDelete && user.roleId != 1}">
                            <a class="btn btn-outline-danger"
                               href="<c:url value='/admin/user/deleteUser?id=${user.id}'/>"
                               onclick="return confirm('CẢNH BÁO: Không thể hoàn tác!\nBạn chắc chắn muốn xóa ${user.fullName} không?');">
                                <i class="fas fa-trash-alt me-2"></i> Xóa tài khoản
                            </a>
                        </c:if>

                        <!-- Admin warning -->
                        <c:if test="${user.roleId == 1}">
                            <div class="alert alert-warning py-2 mb-0 small text-start">
                                <i class="fas fa-info-circle me-1"></i>
                                Tài khoản <b>Admin</b> không được phép xóa trên giao diện.
                            </div>
                        </c:if>

                    </div>

                </div>
            </div>
        </div>

        <!-- RIGHT: Detail Info -->
        <div class="col-lg-8">
            <div class="card shadow-sm border-0 h-100">

                <div class="card-header bg-white py-3 d-flex justify-content-between">
                    <h5 class="m-0 text-primary fw-bold">
                        <i class="fas fa-id-card me-2"></i> Thông tin hồ sơ
                    </h5>
                    <span class="text-muted small">
                        Tạo lúc: <b>${user.createdAt}</b>
                    </span>
                </div>

                <div class="card-body p-4">
                    <div class="row g-3">

                        <!-- FullName -->
                        <div class="col-md-6">
                            <div class="p-3 rounded border bg-light">
                                <div class="text-muted small">Họ và tên</div>
                                <div class="fw-bold fs-5">${user.fullName}</div>
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="col-md-6">
                            <div class="p-3 rounded border bg-light">
                                <div class="text-muted small">Email</div>
                                <div class="fw-semibold">
                                    <i class="fas fa-envelope me-1"></i>
                                    ${user.email}
                                </div>
                            </div>
                        </div>

                        <!-- Phone -->
                        <div class="col-md-6">
                            <div class="p-3 rounded border bg-light">
                                <div class="text-muted small">Số điện thoại</div>
                                <div class="fw-semibold">
                                    <c:choose>
                                        <c:when test="${user.phone != null && user.phone != ''}">
                                            <i class="fas fa-phone me-1"></i> ${user.phone}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Status -->
                        <div class="col-md-6">
                            <div class="p-3 rounded border bg-light">
                                <div class="text-muted small">Trạng thái</div>
                                <div class="fw-semibold">
                                    <c:choose>
                                        <c:when test="${user.status == 1}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-dark">Deactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>

    </div>
</div>
