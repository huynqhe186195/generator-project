<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="fw-bold mb-0">Report C - Bảo trì định kỳ</h3>
            <div class="text-muted small">
                Vật tư: maintenance_spare_parts | Ảnh: maintenance_images (BEFORE/AFTER)
            </div>
        </div>
        <a class="btn btn-light border" href="${pageContext.request.contextPath}/manager/home">Về dashboard</a>
    </div>

    <!-- Filter -->
    <form class="row g-2 align-items-end mb-4" method="get" action="${pageContext.request.contextPath}/manager/reports/maintenance-periodic">
        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">From</label>
            <input type="date" class="form-control" name="from" value="${filter.from}" />
        </div>
        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">To</label>
            <input type="date" class="form-control" name="to" value="${filter.to}" />
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Loại</label>
            <select class="form-select" name="only">
                <option value="" ${filter.onlyPeriodic == null ? 'selected' : ''}>ALL</option>
                <option value="PERIODIC" ${filter.onlyPeriodic != null && filter.onlyPeriodic ? 'selected' : ''}>PERIODIC</option>
                <option value="NON" ${filter.onlyPeriodic != null && !filter.onlyPeriodic ? 'selected' : ''}>NON-PERIODIC</option>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label small text-muted mb-1">Khách hàng</label>
            <select class="form-select" name="customerId">
                <option value="">-- ALL --</option>
                <c:forEach items="${customers}" var="cst">
                    <option value="${cst.id}" ${filter.customerId == cst.id ? 'selected' : ''}>${cst.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Kỹ thuật viên</label>
            <select class="form-select" name="technicianId">
                <option value="">-- ALL --</option>
                <c:forEach items="${technicians}" var="t">
                    <option value="${t.id}" ${filter.technicianId == t.id ? 'selected' : ''}>${t.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label small text-muted mb-1">Model máy</label>
            <select class="form-select" name="modelId">
                <option value="">-- ALL --</option>
                <c:forEach items="${models}" var="m">
                    <option value="${m.id}" ${filter.modelId == m.id ? 'selected' : ''}>${m.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Site (contains)</label>
            <input class="form-control" name="site" value="${filter.siteKeyword}" placeholder="VD: FPT Hòa Lạc" />
        </div>

        <div class="col-md-2 d-grid">
            <button class="btn btn-primary" type="submit">Lọc</button>
        </div>

        <div class="col-md-1 d-grid">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/manager/reports/maintenance-periodic">Reset</a>
        </div>
    </form>

    <!-- KPI cards (giống ảnh) -->
    <div class="row g-3 mb-4">
        <div class="col-md-2">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Lịch theo kế hoạch</div>
                <div class="fs-3 fw-bold">${kpi.planned}</div>
                <div class="text-muted small">PERIODIC trong khoảng</div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Đã thực hiện</div>
                <div class="fs-3 fw-bold">${kpi.done}</div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Trễ hạn</div>
                <div class="fs-3 fw-bold text-danger">${kpi.overdue}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Hủy / Dời lịch</div>
                <div class="fs-3 fw-bold">${kpi.cancelledOrRescheduled}</div>
                <div class="text-muted small">CANCELLED / RESCHEDULED</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Tỷ lệ đúng kế hoạch</div>
                <div class="fs-3 fw-bold"><fmt:formatNumber value="${kpi.onTimeRate}" maxFractionDigits="1"/>%</div>
                <div class="text-muted small">${kpi.onTimeRateNote}</div>
            </div>
        </div>
    </div>

    <!-- Breakdown -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="fw-bold mb-2">Breakdown: Type</div>
                <table class="table table-sm mb-0">
                    <thead><tr><th>Type</th><th class="text-end">Count</th></tr></thead>
                    <tbody>
                    <c:forEach items="${bdType}" var="e">
                        <tr><td>${e.key}</td><td class="text-end">${e.value}</td></tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="fw-bold mb-2">Breakdown: Công suất</div>
                <table class="table table-sm mb-0">
                    <thead><tr><th>Bucket</th><th class="text-end">Count</th></tr></thead>
                    <tbody>
                    <c:forEach items="${bdPower}" var="e">
                        <tr><td>${e.key}</td><td class="text-end">${e.value}</td></tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="fw-bold mb-2">Breakdown: Customer | Site</div>
                <table class="table table-sm mb-0">
                    <thead><tr><th>Customer | Site</th><th class="text-end">Count</th></tr></thead>
                    <tbody>
                    <c:forEach items="${bdSite}" var="e">
                        <tr><td>${e.key}</td><td class="text-end">${e.value}</td></tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="fw-bold mb-2">Breakdown: Kỹ thuật viên</div>
                <table class="table table-sm mb-0">
                    <thead><tr><th>Technician</th><th class="text-end">Count</th></tr></thead>
                    <tbody>
                    <c:forEach items="${bdTech}" var="e">
                        <tr><td>${e.key}</td><td class="text-end">${e.value}</td></tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- List -->
    <div class="card p-3 shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <div class="fw-bold">Danh sách bảo trì</div>
            <div class="text-muted small">Total: ${total}</div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Type</th>
                    <th>Ngày</th>
                    <th>Serial</th>
                    <th>Model</th>
                    <th class="text-end">kVA</th>
                    <th>Khách</th>
                    <th>Site</th>
                    <th>Tech</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Vật tư</th>
                    <th class="text-end">Ảnh</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${rows}" var="r">
                    <tr>
                        <td>${r.maintenanceId}</td>
                        <td>${r.type}</td>
                        <td>${r.maintenanceDate}</td>
                        <td>${r.serialNumber}</td>
                        <td>${r.modelName}</td>
                        <td class="text-end">
                            <c:choose>
                                <c:when test="${not empty r.modelPowerKva}">
                                    <fmt:formatNumber value="${r.modelPowerKva}" maxFractionDigits="1"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${r.customerName}" default="-" /></td>
                        <td><c:out value="${r.site}" default="-" /></td>
                        <td><c:out value="${r.technicianName}" default="-" /></td>
                        <td>
                            <span class="badge bg-secondary">${r.status}</span>
                            <div class="text-muted small">${r.scheduleStatus} / ${r.executionStatus}</div>
                        </td>
                        <td class="text-end">
                                ${r.partsQty}
                            <div class="text-muted small">
                                <fmt:formatNumber value="${r.partsValue}" type="number" maxFractionDigits="0"/>
                            </div>
                        </td>
                        <td class="text-end">
                            <div class="small">Before: ${r.beforeImages}</div>
                            <div class="small">After: ${r.afterImages}</div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty rows}">
                    <tr><td colspan="12" class="text-center text-muted py-4">Không có dữ liệu</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination window giống B (10 nút) -->
        <c:if test="${totalPages > 1}">
            <c:set var="windowSize" value="10" />
            <c:set var="halfLeft" value="4" />
            <c:set var="halfRight" value="5" />

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
                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/maintenance-periodic?page=1
                           &from=${filter.from}&to=${filter.to}&only=${param.only}&onTimeMode=${onTimeMode}
                           &customerId=${filter.customerId}&technicianId=${filter.technicianId}&modelId=${filter.modelId}
                           &site=${filter.siteKeyword}">«</a>
                    </li>
                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/maintenance-periodic?page=${page-1}
                           &from=${filter.from}&to=${filter.to}&only=${param.only}&onTimeMode=${onTimeMode}
                           &customerId=${filter.customerId}&technicianId=${filter.technicianId}&modelId=${filter.modelId}
                           &site=${filter.siteKeyword}">‹</a>
                    </li>

                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                        <li class="page-item ${p == page ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/manager/reports/maintenance-periodic?page=${p}
                               &from=${filter.from}&to=${filter.to}&only=${param.only}&onTimeMode=${onTimeMode}
                               &customerId=${filter.customerId}&technicianId=${filter.technicianId}&modelId=${filter.modelId}
                               &site=${filter.siteKeyword}">${p}</a>
                        </li>
                    </c:forEach>

                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/maintenance-periodic?page=${page+1}
                           &from=${filter.from}&to=${filter.to}&only=${param.only}&onTimeMode=${onTimeMode}
                           &customerId=${filter.customerId}&technicianId=${filter.technicianId}&modelId=${filter.modelId}
                           &site=${filter.siteKeyword}">›</a>
                    </li>
                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/manager/reports/maintenance-periodic?page=${totalPages}
                           &from=${filter.from}&to=${filter.to}&only=${param.only}&onTimeMode=${onTimeMode}
                           &customerId=${filter.customerId}&technicianId=${filter.technicianId}&modelId=${filter.modelId}
                           &site=${filter.siteKeyword}">»</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>