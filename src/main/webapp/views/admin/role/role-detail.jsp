<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Role Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="card shadow">
        <div class="card-header bg-info text-white">
            Role Detail
        </div>

        <div class="card-body">
            <p><strong>ID:</strong> ${role.id}</p>
            <p><strong>Name:</strong> ${role.name}</p>
            <p><strong>Description:</strong> ${role.description}</p>
            <p><strong>Status:</strong>
                <span class="badge ${role.status == 1 ? 'bg-success' : 'bg-danger'}">
                    ${role.status == 1 ? 'Active' : 'Inactive'}
                </span>
            </p>
        </div>

        <div class="card-footer">
            <a href="role-list" class="btn btn-secondary">Back</a>
        </div>
    </div>
</div>

</body>
</html>
