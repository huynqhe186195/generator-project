<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<title>Create Role</title>

<div class="container-fluid px-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Create Role</h3>
        <a href="<c:url value='/admin/role-list'/>" class="btn btn-outline-secondary">
            Back
        </a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-success text-white">
            <h5 class="mb-0">Role Information</h5>
        </div>

        <div class="card-body">
            <form method="post" action="<c:url value='/admin/role-create'/>">

                <div class="mb-3">
                    <label class="form-label fw-bold">Role Name</label>
                    <input type="text" name="name" class="form-control" required placeholder="Ví dụ: Admin, Staff, Shipper...">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Default Redirect URL</label>
                    <input type="text" name="redirectUrl" class="form-control" required
                           placeholder="Ví dụ: /admin, /home, /staff/tasks">
                    <small class="text-muted">Đường dẫn người dùng sẽ được chuyển tới sau khi đăng nhập.</small>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="3"></textarea>
                </div>

                <div class="d-flex gap-2">
                    <button class="btn btn-success">
                        Save
                    </button>
                    <a href="<c:url value='/admin/role-list'/>" class="btn btn-secondary">
                        Cancel
                    </a>
                </div>

            </form>
        </div>
    </div>

</div>