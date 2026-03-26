<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Chi tiết Yêu cầu #${incident.id}</title>

<div class="container-fluid py-4">
    <c:set var="preferredTimeFrom" value="${incident.info.preferredTimeFrom}" />
    <c:set var="preferredTimeTo" value="${incident.info.preferredTimeTo}" />
    <c:set var="preferredTimeSlot" value="${not empty incident.info.preferredTimeSlot ? incident.info.preferredTimeSlot : incidentEntity.preferredTimeSlot}" />
    <c:set var="urgencyLevel" value="${not empty incidentEntity ? incidentEntity.urgencyLevel : incident.info.urgencyLevel}" />

    <%-- Nút Quay lại --%>
    <div class="mb-3">
        <a href="<c:url value='/staff/incident-list'/>" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary fw-bold mb-0">
            <i class="fas fa-file-alt me-2 text-primary"></i>Chi tiết Yêu cầu #${incident.id}
        </h3>

        <%-- Hiển thị trạng thái góc trên cùng --%>
        <div>
            <c:choose>
                <c:when test="${incident.status == 'NEW'}"><span class="badge bg-danger fs-6 px-3 py-2 rounded-pill">MỚI (CẦN XỬ LÝ)</span></c:when>
                <c:when test="${incident.status == 'VERIFIED'}"><span class="badge bg-info text-dark fs-6 px-3 py-2 rounded-pill">ĐÃ XÁC MINH</span></c:when>
                <c:when test="${incident.status == 'WAITING_MANAGER'}"><span class="badge bg-warning text-dark fs-6 px-3 py-2 rounded-pill">CHỜ DUYỆT</span></c:when>
                <c:when test="${incident.status == 'APPROVED'}"><span class="badge bg-primary fs-6 px-3 py-2 rounded-pill">ĐÃ DUYỆT</span></c:when>
                <c:otherwise><span class="badge bg-secondary fs-6 px-3 py-2 rounded-pill">${incident.status}</span></c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="row g-4">
        <%-- CỘT TRÁI: THÔNG TIN SỰ CỐ --%>
        <div class="col-lg-8">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 text-primary fw-bold"><i class="fas fa-exclamation-triangle me-2"></i>Nội dung sự cố</h5>
                </div>
                <div class="card-body p-4">
                    <div class="mb-4">
                        <label class="text-muted small fw-bold text-uppercase mb-1">Tiêu đề yêu cầu</label>
                        <h4 class="text-dark fw-bold mb-0">${incident.info.title}</h4>
                    </div>

                    <%-- Dòng 1: Loại sự cố & Thời gian gửi --%>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold text-uppercase mb-1">Loại sự cố</label>
                            <div class="fs-6">
                                <c:choose>
                                    <c:when test="${incident.info.issueType == 'MAINTENANCE'}">Bảo dưỡng định kỳ</c:when>
                                    <c:when test="${incident.info.issueType == 'REPLACEMENT'}">Thay thế phụ tùng</c:when>
                                    <c:when test="${incident.info.issueType == 'BROKEN'}">Lỗi / Hỏng hóc</c:when>
                                    <c:otherwise>${not empty incident.info.issueType ? incident.info.issueType : 'Khác'}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold text-uppercase mb-1">Thời gian gửi</label>
                            <div class="fs-6 text-dark">
                                <i class="far fa-clock me-1 text-secondary"></i>
                                <fmt:formatDate value="${incident.createdAt}" pattern="dd/MM/yyyy - HH:mm" />
                            </div>
                        </div>
                    </div>

                    <%-- THÊM MỚI - Dòng 2: Ngày/giờ mong muốn + mức độ nghiêm trọng --%>
                    <div class="row mb-4 g-3">
                        <div class="col-md-7">
                            <div class="border-start border-3 border-success ps-3 ms-1 bg-light py-3 rounded-end h-100">
                                <label class="text-muted small fw-bold text-uppercase mb-2 d-block">Ngày mong muốn sửa chữa</label>
                                <div class="fs-6 text-dark fw-bold mb-2">
                                    <i class="fas fa-calendar-check me-2 text-success"></i>
                                    <c:choose>
                                        <c:when test="${not empty incident.info.preferredDate}">
                                            <fmt:parseDate value="${incident.info.preferredDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="fst-italic text-muted fw-normal">Sắp xếp càng sớm càng tốt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="small text-dark mb-1">
                                    <i class="far fa-clock me-2 text-primary"></i>
                                    <strong>Khung giờ:</strong>
                                    <c:choose>
                                        <c:when test="${not empty preferredTimeFrom and not empty preferredTimeTo}">
                                            ${fn:substring(preferredTimeFrom, 0, 5)} - ${fn:substring(preferredTimeTo, 0, 5)}
                                        </c:when>
                                        <c:otherwise>Linh động</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="small text-dark">
                                    <i class="fas fa-sun me-2 text-warning"></i>
                                    <strong>Buổi ưu tiên:</strong>
                                    <c:choose>
                                        <c:when test="${preferredTimeSlot == 'MORNING'}">Buổi sáng</c:when>
                                        <c:when test="${preferredTimeSlot == 'AFTERNOON'}">Buổi chiều</c:when>
                                        <c:when test="${preferredTimeSlot == 'ANYTIME' || empty preferredTimeSlot}">Linh động cả ngày</c:when>
                                        <c:otherwise>${preferredTimeSlot}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="bg-light border rounded p-3 h-100">
                                <label class="text-muted small fw-bold text-uppercase mb-2 d-block">Mức độ nghiêm trọng</label>
                                <c:choose>
                                    <c:when test="${urgencyLevel == 'CRITICAL'}">
                                        <span class="badge bg-danger fs-6 px-3 py-2">Khẩn cấp</span>
                                    </c:when>
                                    <c:when test="${urgencyLevel == 'HIGH'}">
                                        <span class="badge bg-warning text-dark fs-6 px-3 py-2">Cao</span>
                                    </c:when>
                                    <c:when test="${urgencyLevel == 'MEDIUM'}">
                                        <span class="badge bg-info text-dark fs-6 px-3 py-2">Trung bình</span>
                                    </c:when>
                                    <c:when test="${urgencyLevel == 'LOW'}">
                                        <span class="badge bg-secondary fs-6 px-3 py-2">Thấp</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary fs-6 px-3 py-2">${not empty urgencyLevel ? urgencyLevel : 'Chưa cập nhật'}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <%-- Mô tả chi tiết --%>
                    <div class="mb-0">
                        <label class="text-muted small fw-bold text-uppercase mb-2">Mô tả chi tiết</label>
                        <div class="p-3 bg-light rounded border">
                            <c:choose>
                                <c:when test="${not empty incident.info.description}">
                                    ${incident.info.description}
                                </c:when>
                                <c:otherwise>
                                    <span class="fst-italic text-muted">Không có mô tả chi tiết từ người gửi.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- CỘT PHẢI: THÔNG TIN THIẾT BỊ & NGƯỜI BÁO --%>
        <div class="col-lg-4">
            <%-- Thẻ 1: Thông tin thiết bị --%>
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white border-bottom py-3">
                    <h6 class="mb-0 text-dark fw-bold"><i class="fas fa-server me-2 text-primary"></i>Thông tin Thiết bị</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty product}">
                            <div class="mb-3">
                                <label class="text-muted small mb-1">Tên máy / Model</label>
                                <div class="fw-bold text-dark fs-6">${product.modelName}</div>
                            </div>
                            <div class="mb-0">
                                <label class="text-muted small mb-1">Số Serial</label>
                                <div class="font-monospace text-secondary"><i class="fas fa-barcode me-2"></i>${product.serialNumber}</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-3 text-muted">
                                <i class="fas fa-exclamation-circle fa-2x mb-2 text-warning"></i>
                                <p class="mb-0">Không tìm thấy thông tin thiết bị (ID: ${incident.info.productId})</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- Thẻ 2: Thông tin người báo --%>
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white border-bottom py-3">
                    <h6 class="mb-0 text-dark fw-bold"><i class="fas fa-user-circle me-2 text-success"></i>Thông tin Người báo</h6>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="avatar-circle bg-light text-secondary d-flex justify-content-center align-items-center rounded-circle me-3" style="width: 45px; height: 45px;">
                            <i class="fas fa-user fs-5"></i>
                        </div>
                        <div>
                            <div class="fw-bold text-dark">${incident.info.reporterName}</div>
                            <a href="<c:url value='/staff/user-information?id=${not empty product ? product.customerId : incident.senderId}'/>"
                               class="text-decoration-none small text-primary">Xem hồ sơ KH <i class="fas fa-external-link-alt ms-1"></i></a>
                        </div>
                    </div>
                    <hr class="text-muted opacity-25">
                    <div class="mb-0">
                        <label class="text-muted small mb-1">Số điện thoại liên hệ</label>
                        <div class="fw-bold text-dark"><i class="fas fa-phone-alt me-2 text-secondary"></i>${incident.info.reporterPhone}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- THANH CÔNG CỤ XỬ LÝ (Tùy theo trạng thái) --%>
    <div class="card shadow-sm border-0 mt-4 bg-light">
        <div class="card-body d-flex justify-content-end gap-2">
            <c:choose>
                <c:when test="${incident.status == 'NEW'}">
                    <a href="<c:url value='/staff/incident/verify?id=${incident.id}'/>" class="btn btn-danger px-4 rounded-pill">
                        <i class="fas fa-check-circle me-2"></i>Chuyển sang Xác minh
                    </a>
                </c:when>
                <c:when test="${incident.status == 'VERIFIED'}">
                    <a href="<c:url value='/staff/incident/escalate?id=${incident.id}'/>" class="btn btn-primary px-4 rounded-pill">
                        <i class="fas fa-paper-plane me-2"></i>Gửi yêu cầu Báo giá
                    </a>
                </c:when>
                <c:when test="${incident.status == 'APPROVED'}">
                    <form action="<c:url value='/staff/assign-task'/>" method="post" class="m-0">
                        <input type="hidden" name="id" value="${incident.id}">
                        <button type="submit" class="btn btn-success px-4 rounded-pill" onclick="return confirm('Xác nhận tạo task bảo trì cho yêu cầu này?')">
                            <i class="fas fa-tools me-2"></i>Tạo Task Kỹ thuật viên
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-secondary px-4 rounded-pill disabled" disabled>
                        <i class="fas fa-lock me-2"></i>Không có thao tác khả dụng
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>