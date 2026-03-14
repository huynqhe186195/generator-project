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

        .ai-bubble-toggle { display: none; }
        .ai-bubble-launcher {
            position: fixed;
            right: 24px;
            bottom: 24px;
            width: 66px;
            height: 66px;
            border-radius: 50%;
            border: none;
            background: #c20000;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 31px;
            box-shadow: 0 10px 24px rgba(0,0,0,.25);
            cursor: pointer;
            z-index: 2000;
        }

        .ai-chatbox {
            position: fixed;
            right: 24px;
            bottom: 104px;
            width: 380px;
            max-width: calc(100vw - 32px);
            background: #f8f8f8;
            border: 1px solid #dfdfdf;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 20px 38px rgba(0,0,0,.25);
            opacity: 0;
            transform: translateY(20px) scale(.97);
            pointer-events: none;
            transition: all .22s ease;
            z-index: 1999;
        }

        .ai-bubble-toggle:checked ~ .ai-chatbox {
            opacity: 1;
            transform: translateY(0) scale(1);
            pointer-events: auto;
        }

        .ai-chatbox-header {
            background: #b50000;
            color: #fff;
            padding: 12px 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-weight: 700;
        }

        .ai-chatbox-body {
            padding: 14px;
            max-height: 62vh;
            overflow: auto;
            background: linear-gradient(180deg, #f2f2f2 0%, #fbfbfb 100%);
        }

        .ai-msg {
            background: #fff;
            border-radius: 12px;
            padding: 10px 12px;
            margin-bottom: 10px;
            box-shadow: 0 1px 2px rgba(0,0,0,.08);
        }

        .ai-chip { display: inline-block; margin: 0 6px 8px 0; padding: 6px 12px; border-radius: 999px; background: #ececec; font-weight: 600; }
        .ai-input { display: grid; grid-template-columns: 1fr auto; gap: 8px; margin-top: 8px; }
        .ai-tools { margin-top: 12px; border: 1px solid #ebebeb; background: #fff; border-radius: 10px; padding: 10px; }
        .ai-tip-badge {
            position: fixed;
            right: 102px;
            bottom: 53px;
            background: #111;
            color: #fff;
            border-radius: 8px;
            padding: 8px 12px;
            font-weight: 700;
            z-index: 2000;
        }

        @media (max-width: 992px) {
            .contract-field { grid-template-columns: 1fr; }
            .ai-chatbox { right: 10px; bottom: 90px; width: calc(100vw - 20px); }
            .ai-bubble-launcher { right: 10px; bottom: 12px; }
            .ai-tip-badge { display: none; }
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

<input type="checkbox" id="aiWidgetToggle" class="ai-bubble-toggle"/>
<label for="aiWidgetToggle" class="ai-bubble-launcher" title="Mở AI Assistant">🤖</label>
<div class="ai-tip-badge">Xin chào, Em là trợ lý AI! 👋</div>

<div class="ai-chatbox">
    <div class="ai-chatbox-header">
        <span><i class="fa fa-android"></i> AI Assistant</span>
        <label for="aiWidgetToggle" style="cursor:pointer; margin:0;"><i class="fa fa-close"></i></label>
    </div>
    <div class="ai-chatbox-body">
        <div class="ai-msg">Chào bạn! Mình hỗ trợ trích xuất danh sách thiết bị từ file hợp đồng (snapshot/PDF).</div>
        <div>
            <span class="ai-chip">Đọc model thô</span>
            <span class="ai-chip">Đọc serial nếu có</span>
            <span class="ai-chip">Gợi ý model match</span>
        </div>

        <div class="ai-input">
            <input class="form-control" placeholder="Nhập câu hỏi cho AI..." />
            <button class="btn btn-primary" type="button"><i class="fa fa-send"></i></button>
        </div>

        <div class="ai-tools">
            <c:choose>
                <c:when test="${empty draftContract}">
                    <div class="alert alert-warning mb-0">Vui lòng lưu nháp hợp đồng trước khi chạy AI.</div>
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
</body>
</html>
