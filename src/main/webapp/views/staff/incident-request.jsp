<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="me" value="${sessionScope.USERMODEL}"/>

<title>Danh sách yêu cầu bảo trì</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Quản lý Yêu cầu Bảo trì</h3>

    </div>

    <div class="card shadow mb-4 border-0">
        <div class="card-body bg-light rounded">
            <form action="<c:url value='/staff/incident-list'/>" method="get" class="row g-3">

                <div class="col-md-2">
                    <label class="form-label small text-muted mb-1">Từ ngày:</label>
                    <input type="date" name="fromDate" value="${param.fromDate}" class="form-control">
                </div>

                <div class="col-md-2">
                    <label class="form-label small text-muted mb-1">Đến ngày:</label>
                    <input type="date" name="toDate" value="${param.toDate}" class="form-control">
                </div>
                <%--                <div class="col-md-3">--%>
                <%--                    <label class="form-label small text-muted mb-1">Mức độ:</label>--%>
                <%--                    <select class="form-select" name="priority">--%>
                <%--                        <option value="">-- Tất cả --</option>--%>
                <%--                        <option value="CRITICAL" ${param.priority == 'CRITICAL' ? 'selected' : ''}>Nghiêm trọng</option>--%>
                <%--                        <option value="HIGH" ${param.priority == 'HIGH' ? 'selected' : ''}>Cao</option>--%>
                <%--                        <option value="MEDIUM" ${param.priority == 'MEDIUM' ? 'selected' : ''}>Trung bình</option>--%>
                <%--                        <option value="LOW" ${param.priority == 'LOW' ? 'selected' : ''}>Thấp</option>--%>
                <%--                    </select>--%>
                <%--                </div>--%>

                <div class="col-md-3">
                    <label class="form-label small text-muted mb-1">Trạng thái:</label>
                    <select class="form-select" name="status">
                        <option value="">-- Tất cả --</option>
                        <option value="NEW" ${param.status == 'NEW' ? 'selected' : ''}>Mới</option>
                        <option value="ASSIGNED" ${param.status == 'ASSIGNED' ? 'selected' : ''}>Đã giao</option>
                        <option value="IN_PROGRESS" ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>Đang xử lý
                        </option>
                        <option value="RESOLVED" ${param.status == 'RESOLVED' ? 'selected' : ''}>Hoàn thành</option>
                    </select>
                </div>

                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-secondary w-100">
                        <i class="fas fa-filter me-2"></i> Lọc
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light text-secondary">
                    <tr>
                        <th class="py-3 ps-4">#</th>
                        <th class="py-3">Thông tin sự cố / Thiết bị</th>
                        <th class="py-3">Người báo cáo</th>
                        <th class="py-3">Ngày tạo</th>
                        <%--                        <th class="py-3">Mức độ</th>--%>
                        <th class="py-3">Trạng thái</th>
                        <th class="py-3 text-end pe-4">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listIncidents}" var="inc" varStatus="loop">
                        <tr>
                            <td class="ps-4">${(currentPage - 1) * 10 + loop.index + 1}</td>

                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded p-2 me-3 d-flex align-items-center justify-content-center"
                                         style="width: 40px; height: 40px;">
                                        <i class="fas fa-cogs text-secondary"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-truncate" style="max-width: 200px;"
                                             title="${inc.title}">
                                                ${inc.title}
                                        </div>
                                        <small class="text-muted">
                                            Máy: ${inc.productName}
                                        </small>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <a href="<c:url value='/staff/user-information?id=${inc.reportedBy}'/>" class="user-link"
                                   title="Xem hồ sơ">
                                        ${inc.reporterName}
                                </a>
                                    <%--                                <small class="text-muted">ID: ${inc.reportedBy}</small>--%>
                            </td>

                            <td>
                                <small class="text-secondary">
                                    <fmt:formatDate value="${inc.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </small>
                            </td>

                                <%--                            <td>--%>
                                <%--                                <c:choose>--%>
                                <%--                                    <c:when test="${inc.priority == 'CRITICAL'}">--%>
                                <%--                                        <span class="badge bg-dark"><i class="fas fa-exclamation-triangle"></i> NGUY HIỂM</span>--%>
                                <%--                                    </c:when>--%>
                                <%--                                    <c:when test="${inc.priority == 'HIGH'}">--%>
                                <%--                                        <span class="badge bg-danger">CAO</span>--%>
                                <%--                                    </c:when>--%>
                                <%--                                    <c:when test="${inc.priority == 'MEDIUM'}">--%>
                                <%--                                        <span class="badge bg-warning text-dark">TBÌNH</span>--%>
                                <%--                                    </c:when>--%>
                                <%--                                    <c:otherwise>--%>
                                <%--                                        <span class="badge bg-info text-dark">THẤP</span>--%>
                                <%--                                    </c:otherwise>--%>
                                <%--                                </c:choose>--%>
                                <%--                            </td>--%>

                            <td>
                                <c:choose>
                                    <c:when test="${inc.status == 'NEW'}">
                                            <span class="badge bg-success rounded-pill">
                                                <i class="fas fa-star me-1"></i> Mới
                                            </span>
                                    </c:when>
                                    <c:when test="${inc.status == 'ASSIGNED'}">
                                        <span class="badge bg-primary rounded-pill">
                                            <i class="fas fa-user-check me-1"></i> Đã giao
                                        </span>
                                        <br>
                                        <small class="text-muted" style="font-size: 0.75rem">
                                            Tech:
                                            <a href="<c:url value='/staff/user-information?id=${inc.technicianId}'/>"
                                               class="user-link">
                                                    ${inc.technicianName}
                                            </a>
                                        </small>
                                    </c:when>

                                    <c:when test="${inc.status == 'IN_PROGRESS'}">
                                        <span class="badge bg-warning text-dark rounded-pill">
                                            <i class="fas fa-tools me-1"></i> Đang xử lý
                                        </span>
                                        <br>
                                        <small class="text-muted" style="font-size: 0.75rem">
                                            Tech:
                                            <a href="<c:url value='/staff/user-information?id=${inc.technicianId}'/>"
                                               class="user-link">
                                                    ${inc.technicianName}
                                            </a>
                                        </small>
                                    </c:when>
                                    <c:when test="${inc.status == 'RESOLVED'}">
                                            <span class="badge bg-secondary rounded-pill">
                                                <i class="fas fa-check-circle me-1"></i> Hoàn thành
                                            </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-dark rounded-pill">${inc.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td class="text-end pe-4">
                                <div class="d-flex gap-1 justify-content-end">
                                    <a href="<c:url value='/staff/incident/detail?id=${inc.id}'/>"
                                       class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <c:if test="${inc.status == 'NEW'}">
                                        <button type="button"
                                                class="btn btn-sm btn-success"
                                                title="Giao việc cho kỹ thuật viên"
                                                onclick="openAssignModal(${inc.id}, '${inc.title}')">
                                            <i class="fas fa-tools"></i> Giao việc
                                        </button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty listIncidents}">
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="fas fa-clipboard-list fa-3x mb-3 text-gray-300"></i><br>
                                Hiện chưa có yêu cầu nào.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card-footer bg-white py-3">
            <c:if test="${totalPages > 0}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-end mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="<c:url value='/staff/incident-list?page=${currentPage - 1}&fromDate=${param.fromDate}&toDate=${param.toDate}&status=${param.status}'/>">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link"
                                   href="<c:url value='/staff/incident-list?page=${i}&fromDate=${param.fromDate}&toDate=${param.toDate}&status=${param.status}'/>">
                                        ${i}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="<c:url value='/staff/incident-list?page=${currentPage + 1}&fromDate=${param.fromDate}&toDate=${param.toDate}&status=${param.status}'/>">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>

