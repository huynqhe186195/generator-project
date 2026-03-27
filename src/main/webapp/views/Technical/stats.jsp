<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="totalTasks" value="${stats.totalTasks}" />
<c:set var="completedPercent" value="${totalTasks > 0 ? (stats.completedTasks * 100.0 / totalTasks) : 0}" />
<c:set var="scheduledPercent" value="${totalTasks > 0 ? (stats.scheduledTasks * 100.0 / totalTasks) : 0}" />
<c:set var="cancelledPercent" value="${totalTasks > 0 ? (stats.cancelledTasks * 100.0 / totalTasks) : 0}" />

<c:set var="repairPercent" value="${totalTasks > 0 ? (stats.repairTasks * 100.0 / totalTasks) : 0}" />
<c:set var="periodicPercent" value="${totalTasks > 0 ? (stats.periodicTasks * 100.0 / totalTasks) : 0}" />
<c:set var="inspectionPercent" value="${totalTasks > 0 ? (stats.inspectionTasks * 100.0 / totalTasks) : 0}" />

<style>
    .stats-card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 0.25rem 1rem rgba(0,0,0,.06);
    }

    .stats-value {
        font-size: 2rem;
        font-weight: 700;
        line-height: 1.1;
    }

    .stats-label {
        color: #6c757d;
        font-size: .95rem;
        margin-bottom: .35rem;
    }

    .section-card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 0.25rem 1rem rgba(0,0,0,.06);
    }

    .section-title {
        font-size: 1rem;
        font-weight: 700;
    }

    .mini-kpi {
        border-radius: 14px;
        background: #f8f9fa;
        padding: 14px 16px;
        height: 100%;
    }

    .mini-kpi .value {
        font-size: 1.5rem;
        font-weight: 700;
    }

    .table thead th {
        vertical-align: middle;
        white-space: nowrap;
    }

    .progress {
        height: 12px;
        border-radius: 999px;
        background-color: #edf0f2;
    }

    .chart-label {
        min-width: 110px;
        font-weight: 600;
    }

    .money-text {
        font-weight: 700;
        color: #198754;
    }

    .soft-badge {
        display: inline-block;
        padding: .35rem .7rem;
        border-radius: 999px;
        font-size: .8rem;
        font-weight: 600;
    }

    .soft-success { background: #d1e7dd; color: #0f5132; }
    .soft-warning { background: #fff3cd; color: #664d03; }
    .soft-danger  { background: #f8d7da; color: #842029; }
    .soft-primary { background: #cfe2ff; color: #084298; }
    .soft-info    { background: #cff4fc; color: #055160; }
    .soft-secondary { background: #e2e3e5; color: #41464b; }
</style>

<div class="container-fluid px-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">📊 Thống kê của tôi</h4>
        <span class="soft-badge soft-primary">Dashboard kỹ thuật</span>
    </div>

    <!-- TỔNG QUAN -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card stats-card h-100">
                <div class="card-body">
                    <div class="stats-label">Tổng công việc</div>
                    <div class="stats-value">${stats.totalTasks}</div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stats-card h-100">
                <div class="card-body">
                    <div class="stats-label">Đang chờ xử lý</div>
                    <div class="stats-value text-warning">${stats.scheduledTasks}</div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stats-card h-100">
                <div class="card-body">
                    <div class="stats-label">Đã hoàn thành</div>
                    <div class="stats-value text-success">${stats.completedTasks}</div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stats-card h-100">
                <div class="card-body">
                    <div class="stats-label">Đã hủy</div>
                    <div class="stats-value text-danger">${stats.cancelledTasks}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- TIẾN ĐỘ / CƠ CẤU -->
    <div class="row g-3 mb-4">
        <div class="col-lg-6">
            <div class="card section-card h-100">
                <div class="card-body">
                    <div class="section-title mb-4">📌 Cơ cấu trạng thái công việc</div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="chart-label">Hoàn thành</span>
                            <span><fmt:formatNumber value="${completedPercent}" maxFractionDigits="1"/>% (${stats.completedTasks})</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-success" style="width: ${completedPercent}%"></div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="chart-label">Đang chờ</span>
                            <span><fmt:formatNumber value="${scheduledPercent}" maxFractionDigits="1"/>% (${stats.scheduledTasks})</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-warning" style="width: ${scheduledPercent}%"></div>
                        </div>
                    </div>

                    <div>
                        <div class="d-flex justify-content-between mb-1">
                            <span class="chart-label">Đã hủy</span>
                            <span><fmt:formatNumber value="${cancelledPercent}" maxFractionDigits="1"/>% (${stats.cancelledTasks})</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-danger" style="width: ${cancelledPercent}%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card section-card h-100">
                <div class="card-body">
                    <div class="section-title mb-4">🛠 Cơ cấu loại công việc</div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="chart-label">REPAIR</span>
                            <span><fmt:formatNumber value="${repairPercent}" maxFractionDigits="1"/>% (${stats.repairTasks})</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-primary" style="width: ${repairPercent}%"></div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="chart-label">PERIODIC</span>
                            <span><fmt:formatNumber value="${periodicPercent}" maxFractionDigits="1"/>% (${stats.periodicTasks})</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-info" style="width: ${periodicPercent}%"></div>
                        </div>
                    </div>

                    <div>
                        <div class="d-flex justify-content-between mb-1">
                            <span class="chart-label">INSPECTION</span>
                            <span><fmt:formatNumber value="${inspectionPercent}" maxFractionDigits="1"/>% (${stats.inspectionTasks})</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-secondary" style="width: ${inspectionPercent}%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- KPI THÁNG / CHI PHÍ -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="mini-kpi">
                <div class="text-muted mb-1">Công việc tháng này</div>
                <div class="value">${stats.tasksThisMonth}</div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="mini-kpi">
                <div class="text-muted mb-1">Hoàn thành tháng này</div>
                <div class="value text-success">${stats.completedThisMonth}</div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="mini-kpi">
                <div class="text-muted mb-1">Máy đã xử lý</div>
                <div class="value">${stats.distinctProducts}</div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="mini-kpi">
                <div class="text-muted mb-1">Số loại vật tư</div>
                <div class="value">${stats.distinctSpareParts}</div>
            </div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card stats-card h-100">
                <div class="card-body">
                    <div class="stats-label">Tổng chi phí tất cả job</div>
                    <div class="fs-4 fw-bold">
                        <fmt:formatNumber value="${stats.totalAllTaskCost}" type="number"/> đ
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card stats-card h-100">
                <div class="card-body">
                    <div class="stats-label">Chi phí job hoàn thành</div>
                    <div class="fs-4 fw-bold text-success">
                        <fmt:formatNumber value="${stats.totalCompletedCost}" type="number"/> đ
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card stats-card h-100">
                <div class="card-body">
                    <div class="stats-label">Tổng chi phí vật tư</div>
                    <div class="fs-4 fw-bold text-primary">
                        <fmt:formatNumber value="${stats.totalMaterialCost}" type="number"/> đ
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- VẬT TƯ -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="mini-kpi">
                <div class="text-muted mb-1">Tổng số vật tư đã dùng</div>
                <div class="value">${stats.totalMaterialQuantity}</div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card section-card h-100">
                <div class="card-body">
                    <div class="section-title mb-3">🔧 Top 5 vật tư dùng nhiều nhất</div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Tên vật tư</th>
                                <th>Mã</th>
                                <th>Tổng số lượng</th>
                                <th>Tổng chi phí</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${empty topParts}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted">Chưa có dữ liệu vật tư</td>
                                </tr>
                            </c:if>

                            <c:forEach items="${topParts}" var="p" varStatus="st">
                                <tr>
                                    <td>${st.index + 1}</td>
                                    <td class="fw-semibold">${p.sparePartName}</td>
                                    <td>${p.partCode}</td>
                                    <td>${p.totalQuantityUsed}</td>
                                    <td><fmt:formatNumber value="${p.totalCost}" type="number"/> đ</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- RECENT COMPLETED -->
    <div class="card section-card">
        <div class="card-body">
            <div class="section-title mb-3">✅ 5 công việc hoàn thành gần đây</div>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Serial</th>
                        <th>Tên máy</th>
                        <th>Ngày bảo trì</th>
                        <th>Loại</th>
                        <th>Chi phí</th>
                        <th>Hoàn thành lúc</th>
                        <th>Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty recentCompleted}">
                        <tr>
                            <td colspan="7" class="text-center text-muted">Chưa có công việc hoàn thành</td>
                        </tr>
                    </c:if>

                    <c:forEach items="${recentCompleted}" var="t">
                        <tr>
                            <td>${t.productSerialNumber}</td>
                            <td class="fw-semibold">${t.productName}</td>
                            <td>
                                <fmt:formatDate value="${t.maintenanceDate}" pattern="dd-MM-yyyy"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${t.type == 'REPAIR'}">
                                        <span class="soft-badge soft-primary">REPAIR</span>
                                    </c:when>
                                    <c:when test="${t.type == 'PERIODIC'}">
                                        <span class="soft-badge soft-info">PERIODIC</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="soft-badge soft-secondary">INSPECTION</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="money-text">
                                <fmt:formatNumber value="${t.totalCost}" type="number"/> đ
                            </td>
                            <td>
                                <c:if test="${not empty t.completedAt}">
                                    <fmt:formatDate value="${t.completedAt}" pattern="dd-MM-yyyy HH:mm:ss"/>
                                </c:if>
                            </td>
                            <td>
                                <a class="btn btn-sm btn-outline-primary"
                                   href="<c:url value='/technical/task-detail?id=${t.id}'/>">
                                    Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>