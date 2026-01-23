<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="me" value="${sessionScope.USERMODEL}" />

<title>Danh sách người dùng</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Quản lý người dùng</h3>

        <c:if test="${me.hasPermission('USER_MANAGE')}">
            <a href="<c:url value='/admin/user/addNewUser'/>" class="btn btn-primary">
                <i class="fas fa-plus-circle me-2"></i> Thêm nhân viên mới
            </a>
        </c:if>
    </div>

    <div class="card shadow mb-4 border-0">
        <div class="card-body bg-light rounded">
            <form action="<c:url value='/admin/user/user-list'/>" method="get" class="row g-3">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="keyword" value="${param.keyword}" class="form-control" placeholder="Tìm theo tên hoặc email...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="role">
                        <option value="">-- Tất cả vai trò --</option>
                        <option value="1" ${param.role == '1' ? 'selected' : ''}>Quản trị viên (Admin)</option>
                        <option value="2" ${param.role == '2' ? 'selected' : ''}>Nhân viên kỹ thuật</option>
                        <option value="3" ${param.role == '3' ? 'selected' : ''}>Khách hàng</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="status">
                        <option value="">-- Trạng thái --</option>
                        <option value="1" ${param.status == '1' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="0" ${param.status == '0' ? 'selected' : ''}>Đã khóa</option>
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
                                <td class="ps-4">${(currentPage - 1) * 5 + loop.index + 1}</td>

                                <td>
                                    <div class="d-flex align-items-center">
                                        <c:choose>
                                            <c:when test="${u.avatarUrl != null && u.avatarUrl.startsWith('http')}">
                                                <img src="${u.avatarUrl}" class="rounded-circle me-3" width="40" height="40" alt="Avatar" style="object-fit: cover;">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="<c:url value='/${u.avatarUrl}'/>"
                                                     class="rounded-circle me-3" width="40" height="40"
                                                     alt="Avatar" style="object-fit: cover;"
                                                     onerror="this.src='https://ui-avatars.com/api/?name=${u.fullName}&background=random'">
                                            </c:otherwise>
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
                                        <c:when test="${u.roleId == 2}"><span class="badge bg-info text-dark">MANAGER</span></c:when>
                                        <c:when test="${u.roleId == 3}"><span class="badge bg-secondary">STAFF</span></c:when>
                                        <c:when test="${u.roleId == 4}"><span class="badge bg-secondary">TECHNICAL</span></c:when>
                                        <c:when test="${u.roleId == 5}"><span class="badge bg-secondary">CUSTOMER</span></c:when>
                                        <c:otherwise><span class="badge bg-light text-dark">UNKNOWN</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 1}">
                                            <span class="badge bg-success rounded-pill"><i class="fas fa-check-circle me-1"></i> Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary rounded-pill"><i class="fas fa-ban me-1"></i> Deactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-end pe-4">
                                    <div class="d-flex gap-1 justify-content-end">
                                        <c:if test="${me.hasPermission('USER_VIEW')}">
                                            <a href="<c:url value='/admin/user/user-detail?id=${u.id}'/>" class="btn btn-sm btn-info text-white" title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </c:if>

                                        <c:if test="${me.hasPermission('USER_MANAGE') && u.roleId != 1}">
                                            <a href="<c:url value='/admin/user/updateUser?id=${u.id}'/>" class="btn btn-sm btn-warning text-white" title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <c:choose>
                                                <c:when test="${u.status == 1}">
                                                    <a href="javascript:void(0)" onclick="confirmLock(${u.id}, 1)" class="btn btn-sm btn-danger" title="Khóa tài khoản">
                                                        <i class="fas fa-lock"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="javascript:void(0)" onclick="confirmLock(${u.id}, 0)" class="btn btn-sm btn-success" title="Mở khóa">
                                                        <i class="fas fa-unlock"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listUsers}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="fas fa-box-open fa-3x mb-3 text-gray-300"></i><br>
                                    Không tìm thấy dữ liệu nào phù hợp.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card-footer bg-white py-3">
            <c:if test="${totalPages > 0}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-end mb-0">

                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/user/user-list?page=${currentPage - 1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}'/>">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </li>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="<c:url value='/admin/user/user-list?page=${i}&keyword=${param.keyword}&role=${param.role}&status=${param.status}'/>">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/user/user-list?page=${currentPage + 1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}'/>">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>

<script>
    function confirmLock(id, currentStatus) {
        let action = (currentStatus == 1) ? "KHÓA" : "MỞ KHÓA";
        // Sử dụng tiếng Việt có dấu cho thân thiện
        let confirmMsg = "Bạn có chắc chắn muốn " + action + " tài khoản này không?";

        if (confirm(confirmMsg)) {
            // Cập nhật đường dẫn cho đúng với cấu trúc /admin/user/*
            // Ví dụ: /admin/user/toggle-status?id=...
            window.location.href = "<c:url value='/admin/user/toggle-status'/>?id=" + id + "&status=" + currentStatus;
        }
    }
</script>