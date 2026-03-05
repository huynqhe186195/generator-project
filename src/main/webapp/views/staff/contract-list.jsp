<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách hợp đồng (Staff - chỉ xem)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">Danh sách hợp đồng (Chỉ xem)</h4>
        <a href="<c:url value='/staff/customer-requests'/>" class="btn btn-outline-secondary btn-sm">Inbox customer request</a>
    </div>

    <form method="get" action="<c:url value='/staff/contracts'/>" class="row g-2 mb-3">
        <div class="col-md-6"><input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Tìm theo mã HĐ, khách hàng, serial..."></div>
        <div class="col-md-3">
            <select class="form-select" name="status">
                <option value="">-- Tất cả trạng thái --</option>
                <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                <option value="EXPIRED" ${status == 'EXPIRED' ? 'selected' : ''}>EXPIRED</option>
                <option value="TERMINATED" ${status == 'TERMINATED' ? 'selected' : ''}>TERMINATED</option>
            </select>
        </div>
        <div class="col-md-3 d-grid"><button class="btn btn-primary">Lọc</button></div>
    </form>

    <div class="alert alert-info py-2">Staff chỉ có quyền <strong>xem danh sách</strong> và <strong>xem chi tiết hợp đồng</strong>, không có quyền chỉnh sửa.</div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light"><tr><th>Mã HĐ</th><th>Khách hàng</th><th>Thời hạn</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="c" items="${contracts}">
                    <tr>
                        <td class="fw-bold text-primary">${c.contractNumber}</td>
                        <td>${c.customerName}</td>
                        <td><fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/> - <fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></td>
                        <td>${c.status}</td>
                        <td class="text-end">
                            <a class="btn btn-sm btn-outline-primary" href="<c:url value='/staff/contract/detail?id=${c.id}'/>">Xem chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty contracts}"><tr><td colspan="5" class="text-center py-4 text-muted">Không có hợp đồng.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
