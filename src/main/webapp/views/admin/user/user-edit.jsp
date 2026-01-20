<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Chỉnh sửa thông tin</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Chỉnh sửa người dùng: #${user.id}</h3>
        <a href="<c:url value='/admin/user/user-list'/>" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i> Quay lại
        </a>
    </div>

    <form action="<c:url value='/admin/user-list/handleEditUser'/>" method="post" enctype="multipart/form-data">

        <input type="hidden" name="id" value="${user.id}">
        <input type="hidden" name="currentAvatar" value="${user.avatarUrl}">

        <div class="row">
            <div class="col-md-8">
                <div class="card shadow mb-4 border-0">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Thông tin chung</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và tên</label>
                            <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email (Không thể sửa)</label>
                                <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control" value="${user.phone}">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Vai trò</label>
                                <select class="form-select" name="roleId">
                                    <c:forEach items="${listRoles}" var="role">
                                        <option value="${role.id}" ${user.roleId == role.id ? 'selected' : ''}>
                                            ${role.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Trạng thái</label>
                                <select class="form-select" name="status">
                                    <option value="1" ${user.status == 1 ? 'selected' : ''}>Đang hoạt động</option>
                                    <option value="0" ${user.status == 0 ? 'selected' : ''}>Đã khóa</option>
                                </select>
                            </div>
                        </div>
                        </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow mb-4 border-0">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Ảnh đại diện</h6>
                    </div>
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${user.avatarUrl != null && user.avatarUrl.startsWith('http')}">
                                    <img id="avatarPreview" src="${user.avatarUrl}" class="rounded-circle img-thumbnail" style="width: 150px; height: 150px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img id="avatarPreview"
                                         src="<c:url value='/${user.avatarUrl}'/>"
                                         class="rounded-circle img-thumbnail"
                                         style="width: 150px; height: 150px; object-fit: cover;"
                                         onerror="this.src='https://via.placeholder.com/150'">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-start w-100 fw-bold">Đổi ảnh mới (Tùy chọn)</label>
                            <input type="file" name="avatarFile" id="avatarInput" class="form-control" accept="image/*">
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 btn-lg">
                    <i class="fas fa-save me-2"></i> Lưu thay đổi
                </button>
            </div>
        </div>
    </form>
</div>

<script>
    // Script xem trước ảnh khi chọn file
    document.getElementById('avatarInput').addEventListener('change', function(e) {
        if (e.target.files && e.target.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatarPreview').src = e.target.result;
            }
            reader.readAsDataURL(e.target.files[0]);
        }
    });
</script>