<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="fw-bold mb-0">Report D - Quản lý máy &amp; tài sản</h3>
            <div class="text-muted small">Asset lifecycle: warranty (contract end), incidents, maintenance, cost</div>
        </div>
        <a class="btn btn-light border" href="${pageContext.request.contextPath}/manager/home">Về dashboard</a>
    </div>

    <!-- Filter -->
    <form class="row g-2 align-items-end mb-4" method="get" action="${pageContext.request.contextPath}/manager/reports/assets">

        <div class="col-md-4">
            <label class="form-label small text-muted mb-1">Keyword</label>
            <input class="form-control" name="keyword" value="${filter.keyword}"
                   placeholder="serial / model / brand / customer / location"/>
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Status</label>
            <select class="form-select" name="status">
                <option value="ALL" ${empty filter.status || filter.status == 'ALL' ? 'selected' : ''}>ALL</option>
                <option value="RUNNING" ${filter.status == 'RUNNING' ? 'selected' : ''}>RUNNING</option>
                <option value="MAINTENANCE" ${filter.status == 'MAINTENANCE' ? 'selected' : ''}>MAINTENANCE</option>
                <option value="BROKEN" ${filter.status == 'BROKEN' ? 'selected' : ''}>BROKEN</option>
                <option value="RECEIVED_QUOTE" ${filter.status == 'RECEIVED_QUOTE' ? 'selected' : ''}>RECEIVED_QUOTE</option>
                <option value="READY" ${filter.status == 'READY' ? 'selected' : ''}>READY</option>
                <option value="REPAIRING" ${filter.status == 'REPAIRING' ? 'selected' : ''}>REPAIRING</option>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Warranty</label>
            <select class="form-select" name="warrantyScope">
                <option value="" ${empty filter.warrantyScope ? 'selected' : ''}>ALL</option>
                <option value="EXPIRING_30" ${filter.warrantyScope == 'EXPIRING_30' ? 'selected' : ''}>
                    Sắp hết bảo hành (30 ngày) (theo end_date hợp đồng)
                </option>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Total cost (all-time)</label>
            <select class="form-select" name="costBucket">
                <option value="" ${empty filter.costBucket ? 'selected' : ''}>ALL</option>
                <option value="LT_500K" ${filter.costBucket == 'LT_500K' ? 'selected' : ''}>&lt; 500.000</option>
                <option value="500K_1M" ${filter.costBucket == '500K_1M' ? 'selected' : ''}>500.000 - 1.000.000</option>
                <option value="1M_2M" ${filter.costBucket == '1M_2M' ? 'selected' : ''}>1.000.000 - 2.000.000</option>
                <option value="GE_2M" ${filter.costBucket == 'GE_2M' ? 'selected' : ''}>&ge; 2.000.000</option>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Last PERIODIC</label>
            <select class="form-select" name="periodicScope">
                <option value="" ${empty filter.periodicScope ? 'selected' : ''}>ALL</option>
                <option value="HAS" ${filter.periodicScope == 'HAS' ? 'selected' : ''}>Có Last Periodic</option>
                <option value="NONE" ${filter.periodicScope == 'NONE' ? 'selected' : ''}>Không có Last Periodic</option>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Year</label>
            <input class="form-control" type="number" name="year" value="${filter.manufactureYear}" placeholder="VD: 2002"/>
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Customer</label>
            <select class="form-select" name="customerId">
                <option value="">-- ALL --</option>
                <c:if test="${not empty customers}">
                    <c:forEach items="${customers}" var="cst">
                        <option value="${cst.id}" ${filter.customerId == cst.id ? 'selected' : ''}>${cst.name}</option>
                    </c:forEach>
                </c:if>
            </select>
            <div class="text-muted small mt-1">
                <c:if test="${empty customers}">Chưa load dropdown customers (bạn cần setAttribute "customers").</c:if>
            </div>
        </div>

        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Model</label>
            <select class="form-select" name="modelId">
                <option value="">-- ALL --</option>
                <c:if test="${not empty models}">
                    <c:forEach items="${models}" var="m">
                        <option value="${m.id}" ${filter.modelId == m.id ? 'selected' : ''}>${m.name}</option>
                    </c:forEach>
                </c:if>
            </select>
            <div class="text-muted small mt-1">
                <c:if test="${empty models}">Chưa load dropdown models (bạn cần setAttribute "models").</c:if>
            </div>
        </div>

        <div class="col-md-2 d-grid">
            <button class="btn btn-primary" type="submit">Lọc</button>
        </div>
        <div class="col-md-1 d-grid">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/manager/reports/assets">Reset</a>
        </div>
    </form>

    <!-- KPI -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Tổng số máy</div>
                <div class="fs-3 fw-bold">${kpi.totalAssets}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Sắp hết bảo hành (30 ngày)</div>
                <div class="fs-3 fw-bold text-warning">${kpi.expiringWarranty30}</div>
                <div class="text-muted small">Theo contracts.end_date</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Máy lỗi/bảo trì</div>
                <div class="fs-3 fw-bold text-danger">${kpi.brokenOrProblemAssets}</div>
                <div class="text-muted small">MAINTENANCE (Phase 1)</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 shadow-sm h-100">
                <div class="text-muted small">Lâu chưa PM (heuristic)</div>
                <div class="fs-3 fw-bold">${kpi.overduePmAssets}</div>
                <div class="text-muted small">Last PERIODIC &gt; 60 ngày hoặc chưa từng PM</div>
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="card p-3 shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <div class="fw-bold">Danh sách máy</div>
            <div class="text-muted small">Total: ${total}</div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Serial</th>
                    <th>Brand</th>
                    <th>Model</th>
                    <th class="text-end">kVA</th>
                    <th>Year</th>
                    <th>Customer</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th class="text-end">Hours</th>
                    <th>Warranty end</th>
                    <th class="text-end">Incidents (90d)</th>
                    <th>Last PM</th>
                    <th class="text-end">Total cost</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${rows}" var="r">
                    <tr>
                        <td>${r.productId}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/reports/assets/detail?id=${r.productId}">
                                    ${r.serialNumber}
                            </a>
                        </td>
                        <td><c:out value="${r.brandName}" default="-" /></td>
                        <td><c:out value="${r.modelName}" default="-" /></td>

                        <td class="text-end">
                            <c:choose>
                                <c:when test="${not empty r.modelPowerKva}">
                                    <fmt:formatNumber value="${r.modelPowerKva}" maxFractionDigits="1"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td><c:out value="${r.manufactureYear}" default="-" /></td>
                        <td><c:out value="${r.customerName}" default="-" /></td>
                        <td><c:out value="${r.currentLocation}" default="-" /></td>

                        <td><span class="badge bg-secondary">${r.status}</span></td>

                        <td class="text-end">
                            <c:choose>
                                <c:when test="${not empty r.totalRunningHours}">
                                    <fmt:formatNumber value="${r.totalRunningHours}" maxFractionDigits="1"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${not empty r.warrantyEndDate}">
                                    <fmt:formatDate value="${r.warrantyEndDate}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-end">${r.incidents90d}</td>

                        <td>
                            <c:choose>
                                <c:when test="${not empty r.lastPeriodicDate}">
                                    <fmt:formatDate value="${r.lastPeriodicDate}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-end">
                            <fmt:formatNumber value="${r.totalCostAllTime}" type="number" maxFractionDigits="0"/>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty rows}">
                    <tr><td colspan="14" class="text-center text-muted py-4">Không có dữ liệu</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination window 10 -->
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

            <c:set var="baseUrl" value="${pageContext.request.contextPath}/manager/reports/assets" />

            <nav class="d-flex justify-content-end">
                <ul class="pagination mb-0 flex-wrap">

                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${baseUrl}?page=1
               &keyword=${filter.keyword}
               &status=${filter.status}
               &warrantyScope=${filter.warrantyScope}
               &costBucket=${filter.costBucket}
               &periodicScope=${filter.periodicScope}
               &year=${filter.manufactureYear}
               &customerId=${filter.customerId}
               &modelId=${filter.modelId}">«</a>
                    </li>

                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${baseUrl}?page=${page-1}
               &keyword=${filter.keyword}
               &status=${filter.status}
               &warrantyScope=${filter.warrantyScope}
               &costBucket=${filter.costBucket}
               &periodicScope=${filter.periodicScope}
               &year=${filter.manufactureYear}
               &customerId=${filter.customerId}
               &modelId=${filter.modelId}">‹</a>
                    </li>

                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                        <li class="page-item ${p == page ? 'active' : ''}">
                            <a class="page-link"
                               href="${baseUrl}?page=${p}
                 &keyword=${filter.keyword}
                 &status=${filter.status}
                 &warrantyScope=${filter.warrantyScope}
                 &costBucket=${filter.costBucket}
                 &periodicScope=${filter.periodicScope}
                 &year=${filter.manufactureYear}
                 &customerId=${filter.customerId}
                 &modelId=${filter.modelId}">${p}</a>
                        </li>
                    </c:forEach>

                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${baseUrl}?page=${page+1}
               &keyword=${filter.keyword}
               &status=${filter.status}
               &warrantyScope=${filter.warrantyScope}
               &costBucket=${filter.costBucket}
               &periodicScope=${filter.periodicScope}
               &year=${filter.manufactureYear}
               &customerId=${filter.customerId}
               &modelId=${filter.modelId}">›</a>
                    </li>

                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${baseUrl}?page=${totalPages}
               &keyword=${filter.keyword}
               &status=${filter.status}
               &warrantyScope=${filter.warrantyScope}
               &costBucket=${filter.costBucket}
               &periodicScope=${filter.periodicScope}
               &year=${filter.manufactureYear}
               &customerId=${filter.customerId}
               &modelId=${filter.modelId}">»</a>
                    </li>

                </ul>
            </nav>
        </c:if>

    </div>
</div>