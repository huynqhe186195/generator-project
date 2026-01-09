<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .card-stat { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); color: white; }
        .bg-primary-gradient { background: linear-gradient(45deg, #4e73df, #224abe); }
        .bg-success-gradient { background: linear-gradient(45deg, #1cc88a, #13855c); }
        .bg-warning-gradient { background: linear-gradient(45deg, #f6c23e, #dda20a); }
        .bg-danger-gradient { background: linear-gradient(45deg, #e74a3b, #be2617); }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#"><i class="fas fa-bolt text-warning"></i> Gen-CMS</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link active" href="#">Trang chủ</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Danh sách máy</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Báo cáo</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value='/profile'/>">Admin: <strong>${userInfo.fullName}</strong></a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4 text-secondary">${title}</h2>

    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card card-stat bg-primary-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Tổng số máy</h6>
                        <h2 class="mb-0">${total}</h2>
                    </div>
                    <i class="fas fa-server fa-2x opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat bg-success-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Đang hoạt động</h6>
                        <h2 class="mb-0">${running}</h2>
                    </div>
                    <i class="fas fa-check-circle fa-2x opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat bg-warning-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Đang bảo trì</h6>
                        <h2 class="mb-0">${maintenance}</h2>
                    </div>
                    <i class="fas fa-tools fa-2x opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat bg-danger-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Cảnh báo lỗi</h6>
                        <h2 class="mb-0">${error}</h2>
                    </div>
                    <i class="fas fa-exclamation-triangle fa-2x opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow">
        <div class="card-header py-3 d-flex justify-content-between align-items-center bg-white">
            <h6 class="m-0 font-weight-bold text-primary">Danh sách máy phát điện gần đây</h6>
            <button class="btn btn-sm btn-primary"><i class="fas fa-plus"></i> Thêm máy mới</button>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                    <thead class="table-light">
                        <tr>
                            <th>Mã Máy</th>
                            <th>Tên Máy</th>
                            <th>Công Suất (kVA)</th>
                            <th>Vị Trí</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>GEN-001</td>
                            <td>Honda EU2200i</td>
                            <td>2.2</td>
                            <td>Kho A - Tầng 1</td>
                            <td><span class="badge bg-success">Đang chạy</span></td>
                            <td>
                                <button class="btn btn-sm btn-info text-white"><i class="fas fa-eye"></i></button>
                                <button class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>GEN-002</td>
                            <td>Cummins C20D6</td>
                            <td>20</td>
                            <td>Nhà máy B</td>
                            <td><span class="badge bg-warning text-dark">Bảo trì</span></td>
                            <td>
                                <button class="btn btn-sm btn-info text-white"><i class="fas fa-eye"></i></button>
                                <button class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>GEN-003</td>
                            <td>Yamaha EF2000</td>
                            <td>2.0</td>
                            <td>Sân thượng</td>
                            <td><span class="badge bg-danger">Lỗi kết nối</span></td>
                            <td>
                                <button class="btn btn-sm btn-info text-white"><i class="fas fa-eye"></i></button>
                                <button class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<footer class="sticky-footer bg-white mt-5 py-3 text-center shadow-sm">
    <div class="container my-auto">
        <span class="text-muted">Copyright &copy; CMS Máy Phát Điện - Huy 2026</span>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>