<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>System Report</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js">
    </script>

    <style>
        .kpi-card {
            border: none;
            border-radius: 12px;
            color: #fff;
            transition: transform 0.2s;
            cursor: pointer;
            text-decoration: none;
            display: block;
        }

        .kpi-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,.2) !important;
        }

        .kpi-card.active {
            outline: 3px solid rgba(0,0,0,.15);
        }

        .kpi-title {
            font-size: 0.85rem;
            letter-spacing: .02em;
            text-transform: uppercase;
            opacity: 0.9;
        }

        .kpi-subtitle {
            font-size: 0.78rem;
            opacity: 0.85;
        }

        .chart-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,.06);
        }

        .chart-card .card-header {
            background: transparent;
            border-bottom: 1px solid #f0f0f0;
            font-weight: 600;
        }

        .year-form select {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 6px 14px;
            font-size: .9rem;
            cursor: pointer;
        }
    </style>
</head>

<body>
<div class="container-fluid p-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-0">System Report</h4>
            <small class="text-muted">
                Dashboard quản lý hệ thống — Năm
                <strong>${selectedYear}</strong>
            </small>
        </div>

        <form method="get"
              action="${pageContext.request.contextPath}/manager/system-report"
              class="year-form d-flex align-items-center gap-2">
            <input type="hidden" name="section" value="${section}" />
            <label class="text-muted mb-0 fw-semibold">Năm:</label>
            <select name="year" onchange="this.form.submit()">
                <c:forEach var="y" begin="${yearFrom}" end="${yearTo}">
                    <option value="${y}" ${selectedYear == y ? 'selected' : ''}>
                            ${y}
                    </option>
                </c:forEach>
            </select>
        </form>
    </div>

    <!-- Module cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <a class="card kpi-card bg-primary shadow p-3 h-100
               ${section == 'inventory' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/system-report?section=inventory&year=${selectedYear}">
                <div class="kpi-title">Quy mô tài sản</div>
                <div class="kpi-subtitle">Asset & Database Overview</div>
            </a>
        </div>

        <div class="col-md-3">
            <a class="card kpi-card bg-success shadow p-3 h-100
               ${section == 'service' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/system-report?section=service&year=${selectedYear}">
                <div class="kpi-title">Vận hành & Bảo trì</div>
                <div class="kpi-subtitle">Service & Maintenance KPIs</div>
            </a>
        </div>

        <div class="col-md-3">
            <a class="card kpi-card bg-danger shadow p-3 h-100
               ${section == 'financial' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/system-report?section=financial&year=${selectedYear}">
                <div class="kpi-title">Tài chính dịch vụ lẻ</div>
                <div class="kpi-subtitle">Ad-hoc Service Profitability</div>
            </a>
        </div>

        <div class="col-md-3">
            <a class="card kpi-card bg-warning shadow p-3 h-100 text-dark
               ${section == 'risk' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/system-report?section=risk&year=${selectedYear}">
                <div class="kpi-title">Rủi ro & Giữ chân</div>
                <div class="kpi-subtitle">Risk & Retention</div>
            </a>
        </div>
    </div>

    <!-- Section content -->
    <c:choose>
        <c:when test="${section == 'inventory'}">
            <jsp:include page="/views/manager/system-report/section-inventory.jsp" />
        </c:when>
        <c:when test="${section == 'service'}">
            <jsp:include page="/views/manager/system-report/section-service.jsp" />
        </c:when>
        <c:when test="${section == 'financial'}">
            <jsp:include page="/views/manager/system-report/section-financial.jsp" />
        </c:when>
        <c:when test="${section == 'risk'}">
            <jsp:include page="/views/manager/system-report/section-risk.jsp" />
        </c:when>
        <c:otherwise>
            <jsp:include page="/views/manager/system-report/section-inventory.jsp" />
        </c:otherwise>
    </c:choose>

</div>
</body>
</html>