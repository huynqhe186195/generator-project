<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .card-stat { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); color: white; }
        .bg-primary-gradient { background: linear-gradient(45deg, #4e73df, #224abe); }
        .bg-success-gradient { background: linear-gradient(45deg, #1cc88a, #13855c); }
        .bg-warning-gradient { background: linear-gradient(45deg, #f6c23e, #dda20a); }
        .bg-danger-gradient { background: linear-gradient(45deg, #e74a3b, #be2617); }
        .avatar-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(45deg, #4e73df, #224abe);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        .user-info-cell { display: flex; align-items: center; gap: 10px; }
        .switch { position: relative; display: inline-block; width: 50px; height: 24px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider {
            position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
            background-color: #ccc; transition: .4s; border-radius: 24px;
        }
        .slider:before {
            position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px;
            background-color: white; transition: .4s; border-radius: 50%;
        }
        input:checked + .slider { background-color: #1cc88a; }
        input:checked + .slider:before { transform: translateX(26px); }
        .status-dot {
            width: 8px; height: 8px; border-radius: 50%;
            display: inline-block; margin-right: 5px;
        }
        .modal-header { border-bottom: 2px solid #f0f0f0; }
        .info-row { padding: 12px 0; border-bottom: 1px solid #f0f0f0; }
        .info-label { font-weight: 600; color: #6c757d; }
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
                <li class="nav-item"><a class="nav-link" href="<c:url value='/'></c:url>">Trang chủ</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Danh sách máy</a></li>
                <li class="nav-item"><a class="nav-link active" href="#">Quản lý người dùng</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Báo cáo</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value='/profile'/>">Admin: <strong>${userInfo.fullName}</strong></a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4 text-secondary">Quản lý người dùng</h2>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card card-stat bg-primary-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Tổng người dùng</h6>
                        <h2 class="mb-0">${totalUsers}</h2>
                    </div>
                    <i class="fas fa-users fa-2x opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat bg-success-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Đang hoạt động</h6>
                        <h2 class="mb-0">${activeUsers}</h2>
                    </div>
                    <i class="fas fa-user-check fa-2x opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat bg-warning-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Tạm khóa</h6>
                        <h2 class="mb-0">${inactiveUsers}</h2>
                    </div>
                    <i class="fas fa-user-lock fa-2x opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat bg-danger-gradient p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase">Admin</h6>
                        <h2 class="mb-0">${adminUsers}</h2>
                    </div>
                    <i class="fas fa-user-shield fa-2x opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- User Management Table -->
    <div class="card shadow">
        <div class="card-header py-3 d-flex justify-content-between align-items-center bg-white">
            <h6 class="m-0 font-weight-bold text-primary">
                <i class="fas fa-users-cog"></i> Danh sách người dùng
            </h6>
            <div>
                <button class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fas fa-user-plus"></i> Thêm người dùng
                </button>
                <button class="btn btn-sm btn-secondary">
                    <i class="fas fa-file-export"></i> Xuất Excel
                </button>
            </div>
        </div>
        <div class="card-body">
            <!-- Search and Filter -->
            <div class="row mb-3">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" class="form-control" placeholder="Tìm kiếm theo tên, email, username...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-select">
                        <option value="">Tất cả vai trò</option>
                        <option value="admin">Admin</option>
                        <option value="manager">Quản lý</option>
                        <option value="user">Người dùng</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select">
                        <option value="">Tất cả trạng thái</option>
                        <option value="active">Hoạt động</option>
                        <option value="inactive">Tạm khóa</option>
                    </select>
                </div>
            </div>

            <!-- Users Table -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle" width="100%" cellspacing="0">
                    <thead class="table-light">
                    <tr>
                        <th width="5%">#</th>
                        <th width="25%">Người dùng</th>
                        <th width="15%">Username</th>
                        <th width="15%">Vai trò</th>
                        <th width="12%">Ngày tạo</th>
                        <th width="10%">Trạng thái</th>
                        <th width="18%">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${userList}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>
                                <div class="user-info-cell">
                                    <div class="avatar-circle">${user.initials}</div>
                                    <div>
                                        <div class="fw-bold">${user.fullName}</div>
                                        <small class="text-muted">${user.email}</small>
                                    </div>
                                </div>
                            </td>
                            <td>${user.username}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}">
                                        <span class="badge bg-danger"><i class="fas fa-crown"></i> Admin</span>
                                    </c:when>
                                    <c:when test="${user.role == 'MANAGER'}">
                                        <span class="badge bg-warning text-dark"><i class="fas fa-user-tie"></i> Quản lý</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info"><i class="fas fa-user"></i> Người dùng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${user.createdDate}</td>
                            <td>
                                <label class="switch">
                                    <input type="checkbox" ${user.active ? 'checked' : ''}
                                           onchange="toggleUserStatus(${user.id}, this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-info text-white"
                                        onclick="viewUserDetail(${user.id})"
                                        title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-sm btn-warning"
                                        onclick="editUser(${user.id})"
                                        title="Chỉnh sửa">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-danger"
                                        onclick="deleteUser(${user.id})"
                                        title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-end">
                    <li class="page-item disabled">
                        <a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- View User Detail Modal -->
<div class="modal fade" id="viewUserModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fas fa-user-circle"></i> Chi tiết người dùng</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-4 text-center border-end">
                        <div class="avatar-circle mx-auto mb-3" style="width: 100px; height: 100px; font-size: 2.5rem;">
                            <span id="modalInitials">NH</span>
                        </div>
                        <h5 id="modalFullName">Nguyễn Văn Huy</h5>
                        <span id="modalRoleBadge" class="badge bg-danger">Admin</span>
                        <div class="mt-3">
                            <span id="modalStatusBadge" class="badge bg-success">
                                <span class="status-dot bg-white"></span> Đang hoạt động
                            </span>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <h6 class="text-primary mb-3"><i class="fas fa-info-circle"></i> Thông tin cơ bản</h6>
                        <div class="info-row row">
                            <div class="col-5 info-label">Email:</div>
                            <div class="col-7" id="modalEmail">huy@gencms.com</div>
                        </div>
                        <div class="info-row row">
                            <div class="col-5 info-label">Username:</div>
                            <div class="col-7" id="modalUsername">huynguyen</div>
                        </div>
                        <div class="info-row row">
                            <div class="col-5 info-label">Số điện thoại:</div>
                            <div class="col-7" id="modalPhone">0901234567</div>
                        </div>
                        <div class="info-row row">
                            <div class="col-5 info-label">Ngày tạo:</div>
                            <div class="col-7" id="modalCreatedDate">15/12/2025</div>
                        </div>
                        <div class="info-row row">
                            <div class="col-5 info-label">Lần đăng nhập cuối:</div>
                            <div class="col-7" id="modalLastLogin">10/01/2026 14:30</div>
                        </div>
                        <div class="info-row row border-0">
                            <div class="col-5 info-label">Địa chỉ:</div>
                            <div class="col-7" id="modalAddress">Hà Nội, Việt Nam</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-warning"><i class="fas fa-edit"></i> Chỉnh sửa</button>
            </div>
        </div>
    </div>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title"><i class="fas fa-user-plus"></i> Thêm người dùng mới</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="addUserForm">
                    <div class="mb-3">
                        <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="fullName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Username <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" name="phone">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                        <select class="form-select" name="role" required>
                            <option value="">Chọn vai trò</option>
                            <option value="USER">Người dùng</option>
                            <option value="MANAGER">Quản lý</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-success" onclick="submitAddUser()">
                    <i class="fas fa-save"></i> Lưu
                </button>
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
<script>
    // Toggle user active/inactive status
    function toggleUserStatus(userId, isActive) {
        const status = isActive ? 'kích hoạt' : 'tạm khóa';
        if (confirm(`Bạn có chắc muốn ${status} người dùng này?`)) {
            // Ajax call to update status
            fetch(`/api/users/${userId}/status`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ active: isActive })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(`${status.charAt(0).toUpperCase() + status.slice(1)} người dùng thành công!`);
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Không thể kết nối đến server!');
                });
        } else {
            // Revert checkbox if user cancels
            event.target.checked = !isActive;
        }
    }

    // View user details
    function viewUserDetail(userId) {
        // Ajax call to get user details
        fetch(`/api/users/${userId}`)
            .then(response => response.json())
            .then(user => {
                document.getElementById('modalInitials').textContent = user.initials;
                document.getElementById('modalFullName').textContent = user.fullName;
                document.getElementById('modalEmail').textContent = user.email;
                document.getElementById('modalUsername').textContent = user.username;
                document.getElementById('modalPhone').textContent = user.phone || 'Chưa cập nhật';
                document.getElementById('modalCreatedDate').textContent = user.createdDate;
                document.getElementById('modalLastLogin').textContent = user.lastLogin || 'Chưa đăng nhập';
                document.getElementById('modalAddress').textContent = user.address || 'Chưa cập nhật';

                // Update role badge
                const roleBadge = document.getElementById('modalRoleBadge');
                if (user.role === 'ADMIN') {
                    roleBadge.className = 'badge bg-danger';
                    roleBadge.innerHTML = '<i class="fas fa-crown"></i> Admin';
                } else if (user.role === 'MANAGER') {
                    roleBadge.className = 'badge bg-warning text-dark';
                    roleBadge.innerHTML = '<i class="fas fa-user-tie"></i> Quản lý';
                } else {
                    roleBadge.className = 'badge bg-info';
                    roleBadge.innerHTML = '<i class="fas fa-user"></i> Người dùng';
                }

                // Update status badge
                const statusBadge = document.getElementById('modalStatusBadge');
                if (user.active) {
                    statusBadge.className = 'badge bg-success';
                    statusBadge.innerHTML = '<span class="status-dot bg-white"></span> Đang hoạt động';
                } else {
                    statusBadge.className = 'badge bg-secondary';
                    statusBadge.innerHTML = '<span class="status-dot bg-white"></span> Tạm khóa';
                }

                // Show modal
                const modal = new bootstrap.Modal(document.getElementById('viewUserModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Không thể tải thông tin người dùng!');
            });
    }

    // Edit user
    function editUser(userId) {
        window.location.href = `/users/edit/${userId}`;
    }

    // Delete user
    function deleteUser(userId) {
        if (confirm('Bạn có chắc chắn muốn xóa người dùng này? Hành động này không thể hoàn tác!')) {
            fetch(`/api/users/${userId}`, {
                method: 'DELETE'
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Xóa người dùng thành công!');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Không thể kết nối đến server!');
                });
        }
    }

    // Submit add user form
    function submitAddUser() {
        const form = document.getElementById('addUserForm');
        if (form.checkValidity()) {
            const formData = new FormData(form);
            const userData = Object.fromEntries(formData.entries());

            fetch('/api/users', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(userData)
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Thêm người dùng thành công!');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Không thể kết nối đến server!');
                });
        } else {
            form.reportValidity();
        }
    }
</script>
</body>
</html>