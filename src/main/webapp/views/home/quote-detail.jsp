<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Báo giá #QUOTE-${quote.id} | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light">

<div class="container py-5">
    <%-- Header và Nút Quay lại --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-primary mb-1"><i class="fas fa-file-invoice-dollar me-2"></i>Chi tiết Báo giá</h3>
            <p class="text-muted mb-0">Mã tham chiếu: <span class="fw-bold text-dark">#QUOTE-${quote.id}</span></p>
        </div>
        <%-- Đổi URL này về đường link trang lịch sử báo giá trước đó của bạn --%>
        <a href="javascript:history.back()" class="btn btn-outline-secondary rounded-pill px-4 fw-bold">
            <i class="fas fa-arrow-left me-2"></i>Quay lại lịch sử
        </a>
    </div>

    <div class="row">
        <%-- BẢNG CHI TIẾT VẬT TƯ (BÊN TRÁI) --%>
        <div class="col-lg-8">
            <div class="card shadow-sm border-0 rounded-4 overflow-hidden mb-4">
                <div class="card-header bg-white py-3 border-bottom">
                    <h5 class="mb-0 fw-bold text-secondary"><i class="fas fa-tools me-2"></i>Hạng mục sửa chữa & Vật tư</h5>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-secondary">
                        <tr>
                            <th class="ps-4 py-3">STT</th>
                            <th class="py-3">Mô tả / Tên vật tư</th>
                            <th class="py-3 text-center">Số lượng</th>
                            <th class="py-3 text-end">Đơn giá</th>
                            <th class="pe-4 py-3 text-end">Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty quoteDetails}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">Không có chi tiết vật tư nào.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${quoteDetails}" var="detail" varStatus="loop">
                                    <tr>
                                        <td class="ps-4 fw-bold text-secondary">${loop.index + 1}</td>
                                        <td class="fw-bold text-dark">${detail.description}</td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary rounded-pill px-3">${detail.quantity}</span>
                                        </td>
                                        <td class="text-end text-muted">
                                            <fmt:formatNumber value="${detail.unitPrice}" pattern="#,###" /> đ
                                        </td>
                                        <td class="pe-4 text-end fw-bold text-primary">
                                            <fmt:formatNumber value="${detail.totalPrice}" pattern="#,###" /> đ
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

        <%-- THÔNG TIN TỔNG QUAN BÁO GIÁ (BÊN PHẢI) --%>
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 rounded-4 position-sticky" style="top: 20px;">
                <div class="card-header bg-primary text-white py-3 border-0">
                    <h5 class="mb-0 fw-bold"><i class="fas fa-info-circle me-2"></i>Tổng quan báo giá</h5>
                </div>
                <div class="card-body bg-white p-4">

                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <span class="text-muted small">Trạng thái:</span>
                        <c:choose>
                            <c:when test="${quote.status == 'APPROVED'}">
                                <span class="badge bg-success rounded-pill px-3 py-2">Khách đã đồng ý</span>
                            </c:when>
                            <c:when test="${quote.status == 'REJECTED'}">
                                <span class="badge bg-danger rounded-pill px-3 py-2">Khách đã từ chối</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning text-dark rounded-pill px-3 py-2">${quote.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <hr class="text-muted opacity-25">



                    <div class="mb-3">
                        <p class="text-muted small mb-1"><i class="fas fa-check-double me-1"></i>Ngày duyệt/xác nhận:</p>
                        <p class="fw-bold text-dark mb-0">
                            <c:choose>
                                <c:when test="${not empty quote.approvedAt}">
                                    <fmt:formatDate value="${quote.approvedAt}" pattern="dd/MM/yyyy HH:mm" timeZone="Asia/Ho_Chi_Minh" />
                                </c:when>
                                <c:otherwise><span class="fst-italic text-muted">Chưa duyệt</span></c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <hr class="text-muted opacity-25">

                    <%-- Tổng tiền --%>
                    <div class="mt-4 pt-2 border-top border-2 border-primary border-opacity-25">
                        <p class="text-muted small text-uppercase fw-bold mb-1">Tổng chi phí sửa chữa:</p>
                        <h3 class="fw-bold text-danger mb-0">
                            <fmt:formatNumber value="${quote.totalAmount}" pattern="#,###" /> VNĐ
                        </h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>