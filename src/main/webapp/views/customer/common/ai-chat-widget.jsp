<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .customer-ai-widget { position: fixed; right: 24px; bottom: 24px; z-index: 1080; }
  .customer-ai-toggle {
    width: 60px; height: 60px; border: none; border-radius: 50%;
    background: linear-gradient(135deg, #4e73df, #224abe); color: #fff;
    box-shadow: 0 16px 36px rgba(34, 74, 190, .35); font-size: 1.3rem;
  }
  .customer-ai-panel {
    display: none; width: 360px; max-width: calc(100vw - 32px); height: 520px;
    margin-bottom: 12px; background: #fff; border-radius: 24px; overflow: hidden;
    box-shadow: 0 18px 40px rgba(15, 23, 42, .18); border: 1px solid rgba(15,23,42,.08);
  }
  .customer-ai-panel.is-open { display: flex; flex-direction: column; }
  .customer-ai-header { padding: 16px 18px; background: linear-gradient(135deg, #4e73df, #224abe); color: #fff; }
  .customer-ai-body { flex: 1; padding: 16px; overflow-y: auto; background: #f8faff; }
  .customer-ai-message { margin-bottom: 12px; display: flex; }
  .customer-ai-message.user { justify-content: flex-end; }
  .customer-ai-bubble {
    max-width: 85%; padding: 12px 14px; border-radius: 18px; line-height: 1.45; font-size: .95rem;
    box-shadow: 0 6px 16px rgba(15,23,42,.08);
  }
  .customer-ai-message.bot .customer-ai-bubble { background: #fff; color: #111827; }
  .customer-ai-message.user .customer-ai-bubble { background: #4e73df; color: #fff; }
  .customer-ai-results { margin-top: 12px; display: grid; gap: 10px; }
  .customer-ai-result { display: block; text-decoration: none; color: inherit; background: #fff; border: 1px solid #dbe4ff; border-radius: 16px; padding: 12px; }
  .customer-ai-result:hover { border-color: #4e73df; transform: translateY(-1px); }
  .customer-ai-footer { padding: 14px; border-top: 1px solid rgba(15,23,42,.08); background: #fff; }
  .customer-ai-form { display: flex; gap: 10px; }
  .customer-ai-form textarea { resize: none; min-height: 48px; max-height: 120px; }
  .customer-ai-status { font-size: .82rem; color: #64748b; margin-top: 8px; min-height: 18px; }
</style>

<div class="customer-ai-widget">
  <div class="customer-ai-panel" id="customerAiPanel">
    <div class="customer-ai-header">
      <div class="fw-bold"><i class="fas fa-robot me-2"></i>AI hỗ trợ khách hàng</div>
      <div class="small opacity-75">Tìm thiết bị theo model, serial hoặc tên máy.</div>
    </div>
    <div class="customer-ai-body" id="customerAiMessages">
      <div class="customer-ai-message bot">
        <div class="customer-ai-bubble">Xin chào! Tôi có thể giúp bạn tìm thiết bị của mình theo model hoặc serial.</div>
      </div>
    </div>
    <div class="customer-ai-footer">
      <form class="customer-ai-form" id="customerAiForm">
        <textarea class="form-control" id="customerAiInput" placeholder="Ví dụ: tìm máy Cummins serial ABC123"></textarea>
        <button type="submit" class="btn btn-primary rounded-pill px-3"><i class="fas fa-paper-plane"></i></button>
      </form>
      <div class="customer-ai-status" id="customerAiStatus"></div>
    </div>
  </div>
  <button type="button" class="customer-ai-toggle" id="customerAiToggle" aria-label="Mở AI chat">
    <i class="fas fa-comments"></i>
  </button>
</div>

<script>
(function () {
  const panel = document.getElementById('customerAiPanel');
  const toggle = document.getElementById('customerAiToggle');
  const form = document.getElementById('customerAiForm');
  const input = document.getElementById('customerAiInput');
  const messages = document.getElementById('customerAiMessages');
  const status = document.getElementById('customerAiStatus');
  if (!panel || !toggle || !form || !input || !messages || !status) return;

  toggle.addEventListener('click', function () {
    panel.classList.toggle('is-open');
    if (panel.classList.contains('is-open')) input.focus();
  });

  form.addEventListener('submit', async function (event) {
    event.preventDefault();
    const message = input.value.trim();
    if (!message) return;

    appendMessage('user', message);
    input.value = '';
    status.textContent = 'Đang xử lý...';

    try {
      const response = await fetch('<c:url value="/customer/ai-chat"/>', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: new URLSearchParams({ message })
      });
      const data = await response.json();
      appendBotReply(data.reply || 'Tôi chưa có phản hồi phù hợp.', data.results || []);
      if (data.actionType === 'REDIRECT' && data.redirectUrl) {
        status.textContent = 'Đang mở trang chi tiết...';
        window.location.href = data.redirectUrl;
        return;
      }
      status.textContent = '';
    } catch (error) {
      appendBotReply('Xin lỗi, hiện tôi chưa kết nối được hệ thống. Bạn vui lòng thử lại sau.', []);
      status.textContent = '';
    }
  });

  function appendMessage(role, text) {
    const row = document.createElement('div');
    row.className = 'customer-ai-message ' + role;
    const bubble = document.createElement('div');
    bubble.className = 'customer-ai-bubble';
    bubble.textContent = text;
    row.appendChild(bubble);
    messages.appendChild(row);
    messages.scrollTop = messages.scrollHeight;
  }

  function appendBotReply(reply, results) {
    const row = document.createElement('div');
    row.className = 'customer-ai-message bot';
    const bubble = document.createElement('div');
    bubble.className = 'customer-ai-bubble';
    bubble.textContent = reply;

    if (Array.isArray(results) && results.length) {
      const list = document.createElement('div');
      list.className = 'customer-ai-results';
      results.forEach(function (item) {
        const link = document.createElement('a');
        link.className = 'customer-ai-result';
        link.href = item.detailUrl || '#';
        link.innerHTML = '<div class="fw-bold text-primary">' + escapeHtml(item.modelName || 'Thiết bị') + '</div>'
          + '<div class="small text-muted">Serial: ' + escapeHtml(item.serialNumber || '-') + '</div>'
          + '<div class="small text-muted">Brand: ' + escapeHtml(item.brandName || '-') + '</div>'
          + '<div class="small text-muted">Vị trí: ' + escapeHtml(item.currentLocation || '-') + '</div>';
        list.appendChild(link);
      });
      bubble.appendChild(list);
    }

    row.appendChild(bubble);
    messages.appendChild(row);
    messages.scrollTop = messages.scrollHeight;
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }
})();
</script>
