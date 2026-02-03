<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="me" value="${sessionScope.USERMODEL}" />

<title>Danh sách người dùng</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Xem danh sách khách hàng</h3>
    </div>

    <div class="card shadow mb-4 border-0">
        <div class="card-body bg-light rounded">
            <form action="<c:url value='/staff/customer-list'/>" method="get" class="row g-3">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="keyword" value="${param.keyword}" class="form-control" placeholder="Tìm theo tên hoặc email...">
                    </div>
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
                            <td>
                                <c:choose>
                                    <c:when test="${u.phone!=null}">
                                        <span class="text-secondary fw-bold">${u.phone}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-secondary fw-bold">Chưa có SĐT</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.roleId == 5}"><span class="badge bg-secondary">CUSTOMER</span></c:when>
                                </c:choose>
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
                            <a class="page-link" href="<c:url value='/staff/customer-list?page=${currentPage - 1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}'/>">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </li>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="<c:url value='/staff/customer-list?page=${i}&keyword=${param.keyword}&role=${param.role}&status=${param.status}'/>">
                                        ${i}
                                </a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/staff/customer-list?page=${currentPage + 1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}'/>">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>