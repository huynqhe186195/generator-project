<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Lịch sử Báo giá | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light">

<div class="container py-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-primary mb-1"><i class="fas fa-history me-2"></i>Lịch sử Báo giá & Sửa chữa</h3>
            <p class="text-muted mb-0">
                Thiết bị: <span class="fw-bold text-dark">${product.modelName}</span>
                (Serial: <span class="font-monospace">${product.serialNumber}</span>)
            </p>
        </div>
        <a href="<c:url value='/product-list'/>" class="btn btn-outline-secondary rounded-pill px-4 fw-bold">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-primary text-white">
                <tr>
                    <th class="ps-4 py-3">Mã Báo Giá</th>
                    <th class="py-3">Ngày tạo</th>
                    <th class="py-3">Ngày duyệt</th>
                    <th class="py-3 text-end">Tổng tiền</th>
                    <th class="py-3 text-center">Trạng thái</th>
                    <th class="pe-4 py-3 text-center">Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty quoteHistory}">
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="fas fa-folder-open fa-3x mb-3 opacity-25"></i>
                                <h5>Chưa có lịch sử báo giá nào cho thiết bị này.</h5>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${quoteHistory}" var="q">
                            <tr>
                                <td class="ps-4 fw-bold text-secondary">#QUOTE-${q.id}</td>
                                <td>
                                        <%-- Thêm timeZone vào đây --%>
                                    <fmt:formatDate value="${q.createdAt}" pattern="dd/MM/yyyy HH:mm" timeZone="Asia/Ho_Chi_Minh" />
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty q.approvedAt}">
                                            <%-- Thêm timeZone vào đây --%>
                                            <fmt:formatDate value="${q.approvedAt}" pattern="dd/MM/yyyy HH:mm" timeZone="Asia/Ho_Chi_Minh" />
                                        </c:when>
                                        <c:otherwise><span class="text-muted fst-italic">Chưa duyệt</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end fw-bold text-danger">
                                    <fmt:formatNumber value="${q.totalAmount}" pattern="#,###" /> đ
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${q.status == 'APPROVED'}">
                                            <span class="badge bg-success rounded-pill px-3 py-2">Đã đồng ý</span>
                                        </c:when>
                                        <c:when test="${q.status == 'REJECTED'}">
                                            <span class="badge bg-danger rounded-pill px-3 py-2">Đã từ chối</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary rounded-pill px-3 py-2">${q.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-4 text-center">
                                        <%-- Bạn có thể viết thêm chức năng xem chi tiết báo giá cũ sau này --%>
                                    <button class="btn btn-sm btn-light border btn-pill px-3" onclick="alert('Tính năng xem chi tiết hóa đơn cũ đang phát triển!')">
                                        <i class="fas fa-eye text-primary"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>