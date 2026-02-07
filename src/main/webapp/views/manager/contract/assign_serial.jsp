<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container py-4" style="max-width: 980px;">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <div>
            <h3 class="mb-1 fw-bold">Gán serial vào hợp đồng</h3>
            <div class="text-muted">Tạo Product cho khách hàng sau khi import hợp đồng</div>
        </div>
        <a class="btn btn-outline-secondary"
           href="${pageContext.request.contextPath}/manager/contracts?action=detail&id=${contract.id}">
            ← Quay lại chi tiết
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <b>Lỗi:</b> ${error}
        </div>
    </c:if>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="row g-2">
                <div class="col-md-6">
                    <div class="fw-semibold">Số hợp đồng:</div>
                    <div class="text-primary fw-bold">${contract.contractNumber}</div>
                </div>
                <div class="col-md-6">
                    <div class="fw-semibold">Trạng thái:</div>
                    <div>
                        <c:choose>
                            <c:when test="${contract.status == 'PENDING_SERIAL'}">
                                <span class="badge bg-warning text-dark">PENDING_SERIAL</span>
                            </c:when>
                            <c:when test="${contract.status == 'ACTIVE'}">
                                <span class="badge bg-success">ACTIVE</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${contract.status}</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="text-muted ms-2">contractId: ${contract.id} | customerId: ${contract.customerId}</span>
                    </div>
                </div>
            </div>

            <div class="alert alert-info mt-3 mb-0">
                Import xong hợp đồng sẽ ở <b>PENDING_SERIAL</b>. Khi gán serial thành công (tạo Product),
                hệ thống chuyển hợp đồng sang <b>ACTIVE</b>.
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/manager/contracts">
                <input type="hidden" name="action" value="assignSerialSubmit"/>
                <input type="hidden" name="contractId" value="${contract.id}"/>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Serial number <span class="text-danger">*</span></label>
                        <input type="text" name="serialNumber" class="form-control"
                               placeholder="VD: SN-2026-5555"
                               value="${param.serialNumber}" required>
                        <div class="form-text">Serial là duy nhất. Nếu đã tồn tại, hệ thống sẽ báo lỗi.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Model (tùy chọn)</label>
                        <select name="modelId" class="form-select">
                            <option value="">-- Chọn model --</option>
                            <c:forEach var="m" items="${models}">
                                <option value="${m.id}" <c:if test="${param.modelId == m.id}">selected</c:if>>
                                    ${m.name}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Nếu muốn bắt buộc model, enforce ở DAO/service.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Ngày mua (tùy chọn)</label>
                        <input type="date" name="purchaseDate" class="form-control" value="${param.purchaseDate}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Năm sản xuất (tùy chọn)</label>
                        <input type="number" name="manufactureYear" class="form-control"
                               placeholder="VD: 2024" min="1990" max="2100" value="${param.manufactureYear}">
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">Vị trí hiện tại (tùy chọn)</label>
                        <input type="text" name="currentLocation" class="form-control"
                               placeholder="VD: Địa chỉ lắp đặt / Kho khách..."
                               value="${param.currentLocation}">
                        <div class="form-text">Nếu để trống, bạn có thể auto set theo tên khách (tùy code).</div>
                    </div>

                    <div class="col-12 d-flex gap-2 pt-2">
                        <button type="submit" class="btn btn-primary">
                            Gán serial (tạo Product)
                        </button>
                        <a class="btn btn-outline-secondary"
                           href="${pageContext.request.contextPath}/manager/contracts?action=assignSerialForm&id=${contract.id}">
                            Làm mới
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
