<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<form method="post" action="<c:url value='/admin/role-update'/>">

    <input type="hidden" name="id" value="${role.id}" />

    <div class="mb-3">
        <label class="form-label fw-bold">Role Name</label>
        <input class="form-control" name="name" value="${role.name}" required>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Description</label>
        <textarea class="form-control" name="description" rows="3">${role.description}</textarea>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Redirect URL</label>
        <input type="text" class="form-control" name="redirectUrl"
               value="${role.redirectUrl}" placeholder="/admin/dashboard">
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Status</label>
        <select class="form-select" name="status">
            <option value="1" ${role.status == 1 ? 'selected' : ''}>
                Active
            </option>
            <option value="0" ${role.status == 0 ? 'selected' : ''}>
                Inactive
            </option>
        </select>
    </div>

    <div class="d-flex gap-2">
        <button class="btn btn-warning">Update</button>
        <a href="<c:url value='/admin/role-list'/>" class="btn btn-secondary">
            Cancel
        </a>
    </div>

</form>