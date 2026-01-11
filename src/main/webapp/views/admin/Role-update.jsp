<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Update Role</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="card shadow">
        <div class="card-header bg-warning">
            Update Role
        </div>

        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/role-update">
                <input type="hidden" name="id" value="${role.id}"/>

                <div class="mb-3">
                    <label class="form-label">Name</label>
                    <input class="form-control" name="name" value="${role.name}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control" name="description">${role.description}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select class="form-select" name="status">
                        <option value="1" ${role.status==1?'selected':''}>Active</option>
                        <option value="0" ${role.status==0?'selected':''}>Inactive</option>
                    </select>
                </div>

                <button class="btn btn-warning">Update</button>
                <a href="${pageContext.request.contextPath}/role-list"
                   class="btn btn-secondary">
                    Cancel
                </a>
            </form>
        </div>
    </div>
</div>

</body>
</html>
