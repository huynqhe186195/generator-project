<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo hợp đồng</title>
</head>

<body>
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-0 text-primary">
                <i class="fa fa-file-contract"></i> Tạo hợp đồng (Header)
            </h3>
            <div class="text-muted small">
                Luồng mới: Tạo hợp đồng → <b>PENDING_SERIAL</b> → gán serial để tạo Product.
            </div>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/manager/contracts?action=list" class="btn btn-secondary">
                <i class="fa fa-arrow-left"></i> Danh sách
            </a>
        </div>
    </div>

    <!-- Hiển thị lỗi -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <b>Lỗi:</b> ${errorMessage}
        </div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-header bg-light fw-bold">
            <i class="fa fa-info-circle text-primary"></i> Thông tin hợp đồng
        </div>

        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/manager/contracts">
                <input type="hidden" name="action" value="create" />

                <div class="mb-3">
                    <label class="form-label fw-bold">Số hợp đồng <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="contractNumber"
                           value="${contract.contractNumber != null ? contract.contractNumber : param.contractNumber}"
                           placeholder="VD: HD-2026-001" required />
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Khách hàng <span class="text-danger">*</span></label>
                    <select class="form-select" name="customerId" required>
                        <option value="">-- Chọn khách hàng --</option>
                        <c:forEach var="cus" items="${customers}">
                            <option value="${cus.id}"
                                <c:if test="${(not empty contract && contract.customerId == cus.id) || (param.customerId == cus.id)}">selected</c:if>>
                                ${cus.fullName} - ${cus.email}
                            </option>
                        </c:forEach>
                    </select>
                    <div class="form-text">
                        Nếu khách chưa có tài khoản, dùng chức năng <b>Yêu cầu tạo account</b> ở màn list/import.
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Ngày ký <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" name="signedDate"
                               value="${param.signedDate}"
                               required />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Ngày có hiệu lực <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" name="startDate"
                               value="${contract.startDate != null ? contract.startDate : param.startDate}"
                               required />
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Ngày hết hiệu lực <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" name="endDate"
                               value="${contract.endDate != null ? contract.endDate : param.endDate}"
                               required />
                    </div>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-save"></i> Tạo hợp đồng
                    </button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/manager/contracts?action=list">
                        Hủy
                    </a>
                </div>

            </form>
        </div>
    </div>

</div>
</body>
</html>
