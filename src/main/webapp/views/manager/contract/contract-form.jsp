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
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="text-primary mb-0"><i class="fa fa-file-contract"></i> Tạo hợp đồng (Draft + AI Review)</h3>
        <a href="${pageContext.request.contextPath}/manager/contracts?action=list" class="btn btn-secondary"><i class="fa fa-arrow-left"></i> Danh sách</a>
    </div>

    <c:if test="${not empty param.msg}"><div class="alert alert-info">${param.msg}</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>

    <div class="row g-3">
        <div class="col-lg-6">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-light fw-bold">1) Header hợp đồng</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/contracts/draft">
                        <div class="mb-2">
                            <label class="form-label fw-bold">Số hợp đồng *</label>
                            <input type="text" name="contractNumber" class="form-control" required
                                   value="${draftContract.contractNumber != null ? draftContract.contractNumber : param.contractNumber}"/>
                        </div>
                        <div class="mb-2">
                            <label class="form-label fw-bold">Bên mua *</label>
                            <select class="form-select" name="customerId" required>
                                <option value="">-- Chọn khách hàng --</option>
                                <c:forEach var="cus" items="${customers}">
                                    <option value="${cus.id}" <c:if test="${draftContract.customerId == cus.id}">selected</c:if>>${cus.fullName} - ${cus.email}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-2">
                                <label class="form-label fw-bold">Ngày ký *</label>
                                <input type="date" name="signedDate" class="form-control" required value="${draftContract.signedDate}"/>
                            </div>
                            <div class="col-md-4 mb-2">
                                <label class="form-label fw-bold">Ngày hiệu lực *</label>
                                <input type="date" name="startDate" class="form-control" required value="${draftContract.startDate}"/>
                            </div>
                            <div class="col-md-4 mb-2">
                                <label class="form-label fw-bold">Ngày hết hạn *</label>
                                <input type="date" name="endDate" class="form-control" required value="${draftContract.endDate}"/>
                            </div>
                        </div>
                        <button class="btn btn-primary" type="submit"><i class="fa fa-save"></i> Lưu nháp</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-light fw-bold">2) Chat box AI (Upload + Extract)</div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty draftContract}">
                            <div class="alert alert-warning">Hãy lưu nháp hợp đồng trước khi dùng AI.</div>
                        </c:when>
                        <c:otherwise>
                            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/manager/contracts/ai/upload" class="mb-3">
                                <input type="hidden" name="contractId" value="${draftContract.id}"/>
                                <label class="form-label">Upload ảnh snapshot hoặc PDF</label>
                                <input type="file" name="sourceFile" class="form-control mb-2" accept=".pdf,.png,.jpg,.jpeg,.txt,.csv" required/>
                                <button class="btn btn-outline-primary" type="submit">Upload file</button>
                            </form>

                            <form method="post" action="${pageContext.request.contextPath}/manager/contracts/ai/extract">
                                <input type="hidden" name="contractId" value="${draftContract.id}"/>
                                <button class="btn btn-success" type="submit"><i class="fa fa-robot"></i> AI Extract danh sách thiết bị</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty draftContract}">
        <div class="card shadow-sm mt-3">
            <div class="card-header bg-light fw-bold">3) Review danh sách thiết bị (editable)</div>
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/manager/contracts/ai/apply">
                    <input type="hidden" name="contractId" value="${draftContract.id}"/>
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle">
                            <thead>
                            <tr>
                                <th>Raw model</th>
                                <th>Matched model</th>
                                <th>Quantity</th>
                                <th>Serial</th>
                                <th>Năm SX</th>
                                <th>Vị trí</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${aiItems}">
                                <tr>
                                    <td>
                                        ${item.rawModelName}
                                        <input type="hidden" name="itemId" value="${item.id}"/>
                                    </td>
                                    <td>
                                        <select class="form-select" name="matchedModelId" required>
                                            <option value="">-- Chọn model --</option>
                                            <c:forEach var="m" items="${models}">
                                                <option value="${m.id}" <c:if test="${item.matchedModelId == m.id}">selected</c:if>>${m.name}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td><input class="form-control" type="number" min="1" name="quantity" value="${item.quantity}" required/></td>
                                    <td><input class="form-control" type="text" name="serial" value="${item.rawSerialNumber}"/></td>
                                    <td><input class="form-control" type="number" min="1900" max="2100" name="manufactureYear" value="${item.manufactureYear}"/></td>
                                    <td><input class="form-control" type="text" name="currentLocation" value="${item.currentLocation}"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty aiItems}">
                                <tr><td colspan="6" class="text-center text-muted">Chưa có dữ liệu AI extract.</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-primary" type="submit">Áp dụng dữ liệu đã sửa</button>
                    </div>
                </form>

                <form method="post" action="${pageContext.request.contextPath}/manager/contracts/finalize" class="mt-3">
                    <input type="hidden" name="contractId" value="${draftContract.id}"/>
                    <button type="submit" class="btn btn-danger"><i class="fa fa-check"></i> Tạo hợp đồng (Finalize)</button>
                </form>
            </div>
        </div>
    </c:if>

</div>
</body>
</html>
