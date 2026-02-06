<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* CSS tùy chỉnh cho các thẻ Card đẹp hơn */
        .card-box {
            border: none;
            border-radius: 10px;
            transition: transform 0.3s ease-in-out;
            color: white;
        }
        .card-box:hover {
            transform: translateY(-5px); /* Hiệu ứng bay lên khi di chuột */
            box-shadow: 0 10px 20px rgba(0,0,0,0.2) !important;
        }
        .icon-box {
            font-size: 3.5rem;
            opacity: 0.3;
        }
    </style>
</head>
<body class="bg-light">

    <div class="container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fa fa-tachometer-alt"></i> Tổng quan hoạt động</h2>
            <button class="btn btn-sm btn-outline-secondary">
                <i class="fa fa-sync-alt"></i> Cập nhật dữ liệu
            </button>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="card card-box bg-primary shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2">Hợp đồng Hiệu lực</h6>
                            <h2 class="display-6 fw-bold mb-0">125</h2>
                        </div>
                        <div class="icon-box">
                            <i class="fa fa-file-contract"></i>
                        </div>
                    </div>
                    <small class="mt-3 d-block text-white-50">
                        <i class="fa fa-arrow-up"></i> +5 so với tháng trước
                    </small>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card card-box bg-warning shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2 text-dark">Sắp hết hạn (30 ngày)</h6>
                            <h2 class="display-6 fw-bold mb-0 text-dark">8</h2>
                        </div>
                        <div class="icon-box text-dark">
                            <i class="fa fa-exclamation-triangle"></i>
                        </div>
                    </div>
                    <small class="mt-3 d-block text-dark-50">
                        <a href="contracts?status=EXPIRING" class="text-dark text-decoration-none fw-bold">Xem chi tiết <i class="fa fa-arrow-right"></i></a>
                    </small>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card card-box bg-danger shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2">Yêu cầu chờ duyệt</h6>
                            <h2 class="display-6 fw-bold mb-0">3</h2>
                        </div>
                        <div class="icon-box">
                            <i class="fa fa-bell"></i>
                        </div>
                    </div>
                    <small class="mt-3 d-block text-white-50">
                        Cần xử lý ngay
                    </small>
                </div>
            </div>

             <div class="col-md-3">
                <div class="card card-box bg-success shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2">Tổng máy quản lý</h6>
                            <h2 class="display-6 fw-bold mb-0">340</h2>
                        </div>
                        <div class="icon-box">
                            <i class="fa fa-server"></i>
                        </div>
                    </div>
                    <small class="mt-3 d-block text-white-50">
                        Hệ thống hoạt động ổn định
                    </small>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-list-alt"></i> Hợp đồng mới nhất</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Số HĐ</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><a href="#" class="text-decoration-none">HD-2026-009</a></td>
                                    <td>Công ty Xây dựng ABC</td>
                                    <td>02/02/2026</td>
                                    <td><span class="badge bg-success">ACTIVE</span></td>
                                </tr>
                                <tr>
                                    <td><a href="#" class="text-decoration-none">HD-2026-008</a></td>
                                    <td>Nhà máy Dệt Minh Long</td>
                                    <td>01/02/2026</td>
                                    <td><span class="badge bg-warning text-dark">PENDING</span></td>
                                </tr>
                                <tr>
                                    <td><a href="#" class="text-decoration-none">HD-2026-007</a></td>
                                    <td>Khách sạn Horizon</td>
                                    <td>28/01/2026</td>
                                    <td><span class="badge bg-danger">EXPIRED</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer bg-white text-center py-3">
                        <a href="contracts" class="text-primary text-decoration-none">Xem tất cả hợp đồng</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-sticky-note"></i> Ghi chú nhanh</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle"></i> Nhớ gọi điện nhắc gia hạn cho khách hàng <strong>Công ty May 10</strong> trước ngày 05/02.
                        </div>
                        <div class="alert alert-warning">
                            <i class="fa fa-wrench"></i> Máy phát điện tại <strong>Tòa nhà Keangnam</strong> đang báo lỗi nhiệt độ cao.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>