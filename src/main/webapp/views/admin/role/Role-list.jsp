<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Role Management</title>

<div class="container-fluid px-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Role List</h3>
        <a href="<c:url value='/admin/role-create'/>" class="btn btn-success">
            + Add Role
        </a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">

            <table class="table table-hover table-bordered mb-0 text-center align-middle">
                <thead class="table-secondary">
                <tr>
                    <th style="width:5%">ID</th>
                    <th style="width:30%">Name</th>
                    <th style="width:20%">Status</th>
                    <th style="width:30%">Action</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${roles}" var="r">
                    <tr>
                        <td>${r.id}</td>

                        <td class="fw-semibold">${r.name}</td>

                        <td>
                            <span class="badge rounded-pill
                                ${r.status == 1 ? 'bg-success' : 'bg-danger'}">
                                    ${r.status == 1 ? 'Active' : 'Inactive'}
                            </span>
                        </td>

                        <td>
                            <a href="<c:url value='/admin/role-detail?id=${r.id}'/>"
                               class="btn btn-info btn-sm me-1">
                                Detail
                            </a>

                            <a href="<c:url value='/admin/role-update?id=${r.id}'/>"
                               class="btn btn-warning btn-sm me-1">
                                Edit
                            </a>

                            <!-- 🔥 NÚT DEACTIVATE / ACTIVATE -->
                            <a href="<c:url value='/admin/role-toggle?id=${r.id}'/>"
                               class="btn btn-outline-secondary btn-sm">
                                    ${r.status == 1 ? 'Deactivate' : 'Activate'}
                            </a>
                            <a href="<c:url value='/admin/role-delete?id=${r.id}'/>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Bạn có chắc muốn delete role này?');">
                                Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty roles}">
                    <tr>
                        <td colspan="4" class="text-muted py-4">
                            No roles found
                        </td>
                    </tr>
                </c:if>
                </tbody>

            </table>
        </div>
    </div>
</div>
