<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<title>Xác minh sự cố #${req.id}</title>

<div class="container mt-4">
    <div class="mb-3">
        <a href="<c:url value='/staff/incident-list'/>" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
    </div>

    <div class="card shadow-lg border-0">
        <div class="card-header bg-danger text-white py-3">
            <h5 class="mb-0 fw-bold"><i class="fas fa-tasks me-2"></i>BƯỚC 1: XÁC MINH & ĐỐI CHIẾU THIẾT BỊ</h5>
        </div>

        <div class="card-body bg-light p-4">
            <form action="<c:url value='/staff/verify-status'/>" method="POST">
                <input type="hidden" name="requestId" value="${req.id}" />
                <input type="hidden" name="newStatus" value="VERIFIED" />

                <div class="row g-4">
                    <div class="col-lg-5">
                        <h6 class="text-uppercase text-secondary fw-bold mb-3">
                            <i class="fas fa-envelope-open-text me-2"></i>Yêu cầu từ khách hàng
                        </h6>
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">${req.info.issueType}</span>
                                    <small class="text-muted">ID: #${req.id}</small>
                                </div>

                                <h5 class="fw-bold text-dark mb-3">${req.info.title}</h5>

                                <div class="bg-light p-3 rounded border mb-3">
                                    <label class="small text-muted fw-bold mb-1">Mô tả hiện tượng:</label>
                                    <div class="fst-italic text-secondary">${req.info.description}</div>
                                </div>

                                <div class="row g-2 mb-3">
                                    <div class="col-12">
                                        <div class="p-2 border rounded bg-white">
                                            <div class="small text-muted">Ngày mong muốn</div>
                                            <div class="fw-bold text-primary">
                                                <i class="far fa-calendar-alt me-1"></i>
                                                ${req.info.preferredDate != null ? req.info.preferredDate : 'Càng sớm càng tốt'}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center p-3 border rounded bg-white">
                                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">${req.info.reporterName}</div>
                                        <div class="small text-secondary"><i class="fas fa-phone me-1"></i>${req.info.reporterPhone}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-7">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="text-uppercase text-success fw-bold mb-0">
                                <i class="fas fa-server me-2"></i>Danh sách thiết bị của khách (${customerAssets.size()})
                            </h6>
                            <span class="badge bg-light text-secondary border">Đối chiếu Serial</span>
                        </div>

                        <div class="card border-0 shadow-sm" style="max-height: 500px; overflow-y: auto;">
                            <div class="list-group list-group-flush">
                                <c:forEach items="${customerAssets}" var="asset">
                                    <c:set var="isMatch" value="${asset.id == requestedProduct.id}" />

                                    <div class="list-group-item list-group-item-action py-3 ${isMatch ? 'bg-success bg-opacity-10 border-start border-success border-4' : ''}">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <div class="d-flex align-items-center">
                                                <div class="me-3 text-center" style="width: 40px;">
                                                    <i class="fas fa-server fa-2x ${isMatch ? 'text-success' : 'text-secondary opacity-25'}"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold ${isMatch ? 'text-success' : 'text-dark'}">
                                                            ${asset.modelName}
                                                        <c:if test="${isMatch}">
                                                            <span class="badge bg-success ms-2"><i class="fas fa-check me-1"></i>ĐÚNG MÁY KHÁCH BÁO</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="small text-muted font-monospace">
                                                        SN: <span class="fw-bold text-dark">${asset.serialNumber}</span>
                                                    </div>
                                                    <div class="small mt-1">
                                                        Trạng thái:
                                                        <c:choose>
                                                            <c:when test="${asset.status == 'RUNNING'}"><span class="badge bg-primary rounded-pill" style="font-size: 0.65rem;">RUNNING</span></c:when>
                                                            <c:when test="${asset.status == 'BROKEN'}"><span class="badge bg-danger rounded-pill" style="font-size: 0.65rem;">BROKEN</span></c:when>
                                                            <c:otherwise><span class="badge bg-secondary rounded-pill" style="font-size: 0.65rem;">${asset.status}</span></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>

                                            <c:if test="${!isMatch}">
                                                <span class="text-muted opacity-25" title="Không phải máy này"><i class="fas fa-circle"></i></span>
                                            </c:if>
                                            <c:if test="${isMatch}">
                                                <i class="fas fa-check-circle text-success fs-4"></i>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty customerAssets}">
                                    <div class="p-4 text-center text-muted">
                                        <i class="fas fa-box-open fa-2x mb-2"></i><br>
                                        Khách hàng này chưa sở hữu thiết bị nào trên hệ thống.
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="alert alert-warning border-0 d-flex align-items-center mt-3" role="alert">
                            <input class="form-check-input me-3 shadow-none" type="checkbox" id="checkVerify" style="transform: scale(1.3);" required>
                            <label class="form-check-label fw-bold small text-dark" for="checkVerify">
                                Tôi xác nhận thông tin khách hàng và thiết bị (Serial Number) là chính xác.
                            </label>
                        </div>
                    </div>
                </div>

                <div class="text-end mt-4 pt-3 border-top">
                    <button type="button" class="btn btn-secondary me-2" onclick="history.back()">Hủy</button>
                    <button type="submit" class="btn btn-danger px-4 fw-bold shadow-sm">
                        <i class="fas fa-check-double me-2"></i>Xác Minh & Hoàn tất
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>