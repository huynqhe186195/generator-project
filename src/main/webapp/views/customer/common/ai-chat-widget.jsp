<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty sessionScope.USERMODEL and sessionScope.USERMODEL.roleId == 5}">
<style>
  .customer-ai-widget {
    position: fixed;
    right: 24px;
    bottom: 24px;
    z-index: 1200;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 14px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  .customer-ai-hint {
    display: flex;
    align-items: center;
    gap: 10px;
    max-width: min(360px, calc(100vw - 32px));
    padding: 12px 14px;
    border-radius: 18px;
    background: rgba(15, 23, 42, 0.88);
    color: #fff;
    box-shadow: 0 18px 40px rgba(15, 23, 42, 0.28);
    backdrop-filter: blur(14px);
    animation: customerAiFloat 3s ease-in-out infinite;
  }
  .customer-ai-hint-icon {
    width: 36px;
    height: 36px;
    border-radius: 12px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #60a5fa, #6366f1);
    flex-shrink: 0;
  }
  .customer-ai-hint-title { font-size: .92rem; font-weight: 700; margin: 0; }
  .customer-ai-hint-text { font-size: .8rem; opacity: .8; margin: 2px 0 0; }
  .customer-ai-panel {
    display: none;
    width: min(420px, calc(100vw - 24px));
    height: min(680px, calc(100vh - 120px));
    border-radius: 28px;
    overflow: hidden;
    background: rgba(255, 255, 255, 0.96);
    border: 1px solid rgba(148, 163, 184, 0.26);
    box-shadow: 0 24px 70px rgba(15, 23, 42, 0.24);
    backdrop-filter: blur(22px);
  }
  .customer-ai-panel.is-open {
    display: grid;
    grid-template-rows: auto auto 1fr auto;
  }
  .customer-ai-header {
    position: relative;
    padding: 20px 20px 18px;
    background:
      radial-gradient(circle at top right, rgba(255,255,255,.25), transparent 34%),
      linear-gradient(135deg, #2563eb 0%, #4f46e5 55%, #7c3aed 100%);
    color: #fff;
  }
  .customer-ai-header::after {
    content: '';
    position: absolute;
    inset: auto 20px 0;
    height: 1px;
    background: rgba(255,255,255,.18);
  }
  .customer-ai-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 7px 12px;
    border-radius: 999px;
    background: rgba(255,255,255,.16);
    font-size: .78rem;
    font-weight: 700;
    letter-spacing: .02em;
    margin-bottom: 12px;
  }
  .customer-ai-title { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
  .customer-ai-title h5 { margin: 0; font-size: 1.2rem; font-weight: 800; }
  .customer-ai-close {
    width: 40px;
    height: 40px;
    border: none;
    border-radius: 14px;
    background: rgba(255,255,255,.16);
    color: #fff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }
  .customer-ai-body {
    padding: 18px;
    overflow-y: auto;
    background:
      radial-gradient(circle at top, rgba(96,165,250,.12), transparent 22%),
      linear-gradient(180deg, #f8fbff 0%, #f8fafc 100%);
  }
  .customer-ai-message { display: flex; margin-bottom: 14px; }
  .customer-ai-message.user { justify-content: flex-end; }
  .customer-ai-bubble {
    max-width: 88%;
    padding: 14px 16px;
    border-radius: 20px;
    line-height: 1.5;
    font-size: .94rem;
    box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
    white-space: pre-wrap;
  }
  .customer-ai-message.bot .customer-ai-bubble {
    background: rgba(255,255,255,.92);
    border: 1px solid rgba(191,219,254,.55);
    color: #0f172a;
  }
  .customer-ai-message.user .customer-ai-bubble {
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    color: #fff;
  }
  .customer-ai-results {
    margin-top: 14px;
    display: grid;
    gap: 10px;
  }
  .customer-ai-result {
    display: block;
    padding: 14px;
    border-radius: 18px;
    text-decoration: none;
    color: inherit;
    background: linear-gradient(180deg, #ffffff 0%, #eff6ff 100%);
    border: 1px solid rgba(96,165,250,.22);
    transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
  }
  .customer-ai-result:hover {
    transform: translateY(-2px);
    border-color: rgba(37,99,235,.46);
    box-shadow: 0 16px 30px rgba(37,99,235,.14);
  }
  .customer-ai-result-meta {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 10px;
  }
  .customer-ai-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 10px;
    border-radius: 999px;
    background: rgba(37,99,235,.08);
    color: #1e3a8a;
    font-size: .76rem;
    font-weight: 600;
  }
  .customer-ai-suggestions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    padding: 0 18px 12px;
    background: #fff;
  }
  .customer-ai-suggestion {
    border: 1px solid rgba(148,163,184,.24);
    background: #fff;
    color: #334155;
    border-radius: 999px;
    padding: 8px 12px;
    font-size: .78rem;
    font-weight: 600;
  }
  .customer-ai-footer {
    padding: 16px 18px 18px;
    border-top: 1px solid rgba(148,163,184,.14);
    background: rgba(255,255,255,.98);
  }
  .customer-ai-form {
    display: flex;
    align-items: flex-end;
    gap: 10px;
    padding: 10px;
    border-radius: 22px;
    border: 1px solid rgba(148,163,184,.24);
    background: #f8fafc;
  }
  .customer-ai-form textarea {
    border: none;
    background: transparent;
    box-shadow: none !important;
    min-height: 52px;
    max-height: 132px;
    resize: none;
  }
  .customer-ai-form textarea:focus { outline: none; }
  .customer-ai-send {
    width: 48px;
    height: 48px;
    border: none;
    border-radius: 18px;
    background: linear-gradient(135deg, #2563eb, #7c3aed);
    color: #fff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 16px 28px rgba(79,70,229,.28);
  }
  .customer-ai-status {
    font-size: .8rem;
    color: #64748b;
    margin-top: 8px;
    min-height: 18px;
    padding-left: 4px;
  }
  .customer-ai-toggle {
    width: 68px;
    height: 68px;
    border: none;
    border-radius: 24px;
    background: linear-gradient(135deg, #2563eb 0%, #4f46e5 52%, #7c3aed 100%);
    color: #fff;
    box-shadow: 0 20px 44px rgba(79,70,229,.32);
    position: relative;
  }
  .customer-ai-toggle::after {
    content: '';
    position: absolute;
    inset: -4px;
    border-radius: 28px;
    border: 1px solid rgba(99,102,241,.26);
  }
  .customer-ai-toggle-dot {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 12px;
    height: 12px;
    border-radius: 50%;

    background: #34d399;
    box-shadow: 0 0 0 6px rgba(52,211,153,.18);
  }
  @keyframes customerAiFloat {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-4px); }
  }
  @media (max-width: 767px) {
    .customer-ai-widget { right: 12px; bottom: 12px; left: 12px; align-items: stretch; }
    .customer-ai-hint { max-width: none; }
    .customer-ai-panel { width: 100%; height: min(74vh, 640px); }
    .customer-ai-suggestions { padding-top: 6px; }
    .customer-ai-toggle { align-self: flex-end; }
  }
</style>

<div class="customer-ai-widget" id="customerAiWidget">
  <div class="customer-ai-hint" id="customerAiHint">
    <span class="customer-ai-hint-icon"><i class="fas fa-sparkles"></i></span>
    <div>
      <p class="customer-ai-hint-title">AI đang sẵn sàng hỗ trợ</p>
      <p class="customer-ai-hint-text">Phân biệt máy sở hữu có serial và tài liệu public theo model chỉ trong một ô chat.</p>
    </div>
  </div>

  <div class="customer-ai-panel" id="customerAiPanel">
    <div class="customer-ai-header">
      <div class="customer-ai-badge"><i class="fas fa-robot"></i> Trợ lý AI cho khách hàng</div>
      <div class="customer-ai-title">
        <div>
          <h5>Phân biệt đúng 2 loại device</h5>
        </div>
        <button type="button" class="customer-ai-close" id="customerAiClose" aria-label="Đóng AI chat">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <div class="customer-ai-suggestions" id="customerAiSuggestions">
      <button type="button" class="customer-ai-suggestion" data-message="Tìm thiết bị sở hữu của tôi theo serial ABC123">Thiết bị sở hữu</button>
      <button type="button" class="customer-ai-suggestion" data-message="Tìm tài liệu public model Denyo">Tài liệu public</button>
      <button type="button" class="customer-ai-suggestion" data-message="Tìm máy của tôi ở nhà máy Bình Dương">Theo vị trí máy</button>
    </div>

    <div class="customer-ai-body" id="customerAiMessages">
      <div class="customer-ai-message bot">
        <div class="customer-ai-bubble">Xin chào! Tôi có thể giúp bạn tìm <strong>thiết bị sở hữu</strong> (có serial, thuộc danh sách máy của bạn) hoặc <strong>device tài liệu public</strong> (chỉ có model / thông số, không có serial).</div>
      </div>
    </div>

    <div class="customer-ai-footer">
      <form class="customer-ai-form" id="customerAiForm">
        <textarea class="form-control" id="customerAiInput" placeholder="Ví dụ: liệt kê tất cả máy tôi đang sở hữu hoặc tìm tài liệu public Cummins C220"></textarea>
        <button type="submit" class="customer-ai-send" aria-label="Gửi câu hỏi cho AI">
          <i class="fas fa-paper-plane"></i>
        </button>
      </form>
      <div class="customer-ai-status" id="customerAiStatus"></div>
    </div>
  </div>

  <button type="button" class="customer-ai-toggle" id="customerAiToggle" aria-label="Mở AI chat">
    <span class="customer-ai-toggle-dot"></span>
    <i class="fas fa-comments fs-5"></i>
  </button>
</div>

<script>
(function () {
  const widget = document.getElementById('customerAiWidget');
  const panel = document.getElementById('customerAiPanel');
  const toggle = document.getElementById('customerAiToggle');
  const closeBtn = document.getElementById('customerAiClose');
  const hint = document.getElementById('customerAiHint');
  const form = document.getElementById('customerAiForm');
  const input = document.getElementById('customerAiInput');
  const messages = document.getElementById('customerAiMessages');
  const status = document.getElementById('customerAiStatus');
  const suggestions = document.querySelectorAll('.customer-ai-suggestion');
  if (!widget || !panel || !toggle || !form || !input || !messages || !status) return;

  function setOpenState(isOpen) {
    panel.classList.toggle('is-open', isOpen);
    if (hint) hint.style.display = isOpen ? 'none' : 'flex';
    if (isOpen) input.focus();
  }

  toggle.addEventListener('click', function () {
    setOpenState(!panel.classList.contains('is-open'));
  });

  if (closeBtn) {
    closeBtn.addEventListener('click', function () {
      setOpenState(false);
    });
  }

  suggestions.forEach(function (button) {
    button.addEventListener('click', function () {
      const message = button.getAttribute('data-message') || '';
      input.value = message;
      setOpenState(true);
      input.focus();
    });
  });

  input.addEventListener('keydown', function (event) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      form.requestSubmit();
    }
  });

  form.addEventListener('submit', async function (event) {
    event.preventDefault();
    const message = input.value.trim();
    if (!message) return;

    appendMessage('user', message);
    input.value = '';
    status.textContent = 'AI đang xác định đây là thiết bị sở hữu hay tài liệu public...';

    try {
      const response = await fetch('<c:url value="/customer/ai-chat"/>', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: new URLSearchParams({ message })
      });
      const data = await response.json();
      appendBotReply(data.reply || 'Tôi chưa có phản hồi phù hợp.', data.results || []);
      if (data.actionType === 'REDIRECT' && data.redirectUrl) {
        status.textContent = 'Đang mở trang chi tiết thiết bị...';
        window.location.href = data.redirectUrl;
        return;
      }
      status.textContent = data.success === false ? 'Có lỗi xảy ra, bạn vui lòng thử lại.' : '';
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
        const serialOrDoc = item.serialNumber
          ? '<div class="small text-muted mt-1">Serial: ' + escapeHtml(item.serialNumber) + '</div>'
          : '<div class="small text-muted mt-1">Loại dữ liệu: tài liệu public, không có serial number</div>';
        const locationPill = item.currentLocation
          ? '<span class="customer-ai-pill"><i class="fas fa-location-dot"></i>' + escapeHtml(item.currentLocation) + '</span>'
          : '';
        const statusPill = item.status
          ? '<span class="customer-ai-pill"><i class="fas fa-signal"></i>' + escapeHtml(item.status) + '</span>'
          : '';
        const typePill = '<span class="customer-ai-pill"><i class="fas fa-layer-group"></i>' + escapeHtml(item.deviceTypeLabel || 'Device') + '</span>';
        const description = item.description
          ? '<div class="small text-muted mt-2">' + escapeHtml(item.description) + '</div>'
          : '';
        link.innerHTML = '<div class="fw-bold text-primary">' + escapeHtml(item.modelName || 'Thiết bị') + '</div>'
          + serialOrDoc
          + description
          + '<div class="customer-ai-result-meta">'
          + typePill
          + '<span class="customer-ai-pill"><i class="fas fa-industry"></i>' + escapeHtml(item.brandName || '-') + '</span>'
          + locationPill
          + statusPill
          + '</div>';
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
</c:if>
