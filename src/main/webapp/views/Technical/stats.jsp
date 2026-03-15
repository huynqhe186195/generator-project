<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h4 class="mb-4">📊 Thống kê của tôi</h4>

<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Tổng công việc</div>
                <div class="fs-3 fw-bold">${stats.totalTasks}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Đang chờ</div>
                <div class="fs-3 fw-bold text-warning">${stats.scheduledTasks}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Đã hoàn thành</div>
                <div class="fs-3 fw-bold text-success">${stats.completedTasks}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Đã hủy</div>
                <div class="fs-3 fw-bold text-danger">${stats.cancelledTasks}</div>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">REPAIR</div>
                <div class="fs-3 fw-bold">${stats.repairTasks}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">PERIODIC</div>
                <div class="fs-3 fw-bold">${stats.periodicTasks}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">INSPECTION</div>
                <div class="fs-3 fw-bold">${stats.inspectionTasks}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Máy đã xử lý</div>
                <div class="fs-3 fw-bold">${stats.distinctProducts}</div>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Công việc tháng này</div>
                <div class="fs-3 fw-bold">${stats.tasksThisMonth}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Hoàn thành tháng này</div>
                <div class="fs-3 fw-bold text-success">${stats.completedThisMonth}</div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Tổng chi phí tất cả job</div>
                <div class="fs-5 fw-bold">
                    <fmt:formatNumber value="${stats.totalAllTaskCost}" type="number"/> đ
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Chi phí job hoàn thành</div>
                <div class="fs-5 fw-bold text-success">
                    <fmt:formatNumber value="${stats.totalCompletedCost}" type="number"/> đ
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Tổng số vật tư đã dùng</div>
                <div class="fs-3 fw-bold">${stats.totalMaterialQuantity}</div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Số loại vật tư khác nhau</div>
                <div class="fs-3 fw-bold">${stats.distinctSpareParts}</div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <div class="text-muted">Tổng chi phí vật tư</div>
                <div class="fs-5 fw-bold">
                    <fmt:formatNumber value="${stats.totalMaterialCost}" type="number"/> đ
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-header fw-bold">🔧 Top 5 vật tư dùng nhiều nhất</div>
    <div class="card-body">
        <table class="table table-bordered mb-0">
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
                    <td>${p.sparePartName}</td>
                    <td>${p.partCode}</td>
                    <td>${p.totalQuantityUsed}</td>
                    <td><fmt:formatNumber value="${p.totalCost}" type="number"/> đ</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="card shadow-sm">
    <div class="card-header fw-bold">✅ 5 công việc hoàn thành gần đây</div>
    <div class="card-body">
        <table class="table table-bordered mb-0">
            <thead class="table-light">
            <tr>
                <th>Serial</th>
                <th>Tên máy</th>
                <th>Ngày</th>
                <th>Loại</th>
                <th>Chi phí</th>
                <th>Hoàn thành lúc</th>
                <th>Chi tiết</th>

            </tr>
            </thead>
            <tbody>
            <c:if test="${empty recentCompleted}">
                <tr>
                    <td colspan="6" class="text-center text-muted">Chưa có công việc hoàn thành</td>
                </tr>
            </c:if>

            <c:forEach items="${recentCompleted}" var="t">
                <tr>
                    <td>${t.productSerialNumber}</td>
                    <td>${t.productName}</td>
                    <td>${t.maintenanceDate}</td>
                    <td>${t.type}</td>
                    <td><fmt:formatNumber value="${t.totalCost}" type="number"/> đ</td>
                    <td><fmt:formatDate value="${t.completedAt}" pattern="dd-MM-yyyy HH:mm:ss"/></td>
                    <td>
                        <a class="btn btn-sm btn-primary"
                           href="<c:url value='/technical/repair-report?id=${t.id}'/>">
                            Xem
                        </a>
                    </td>

                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>