<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Create Role</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-success text-white">
            <h4>Create Role</h4>
        </div>

        <div class="card-body">
            <form method="post"
                  action="${pageContext.request.contextPath}/role-create">

                <div class="mb-3">
                    <label class="form-label">Role Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control"></textarea>
                </div>

                <button class="btn btn-success">Save</button>
                <a href="${pageContext.request.contextPath}/role-list"
                   class="btn btn-secondary">Back</a>
            </form>
        </div>
    </div>
</div>

</body>
</html>
