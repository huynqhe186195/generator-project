<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background-color: #f8f9fa; }
        .profile-card { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .profile-img { width: 140px; height: 140px; border-radius: 50%; object-fit: cover; border: 5px solid #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .nav-pills .nav-link.active { background-color: #4e73df; }
        .nav-pills .nav-link { color: #5a5c69; font-weight: 500; }
        .form-control:focus { border-color: #4e73df; box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25); }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-lg-4 mb-4">
            <div class="card profile-card text-center p-4 bg-white">
                <div class="mb-3">
                    <img src="https://bootdey.com/img/Content/avatar/avatar7.png" alt="Avatar" class="profile-img">
                </div>
                <h4 class="mb-1">${fullName}</h4>
                <p class="text-muted mb-2">@${username}</p>
                <span class="badge bg-primary px-3 py-2 rounded-pill">${role}</span>

                <div class="mt-4 text-start">
                    <p class="small text-muted mb-1"><i class="fas fa-building me-2"></i>Phòng ban</p>
                    <h6>${department}</h6>
                    <hr>
                    <p class="small text-muted mb-1"><i class="fas fa-calendar-alt me-2"></i>Ngày tham gia</p>
                    <h6>${joinDate}</h6>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card profile-card bg-white">
                <div class="card-header bg-white border-bottom-0 pt-4 px-4">
                    <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
                        <li class="nav-item">
                            <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#info">Thông tin chung</button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="pill" data-bs-target="#edit">Chỉnh sửa hồ sơ</button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="pill" data-bs-target="#password">Đổi mật khẩu</button>
                        </li>
                    </ul>
                </div>

                <div class="card-body px-4 pb-4">
                    <div class="tab-content" id="pills-tabContent">

                        <div class="tab-pane fade show active" id="info">
                            <h5 class="mb-4 text-primary">Thông tin chi tiết</h5>
                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Họ và tên:</label>
                                <div class="col-sm-9">${fullName}</div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Email:</label>
                                <div class="col-sm-9">${email}</div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Số điện thoại:</label>
                                <div class="col-sm-9">${phone}</div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 fw-bold text-secondary">Vai trò:</label>
                                <div class="col-sm-9 text-success"><i class="fas fa-check-circle"></i> Quản trị hệ thống máy phát</div>
                            </div>

                            <h5 class="mt-5 mb-3 text-primary">Hoạt động gần đây</h5>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item px-0">
                                    <small class="text-muted float-end">Vừa xong</small>
                                    <i class="fas fa-edit text-info me-2"></i> Cập nhật trạng thái máy <strong>GEN-001</strong>
                                </div>
                                <div class="list-group-item px-0">
                                    <small class="text-muted float-end">2 giờ trước</small>
                                    <i class="fas fa-plus-circle text-success me-2"></i> Thêm mới máy phát <strong>Honda EU22i</strong>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="edit">
                            <form>
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" value="${fullName}">
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Email</label>
                                        <input type="email" class="form-control" value="${email}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Số điện thoại</label>
                                        <input type="text" class="form-control" value="${phone}">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <input type="text" class="form-control" placeholder="Nhập địa chỉ của bạn...">
                                </div>
                                <button type="button" class="btn btn-primary"><i class="fas fa-save"></i> Lưu thay đổi</button>
                            </form>
                        </div>

                        <div class="tab-pane fade" id="password">
                            <form>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu hiện tại</label>
                                    <input type="password" class="form-control">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu mới</label>
                                    <input type="password" class="form-control">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Xác nhận mật khẩu mới</label>
                                    <input type="password" class="form-control">
                                </div>
                                <button type="button" class="btn btn-warning text-white"><i class="fas fa-key"></i> Đổi mật khẩu</button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>