<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>

<c:set var="u" value="${myProfile}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }

        .navbar-custom { background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); padding: 15px 0; }
        .navbar-brand { font-weight: 800; font-size: 1.5rem; color: #fff !important; }
        .nav-link { color: rgba(255,255,255,0.9) !important; font-weight: 500; }

        .profile-header { background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); overflow: hidden; }
        .profile-cover { height: 150px; background: linear-gradient(to right, #4e73df, #224abe); }
        .profile-avatar-container { margin-top: -75px; text-align: center; }
        .profile-avatar { width: 150px; height: 150px; border: 5px solid white; border-radius: 50%; object-fit: cover; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }

        .form-control:focus { box-shadow: none; border-color: #4e73df; }
        .btn-primary-custom { background-color: #4e73df; border: none; padding: 10px 30px; border-radius: 50px; font-weight: 600; }
        .btn-primary-custom:hover { background-color: #224abe; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/home'/>"><i class="fas fa-bolt me-2"></i>Gen-CMS</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="<c:url value='/home'/>">Trang chủ</a></li>
                <li class="nav-item ms-3">
                    <span class="text-white fw-bold"><i class="fas fa-user-circle me-1"></i> ${u.fullName}</span>
                    <a href="<c:url value='/account/logout'/>" class="btn btn-sm btn-light text-danger fw-bold ms-2 rounded-pill px-3">Thoát</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <div class="profile-header mb-4">
                <div class="profile-cover"></div>
                <div class="profile-body p-4">
                    <div class="profile-avatar-container">
                        <c:choose>
                            <c:when test="${u.avatarUrl != null && u.avatarUrl.startsWith('http')}">
                                <img id="avatarPreview" src="${u.avatarUrl}" class="profile-avatar">
                            </c:when>
                            <c:otherwise>
                                <img id="avatarPreview"
                                     src="<c:url value='/${u.avatarUrl}'/>"
                                     class="profile-avatar"
                                     onerror="this.src='https://ui-avatars.com/api/?name=${u.fullName}&background=random'">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="text-center mt-3">
                        <h3 class="fw-bold mb-1">${u.fullName}</h3>
                        <p class="text-muted mb-2">@${u.email.split('@')[0]}</p>
                        <span class="badge bg-primary px-3 py-2 rounded-pill">
                            ${u.roleName != null ? u.roleName : 'Khách hàng'}
                        </span>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4 p-md-5">
                    <h4 class="fw-bold mb-4 text-secondary"><i class="fas fa-edit me-2"></i>Thông tin cá nhân</h4>

                    <!-- Thông báo lỗi -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- Thông báo thành công (nếu redirect về ?success=1) -->
                    <c:if test="${param.success == '1'}">
                        <div class="alert alert-success">Cập nhật hồ sơ thành công!</div>
                    </c:if>

                    <!-- ✅ POST về đúng controller /account/* (path: /user-profile) -->
                    <form action="${pageContext.request.contextPath}/account/user-profile"
                          method="POST" enctype="multipart/form-data">
                        <div class="row g-3">

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Họ và tên</label>
                                <input name="fullName" type="text" class="form-control"
                                       value="${u.fullName}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Số điện thoại</label>
                                <input name="phone" type="text" class="form-control"
                                       value="${u.phone != null ? u.phone : ''}" placeholder="Chưa cập nhật">
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-bold">Email (Tên đăng nhập)</label>
                                <input type="email" class="form-control bg-light" value="${u.email}" readonly>
                                <small class="text-muted fst-italic">* Email không thể thay đổi</small>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-bold">Avatar</label>
                                <input id="avatarInput" name="avatar" type="file" class="form-control" accept="image/*">
                                <small class="text-muted fst-italic">* Nếu không chọn ảnh mới thì giữ avatar cũ</small>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Ngày tham gia</label>
                                <input type="text" class="form-control bg-light"
                                       value="<fmt:formatDate value='${u.createdAt}' pattern='dd/MM/yyyy' />" readonly>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Trạng thái</label>
                                <input type="text" class="form-control bg-light text-success fw-bold"
                                       value="Đang hoạt động" readonly>
                            </div>

                        </div>

                        <div class="mt-4 d-flex justify-content-between">
                            <a href="<c:url value='/home'/>" class="btn btn-outline-secondary rounded-pill px-4">
                                <i class="fas fa-arrow-left me-2"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary-custom text-white px-4 shadow-sm">
                                <i class="fas fa-save me-2"></i> Lưu thay đổi
                            </button>
                        </div>
                    </form>

                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Preview avatar ngay khi chọn file -->
<script>
    const avatarInput = document.getElementById('avatarInput');
    const avatarPreview = document.getElementById('avatarPreview');

    if (avatarInput && avatarPreview) {
        avatarInput.addEventListener('change', function () {
            const file = this.files && this.files[0];
            if (!file) return;
            avatarPreview.src = URL.createObjectURL(file);
        });
    }
</script>

</body>
</html>