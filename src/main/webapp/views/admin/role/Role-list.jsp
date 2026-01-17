<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="currentUser" value="${sessionScope.USERMODEL}" />

<title>Role Management</title>

<div class="container-fluid px-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Role List</h3>

        <c:if test="${currentUser.hasPermission('ROLE_CREATE') || currentUser.roleId == 1}">
            <a href="<c:url value='/admin/role/role-create'/>" class="btn btn-success">
                <i class="fa-solid fa-plus"></i> Add Role
            </a>
        </c:if>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">

            <table class="table table-hover table-bordered mb-0 text-center align-middle">
                <thead class="table-secondary">
                <tr>
                    <th style="width:5%">ID</th>
                    <th style="width:20%">Name</th>
                    <th style="width:30%">Description</th>
                    <th style="width:10%">Status</th>
                    <th style="width:35%">Action</th> </tr>
                </thead>

                <tbody>
                <c:forEach items="${roles}" var="r">
                    <tr>
                        <td>${r.id}</td>

                        <td class="fw-semibold text-start ps-4">${r.name}</td>

                        <td class="text-start">${r.description}</td>

                        <td>
                            <span class="badge rounded-pill
                                ${r.status == 1 ? 'bg-success' : 'bg-danger'}">
                                    ${r.status == 1 ? 'Active' : 'Inactive'}
                            </span>
                        </td>

                        <td>
                            <a href="<c:url value='/admin/role/role-detail?id=${r.id}'/>"
                               class="btn btn-info btn-sm me-1 text-white" title="Chi tiết">
                                <i class="fa-solid fa-eye"></i>
                            </a>

                            <c:if test="${r.id != 1}">

                                <c:if test="${currentUser.hasPermission('ROLE_UPDATE') || currentUser.roleId == 1}">

                                    <a href="<c:url value='/admin/role/role-permission?id=${r.id}'/>"
                                       class="btn btn-dark btn-sm me-1"
                                       title="Phân quyền chức năng">
                                       <i class="fa-solid fa-shield-halved"></i> Perms
                                    </a>

                                    <a href="<c:url value='/admin/role/role-update?id=${r.id}'/>"
                                       class="btn btn-warning btn-sm me-1" title="Sửa thông tin">
                                        <i class="fa-solid fa-pen"></i>
                                    </a>

                                    <a href="<c:url value='/admin/role/role-toggle?id=${r.id}'/>"
                                       class="btn btn-outline-secondary btn-sm me-1"
                                       title="${r.status == 1 ? 'Khóa Role' : 'Mở khóa'}">
                                       <i class="fa-solid ${r.status == 1 ? 'fa-lock' : 'fa-lock-open'}"></i>
                                    </a>
                                </c:if>

                                <c:if test="${currentUser.hasPermission('ROLE_DELETE') || currentUser.roleId == 1}">
                                    <a href="<c:url value='/admin/role/role-delete?id=${r.id}'/>"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('CẢNH BÁO: Xóa role này sẽ ảnh hưởng đến tất cả User đang giữ role đó. Bạn chắc chắn chứ?');"
                                       title="Xóa Role">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </c:if>

                            </c:if>

                            <c:if test="${r.id == 1}">
                                <span class="badge bg-secondary"><i class="fa-solid fa-lock"></i> System</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty roles}">
                    <tr>
                        <td colspan="5" class="text-muted py-4">
                            No roles found in database.
                        </td>
                    </tr>
                </c:if>
                </tbody>

            </table>
        </div>
    </div>
</div>