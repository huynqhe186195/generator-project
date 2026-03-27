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
            <option value="SCHEDULED" ${param.status == 'SCHEDULED' ? 'selected' : ''}>SCHEDULED</option>
            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
            <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
        </select>
    </div>

    <!-- FILTER TYPE -->
    <div class="col-md-3">
        <select name="type" class="form-select">
            <option value="">-- Tất cả loại bảo trì --</option>
            <option value="PERIODIC" ${param.type == 'PERIODIC' ? 'selected' : ''}>PERIODIC</option>
            <option value="REPAIR" ${param.type == 'REPAIR' ? 'selected' : ''}>REPAIR</option>
            <option value="INSPECTION" ${param.type == 'INSPECTION' ? 'selected' : ''}>INSPECTION</option>
        </select>
    </div>

    <div class="col-md-2">
        <button class="btn btn-primary w-100">Lọc</button>
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
            <td colspan="6" class="text-center text-muted">
                Không có công việc nào được giao
            </td>
        </tr>
    </c:if>

    <c:forEach items="${tasks}" var="t">
        <tr>
            <td>${t.productSerialNumber}</td>
            <td>${t.productName}</td>
            <td>${t.type}</td>

            <!-- TRẠNG THÁI (CHỈ HIỂN THỊ) -->
            <td>
                <span class="badge
                    ${t.status == 'COMPLETED' ? 'bg-success' :
                      t.status == 'SCHEDULED' ? 'bg-warning' : 'bg-secondary'}">
                        ${t.status}
                </span>
            </td>

            <td>${t.createdAt}</td>

            <!-- HÀNH ĐỘNG -->


                <!-- REPAIR: BÁO CÁO -->
                <td>
                    <a class="btn btn-sm btn-primary"
                       href="<c:url value='/technical/task-detail?id=${t.id}'/>">
                        Chi tiết
                    </a>

                    <c:if test="${t.status != 'COMPLETED' && t.status != 'CANCELLED'}">
                        <a class="btn btn-sm btn-warning"
                           href="<c:url value='/technical/repair-report?id=${t.id}'/>">
                            Báo giá / vật tư
                        </a>
                    </c:if>

                    <c:if test="${t.status == 'SCHEDULED'}">
                        <form method="post"
                              action="<c:url value='/technical/task-complete'/>"
                              style="display:inline;">
                            <input type="hidden" name="id" value="${t.id}" />
                            <button type="submit"
                                    class="btn btn-sm btn-success"
                                    onclick="return confirm('Xác nhận hoàn thành công việc?')">
                                Hoàn thành
                            </button>
                        </form>
                    </c:if>
                </td>

        </tr>
    </c:forEach>

    </tbody>
</table>

<c:if test="${totalPages > 1}">
    <nav>
        <ul class="pagination justify-content-center">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${currentPage - 1}&status=${param.status}&type=${param.type}">
                    «
                </a>
            </li>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="?page=${i}&status=${param.status}&type=${param.type}">
                            ${i}
                    </a>
                </li>
            </c:forEach>

            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${currentPage + 1}&status=${param.status}&type=${param.type}">
                    »
                </a>
            </li>
        </ul>
    </nav>
</c:if>
