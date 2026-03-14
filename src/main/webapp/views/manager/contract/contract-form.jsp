<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo hợp đồng</title>
    <style>
        .contract-panel { background: #fff; border: 1px solid #dcdcdc; border-radius: 10px; }
        .contract-panel .panel-title { font-size: 30px; font-weight: 700; margin: 0; }
        .contract-panel .panel-body { padding: 22px; }
        .contract-field { display: grid; grid-template-columns: 180px 1fr; align-items: center; gap: 10px; margin-bottom: 14px; }
        .contract-field label { margin: 0; font-weight: 600; }

        @media (max-width: 992px) {
            .contract-field { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="container mt-4 mb-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="text-primary mb-0"><i class="fa fa-file-contract"></i> Tạo hợp đồng</h3>
        <a href="${pageContext.request.contextPath}/manager/contracts?action=list" class="btn btn-secondary"><i class="fa fa-arrow-left"></i> Danh sách</a>
    </div>

    <c:if test="${not empty param.msg}"><div class="alert alert-info">${param.msg}</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>

    <div class="contract-panel">
        <div class="panel-body">
            <h2 class="panel-title mb-4">Chi tiết hợp đồng</h2>
            <div class="alert alert-secondary py-2">Mở bong bóng AI góc phải dưới để <b>add file PDF</b> và chạy AI Extract.</div>
            <form method="post" action="${pageContext.request.contextPath}/manager/contracts/draft">
                <div class="contract-field">
                    <label>Số hợp đồng <span class="text-danger">*</span></label>
                    <input type="text" name="contractNumber" class="form-control" required
                           value="${draftContract.contractNumber != null ? draftContract.contractNumber : param.contractNumber}"/>
                </div>

                <div class="contract-field">
                    <label>Bên mua <span class="text-danger">*</span></label>
                    <select class="form-select" name="customerId" required>
                        <option value="">-- Chọn khách hàng --</option>
                        <c:forEach var="cus" items="${customers}">
                            <option value="${cus.id}" <c:if test="${draftContract.customerId == cus.id}">selected</c:if>>${cus.fullName} - ${cus.email}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="contract-field">
                    <label>Ngày ký <span class="text-danger">*</span></label>
                    <input type="date" name="signedDate" class="form-control" required value="${draftContract.signedDate}"/>
                </div>

                <div class="contract-field">
                    <label>Ngày hiệu lực <span class="text-danger">*</span></label>
                    <input type="date" name="startDate" class="form-control" required value="${draftContract.startDate}"/>
                </div>

                <div class="contract-field">
                    <label>Ngày hết hạn <span class="text-danger">*</span></label>
                    <input type="date" name="endDate" class="form-control" required value="${draftContract.endDate}"/>
                </div>

                <button class="btn btn-primary" type="submit"><i class="fa fa-save"></i> Lưu nháp</button>
            </form>
        </div>
    </div>

    <c:if test="${not empty draftContract}">
        <div class="card shadow-sm mt-3">
            <div class="card-header bg-light fw-bold">Danh sách thiết bị review (editable)</div>
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
