<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Phân quyền Role</title>

<div class="container mt-4">
    <div class="card shadow">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Phân quyền cho: <strong>${role.name}</strong></h5>
        </div>

        <div class="card-body">
            <form action="<c:url value='/admin/role-permission'/>" method="POST">

                <input type="hidden" name="roleId" value="${role.id}">

                <div class="alert alert-info">
                    <i class="fa-solid fa-circle-info"></i>
                    Tích chọn các quyền hạn bạn muốn cấp cho vai trò này.
                </div>

                <div class="row">
                    <c:forEach items="${allPermissions}" var="p">
                        <div class="col-md-4 mb-3">
                            <div class="form-check p-3 border rounded bg-light h-100">
                                <input class="form-check-input" type="checkbox"
                                       name="permissionIds"
                                       value="${p.id}"
                                       id="perm_${p.id}"
                                       style="transform: scale(1.2); margin-left: -0.8em;"

                                       /* LOGIC QUAN TRỌNG: Kiểm tra xem quyền này có trong list Role đang có không? */
                                       /* Nếu có thì in ra chữ 'checked' */
                                       <c:if test="${currentPermIds.contains(p.id)}">checked</c:if>
                                >

                                <label class="form-check-label fw-bold ms-2" for="perm_${p.id}">
                                    ${p.name}
                                </label>
                                <div class="text-muted small ms-2 mt-1">
                                    Code: <code>${p.code}</code> <br>
                                    Module: <span class="badge bg-secondary">${p.module}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="mt-4 pt-3 border-top text-end">
                    <a href="<c:url value='/admin/role-list'/>" class="btn btn-secondary me-2">Hủy bỏ</a>
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="fa-solid fa-save"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>