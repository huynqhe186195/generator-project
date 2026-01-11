<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Thêm người dùng mới</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Thêm người dùng mới</h3>
        <a href="<c:url value='/admin/user-list'/>" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i> Quay lại danh sách
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i> <strong>Lỗi:</strong> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <form action="<c:url value='/admin/user-list/user-add'/>" method="post" enctype="multipart/form-data">
        <div class="row">

            <div class="col-md-8">
                <div class="card shadow mb-4 border-0">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-user-lock me-2"></i>Thông tin tài khoản</h6>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="form-control" value="${oldFullName}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control" value="${oldPhone}" placeholder="VD: 0901234567">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control" value="${oldEmail}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" name="password" class="form-control" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Vai trò</label>
                                <select class="form-select" name="roleId">
                                    <option value="2">Nhân viên kỹ thuật</option>
                                    <option value="3">Khách hàng</option>
                                    <option value="1">Admin</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Trạng thái</label>
                                <select class="form-select" name="status">
                                    <option value="1">Active</option>
                                    <option value="0">Locked</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow mb-4 border-0">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-image me-2"></i>Ảnh đại diện</h6>
                    </div>
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <img id="avatarPreview" src="https://via.placeholder.com/150" class="rounded-circle img-thumbnail" style="width: 150px; height: 150px; object-fit: cover;">
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-start w-100 fw-bold">Chọn ảnh từ máy</label>
                            <input type="file" name="avatarFile" id="avatarInput" class="form-control" accept="image/*">
                            <small class="text-muted">Chấp nhận: .jpg, .png, .jpeg</small>
                        </div>
                    </div>
                </div>

                <div class="card shadow border-0">
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i> Lưu người dùng
                            </button>
                            <a href="<c:url value='/admin/user-list'/>" class="btn btn-secondary">Hủy bỏ</a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </form>
</div>

<script>
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