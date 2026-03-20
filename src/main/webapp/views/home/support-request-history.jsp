<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử yêu cầu hỗ trợ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">Lịch sử yêu cầu hỗ trợ của bạn</h4>
        <a href="<c:url value='/views/home/Support.jsp'/>" class="btn btn-outline-secondary btn-sm">Gửi yêu cầu mới</a>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Loại yêu cầu</th>
                    <th>Nội dung</th>
                    <th>Trạng thái</th>
                    <th>Phản hồi từ Staff</th>
                    <th>Thời gian</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${supportRequests}">
                    <tr>
                        <td>#${r.id}</td>
                        <td>${r.info.requestKind}</td>
                        <td>
                            <div class="fw-semibold">${r.info.subject}</div>
                            <small class="text-muted">${r.info.message}</small>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${r.status == 'RESPONDED'}"><span class="badge bg-success">Đã phản hồi</span></c:when>
                                <c:when test="${r.status == 'REJECTED'}"><span class="badge bg-danger">Từ chối</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">${r.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty r.responseMessage}">${r.responseMessage}</c:when>
                                <c:otherwise><span class="text-muted">Đang chờ staff phản hồi...</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty supportRequests}">
                    <tr>
                        <td colspan="6" class="text-center py-4 text-muted">Bạn chưa gửi yêu cầu hỗ trợ nào.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>