<div class="modal fade" id="assignModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<c:url value='/assign-technician'/>" method="POST">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="fas fa-tools me-2"></i>Giao việc & Tạo phiếu bảo trì</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="incident_id" id="modalIncidentId" />

                    <div class="mb-3">
                        <label class="form-label fw-bold">Sự cố đang xử lý:</label>
                        <input type="text" class="form-control bg-light" id="modalIncidentTitle" readonly />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Chọn Kỹ thuật viên <span class="text-danger">*</span>:</label>
                        <select name="technician_id" class="form-select" required>
                            <option value="">-- Chọn nhân viên --</option>
                            <c:forEach items="${listTechnicians}" var="tech">
                                <option value="${tech.id}">
                                        ${tech.fullName} - ${tech.email}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Loại hình bảo trì <span class="text-danger">*</span>:</label>
                        <select name="type" class="form-select" required>
                            <option value="REPAIR">Sửa chữa (REPAIR)</option>
                            <option value="INSPECTION">Kiểm tra (INSPECTION)</option>
                            <option value="PERIODIC">Bảo trì định kỳ (PERIODIC)</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Mô tả công việc / Ghi chú:</label>
                        <textarea name="description" class="form-control" rows="4"
                                  placeholder="Nhập hướng dẫn xử lý hoặc ghi chú cho kỹ thuật viên..."></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane me-1"></i> Xác nhận giao việc
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openAssignModal(incidentId, incidentTitle) {
        document.getElementById('modalIncidentId').value = incidentId;
        document.getElementById('modalIncidentTitle').value = incidentTitle;
        var myModal = new bootstrap.Modal(document.getElementById('assignModal'));
        myModal.show();
    }
</script>