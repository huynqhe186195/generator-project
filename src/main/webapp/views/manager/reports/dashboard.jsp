<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- ===== KPI vận hành ===== -->
<div class="row g-4 mb-5">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <h5 class="fw-bold mb-0">
                <i class="fa fa-gauge-high me-2"></i> Dashboard tổng quan vận hành
            </h5>
            <small class="text-muted">
                SLA: completed_at ≤ scheduled_end (tháng hiện tại)
            </small>
        </div>
        <hr class="mt-2"/>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Tổng khách hàng</div>
            <div class="fs-3 fw-bold">${opKpi.totalCustomers}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Tổng máy quản lý</div>
            <div class="fs-3 fw-bold">${opKpi.totalDevices}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Máy đang hoạt động</div>
            <div class="fs-3 fw-bold text-success">${opKpi.devicesRunning}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Máy đang lỗi</div>
            <div class="fs-3 fw-bold text-danger">${opKpi.devicesBroken}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Máy bảo trì</div>
            <div class="fs-3 fw-bold text-warning">${opKpi.devicesMaintenance}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Ticket hôm nay</div>
            <div class="fs-3 fw-bold">${opKpi.ticketsOpenedToday}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Bảo trì hôm nay</div>
            <div class="fs-3 fw-bold">${opKpi.maintenancesToday}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Bảo trì tuần</div>
            <div class="fs-3 fw-bold">${opKpi.maintenancesThisWeek}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Bảo trì tháng</div>
            <div class="fs-3 fw-bold">${opKpi.maintenancesThisMonth}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Job hoàn thành</div>
            <div class="fs-3 fw-bold">${opKpi.jobsCompletedThisMonth}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Quá hạn</div>
            <div class="fs-3 fw-bold text-danger">${opKpi.overdueMaintenances}</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">SLA (%)</div>
            <div class="fs-3 fw-bold">
                <fmt:formatNumber value="${opKpi.slaOnTimeRateThisMonth}" maxFractionDigits="1"/>%
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm p-3 h-100">
            <div class="text-muted small">Doanh thu</div>
            <div class="fs-3 fw-bold">
                <fmt:formatNumber value="${opKpi.serviceRevenueThisMonth}" maxFractionDigits="0"/>
            </div>
        </div>
    </div>
</div>