<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/24/2026
  Time: 3:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <div>
        <h5 class="fw-bold mb-0">Người dùng hệ thống</h5>
        <small class="text-muted">
            Khoảng: <strong>${userFrom}</strong> → <strong>${userTo}</strong>
        </small>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/manager/system-report"
          class="d-flex align-items-center gap-2">
        <input type="hidden" name="section" value="users" />
        <input type="hidden" name="year" value="${selectedYear}" />

        <label class="text-muted mb-0 fw-semibold">From:</label>
        <input type="date" name="from" value="${userFrom}" class="form-control form-control-sm" />

        <label class="text-muted mb-0 fw-semibold">To:</label>
        <input type="date" name="to" value="${userTo}" class="form-control form-control-sm" />

        <button class="btn btn-sm btn-primary" type="submit">Xem</button>

        <!-- Quick reset to whole selectedYear -->
        <a class="btn btn-sm btn-outline-secondary"
           href="${pageContext.request.contextPath}/manager/system-report?section=users&year=${selectedYear}">
            Năm ${selectedYear}
        </a>
    </form>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-6">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Tổng users (all-time)</div>
            <div class="fs-3 fw-bold">${usrTotalUsers}</div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Users mới trong khoảng</div>
            <div class="fs-3 fw-bold">${usrNewUsers}</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-5">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">Users mới theo role</div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartUsrByRole" height="170"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-7">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">Users mới theo tháng</div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartUsrByMonth" height="120"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const byRole = ${usrByRoleJson};
        const byMonth = ${usrNewByMonthJson};

        const roleLabels = (byRole || []).map(x => x.label);
        const roleVals = (byRole || []).map(x => Number(x.value || 0));

        new Chart(document.getElementById('chartUsrByRole'), {
            type: 'bar',
            data: {
                labels: roleLabels,
                datasets: [{
                    label: 'Users mới',
                    data: roleVals,
                    backgroundColor: 'rgba(108,117,125,0.75)',
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f0f0f0' } },
                    x: { grid: { display: false } }
                }
            }
        });

        const monthLabels = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];
        const monthVals = (byMonth || []).map(x => Number(x.value || 0));

        new Chart(document.getElementById('chartUsrByMonth'), {
            type: 'line',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Users mới',
                    data: monthVals,
                    borderColor: 'rgba(13,110,253,0.8)',
                    backgroundColor: 'rgba(13,110,253,0.15)',
                    fill: true,
                    tension: 0.35
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f0f0f0' } },
                    x: { grid: { display: false } }
                }
            }
        });
    })();
</script>
