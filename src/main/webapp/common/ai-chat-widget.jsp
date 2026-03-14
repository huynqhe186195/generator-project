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
        background: #b50000;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        box-shadow: 0 10px 24px rgba(0,0,0,.28);
        cursor: pointer;
        z-index: 2100;
    }

    .global-ai-chatbox {
        position: fixed;
        right: 24px;
        bottom: 100px;
        width: 500px;
        max-width: calc(100vw - 30px);
        border: 1px solid #d8d8d8;
        border-radius: 12px;
        overflow: hidden;
        background: #f3f3f3;
        box-shadow: 0 24px 42px rgba(0,0,0,.28);
        opacity: 0;
        transform: translateY(16px) scale(.98);
        pointer-events: none;
        transition: all .22s ease;
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
        padding: 14px 16px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-weight: 700;
    }

    .global-ai-header .left {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 18px;
    }

    .global-ai-header .left strong {
        font-size: 36px;
        letter-spacing: .3px;
    }

    .global-ai-header .actions button,
    .global-ai-header .actions label {
        background: transparent;
        color: #fff;
        border: none;
        cursor: pointer;
        font-size: 24px;
        margin-left: 12px;
    }

    .global-ai-body {
        padding: 14px;
        background: linear-gradient(180deg, #efefef 0%, #f8f8f8 100%);
        max-height: 62vh;
        overflow: auto;
    }

    .global-ai-row {
        display: flex;
        align-items: flex-start;
        gap: 10px;
    }

    .global-ai-avatar {
        font-size: 30px;
        line-height: 1;
        margin-top: 6px;
    }

    .global-ai-msg {
        background: #ebedf2;
        border-radius: 12px;
        padding: 12px 14px;
        margin-bottom: 10px;
        color: #434b5a;
        font-weight: 600;
        max-width: 88%;
    }

    .global-ai-chip {
        display: inline-block;
        margin: 0 8px 10px 0;
        padding: 8px 14px;
        border-radius: 999px;
        background: #eceef1;
        font-weight: 700;
        color: #363a42;
        border: 1px solid #e1e3e8;
        cursor: pointer;
    }

    .global-ai-input-wrap {
        margin-top: 10px;
        background: #fff;
        border: 1px solid #e2e2e2;
        border-radius: 10px;
        padding: 8px;
    }

    .global-ai-input-row {
        display: grid;
        grid-template-columns: auto 1fr auto auto;
        gap: 8px;
        align-items: center;
    }

    .global-ai-input-row .btn-icon {
        border: none;
        background: #f5f6f8;
        color: #2d73ff;
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-size: 18px;
    }

    .global-ai-input-row input[type="text"] {
        border: none;
        box-shadow: none;
        font-size: 18px;
        color: #5b6070;
        background: transparent;
    }

    .global-ai-input-row input[type="text"]:focus {
        outline: none;
    }

    .global-ai-send {
        border: none;
        background: #2d73ff;
        color: #fff;
        width: 40px;
        height: 40px;
        border-radius: 10px;
        cursor: pointer;
        font-size: 18px;
    }

    .global-ai-upload-line {
        margin-top: 10px;
    }

    .global-ai-upload-line input[type="file"] {
        font-size: 12px;
    }

    .global-ai-footer {
        text-align: center;
        font-weight: 700;
        color: #4b4b4b;
        padding: 10px 0 2px;
    }

    .global-ai-hidden-file { display: none; }

    @media (max-width: 992px) {
        .global-ai-chatbox {
            width: calc(100vw - 18px);
            right: 9px;
            bottom: 88px;
        }
        .global-ai-bubble-launcher {
            right: 10px;
            bottom: 14px;
        }
    }
</style>

<input type="checkbox" id="globalAiToggle" class="global-ai-bubble-toggle"/>
<label for="globalAiToggle" class="global-ai-bubble-launcher" title="Mở trợ lý AI">🤖</label>

<div class="global-ai-chatbox">
    <div class="global-ai-header">
        <div class="left">
            <span>🤖</span>
            <strong>MITIGA AI</strong>
        </div>
        <div class="actions">
            <button type="button" title="Làm mới"><i class="fa fa-refresh"></i></button>
            <label for="globalAiToggle" title="Đóng"><i class="fa fa-close"></i></label>
        </div>
    </div>

    <div class="global-ai-body">
        <div id="globalAiMessages" class="global-ai-row">
            <div class="global-ai-avatar">🤖</div>
            <div class="global-ai-msg">🎧 Xin chào! Mình là Trợ lý AI của MITIGA, Bạn muốn triển khai AI chatbot cho lĩnh vực nào?</div>
        </div>

        <button type="button" class="global-ai-chip ai-chip-btn">Tại sao doanh nghiệp cần trợ lý AI?</button>
        <button type="button" class="global-ai-chip ai-chip-btn">Quy trình triển khai trợ lý AI?</button>
        <button type="button" class="global-ai-chip ai-chip-btn">Giá triển khai trợ lý AI?</button>
        <button type="button" class="global-ai-chip ai-chip-btn">Kiểm tra đơn hàng #238382</button>
        <button type="button" class="global-ai-chip ai-chip-btn">Tìm trên google 5 sự kiện mới nhất</button>

        <div class="global-ai-input-wrap">
            <div class="global-ai-input-row">
                <button type="button" class="btn-icon" title="Thêm PDF/Snapshot" onclick="document.getElementById('globalAiFileInput').click()">
                    <i class="fa fa-image"></i>
                </button>
                <input id="globalAiInput" type="text" class="form-control" placeholder="Câu hỏi của bạn là gì?"/>
                <button type="button" class="btn-icon" title="Ghi âm"><i class="fa fa-microphone"></i></button>
                <button type="button" id="globalAiSendBtn" class="global-ai-send" title="Gửi"><i class="fa fa-send"></i></button>
            </div>

            <div class="global-ai-upload-line">
                <c:choose>
                    <c:when test="${pageContext.request.requestURI.contains('/manager/contracts/draft') and not empty draftContract}">
                        <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/manager/contracts/ai/upload" class="mb-2">
                            <input id="globalAiFileInput" class="global-ai-hidden-file" type="file" name="sourceFile" accept=".pdf,.png,.jpg,.jpeg,.txt,.csv" onchange="this.form.submit()" required/>
                            <input type="hidden" name="contractId" value="${draftContract.id}"/>
                            <button class="btn btn-sm btn-outline-primary" type="submit"><i class="fa fa-paperclip"></i> Add file PDF/Snapshot</button>
                        </form>
                        <form id="globalAiExtractForm" method="post" action="${pageContext.request.contextPath}/manager/contracts/ai/extract">
                            <input type="hidden" name="contractId" value="${draftContract.id}"/>
                            <button class="btn btn-sm btn-danger" type="submit"><i class="fa fa-robot"></i> Gửi đi (AI Extract)</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <input id="globalAiFileInput" class="global-ai-hidden-file" type="file" accept=".pdf,.png,.jpg,.jpeg,.txt,.csv"/>
                        <div class="alert alert-warning py-2 mb-2">Để add file PDF/snapshot cho hợp đồng, vào màn Tạo hợp đồng nháp.</div>
                        <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/manager/contracts/draft">
                            <i class="fa fa-file-contract"></i> Đi tới màn tạo nháp
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="global-ai-footer">Powered by MITIGA</div>
    </div>
</div>

<script>
(function(){
  const input = document.getElementById('globalAiInput');
  const sendBtn = document.getElementById('globalAiSendBtn');
  const extractForm = document.getElementById('globalAiExtractForm');
  const messages = document.getElementById('globalAiMessages');

  document.querySelectorAll('.ai-chip-btn').forEach(btn => {
    btn.addEventListener('click', () => { if (input) input.value = btn.textContent.trim(); });
  });

  function triggerSend(){
    if (!extractForm) return;
    const data = new FormData(extractForm);
    if (input && input.value) data.append('userPrompt', input.value);
    fetch(extractForm.action + '?format=json', { method:'POST', body:data, headers:{'Accept':'application/json'} })
      .then(r => r.json())
      .then(json => {
        if (!messages) return;
        const bubble = document.createElement('div');
        bubble.className = 'global-ai-msg';
        bubble.style.marginLeft = '40px';
        bubble.textContent = json.chatMessage || 'Đã nhận yêu cầu.';
        messages.parentElement.appendChild(bubble);
      })
      .catch(() => extractForm.submit());
  }

  if (sendBtn) {
    sendBtn.addEventListener('click', triggerSend);
  }

  if (input) {
    input.addEventListener('keydown', function(e){
      if (e.key === 'Enter') {
        e.preventDefault();
        triggerSend();
      }
    });
  }
})();
</script>
