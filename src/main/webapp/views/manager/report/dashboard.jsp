<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard dịch vụ sau bán hàng</title>
    <style>
        .section-card { border: none; border-radius: 18px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08); }
        .metric-card { border: none; border-radius: 16px; color: #fff; min-height: 140px; }
        .metric-card h3 { font-size: 2rem; font-weight: 700; }
        .metric-card small { opacity: 0.9; }
        .bg-service { background: linear-gradient(135deg, #2563eb, #1d4ed8); }
        .bg-maintenance { background: linear-gradient(135deg, #059669, #047857); }
        .bg-repair { background: linear-gradient(135deg, #ea580c, #c2410c); }
        .bg-warning-soft { background: linear-gradient(135deg, #dc2626, #b91c1c); }
        .mini-stat { background: #f8fafc; border-radius: 14px; padding: 14px 16px; height: 100%; }
        .mini-stat .label { font-size: 0.88rem; color: #64748b; text-transform: uppercase; letter-spacing: .04em; }
        .mini-stat .value { font-size: 1.6rem; font-weight: 700; color: #0f172a; }
        .bar-row + .bar-row { margin-top: 14px; }
        .progress { height: 8px; background-color: #e2e8f0; }
        .tag { display: inline-flex; padding: 4px 10px; border-radius: 999px; background: #eff6ff; color: #1d4ed8; font-size: .8rem; font-weight: 600; }
        .section-title { font-weight: 700; color: #0f172a; }
        .chart-placeholder { display: flex; align-items: end; gap: 10px; min-height: 180px; }
        .chart-bar { flex: 1; border-radius: 14px 14px 4px 4px; background: linear-gradient(180deg, #60a5fa, #2563eb); min-height: 20px; position: relative; }
        .chart-label { font-size: 0.8rem; color: #64748b; margin-top: 10px; text-align: center; }
        .table thead th { color: #64748b; font-size: .85rem; text-transform: uppercase; }
    </style>
</head>
<body>
<div class="container-fluid py-3">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="mb-1 text-primary fw-bold">Dashboard dịch vụ sau bán hàng</h2>
            <p class="text-muted mb-0">Tập trung vào ticket, bảo dưỡng, sửa chữa, bảo hành, thiết bị và hiệu suất đội service.</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/reports" class="btn btn-outline-primary">
            <i class="fa fa-rotate-right me-2"></i>Làm mới báo cáo
        </a>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="card metric-card bg-service p-4">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="text-uppercase small fw-semibold">Yêu cầu dịch vụ tháng này</div>
                        <h3 class="mb-1">${stats.serviceRequestsThisMonth}</h3>
                        <small>Hôm nay: ${stats.serviceRequestsToday} · Tuần này: ${stats.serviceRequestsThisWeek}</small>
                    </div>
                    <i class="fa fa-inbox fa-2x opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card metric-card bg-maintenance p-4">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="text-uppercase small fw-semibold">Ca bảo dưỡng</div>
                        <h3 class="mb-1">${stats.maintenanceTickets}</h3>
                        <small>Định kỳ: ${stats.periodicMaintenanceCount} · Đột xuất: ${stats.unexpectedMaintenanceCount}</small>
                    </div>
                    <i class="fa fa-screwdriver-wrench fa-2x opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card metric-card bg-repair p-4">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="text-uppercase small fw-semibold">Ca sửa chữa</div>
                        <h3 class="mb-1">${stats.repairTickets}</h3>
                        <small>Tháng này: ${stats.repairsThisMonth} · Xong: ${stats.repairsDone}</small>
                    </div>
                    <i class="fa fa-toolbox fa-2x opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card metric-card bg-warning-soft p-4">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="text-uppercase small fw-semibold">Yêu cầu đang mở</div>
                        <h3 class="mb-1">${stats.waitingRequests}</h3>
                        <small>Hoàn thành: ${stats.completedRequests} · Quá 72h: ${stats.overdueRequests}</small>
                    </div>
                    <i class="fa fa-clock fa-2x opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-7">
            <div class="card section-card h-100">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h5 class="section-title mb-1">1. Thống kê tiếp nhận dịch vụ</h5>
                            <div class="text-muted">Dashboard đầu vào công việc dành cho manager.</div>
                        </div>
                        <span class="tag">Ticket & SLA</span>
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-md-4"><div class="mini-stat"><div class="label">Phiếu bảo dưỡng</div><div class="value">${stats.maintenanceTickets}</div></div></div>
                        <div class="col-md-4"><div class="mini-stat"><div class="label">Phiếu sửa chữa</div><div class="value">${stats.repairTickets}</div></div></div>
                        <div class="col-md-4"><div class="mini-stat"><div class="label">Yêu cầu quá hạn</div><div class="value text-danger">${stats.overdueRequests}</div></div></div>
                    </div>
                    <div class="chart-placeholder">
                        <c:forEach var="point" items="${stats.requestTrend}">
                            <div class="flex-fill text-center">
                                <div class="chart-bar" style="height: ${point.value * 18 + 20}px;"></div>
                                <div class="fw-semibold mt-2">${point.value}</div>
                                <div class="chart-label">${point.label}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="card section-card h-100">
                <div class="card-body p-4">
                    <h5 class="section-title mb-4">KPI lõi màn hình tổng quan</h5>
                    <div class="bar-row">
                        <div class="d-flex justify-content-between"><span>Thời gian phản hồi trung bình</span><strong><fmt:formatNumber value="${stats.averageResponseHours}" maxFractionDigits="1"/>h</strong></div>
                        <div class="progress"><div class="progress-bar bg-primary" style="width: ${stats.averageResponseHours > 100 ? 100 : stats.averageResponseHours}%;"></div></div>
                    </div>
                    <div class="bar-row">
                        <div class="d-flex justify-content-between"><span>Thời gian xử lý trung bình</span><strong><fmt:formatNumber value="${stats.averageCompletionHours}" maxFractionDigits="1"/>h</strong></div>
                        <div class="progress"><div class="progress-bar bg-success" style="width: ${stats.averageCompletionHours > 100 ? 100 : stats.averageCompletionHours}%;"></div></div>
                    </div>
                    <div class="bar-row">
                        <div class="d-flex justify-content-between"><span>Tỷ lệ đúng hạn</span><strong><fmt:formatNumber value="${stats.onTimeRate}" maxFractionDigits="1"/>%</strong></div>
                        <div class="progress"><div class="progress-bar bg-info" style="width: ${stats.onTimeRate}%;"></div></div>
                    </div>
                    <div class="bar-row">
                        <div class="d-flex justify-content-between"><span>Tỷ lệ tái lỗi sau sửa chữa</span><strong><fmt:formatNumber value="${stats.repeatFailureRate}" maxFractionDigits="1"/>%</strong></div>
                        <div class="progress"><div class="progress-bar bg-warning" style="width: ${stats.repeatFailureRate}%;"></div></div>
                    </div>
                    <div class="bar-row">
                        <div class="d-flex justify-content-between"><span>Tỷ lệ phải quay lại lần 2</span><strong><fmt:formatNumber value="${stats.revisitRate}" maxFractionDigits="1"/>%</strong></div>
                        <div class="progress"><div class="progress-bar bg-danger" style="width: ${stats.revisitRate}%;"></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <div class="card section-card h-100"><div class="card-body p-4">
                <h5 class="section-title mb-4">2. Thống kê bảo dưỡng</h5>
                <div class="row g-3">
                    <div class="col-md-6"><div class="mini-stat"><div class="label">Máy sắp đến hạn</div><div class="value text-warning">${stats.machinesDueSoon}</div></div></div>
                    <div class="col-md-6"><div class="mini-stat"><div class="label">Máy đã quá hạn</div><div class="value text-danger">${stats.machinesOverdue}</div></div></div>
                    <div class="col-md-6"><div class="mini-stat"><div class="label">TG hoàn thành TB</div><div class="value"><fmt:formatNumber value="${stats.averageMaintenanceHours}" maxFractionDigits="1"/>h</div></div></div>
                    <div class="col-md-6"><div class="mini-stat"><div class="label">Loại bảo dưỡng phổ biến</div><div class="value fs-5">${stats.mostCommonMaintenanceType}</div></div></div>
                </div>
                <div class="mt-4 p-3 bg-light rounded-4">
                    <div class="small text-muted mb-1">Model có tần suất bảo dưỡng cao</div>
                    <div class="fs-5 fw-semibold">${stats.mostMaintainedModel}</div>
                </div>
            </div></div>
        </div>
        <div class="col-lg-6">
            <div class="card section-card h-100"><div class="card-body p-4">
                <h5 class="section-title mb-4">3. Thống kê sửa chữa</h5>
                <div class="row g-3 mb-3">
                    <div class="col-md-4"><div class="mini-stat"><div class="label">Chưa sửa xong</div><div class="value">${stats.repairsPending}</div></div></div>
                    <div class="col-md-4"><div class="mini-stat"><div class="label">Thay linh kiện</div><div class="value">${stats.repairsWithParts}</div></div></div>
                    <div class="col-md-4"><div class="mini-stat"><div class="label">Sửa tại chỗ</div><div class="value"><fmt:formatNumber value="${stats.onsiteRepairRate}" maxFractionDigits="0"/>%</div></div></div>
                </div>
                <div class="mb-3 p-3 bg-light rounded-4">
                    <div class="small text-muted mb-1">Model có tỷ lệ lỗi cao</div>
                    <div class="fs-5 fw-semibold">${stats.highestFailureModel}</div>
                </div>
                <div class="small text-muted mb-2">Top lỗi thường gặp</div>
                <c:forEach var="item" items="${stats.topRepairIssues}">
                    <div class="d-flex justify-content-between border-bottom py-2">
                        <span>${item.label}</span>
                        <strong>${item.value}</strong>
                    </div>
                </c:forEach>
            </div></div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-4">
            <div class="card section-card h-100"><div class="card-body p-4">
                <h5 class="section-title mb-4">4. Thống kê bảo hành</h5>
                <div class="mini-stat mb-3"><div class="label">Case còn hiệu lực</div><div class="value">${stats.warrantyActiveCases}</div></div>
                <div class="mini-stat mb-3"><div class="label">Case từ chối bảo hành</div><div class="value">${stats.warrantyRejectedCases}</div></div>
                <div class="mini-stat mb-3"><div class="label">Máy hết hạn bảo hành</div><div class="value">${stats.warrantyExpiredCases}</div></div>
                <div class="mini-stat"><div class="label">Tỷ lệ lỗi thuộc bảo hành</div><div class="value"><fmt:formatNumber value="${stats.warrantyCoverageRate}" maxFractionDigits="1"/>%</div></div>
                <hr>
                <div class="small text-muted">Linh kiện bảo hành nhiều nhất: <strong class="text-dark">${stats.topWarrantyPart}</strong></div>
                <div class="small text-muted mt-2">Khách hàng nhiều case bảo hành: <strong class="text-dark">${stats.topWarrantyCustomer}</strong></div>
                <div class="small text-muted mt-2">Model phát sinh bảo hành nhiều: <strong class="text-dark">${stats.topWarrantyModel}</strong></div>
            </div></div>
        </div>
        <div class="col-lg-4">
            <div class="card section-card h-100"><div class="card-body p-4">
                <h5 class="section-title mb-4">5. Khách hàng và thiết bị sau bán</h5>
                <div class="row g-3">
                    <div class="col-6"><div class="mini-stat"><div class="label">Tổng khách hàng</div><div class="value">${stats.totalCustomersSupported}</div></div></div>
                    <div class="col-6"><div class="mini-stat"><div class="label">Tổng máy theo dõi</div><div class="value">${stats.totalTrackedMachines}</div></div></div>
                    <div class="col-6"><div class="mini-stat"><div class="label">Máy đang hoạt động</div><div class="value text-success">${stats.activeMachines}</div></div></div>
                    <div class="col-6"><div class="mini-stat"><div class="label">Máy ngừng/chờ sửa</div><div class="value text-danger">${stats.stoppedMachines}</div></div></div>
                </div>
                <div class="mt-4 p-3 bg-light rounded-4">
                    <div class="small text-muted mb-1">Khách có máy sắp đến hạn bảo dưỡng</div>
                    <div class="fs-3 fw-bold text-warning">${stats.customersDueSoon}</div>
                </div>
                <div class="mt-3 small text-muted">Khách hàng gọi service nhiều nhất: <strong class="text-dark">${stats.topServiceCustomer}</strong></div>
            </div></div>
        </div>
        <div class="col-lg-4">
            <div class="card section-card h-100"><div class="card-body p-4">
                <h5 class="section-title mb-4">6. Hiệu suất đội service</h5>
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead><tr><th>Kỹ thuật viên</th><th>Số phiếu</th><th>Ghi chú</th></tr></thead>
                        <tbody>
                        <c:forEach var="item" items="${stats.technicianPerformance}">
                            <tr>
                                <td>${item.label}</td>
                                <td><span class="badge bg-primary">${item.value}</span></td>
                                <td class="text-muted small">${item.extra}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div></div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="card section-card h-100"><div class="card-body p-4">
                <h5 class="section-title mb-4">Top 5 model phát sinh service nhiều nhất</h5>
                <c:forEach var="item" items="${stats.topModels}">
                    <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                        <div>
                            <div class="fw-semibold">${item.label}</div>
                            <div class="small text-muted">${item.extra}</div>
                        </div>
                        <span class="badge bg-dark">${item.value}</span>
                    </div>
                </c:forEach>
            </div></div>
        </div>
        <div class="col-lg-6">
            <div class="card section-card h-100"><div class="card-body p-4">
                <h5 class="section-title mb-4">Lịch sử dịch vụ theo khách hàng</h5>
                <c:forEach var="item" items="${stats.customerHistory}">
                    <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                        <div>
                            <div class="fw-semibold">${item.label}</div>
                            <div class="small text-muted">${item.extra}</div>
                        </div>
                        <span class="badge bg-success">${item.value}</span>
                    </div>
                </c:forEach>
                <div class="mt-4">
                    <div class="small text-muted mb-2">Phân bố lỗi theo nhóm</div>
                    <c:forEach var="item" items="${stats.failureGroups}">
                        <div class="d-flex justify-content-between py-1">
                            <span>${item.label}</span>
                            <strong>${item.value}</strong>
                        </div>
                    </c:forEach>
                </div>
            </div></div>
        </div>
    </div>
</div>
</body>
</html>
