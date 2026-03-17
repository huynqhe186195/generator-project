<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>System Report</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .kpi-card { border: none; border-radius: 12px; color: #fff; transition: transform 0.2s; }
        .kpi-card:hover { transform: translateY(-4px); box-shadow: 0 8px 20px rgba(0,0,0,.2) !important; }
        .kpi-icon { font-size: 2.8rem; opacity: 0.25; }
        .chart-card { border: none; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,.06); }
        .chart-card .card-header { background: transparent; border-bottom: 1px solid #f0f0f0; font-weight: 600; }
        .year-form select { border-radius: 8px; border: 1px solid #dee2e6; padding: 6px 14px; font-size: .9rem; cursor: pointer; }
    </style>
</head>
<body>

<div class="container-fluid p-4">

    <%-- HEADER --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-0"><i class="fa fa-chart-bar text-primary me-2"></i>System Report</h4>
            <small class="text-muted">Tổng hợp dữ liệu vận hành — Năm <strong>${selectedYear}</strong></small>
        </div>
        <form method="get" action="${pageContext.request.contextPath}/manager/system-report" class="year-form d-flex align-items-center gap-2">
            <label class="text-muted mb-0 fw-semibold">Năm:</label>
            <select name="year" onchange="this.form.submit()">
                <option value="2024" ${selectedYear == 2024 ? 'selected' : ''}>2024</option>
                <option value="2025" ${selectedYear == 2025 ? 'selected' : ''}>2025</option>
                <option value="2026" ${selectedYear == 2026 ? 'selected' : ''}>2026</option>
                <option value="2027" ${selectedYear == 2027 ? 'selected' : ''}>2027</option>
            </select>
        </form>
    </div>

    <%-- KPI CARDS --%>
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card kpi-card bg-primary shadow p-3 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="small text-uppercase text-white-50 mb-1">Hợp đồng đang hiệu lực</div>
                        <div class="fs-2 fw-bold">${kpiActiveContracts}</div>
                    </div>
                    <div class="kpi-icon"><i class="fa fa-file-contract"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card bg-success shadow p-3 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="small text-uppercase text-white-50 mb-1">Khách mới tháng này</div>
                        <div class="fs-2 fw-bold">${kpiNewCustomers}</div>
                    </div>
                    <div class="kpi-icon"><i class="fa fa-user-plus"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card bg-danger shadow p-3 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="small text-uppercase text-white-50 mb-1">Sự cố chưa xử lý</div>
                        <div class="fs-2 fw-bold">${kpiPendingIncidents}</div>
                    </div>
                    <div class="kpi-icon"><i class="fa fa-exclamation-triangle"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card bg-warning shadow p-3 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="small text-uppercase text-dark-50 mb-1 text-dark">Bảo trì tháng này</div>
                        <div class="fs-2 fw-bold text-dark">${kpiMaintenanceThisMonth}</div>
                    </div>
                    <div class="kpi-icon text-dark"><i class="fa fa-tools"></i></div>
                </div>
            </div>
        </div>
    </div>

    <%-- ROW 1: Khách hàng mới + Trạng thái bảo trì --%>
    <div class="row g-3 mb-3">
        <div class="col-md-7">
            <div class="card chart-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center py-3 px-4">
                    <span><i class="fa fa-users text-primary me-2"></i>Khách hàng mới theo tháng</span>
                    <span class="badge bg-primary-subtle text-primary">${selectedYear}</span>
                </div>
                <div class="card-body px-4 pb-4">
                    <canvas id="chartNewCustomers" height="120"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-5">
            <div class="card chart-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center py-3 px-4">
                    <span><i class="fa fa-wrench text-warning me-2"></i>Trạng thái bảo trì</span>
                    <span class="badge bg-warning-subtle text-warning">${selectedYear}</span>
                </div>
                <div class="card-body px-4 pb-4 d-flex align-items-center justify-content-center">
                    <canvas id="chartMaintenanceStatus" height="160"></canvas>
                </div>
            </div>
        </div>
    </div>

    <%-- ROW 2: Tỷ lệ tái ký + Sự cố theo mức ưu tiên --%>
    <div class="row g-3 mb-3">
        <div class="col-md-7">
            <div class="card chart-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center py-3 px-4">
                    <span><i class="fa fa-redo text-success me-2"></i>Tỷ lệ khách hàng tái ký (%)</span>
                    <span class="badge bg-success-subtle text-success">${selectedYear}</span>
                </div>
                <div class="card-body px-4 pb-4">
                    <canvas id="chartRenewRate" height="120"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-5">
            <div class="card chart-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center py-3 px-4">
                    <span><i class="fa fa-fire text-danger me-2"></i>Sự cố theo mức độ ưu tiên</span>
                    <span class="badge bg-danger-subtle text-danger">${selectedYear}</span>
                </div>
                <div class="card-body px-4 pb-4 d-flex align-items-center">
                    <canvas id="chartIncidentPriority" height="150"></canvas>
                </div>
            </div>
        </div>
    </div>

    <%-- ROW 3: Top linh kiện --%>
    <div class="row g-3 mb-3">
        <div class="col-md-6">
            <div class="card chart-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center py-3 px-4">
                    <span><i class="fa fa-box-open text-info me-2"></i>Top 5 linh kiện sử dụng nhiều nhất</span>
                    <span class="badge bg-info-subtle text-info">Tất cả năm</span>
                </div>
                <div class="card-body px-4 pb-4">
                    <canvas id="chartSpareParts" height="140"></canvas>
                </div>
            </div>
        </div>
    </div>

</div>

<%-- CHART.JS SCRIPTS --%>
<script>
    const monthLabels = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];

    // ── Chart 1: Khách hàng mới theo tháng (Bar) ──────────────────────────
    (function() {
        const raw = ${newCustomersJson};
        const values = [1,2,3,4,5,6,7,8,9,10,11,12].map(k => raw[k] || 0);
        new Chart(document.getElementById('chartNewCustomers'), {
            type: 'bar',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Khách mới',
                    data: values,
                    backgroundColor: 'rgba(13,110,253,0.75)',
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { color: '#f0f0f0' } },
                    x: { grid: { display: false } }
                }
            }
        });
    })();

    // ── Chart 2: Trạng thái bảo trì (Pie) ────────────────────────────────
    (function() {
        const raw = ${maintenanceStatusJson};
        new Chart(document.getElementById('chartMaintenanceStatus'), {
            type: 'pie',
            data: {
                labels: ['Đã lên lịch', 'Hoàn thành', 'Đã huỷ'],
                datasets: [{
                    data: [raw.SCHEDULED || 0, raw.COMPLETED || 0, raw.CANCELLED || 0],
                    backgroundColor: ['#ffc107', '#198754', '#dc3545'],
                    hoverOffset: 8
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom', labels: { padding: 16 } }
                }
            }
        });
    })();

    // ── Chart 3: Tỷ lệ tái ký (Line) ──────────────────────────────────────
    (function() {
        const raw = ${renewRateJson};
        const rates  = raw.map(d => d.rate);
        const totals = raw.map(d => d.total);
        new Chart(document.getElementById('chartRenewRate'), {
            type: 'line',
            data: {
                labels: monthLabels,
                datasets: [
                    {
                        label: 'Tỷ lệ tái ký (%)',
                        data: rates,
                        borderColor: '#198754',
                        backgroundColor: 'rgba(25,135,84,0.1)',
                        tension: 0.4,
                        fill: true,
                        pointRadius: 4,
                        pointBackgroundColor: '#198754'
                    },
                    {
                        label: 'Tổng HĐ mới',
                        data: totals,
                        borderColor: '#6c757d',
                        backgroundColor: 'transparent',
                        tension: 0.4,
                        borderDash: [5, 5],
                        pointRadius: 3
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f0f0f0' } },
                    x: { grid: { display: false } }
                }
            }
        });
    })();

    // ── Chart 4: Sự cố theo mức ưu tiên (Horizontal Bar) ─────────────────
    (function() {
        const raw = ${incidentPriorityJson};
        new Chart(document.getElementById('chartIncidentPriority'), {
            type: 'bar',
            data: {
                labels: ['Thấp', 'Trung bình', 'Cao', 'Nghiêm trọng'],
                datasets: [{
                    label: 'Số sự cố',
                    data: [raw.LOW || 0, raw.MEDIUM || 0, raw.HIGH || 0, raw.CRITICAL || 0],
                    backgroundColor: ['#6ea8fe', '#ffc107', '#fd7e14', '#dc3545'],
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    x: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { color: '#f0f0f0' } },
                    y: { grid: { display: false } }
                }
            }
        });
    })();

    // ── Chart 5: Top linh kiện (Bar) ──────────────────────────────────────
    (function() {
        const raw = ${topSparePartsJson};
        if (!raw || raw.length === 0) return;
        const labels = raw.map(d => d.name);
        const values = raw.map(d => d.total);
        new Chart(document.getElementById('chartSpareParts'), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số lượng dùng',
                    data: values,
                    backgroundColor: 'rgba(13,202,240,0.75)',
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { color: '#f0f0f0' } },
                    x: { grid: { display: false } }
                }
            }
        });
    })();
</script>

</body>
</html>
