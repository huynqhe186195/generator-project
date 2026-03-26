<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .card-box { border: none; border-radius: 10px; transition: transform 0.3s ease-in-out; color: white; }
        .card-box:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.2) !important; }
        .icon-box { font-size: 3.5rem; opacity: 0.3; }
        a { text-decoration: none; }
    </style>
</head>
<body class="bg-light">

    <div class="container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fa fa-tachometer-alt"></i> Tổng quan hoạt động</h2>
            <a href="${pageContext.request.contextPath}/manager" class="btn btn-sm btn-outline-secondary">
                <i class="fa fa-sync-alt"></i> Cập nhật dữ liệu
            </a>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="card card-box bg-primary shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2">Hợp đồng Hiệu lực</h6>
                            <h2 class="display-6 fw-bold mb-0">${activeCount}</h2>
                        </div>
                        <div class="icon-box"><i class="fa fa-file-contract"></i></div>
                    </div>
                    <small class="mt-3 d-block text-white-50">Đang hoạt động trên hệ thống</small>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card card-box bg-warning shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2 text-dark">Sắp hết hạn (30 ngày)</h6>
                            <h2 class="display-6 fw-bold mb-0 text-dark">${expiringCount}</h2>
                        </div>
                        <div class="icon-box text-dark"><i class="fa fa-exclamation-triangle"></i></div>
                    </div>
                    <small class="mt-3 d-block text-dark-50">
                        <a href="contracts?status=ACTIVE" class="text-dark fw-bold">Xem chi tiết <i class="fa fa-arrow-right"></i></a>
                    </small>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card card-box bg-danger shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2">Yêu cầu chờ duyệt</h6>
                            <h2 class="display-6 fw-bold mb-0">${pendingCount}</h2>
                        </div>
                        <div class="icon-box"><i class="fa fa-bell"></i></div>
                    </div>
                    <small class="mt-3 d-block text-white-50">Cần xử lý ngay</small>
                </div>
            </div>

             <div class="col-md-3">
                <div class="card card-box bg-success shadow h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-2">Tổng máy quản lý</h6>
                            <h2 class="display-6 fw-bold mb-0">${productCount}</h2>
                        </div>
                        <div class="icon-box"><i class="fa fa-server"></i></div>
                    </div>
                    <small class="mt-3 d-block text-white-50">Hệ thống hoạt động ổn định</small>
                </div>
            </div>
        </div>

        <!-- ===== Report shortcuts A-F (NEW) ===== -->
        <div class="row g-4 mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0"><i class="fa fa-chart-pie me-2"></i> Reports (A–F)</h5>
                    <small class="text-muted">Lối tắt tới các nhóm báo cáo</small>
                </div>
                <hr class="mt-2" />
            </div>

            <div class="col-md-2">
                <a class="card p-3 shadow-sm h-100" href="${pageContext.request.contextPath}/manager/home">
                    <div class="fw-bold">A. Executive</div>
                    <div class="text-muted small">Dashboard tổng quan</div>
                </a>
            </div>
            <div class="col-md-2">
                <a class="card p-3 shadow-sm h-100" href="${pageContext.request.contextPath}/manager/reports/tickets">
                    <div class="fw-bold">B. Tickets</div>
                    <div class="text-muted small">Sửa chữa / sự cố</div>
                </a>
            </div>
            <div class="col-md-2">
                <a class="card p-3 shadow-sm h-100" href="${pageContext.request.contextPath}/manager/reports/preventive-maintenance">
                    <div class="fw-bold">C. PM</div>
                    <div class="text-muted small">Bảo trì định kỳ</div>
                </a>
            </div>
            <div class="col-md-2">
                <a class="card p-3 shadow-sm h-100" href="${pageContext.request.contextPath}/manager/reports/assets">
                    <div class="fw-bold">D. Assets</div>
                    <div class="text-muted small">Máy & tài sản</div>
                </a>
            </div>
            <div class="col-md-2">
                <a class="card p-3 shadow-sm h-100" href="${pageContext.request.contextPath}/manager/reports/technicians">
                    <div class="fw-bold">E. Technicians</div>
                    <div class="text-muted small">Hiệu suất đội</div>
                </a>
            </div>
            <div class="col-md-2">
                <a class="card p-3 shadow-sm h-100" href="${pageContext.request.contextPath}/manager/reports/finance">
                    <div class="fw-bold">F. Finance</div>
                    <div class="text-muted small">Doanh thu / vật tư</div>
                </a>
            </div>
        </div>

        <!-- ===== A - KPI vận hành (NEW) ===== -->
        <div class="row g-4 mb-5">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0"><i class="fa fa-gauge-high me-2"></i> Dashboard tổng quan vận hành (A)</h5>
                    <small class="text-muted">SLA theo job: completed_at ≤ scheduled_end (tháng hiện tại)</small>
                </div>
                <hr class="mt-2" />
            </div>

            <div class="col-md-3">
                <div class="card shadow-sm p-3 h-100">
                    <div class="text-muted small">Tổng khách hàng</div>
                    <div class="fs-3 fw-bold">${opKpi.totalCustomers}</div>
                    <div class="text-muted small">Customers</div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card shadow-sm p-3 h-100">
                    <div class="text-muted small">Tổng máy quản lý</div>
                    <div class="fs-3 fw-bold">${opKpi.totalDevices}</div>
                    <div class="text-muted small">Devices</div>
                </div>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/assets?status=RUNNING">
                    <div class="text-muted small">Máy đang hoạt động</div>
                    <div class="fs-3 fw-bold text-success">${opKpi.devicesRunning}</div>
                    <div class="text-muted small">RUNNING</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/assets?status=BROKEN">
                    <div class="text-muted small">Máy đang lỗi</div>
                    <div class="fs-3 fw-bold text-danger">${opKpi.devicesBroken}</div>
                    <div class="text-muted small">BROKEN</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/assets?status=MAINTENANCE">
                    <div class="text-muted small">Máy đang bảo trì</div>
                    <div class="fs-3 fw-bold text-warning">${opKpi.devicesMaintenance}</div>
                    <div class="text-muted small">MAINTENANCE</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/tickets?scope=today">
                    <div class="text-muted small">Ticket mở hôm nay</div>
                    <div class="fs-3 fw-bold">${opKpi.ticketsOpenedToday}</div>
                    <div class="text-muted small">Incidents</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/preventive-maintenance?scope=today">
                    <div class="text-muted small">Lịch bảo trì hôm nay</div>
                    <div class="fs-3 fw-bold">${opKpi.maintenancesToday}</div>
                    <div class="text-muted small">Today</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/preventive-maintenance?scope=week">
                    <div class="text-muted small">Lịch bảo trì tuần này</div>
                    <div class="fs-3 fw-bold">${opKpi.maintenancesThisWeek}</div>
                    <div class="text-muted small">This week</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/preventive-maintenance?scope=month">
                    <div class="text-muted small">Lịch bảo trì tháng này</div>
                    <div class="fs-3 fw-bold">${opKpi.maintenancesThisMonth}</div>
                    <div class="text-muted small">This month</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/preventive-maintenance?scope=completed-month">
                    <div class="text-muted small">Job hoàn thành (tháng)</div>
                    <div class="fs-3 fw-bold">${opKpi.jobsCompletedThisMonth}</div>
                    <div class="text-muted small">Completed jobs</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/preventive-maintenance?scope=overdue">
                    <div class="text-muted small">Cảnh báo quá hạn</div>
                    <div class="fs-3 fw-bold text-danger">${opKpi.overdueMaintenances}</div>
                    <div class="text-muted small">Overdue</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/technicians?scope=sla-month">
                    <div class="text-muted small">Tỷ lệ đúng SLA (tháng)</div>
                    <div class="fs-3 fw-bold">
                        <fmt:formatNumber value="${opKpi.slaOnTimeRateThisMonth}" maxFractionDigits="1"/>%
                    </div>
                    <div class="text-muted small">On-time rate</div>
                </a>
            </div>

            <div class="col-md-3">
                <a class="card shadow-sm p-3 h-100" href="${pageContext.request.contextPath}/manager/reports/finance?scope=revenue-month">
                    <div class="text-muted small">Doanh thu service tháng này</div>
                    <div class="fs-3 fw-bold">
                        <fmt:formatNumber value="${opKpi.serviceRevenueThisMonth}" type="number" maxFractionDigits="0"/>
                    </div>
                    <div class="text-muted small">VND</div>
                </a>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-list-alt"></i> Hợp đồng mới nhất</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Số HĐ</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${recentContracts}">
                                    <tr>
                                        <td>
                                            <a href="contracts?action=detail&id=${c.id}" class="text-decoration-none fw-bold">
                                                ${c.contractNumber}
                                            </a>
                                        </td>
                                        <td>${c.customerName}</td>
                                        <td>
                                            <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'ACTIVE'}">
                                                    <span class="badge bg-success">ACTIVE</span>
                                                </c:when>
                                                <c:when test="${c.status == 'EXPIRED'}">
                                                    <span class="badge bg-danger">EXPIRED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">${c.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer bg-white text-center py-3">
                        <a href="${pageContext.request.contextPath}/manager/contracts" class="text-primary fw-bold">Xem tất cả hợp đồng <i class="fa fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-sticky-note"></i> Ghi chú hệ thống</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${expiringCount > 0}">
                            <div class="alert alert-warning shadow-sm">
                                <i class="fa fa-exclamation-circle"></i> Có <strong>${expiringCount}</strong> hợp đồng sắp hết hạn trong tháng này. Vui lòng liên hệ khách hàng.
                            </div>
                        </c:if>

                        <div class="alert alert-info shadow-sm">
                            <i class="fa fa-info-circle"></i> Kiểm tra định kỳ máy phát tại <strong>Khu công nghiệp VSIP</strong> vào ngày mai.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>