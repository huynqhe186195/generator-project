<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .global-ai-bubble-toggle { display: none; }
    .global-ai-bubble-launcher {
        position: fixed;
        right: 24px;
        bottom: 24px;
        width: 64px;
        height: 64px;
        border-radius: 50%;
        background: #c20000;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 30px;
        box-shadow: 0 10px 24px rgba(0,0,0,.25);
        cursor: pointer;
        z-index: 2100;
    }
    .global-ai-chatbox {
        position: fixed;
        right: 24px;
        bottom: 100px;
        width: 380px;
        max-width: calc(100vw - 32px);
        border: 1px solid #dfdfdf;
        border-radius: 12px;
        overflow: hidden;
        background: #f8f8f8;
        box-shadow: 0 20px 38px rgba(0,0,0,.25);
        opacity: 0;
        transform: translateY(20px) scale(.97);
        pointer-events: none;
        transition: all .2s ease;
        z-index: 2099;
    }
    .global-ai-bubble-toggle:checked ~ .global-ai-chatbox {
        opacity: 1;
        transform: translateY(0) scale(1);
        pointer-events: auto;
    }
    .global-ai-header {
        background: #b50000;
        color: #fff;
        padding: 12px 14px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 700;
    }
    .global-ai-body {
        padding: 14px;
        max-height: 62vh;
        overflow: auto;
        background: linear-gradient(180deg, #f2f2f2 0%, #fbfbfb 100%);
    }
    .global-ai-msg { background: #fff; border-radius: 12px; padding: 10px 12px; margin-bottom: 10px; }
    .global-ai-chip { display: inline-block; margin: 0 6px 8px 0; padding: 6px 12px; border-radius: 999px; background: #ececec; font-weight: 600; }
    .global-ai-tools { margin-top: 12px; border: 1px solid #ebebeb; background: #fff; border-radius: 10px; padding: 10px; }
    .global-ai-tip {
        position: fixed;
        right: 100px;
        bottom: 52px;
        background: #111;
        color: #fff;
        border-radius: 8px;
        padding: 8px 12px;
        font-weight: 700;
        z-index: 2100;
    }
</style>

<input type="checkbox" id="globalAiToggle" class="global-ai-bubble-toggle"/>
<label for="globalAiToggle" class="global-ai-bubble-launcher" title="Mở trợ lý AI">🤖</label>
<div class="global-ai-tip">Xin chào, Em là trợ lý AI! 👋</div>

<div class="global-ai-chatbox">
    <div class="global-ai-header">
        <span><i class="fa fa-android"></i> AI Assistant</span>
        <label for="globalAiToggle" style="cursor:pointer; margin:0;"><i class="fa fa-close"></i></label>
    </div>
    <div class="global-ai-body">
        <div class="global-ai-msg">Bong bóng AI này hiển thị toàn hệ thống. Bạn có thể mở ở bất kỳ màn nào.</div>
        <div>
            <span class="global-ai-chip">Đọc model thô</span>
            <span class="global-ai-chip">Đọc serial</span>
            <span class="global-ai-chip">Gợi ý match model</span>
        </div>

        <div class="global-ai-tools">
            <c:choose>
                <c:when test="${pageContext.request.requestURI.contains('/manager/contracts/draft') and not empty draftContract}">
                    <div class="alert alert-success py-2">📎 Bấm nút bên dưới để thêm file PDF/snapshot cho hợp đồng nháp hiện tại.</div>
                    <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/manager/contracts/ai/upload" class="mb-2">
                        <input type="hidden" name="contractId" value="${draftContract.id}"/>
                        <label class="form-label fw-bold">Thêm file PDF/Snapshot</label>
                        <input type="file" name="sourceFile" class="form-control mb-2" accept=".pdf,.png,.jpg,.jpeg,.txt,.csv" required/>
                        <button class="btn btn-outline-primary" type="submit"><i class="fa fa-paperclip"></i> Add file PDF</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/manager/contracts/ai/extract">
                        <input type="hidden" name="contractId" value="${draftContract.id}"/>
                        <button class="btn btn-danger" type="submit"><i class="fa fa-robot"></i> AI Extract</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning mb-2">Bạn đang ở màn khác. Để thêm file PDF, vào <b>Tạo hợp đồng nháp</b>.</div>
                    <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/manager/contracts/draft">
                        <i class="fa fa-file-contract"></i> Đi tới màn thêm PDF
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
