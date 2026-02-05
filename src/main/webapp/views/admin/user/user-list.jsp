<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <c:set var="me" value="${sessionScope.USERMODEL}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
    .card { border-radius: 12px; border: none; }
    .table thead th { background: #f8f9fa; color: #495057; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; }
    .avatar-img { width: 40px; height: 40px; object-fit: cover; border-radius: 50%; }

    /* SỬA LẠI: px-3 py-2 là class bootstrap, không viết trong css được */
    .role-badge { padding: 6px 12px; border-radius: 8px; font-size: 0.85rem; font-weight: 500; display: inline-block; }

    .role-admin { background-color: #ffe5e5; color: #d9534f; border: 1px solid #f5c6cb; } /* Admin */
    .role-manager { background-color: #fef3c7; color: #92400e; border: 1px solid #fde68a; } /* Manager */
    .role-staff { background-color: #e2f3ff; color: #0275d8; border: 1px solid #b8daff; } /* Staff */
    .role-tech { background-color: #f3e8ff; color: #6b21a8; border: 1px solid #e9d5ff; } /* Technical */
    .role-customer { background-color: #e6fffa; color: #088178; border: 1px solid #b2f5ea; } /* Customer */
    .role-it { background-color: #334155; color: #f8fafc; border: 1px solid #1e293b; } /* IT */

    .status-active { color: #28a745; font-weight: 500; }
    .status-locked { color: #dc3545; font-weight: 500; }
    .pagination .page-link { border-radius: 6px; margin: 0 2px; color: #4e73df; }
    .pagination .page-item.active .page-link { background-color: #4e73df; border-color: #4e73df; }
</style>

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark">Quản trị người dùng</h3>
        <c:if test="${me.hasPermission('USER_MANAGE')}">
            <a href="${ctx}/admin/user/addNewUser" class="btn btn-primary px-4 shadow-sm">
                <i class="fas fa-plus-circle me-2"></i> Thêm nhân viên
            </a>
        </c:if>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-body bg-light border-radius-12">
            <form action="${ctx}/admin/user/user-list" method="get" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label small fw-bold">Tìm kiếm</label>
                    <input type="text" name="keyword" value="${param.keyword}"
                           class="form-control" placeholder="Tên, email hoặc SĐT...">
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-bold">Vai trò</label>
                    <select class="form-select" name="role">
                        <option value="">-- Tất cả vai trò --</option>
                        <option value="1" ${param.role == '1' ? 'selected' : ''}>Quản trị viên (Admin)</option>
                        <option value="2" ${param.role == '2' ? 'selected' : ''}>Manager</option>
                        <option value="3" ${param.role == '3' ? 'selected' : ''}>Staff</option>
                        <option value="4" ${param.role == '4' ? 'selected' : ''}>Technical</option>
                        <option value="5" ${param.role == '5' ? 'selected' : ''}>Customer</option>
                        <option value="6" ${param.role == '6' ? 'selected' : ''}>IT System</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-bold">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="">-- Tất cả --</option>
                        <option value="1" ${param.status == '1' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="0" ${param.status == '0' ? 'selected' : ''}>Đã khóa</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <button type="submit" class="btn btn-dark w-100">
                        <i class="fas fa-filter me-1"></i> Lọc
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th class="text-center" style="width: 50px;">#</th>
                    <th>Thành viên</th>
                    <th>Thông tin liên hệ</th>
                    <th>Vai trò hệ thống</th>
                    <th class="text-center">Trạng thái</th>
                    <th class="text-end pe-4">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listUsers}" var="u" varStatus="i">
                    <tr>
                        <td class="text-center text-muted">${i.index + 1}</td>
                        <td>
                            <div class="d-flex align-items-center">
                                <c:choose>
                                    <%-- 1. Link Online (Bắt đầu bằng http) --%>
                                    <c:when test="${not empty u.avatarUrl and fn:startsWith(u.avatarUrl, 'http')}">
                                        <img src="${u.avatarUrl}" class="avatar-img me-3 shadow-sm border">
                                    </c:when>

                                    <%-- 2. Ảnh Upload (Local) -> Thêm ${ctx} vào trước --%>
                                    <c:when test="${not empty u.avatarUrl}">
                                        <img src="${ctx}/${u.avatarUrl}" class="avatar-img me-3 shadow-sm border">
                                    </c:when>

                                    <%-- 3. Không có ảnh -> Dùng mặc định --%>
                                    <c:otherwise>
                                        <img src="https://ui-avatars.com/api/?name=${u.fullName}&background=random" class="avatar-img me-3 shadow-sm border">
                                    </c:otherwise>
                                </c:choose>

                                <div>
                                    <div class="fw-bold text-primary">${u.fullName}</div>
                                    <small class="text-muted">ID: #${u.id}</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="small text-dark"><i class="fas fa-envelope me-2 text-muted"></i>${u.email}</div>
                            <div class="small text-dark"><i class="fas fa-phone me-2 text-muted"></i>${u.phone}</div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.roleId == 1}"><span class="badge role-badge role-admin"><i class="fas fa-user-shield me-1"></i> Admin</span></c:when>
                                <c:when test="${u.roleId == 2}"><span class="badge role-badge role-manager"><i class="fas fa-user-tie me-1"></i> Manager</span></c:when>
                                <c:when test="${u.roleId == 3}"><span class="badge role-badge role-staff"><i class="fas fa-user me-1"></i> Staff</span></c:when>
                                <c:when test="${u.roleId == 4}"><span class="badge role-badge role-tech"><i class="fas fa-user-cog me-1"></i> Technical</span></c:when>
                                <c:when test="${u.roleId == 5}"><span class="badge role-badge role-customer"><i class="fas fa-user-tag me-1"></i> Customer</span></c:when>
                                <c:when test="${u.roleId == 6}"><span class="badge role-badge role-it"><i class="fas fa-laptop-code me-1"></i> IT System</span></c:when>
                                <c:otherwise><span class="badge bg-secondary px-3 py-2">Unknown</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <span class="${u.status == 1 ? 'status-active' : 'status-locked'}">
                                <i class="fas ${u.status == 1 ? 'fa-check-circle' : 'fa-ban'} me-1"></i>
                                ${u.status == 1 ? 'Active' : 'Locked'}
                            </span>
                        </td>
                        <td class="text-end pe-4">
                            <a href="${ctx}/admin/user/user-detail?id=${u.id}" class="btn btn-sm btn-outline-info border-0" title="Xem"><i class="fas fa-eye"></i></a>
                            <c:if test="${me.hasPermission('USER_MANAGE') && u.roleId != 1}">
                                <a href="${ctx}/admin/user/updateUser?id=${u.id}" class="btn btn-sm btn-outline-warning border-0" title="Sửa"><i class="fas fa-edit"></i></a>
                                <button class="btn btn-sm border-0 ${u.status == 1 ? 'text-danger' : 'text-success'}"
                                        onclick="toggleStatus(${u.id}, ${u.status})" title="Khóa/Mở"><i class="fas ${u.status == 1 ? 'fa-lock' : 'fa-unlock'}"></i></button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listUsers}">
                    <tr><td colspan="6" class="text-center py-5 text-muted">Không tìm thấy dữ liệu.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white border-top-0 py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="text-muted small">Trang ${currentPage} / ${totalPages}</div>
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${ctx}/admin/user/user-list?page=${currentPage - 1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}"><i class="fas fa-chevron-left"></i></a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                    <a class="page-link" href="${ctx}/admin/user/user-list?page=${p}&keyword=${param.keyword}&role=${param.role}&status=${param.status}">${p}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${ctx}/admin/user/user-list?page=${currentPage + 1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}"><i class="fas fa-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
    function toggleStatus(id, status) {
        const action = status === 1 ? "khóa" : "mở khóa";
        if (confirm("Xác nhận " + action + " tài khoản này?")) {
            // Đảm bảo đường dẫn Controller xử lý action này là đúng
            window.location.href = "${ctx}/admin/user-status?id=" + id + "&status=" + status;
        }
    }
</script>