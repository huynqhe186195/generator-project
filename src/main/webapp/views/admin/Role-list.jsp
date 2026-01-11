<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Role Management</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Role List</h5>
            <a href="role-create" class="btn btn-success btn-sm">
                + Add Role
            </a>
        </div>

        <div class="card-body p-0">
            <table class="table table-hover table-bordered mb-0">
                <thead class="table-secondary text-center">
                <tr>
                    <th style="width: 5%">ID</th>
                    <th style="width: 30%">Name</th>
                    <th style="width: 20%">Status</th>
                    <th style="width: 25%">Action</th>
                </tr>
                </thead>

                <tbody class="text-center align-middle">
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
                            <a href="role-detail?id=${r.id}"
                               class="btn btn-info btn-sm me-1">
                                Detail
                            </a>
                            <a href="role-update?id=${r.id}"
                               class="btn btn-warning btn-sm me-1">
                                Edit
                            </a>
                            <a href="role-toggle?id=${r.id}"
                               class="btn btn-outline-secondary btn-sm">
                                    ${r.status == 1 ? 'Deactivate' : 'Activate'}
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty roles}">
                    <tr>
                        <td colspan="4" class="text-muted text-center py-4">
                            No roles found
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
