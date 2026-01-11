<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Danh sách người dùng</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Quản lý người dùng</h3>
        <a href="<c:url value='/admin/user-add'/>" class="btn btn-primary">
            <i class="fas fa-plus-circle me-2"></i> Thêm nhân viên mới
        </a>
    </div>

    <div class="card shadow mb-4 border-0">
        <div class="card-body bg-light rounded">
            <form action="<c:url value='/admin/user-list'/>" method="get" class="row g-3">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên hoặc email...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="role">
                        <option value="">-- Tất cả vai trò --</option>
                        <option value="ADMIN">Quản trị viên (Admin)</option>
                        <option value="STAFF">Nhân viên kỹ thuật</option>
                        <option value="CUSTOMER">Khách hàng</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="status">
                        <option value="">-- Trạng thái --</option>
                        <option value="1">Đang hoạt động</option>
                        <option value="0">Đã khóa</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-secondary w-100">Lọc dữ liệu</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light text-secondary">
                        <tr>
                            <th class="py-3 ps-4">#</th>
                            <th class="py-3">Thông tin cá nhân</th>
                            <th class="py-3">Tài khoản</th>
                            <th class="py-3">Vai trò</th>
                            <th class="py-3">Trạng thái</th>
                            <th class="py-3 text-end pe-4">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="ps-4">1</td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="https://ui-avatars.com/api/?name=Huy+Nguyen&background=random" class="rounded-circle me-3" width="40" height="40">
                                    <div>
                                        <div class="fw-bold">Nguyễn Quốc Huy</div>
                                        <small class="text-muted">huy@fpt.edu.vn</small>
                                    </div>
                                </div>
                            </td>
                            <td><span class="fw-bold text-primary">admin_huy</span></td>
                            <td><span class="badge bg-danger">ADMIN</span></td>
                            <td><span class="badge bg-success rounded-pill"><i class="fas fa-check-circle me-1"></i> Active</span></td>
                            <td class="text-end pe-4">
                                <a href="<c:url value='/admin/user-list/user-detail'/>" class="btn btn-sm btn-info text-white me-1" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="#" class="btn btn-sm btn-outline-primary me-1" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                <button class="btn btn-sm btn-outline-danger" title="Khóa tài khoản"><i class="fas fa-lock"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td class="ps-4">2</td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="https://ui-avatars.com/api/?name=Tran+Van+B&background=random" class="rounded-circle me-3" width="40" height="40">
                                    <div>
                                        <div class="fw-bold">Trần Văn B</div>
                                        <small class="text-muted">b_tran@gmail.com</small>
                                    </div>
                                </div>
                            </td>
                            <td><span>technician_b</span></td>
                            <td><span class="badge bg-info text-dark">STAFF</span></td>
                            <td><span class="badge bg-success rounded-pill"><i class="fas fa-check-circle me-1"></i> Active</span></td>
                            <td class="text-end pe-4">
                                <a href="<c:url value='/admin/user-list/user-detail'/>" class="btn btn-sm btn-info text-white me-1" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="#" class="btn btn-sm btn-outline-primary me-1" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                <button class="btn btn-sm btn-outline-danger" title="Khóa tài khoản"><i class="fas fa-lock"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td class="ps-4">3</td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="https://ui-avatars.com/api/?name=Nguyen+Thi+C&background=random" class="rounded-circle me-3" width="40" height="40">
                                    <div>
                                        <div class="fw-bold">Nguyễn Thị C</div>
                                        <small class="text-muted">c_nguyen@yahoo.com</small>
                                    </div>
                                </div>
                            </td>
                            <td><span>customer_c</span></td>
                            <td><span class="badge bg-secondary">CUSTOMER</span></td>
                            <td><span class="badge bg-secondary rounded-pill"><i class="fas fa-ban me-1"></i> Locked</span></td>
                            <td class="text-end pe-4">
                                <a href="<c:url value='/admin/user-list/user-detail'/>" class="btn btn-sm btn-info text-white me-1" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="#" class="btn btn-sm btn-outline-primary me-1" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                <button class="btn btn-sm btn-outline-success" title="Mở khóa"><i class="fas fa-unlock"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card-footer bg-white py-3">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-end mb-0">
                    <li class="page-item disabled"><a class="page-link" href="#">Trước</a></li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item"><a class="page-link" href="#">Sau</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>