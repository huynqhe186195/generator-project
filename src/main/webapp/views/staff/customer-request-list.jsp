<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Yêu cầu từ Customer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">Yêu cầu từ phía khách hàng</h4>
        <div class="d-flex gap-2">
            <a href="<c:url value='/staff/contracts'/>" class="btn btn-outline-primary btn-sm">Xem hợp đồng</a>
            <a href="<c:url value='/staff/incident-list'/>" class="btn btn-outline-secondary btn-sm">Trang chủ</a>
        </div>
    </div>

    <c:if test="${param.message == 'responded'}">
        <div class="alert alert-success">Đã phản hồi yêu cầu thành công.</div>
    </c:if>
    <c:if test="${param.message == 'missing_response'}">
        <div class="alert alert-warning">Vui lòng nhập nội dung phản hồi.</div>
    </c:if>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>Loại yêu cầu</th>
                    <th>Nội dung</th>
                    <th>Trạng thái</th>
                    <th>Thời gian</th>
                    <th style="width: 320px;">Phản hồi staff</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${customerRequests}">
                    <c:set var="payload" value="${requestPayloads[r.id]}"/>
                    <c:set var="sender" value="${requestSenders[r.id]}"/>
                    <tr>
                        <td>#${r.id}</td>
                        <td>
                            <div class="fw-bold">${sender.fullName}</div>
                            <small class="text-muted">${sender.email}</small>
                        </td>
                        <td><span class="badge bg-info text-dark">${payload.requestKind}</span></td>
                        <td>
                            <div class="fw-semibold">${payload.subject}</div>
                            <small class="text-muted">${payload.message}</small>
                        </td>
                        <td><span class="badge bg-secondary">${r.status}</span></td>
                        <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>
                            <form action="<c:url value='/staff/customer-request/respond'/>" method="post" class="d-grid gap-2">
                                <input type="hidden" name="requestId" value="${r.id}">
                                <textarea class="form-control form-control-sm" name="responseMessage" rows="2"
                                          placeholder="Nhập phản hồi cho customer..." required></textarea>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-success" type="submit" name="action" value="RESPOND">Phản hồi</button>
                                    <button class="btn btn-sm btn-outline-danger" type="submit" name="action" value="REJECT">Từ chối</button>
                                </div>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty customerRequests}">
                    <tr><td colspan="7" class="text-center py-4 text-muted">Chưa có yêu cầu customer nào.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
