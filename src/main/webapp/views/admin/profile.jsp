<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <title>Hồ sơ cá nhân</title>

<c:set var="u" value="${myProfile}" />

<div class="container-fluid">
    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card shadow border-0 text-center p-4">
                <div class="mb-3 mx-auto">
                    <c:choose>
                        <c:when test="${u.avatarUrl != null && u.avatarUrl.startsWith('http')}">
                            <img src="${u.avatarUrl}" class="rounded-circle img-thumbnail"
                                 style="width: 150px; height: 150px; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <img src="<c:url value='/${u.avatarUrl}'/>" class="rounded-circle img-thumbnail"
                                 style="width: 150px; height: 150px; object-fit: cover;"
                                 onerror="this.src='https://ui-avatars.com/api/?name=${u.fullName}'">
                        </c:otherwise>
                    </c:choose>
                </div>

                <h4 class="fw-bold mb-0">${u.fullName}</h4>
                <p class="text-muted small">@${u.email.split('@')[0]}</p> <div class="mt-3">
                    <span class="badge bg-primary px-3 py-2 rounded-pill">
                        ${u.roleName != null ? u.roleName : 'N/A'}
                    </span>
                </div>

                <hr>

                <div class="text-start px-3">
                    <div class="mb-3">
                        <small class="text-muted fw-bold text-uppercase"><i class="fas fa-building me-1"></i> Phòng ban</small>
                        <div class="fw-semibold">
                            <c:choose>
                                <c:when test="${u.roleId == 1}">Ban Quản Trị</c:when>
                                <c:when test="${u.roleId == 2}">Kỹ thuật vận hành</c:when>
                                <c:otherwise>Khách hàng thành viên</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div>
                        <small class="text-muted fw-bold text-uppercase"><i class="fas fa-calendar-alt me-1"></i> Ngày tham gia</small>
                        <div class="fw-semibold">
                            <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card shadow border-0">
                <div class="card-header bg-white p-0 border-bottom-0">
                    <ul class="nav nav-tabs px-3 pt-3" id="profileTab" role="tablist">
                        <li class="nav-item">
                            <button class="nav-link active fw-bold" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button">
                                Thông tin chung
                            </button>
                        </li>
                    </ul>
                </div>

                <div class="card-body p-4">
                    <div class="tab-content" id="profileTabContent">
                        <div class="tab-pane fade show active" id="info" role="tabpanel">
                            <h5 class="text-primary mb-4">Thông tin chi tiết</h5>

                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Họ và tên:</label>
                                <div class="col-sm-9">${u.fullName}</div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Email:</label>
                                <div class="col-sm-9">${u.email}</div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Số điện thoại:</label>
                                <div class="col-sm-9">${u.phone != null ? u.phone : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}</div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Vai trò:</label>
                                <div class="col-sm-9 text-success fw-bold">
                                    <i class="fas fa-check-circle me-1"></i> ${u.roleName}
                                </div>
                            </div>

                            <hr class="my-4">

                            <h5 class="text-primary mb-3">Hoạt động gần đây</h5>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item px-0 d-flex justify-content-between align-items-center">
                                    <div><i class="fas fa-sign-in-alt text-info me-2"></i> Đăng nhập hệ thống</div>
                                    <small class="text-muted">Vừa xong</small>
                                </div>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>