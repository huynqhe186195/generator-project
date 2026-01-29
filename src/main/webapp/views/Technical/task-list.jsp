<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h4 class="mb-4">🛠 Công việc của tôi</h4>


<form method="get"
      action="<c:url value='/technical/my-tasks'/>"
      class="row g-2 mb-3">

    <!-- FILTER STATUS -->
    <div class="col-md-3">
        <select name="status" class="form-select">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="SCHEDULED"
            ${param.status == 'SCHEDULED' ? 'selected' : ''}>
                SCHEDULED
            </option>
            <option value="COMPLETED"
            ${param.status == 'COMPLETED' ? 'selected' : ''}>
                COMPLETED
            </option>
            <option value="CANCELLED"
            ${param.status == 'CANCELLED' ? 'selected' : ''}>
                CANCELLED
            </option>
        </select>
    </div>

    <!-- FILTER TYPE -->
    <div class="col-md-3">
        <select name="type" class="form-select">
            <option value="">-- Tất cả loại bảo trì --</option>
            <option value="PERIODIC"
            ${param.type == 'PERIODIC' ? 'selected' : ''}>
                PERIODIC
            </option>
            <option value="REPAIR"
            ${param.type == 'REPAIR' ? 'selected' : ''}>
                REPAIR
            </option>
            <option value="INSPECTION"
            ${param.type == 'INSPECTION' ? 'selected' : ''}>
                INSPECTION
            </option>
        </select>
    </div>

    <div class="col-md-2">
        <button class="btn btn-primary w-100">
            Lọc
        </button>
    </div>
</form>

<table class="table table-bordered bg-white">
    <thead class="table-light">
    <tr>
        <th>Serial Number</th>
        <th>Tên máy</th>
        <th>Loại bảo trì</th>
        <th>Trạng thái</th>
        <th>Ngày bảo trì</th>
        <th>Hành động</th>

    </tr>
    </thead>
    <tbody>

    <c:if test="${empty tasks}">
        <tr>
            <td colspan="5" class="text-center text-muted">
                Không có công việc nào được giao
            </td>
        </tr>
    </c:if>

    <c:forEach items="${tasks}" var="t">
        <tr>
            <td>${t.productSerialNumber}</td>
            <td>${t.productName}</td>
            <td>${t.type}</td>


            <!-- ===== TRẠNG THÁI (ENUM CHUẨN) ===== -->
            <td>
                <form method="post"
                      action="<c:url value='/technical/task-status'/>">

                    <input type="hidden" name="id" value="${t.id}" />

                    <select name="status"
                            class="form-select form-select-sm"
                            onchange="this.form.submit()">

                        <option value="SCHEDULED"
                            ${t.status == 'SCHEDULED' ? 'selected' : ''}>
                            SCHEDULED
                        </option>

                        <option value="COMPLETED"
                            ${t.status == 'COMPLETED' ? 'selected' : ''}>
                            COMPLETED
                        </option>

                        <option value="CANCELLED"
                            ${t.status == 'CANCELLED' ? 'selected' : ''}>
                            CANCELLED
                        </option>

                    </select>
                </form>
            </td>

            <td>
                    ${t.createdAt}
            </td>
            <!-- ===== HÀNH ĐỘNG ===== -->
            <td>
                <a class="btn btn-sm btn-primary"
                   href="<c:url value='/technical/task-detail?id=${t.id}'/>">
                    Xem
                </a>
            </td>
        </tr>
    </c:forEach>

    </tbody>
</table>
