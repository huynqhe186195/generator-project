<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hợp đồng (Staff - chỉ xem)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">Chi tiết hợp đồng #${c.contractNumber}</h4>
        <a class="btn btn-outline-secondary btn-sm" href="<c:url value='/staff/contracts'/>">Quay lại danh sách</a>
    </div>

    <div class="alert alert-warning py-2">Staff chỉ có quyền xem thông tin hợp đồng, không thể cập nhật/chỉnh sửa.</div>

    <div class="card shadow-sm mb-3">
        <div class="card-body row g-3">
            <div class="col-md-6"><strong>Khách hàng:</strong> ${u.fullName}</div>
            <div class="col-md-6"><strong>Trạng thái:</strong> ${c.status}</div>
            <div class="col-md-6"><strong>Bắt đầu:</strong> <fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/></div>
            <div class="col-md-6"><strong>Kết thúc:</strong> <fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></div>
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-header fw-bold">Thiết bị thuộc hợp đồng</div>
        <div class="table-responsive">
            <table class="table mb-0">
                <thead class="table-light"><tr><th>Serial</th><th>Model</th><th>Trạng thái</th></tr></thead>
                <tbody>
                <c:forEach var="p" items="${products}">
                    <tr><td>${p.serialNumber}</td><td>${p.modelName}</td><td>${p.status}</td></tr>
                </c:forEach>
                <c:if test="${empty products}"><tr><td colspan="3" class="text-center text-muted">Không có thiết bị.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header fw-bold">Lịch sử sự kiện hợp đồng</div>
        <ul class="list-group list-group-flush">
            <c:forEach var="ev" items="${contractEvents}">
                <li class="list-group-item d-flex justify-content-between">
                    <span>${ev.eventType} - ${ev.note}</span>
                    <small class="text-muted"><fmt:formatDate value="${ev.createdAt}" pattern="dd/MM/yyyy HH:mm"/></small>
                </li>
            </c:forEach>
            <c:if test="${empty contractEvents}"><li class="list-group-item text-muted">Chưa có lịch sử sự kiện.</li></c:if>
        </ul>
    </div>
</div>
</body>
</html>
