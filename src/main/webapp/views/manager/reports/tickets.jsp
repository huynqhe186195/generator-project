<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="fw-bold mb-0"><i class="fa fa-wrench me-2"></i>Report B - Quản lý ticket sửa chữa</h3>
            <div class="text-muted small">
                Search theo: Serial / Model / Khách hàng / Kỹ thuật viên / Tiêu đề / Contract input
            </div>
        </div>
        <a class="btn btn-light border" href="${pageContext.request.contextPath}/manager/home">
            <i class="fa fa-arrow-left me-2"></i>Về dashboard
        </a>
    </div>

    <!-- Filter -->
    <form class="row g-2 align-items-end mb-4" method="get" action="${pageContext.request.contextPath}/manager/reports/tickets">
        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Keyword</label>
            <input class="form-control" name="keyword" value="${filter.keyword}" placeholder="VD: SN-2026-998 / Nguyễn Quang Huy / Lê Kỹ Thuật / Honda..." />
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">From</label>
            <input type="date" class="form-control" name="from" value="${filter.from}" />
        </div>
        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">To</label>
            <input type="date" class="form-control" name="to" value="${filter.to}" />
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Status</label>
            <select class="form-select" name="status">
                <option value="ALL" ${empty filter.status || filter.status == 'ALL' ? 'selected' : ''}>ALL</option>
                <option value="NEW" ${filter.status == 'NEW' ? 'selected' : ''}>NEW</option>
                <option value="VERIFYING" ${filter.status == 'VERIFYING' ? 'selected' : ''}>VERIFYING</option>
                <option value="WAITING_MANAGER" ${filter.status == 'WAITING_MANAGER' ? 'selected' : ''}>WAITING_MANAGER</option>
                <option value="APPROVED" ${filter.status == 'APPROVED' ? 'selected' : ''}>APPROVED</option>
                <option value="IN_PROGRESS" ${filter.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                <option value="COMPLETED" ${filter.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                <option value="REJECTED" ${filter.status == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
            </select>
        </div>

        <div class="col-md-1">
            <label class="form-label small text-muted mb-1">Priority</label>
            <select class="form-select" name="priority">
                <option value="ALL" ${empty filter.priority || filter.priority == 'ALL' ? 'selected' : ''}>ALL</option>
                <option value="LOW" ${filter.priority == 'LOW' ? 'selected' : ''}>LOW</option>
                <option value="MEDIUM" ${filter.priority == 'MEDIUM' ? 'selected' : ''}>MEDIUM</option>
                <option value="HIGH" ${filter.priority == 'HIGH' ? 'selected' : ''}>HIGH</option>
                <option value="CRITICAL" ${filter.priority == 'CRITICAL' ? 'selected' : ''}>CRITICAL</option>
            </select>
        </div>

        <div class="col-md-2 d-grid">
            <button class="btn btn-primary" type="submit"><i class="fa fa-filter me-2"></i>Lọc</button>
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Khách hàng</label>
            <select class="form-select" name="customerId">
                <option value="">-- ALL --</option>
                <c:forEach items="${customers}" var="cst">
                    <option value="${cst.id}" ${filter.customerId == cst.id ? 'selected' : ''}>${cst.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Kỹ thuật viên</label>
            <select class="form-select" name="technicianId">
                <option value="">-- ALL --</option>
                <c:forEach items="${technicians}" var="t">
                    <option value="${t.id}" ${filter.technicianId == t.id ? 'selected' : ''}>${t.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Model máy</label>
            <select class="form-select" name="modelId">
                <option value="">-- ALL --</option>
                <c:forEach items="${models}" var="m">
                    <option value="${m.id}" ${filter.modelId == m.id ? 'selected' : ''}>${m.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-1 d-grid">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/manager/reports/tickets"><i class="fa fa-rotate-left"></i></a>
        </div>
    </form>

    <!-- KPI -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Tổng ticket</div>
                <div class="fs-3 fw-bold">${kpiTotal}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Ticket đang mở</div>
                <div class="fs-3 fw-bold">${kpiOpen}</div>
                <div class="text-muted small">Không gồm COMPLETED/REJECTED</div>
            </div>
        </div>
    </div>

    <!-- Breakdown -->
    <div class="row g-3 mb-4">
        <div class="col-md-6">
            <div class="card p-3 shadow-sm h-100">
                <div class="fw-bold mb-2">Ticket theo trạng thái</div>
                <table class="table table-sm mb-0">
                    <thead>
                    <tr>
                        <th>Status</th>
                        <th class="text-end">Count</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${byStatus}" var="e">
                        <tr>
                            <td>${e.key}</td>
                            <td class="text-end">${e.value}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card p-3 shadow-sm h-100">
                <div class="fw-bold mb-2">Ticket theo ưu tiên</div>
                <table class="table table-sm mb-0">
                    <thead>
                    <tr>
                        <th>Priority</th>
                        <th class="text-end">Count</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${byPriority}" var="e">
                        <tr>
                            <td>${e.key}</td>
                            <td class="text-end">${e.value}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- List -->
    <div class="card p-3 shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <div class="fw-bold">Danh sách ticket</div>
            <div class="text-muted small">Total: ${total}</div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Tiêu đề</th>
                    <th>Serial</th>
                    <th>Model</th>
                    <th>Khách hàng</th>
                    <th>Kỹ thuật viên</th>
                    <th>Status</th>
                    <th>Priority</th>
                    <th>Created</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${tickets}" var="t">
                    <tr>
                        <td>${t.id}</td>
                        <td>${t.title}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty t.serialNumber}">${t.serialNumber}</c:when>
                                <c:when test="${not empty t.inputSerialNumber}">
                                    <span class="text-muted">${t.inputSerialNumber}</span>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${t.modelName}" default="-" /></td>
                        <td><c:out value="${t.customerName}" default="-" /></td>
                        <td><c:out value="${t.technicianName}" default="-" /></td>
                        <td><span class="badge bg-secondary">${t.status}</span></td>
                        <td><span class="badge bg-dark">${t.priority}</span></td>
                        <td><fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty tickets}">
                    <tr>
                        <td colspan="9" class="text-center text-muted py-4">Không có dữ liệu</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <c:set var="windowSize" value="10" />
            <c:set var="halfLeft" value="4" />
            <c:set var="halfRight" value="5" />

            <!-- startPage/endPage computed -->
            <c:choose>
                <c:when test="${totalPages <= windowSize}">
                    <c:set var="startPage" value="1" />
                    <c:set var="endPage" value="${totalPages}" />
                </c:when>

                <c:when test="${page <= 5}">
                    <c:set var="startPage" value="1" />
                    <c:set var="endPage" value="${windowSize}" />
                </c:when>

                <c:when test="${page >= (totalPages - 4)}">
                    <c:set var="startPage" value="${totalPages - (windowSize - 1)}" />
                    <c:set var="endPage" value="${totalPages}" />
                </c:when>

                <c:otherwise>
                    <c:set var="startPage" value="${page - halfLeft}" />
                    <c:set var="endPage" value="${page + halfRight}" />
                </c:otherwise>
            </c:choose>

            <nav class="d-flex justify-content-end">
                <ul class="pagination mb-0 flex-wrap">
                    <!-- First -->
                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/tickets?page=1
                   &from=${filter.from}&to=${filter.to}
                   &status=${filter.status}&priority=${filter.priority}
                   &keyword=${filter.keyword}
                   &customerId=${filter.customerId}
                   &technicianId=${filter.technicianId}
                   &modelId=${filter.modelId}">
                            «
                        </a>
                    </li>

                    <!-- Prev -->
                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/tickets?page=${page-1}
                   &from=${filter.from}&to=${filter.to}
                   &status=${filter.status}&priority=${filter.priority}
                   &keyword=${filter.keyword}
                   &customerId=${filter.customerId}
                   &technicianId=${filter.technicianId}
                   &modelId=${filter.modelId}">
                            ‹
                        </a>
                    </li>

                    <!-- Pages window -->
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                        <li class="page-item ${p == page ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/manager/reports/tickets?page=${p}
                       &from=${filter.from}&to=${filter.to}
                       &status=${filter.status}&priority=${filter.priority}
                       &keyword=${filter.keyword}
                       &customerId=${filter.customerId}
                       &technicianId=${filter.technicianId}
                       &modelId=${filter.modelId}">
                                    ${p}
                            </a>
                        </li>
                    </c:forEach>

                    <!-- Next -->
                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/tickets?page=${page+1}
                   &from=${filter.from}&to=${filter.to}
                   &status=${filter.status}&priority=${filter.priority}
                   &keyword=${filter.keyword}
                   &customerId=${filter.customerId}
                   &technicianId=${filter.technicianId}
                   &modelId=${filter.modelId}">
                            ›
                        </a>
                    </li>

                    <!-- Last -->
                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/tickets?page=${totalPages}
                   &from=${filter.from}&to=${filter.to}
                   &status=${filter.status}&priority=${filter.priority}
                   &keyword=${filter.keyword}
                   &customerId=${filter.customerId}
                   &technicianId=${filter.technicianId}
                   &modelId=${filter.modelId}">
                            »
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>