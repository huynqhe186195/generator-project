<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Danh sách người dùng</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Quản lý người dùng</h3>
        <a href="<c:url value='/admin/user-list/addNewUser'/>" class="btn btn-primary">
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
                        <option value="1">Quản trị viên (Admin)</option>
                        <option value="2">Nhân viên kỹ thuật</option>
                        <option value="3">Khách hàng</option>
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
                            <th class="py-3">SĐT</th>
                            <th class="py-3">Vai trò</th>
                            <th class="py-3">Trạng thái</th>
                            <th class="py-3 text-end pe-4">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listUsers}" var="u" varStatus="loop">
                            <tr>
                                <td class="ps-4">${loop.index + 1}</td>

                                <td>
                                    <div class="d-flex align-items-center">
                                        <c:choose>
                                            <c:when test="${u.avatarUrl != null && u.avatarUrl.startsWith('http')}">
                                                <img src="${u.avatarUrl}" class="rounded-circle me-3" width="40" height="40" alt="Avatar" style="object-fit: cover;">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="<c:url value='/${u.avatarUrl}'/>"
                                                     class="rounded-circle me-3"
                                                     width="40" height="40"
                                                     alt="Avatar"
                                                     style="object-fit: cover;"
                                                     onerror="this.src='https://via.placeholder.com/40'"> </c:otherwise>
                                        </c:choose>

                                        <div>
                                            <div class="fw-bold">${u.fullName}</div>
                                            <small class="text-muted">${u.email}</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="text-secondary fw-bold">${u.phone}</span></td>

                                <td>
                                    <c:choose>
                                        <c:when test="${u.roleId == 1}"><span class="badge bg-danger">ADMIN</span></c:when>
                                        <c:when test="${u.roleId == 2}"><span class="badge bg-info text-dark">STAFF</span></c:when>
                                        <c:when test="${u.roleId == 3}"><span class="badge bg-secondary">CUSTOMER</span></c:when>
                                        <c:otherwise><span class="badge bg-light text-dark">UNKNOWN</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 1}">
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check-circle me-1"></i> Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary rounded-pill"><i class="fas fa-ban me-1"></i> Locked</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-end pe-4">
                                    <a href="<c:url value='/admin/user-list/user-detail?id=${u.id}'/>" class="btn btn-sm btn-info text-white me-1" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <a href="<c:url value = '/admin/user-list/updateUser?id=${u.id}'/>" class="btn btn-sm btn-outline-primary me-1" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>

                                    <c:if test="${u.status == 1}">
                                        <button class="btn btn-sm btn-outline-danger" title="Khóa tài khoản"><i class="fas fa-lock"></i></button>
                                    </c:if>
                                    <c:if test="${u.status != 1}">
                                        <button class="btn btn-sm btn-outline-success" title="Mở khóa"><i class="fas fa-unlock"></i></button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listUsers}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    <i class="fas fa-box-open fa-2x mb-2"></i><br>
                                    Không tìm thấy dữ liệu nào.
                                </td>
                            </tr>
                        </c:if>
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