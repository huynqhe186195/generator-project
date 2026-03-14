<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo hợp đồng</title>
    <style>
        .contract-create-layout { display: grid; grid-template-columns: 1.25fr 0.9fr; gap: 20px; }
        .contract-panel { background: #fff; border: 1px solid #dcdcdc; border-radius: 10px; }
        .contract-panel .panel-title { font-size: 30px; font-weight: 700; margin: 0; }
        .contract-panel .panel-body { padding: 22px; }
        .contract-field { display: grid; grid-template-columns: 180px 1fr; align-items: center; gap: 10px; margin-bottom: 14px; }
        .contract-field label { margin: 0; font-weight: 600; }

        .mitiga-chatbox { border-radius: 12px; overflow: hidden; border: 1px solid #e1e1e1; background: #f7f7f7; }
        .mitiga-header { background: #b50000; color: #fff; padding: 14px 16px; display: flex; align-items: center; justify-content: space-between; }
        .mitiga-header .brand { font-weight: 700; font-size: 30px; display: flex; align-items: center; gap: 8px; }
        .mitiga-content { padding: 14px; min-height: 430px; background: linear-gradient(180deg, #f3f3f3 0%, #fbfbfb 100%); }
        .chat-bubble { background: #fff; border-radius: 12px; padding: 10px 12px; margin-bottom: 10px; box-shadow: 0 1px 2px rgba(0,0,0,.06); }
        .chat-chip { display: inline-block; margin: 0 6px 8px 0; padding: 7px 12px; border-radius: 999px; background: #ececec; font-weight: 600; }
        .chat-input { display: grid; grid-template-columns: 1fr auto auto; gap: 8px; background: #fff; border-radius: 9px; padding: 8px; border: 1px solid #e4e4e4; }
        .chat-footer { text-align: center; font-weight: 700; color: #666; margin-top: 10px; }
        .chat-tools { margin-top: 14px; background: #fff; border-radius: 10px; border: 1px solid #ececec; padding: 12px; }

        @media (max-width: 992px) {
            .contract-create-layout { grid-template-columns: 1fr; }
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

    <div class="contract-create-layout">
        <div class="contract-panel">
            <div class="panel-body">
                <h2 class="panel-title mb-4">Chi tiết hợp đồng</h2>
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

        <div class="mitiga-chatbox">
            <div class="mitiga-header">
                <div class="brand">
                    <span>🤖</span>
                    <span>MITIGA AI</span>
                </div>
                <div>
                    <i class="fa fa-refresh me-3"></i>
                    <i class="fa fa-close"></i>
                </div>
            </div>

            <div class="mitiga-content">
                <div class="chat-bubble">
                    Xin chào! Mình là trợ lý AI. Bạn muốn trích xuất danh sách thiết bị từ file hợp đồng?
                </div>

                <div>
                    <span class="chat-chip">Trích xuất model + serial</span>
                    <span class="chat-chip">Kiểm tra số lượng thiết bị</span>
                    <span class="chat-chip">Gợi ý matched model</span>
                </div>

                <div class="chat-input mt-3">
                    <input class="form-control border-0" placeholder="Câu hỏi của bạn là gì?"/>
                    <button class="btn btn-link" type="button"><i class="fa fa-microphone"></i></button>
                    <button class="btn btn-primary" type="button"><i class="fa fa-send"></i></button>
                </div>
                <div class="chat-footer">Powered by MITIGA</div>

                <div class="chat-tools">
                    <c:choose>
                        <c:when test="${empty draftContract}">
                            <div class="alert alert-warning mb-0">Vui lòng lưu nháp hợp đồng trước khi upload file cho AI.</div>
                        </c:when>
                        <c:otherwise>
                            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/manager/contracts/ai/upload" class="mb-2">
                                <input type="hidden" name="contractId" value="${draftContract.id}"/>
                                <label class="form-label">Upload snapshot/PDF</label>
                                <input type="file" name="sourceFile" class="form-control mb-2" accept=".pdf,.png,.jpg,.jpeg,.txt,.csv" required/>
                                <button class="btn btn-outline-primary" type="submit">Upload file</button>
                            </form>

                            <form method="post" action="${pageContext.request.contextPath}/manager/contracts/ai/extract">
                                <input type="hidden" name="contractId" value="${draftContract.id}"/>
                                <button class="btn btn-danger" type="submit"><i class="fa fa-robot"></i> AI Extract</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
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
