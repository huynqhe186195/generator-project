<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <title>Role Detail</title>

        <div class="container-fluid">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-secondary">Role Detail</h4>
                <a href="<c:url value='/admin/role-list'/>" class="btn btn-outline-secondary">
                    ← Back
                </a>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-info text-white fw-bold">
                    Role Information
                </div>

                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p><strong>ID:</strong> ${role.id}</p>
                            <p><strong>Name:</strong> ${role.name}</p>
                        </div>

                        <div class="col-md-6">
                            <p><strong>Status:</strong>
                                <span class="badge ${role.status == 1 ? 'bg-success' : 'bg-danger'}">
                                    ${role.status == 1 ? 'Active' : 'Inactive'}
                                </span>
                            </p>
                        </div>
                    </div>

                    <p><strong>Description:</strong></p>
                    <div class="border rounded p-3 bg-light">
                        ${role.description}
                    </div>
                </div>
            </div>

        </div>