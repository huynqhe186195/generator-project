<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <title>Update Role</title>

        <div class="container-fluid px-4">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="text-secondary">Update Role</h3>
                <a href="<c:url value='/admin/role-list'/>" class="btn btn-outline-secondary">
                    Back
                </a>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0">Role Information</h5>
                </div>

                <div class="card-body">
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
                            <label class="form-label fw-bold">Status</label>
                            <select class="form-select" name="status">
                                <option value="1" ${role.status==1 ? 'selected' : '' }>
                                    Active
                                </option>
                                <option value="0" ${role.status==0 ? 'selected' : '' }>
                                    Inactive
                                </option>
                            </select>
                        </div>

                        <div class="d-flex gap-2">
                            <button class="btn btn-warning">
                                Update
                            </button>
                            <a href="<c:url value='/admin/role-list'/>" class="btn btn-secondary">
                                Cancel
                            </a>
                        </div>

                    </form>
                </div>
            </div>

        </div>