<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .chatbot-bubble {
        position: fixed;
        right: 24px;
        bottom: 24px;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        border: none;
        background: linear-gradient(135deg, #0d6efd, #4b8bff);
        color: #fff;
        font-size: 22px;
        box-shadow: 0 10px 20px rgba(13, 110, 253, .35);
        z-index: 2000;
    }

    .chatbot-panel {
        position: fixed;
        right: 24px;
        bottom: 96px;
        width: min(420px, calc(100vw - 32px));
        max-height: 72vh;
        background: #fff;
        border: 1px solid #d7e4ff;
        border-radius: 14px;
        box-shadow: 0 16px 30px rgba(0, 0, 0, .18);
        z-index: 2000;
        display: none;
        overflow: hidden;
    }

    .chatbot-header {
        background: #0d6efd;
        color: #fff;
        padding: 10px 14px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .chatbot-body {
        padding: 12px;
        max-height: calc(72vh - 50px);
        overflow-y: auto;
        background: #f8fbff;
    }

    .chat-msg {
        border-radius: 10px;
        padding: 8px 10px;
        margin-bottom: 8px;
        max-width: 92%;
        font-size: 14px;
        white-space: pre-wrap;
    }

    .chat-msg.user {
        background: #dbe8ff;
        margin-left: auto;
    }

    .chat-msg.bot {
        background: #ffffff;
        border: 1px solid #d9e7ff;
    }
</style>

<div class="container py-4" style="max-width: 1100px;">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <div>
            <h3 class="mb-1 fw-bold">Tạo thiết bị cho hợp đồng</h3>
            <div class="text-muted">Bước 2: thêm danh sách thiết bị thủ công hoặc trích xuất bằng AI từ PDF/ảnh.</div>
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
                    <div class="text-primary fw-bold" id="contractNumberView">${contract.contractNumber}</div>
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
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="alert alert-info mb-3">
                <i class="fa fa-robot"></i> Chatbot AI đã chuyển sang dạng bong bóng chat ở góc phải màn hình.
            </div>

            <form method="post" action="${pageContext.request.contextPath}/manager/contracts" id="deviceForm">
                <input type="hidden" name="action" value="assignSerialSubmit"/>
                <input type="hidden" name="contractId" value="${contract.id}"/>

                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="mb-0">Danh sách thiết bị</h6>
                    <button type="button" class="btn btn-outline-primary btn-sm" id="addRowBtn">+ Thêm dòng</button>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered align-middle" id="deviceTable">
                        <thead class="table-light">
                        <tr>
                            <th style="width: 18%;">Serial <span class="text-danger">*</span></th>
                            <th style="width: 25%;">Model</th>
                            <th style="width: 17%;">Ngày mua</th>
                            <th style="width: 14%;">Năm sản xuất</th>
                            <th>Vị trí hiện tại</th>
                            <th style="width: 70px;">Xóa</th>
                        </tr>
                        </thead>
                        <tbody id="deviceTableBody">
                        <tr>
                            <td><input type="text" class="form-control" name="serialNumbers" required></td>
                            <td>
                                <select name="modelIds" class="form-select">
                                    <option value="">-- Chọn model --</option>
                                    <c:forEach var="m" items="${models}">
                                        <option value="${m.id}">${m.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><input type="date" class="form-control" name="purchaseDates"></td>
                            <td><input type="number" class="form-control" name="manufactureYears" min="1990" max="2100"></td>
                            <td><input type="text" class="form-control" name="currentLocations"></td>
                            <td class="text-center"><button type="button" class="btn btn-sm btn-outline-danger remove-row-btn">×</button></td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex gap-2 pt-2">
                    <button type="submit" class="btn btn-primary">Lưu danh sách thiết bị</button>
                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/manager/contracts?action=assignSerialForm&id=${contract.id}">
                        Làm mới
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<button type="button" class="chatbot-bubble" id="chatBubbleBtn" title="Mở chatbot AI">
    <i class="fa fa-robot"></i>
</button>

<div class="chatbot-panel" id="chatbotPanel">
    <div class="chatbot-header">
        <strong>Chatbot AI trợ lý hợp đồng</strong>
        <button type="button" class="btn btn-sm btn-light" id="closeChatbotBtn">×</button>
    </div>
    <div class="chatbot-body" id="chatbotBody">
        <div class="chat-msg bot">Xin chào! Bạn có thể hỏi bất cứ điều gì như GPT/Gemini. Nếu muốn trích xuất thiết bị từ PDF/ảnh, hãy upload file rồi bấm nút trích xuất.</div>

        <div class="mb-2">
            <label class="form-label fw-semibold mb-1">File hợp đồng (PDF/ảnh)</label>
            <input type="file" class="form-control" id="aiSourceFile" accept="application/pdf,image/*">
        </div>

        <div class="mb-2">
            <label class="form-label fw-semibold mb-1">Gemini API key (nếu cần)</label>
            <input type="password" class="form-control" id="geminiApiKey" placeholder="AIza...">
        </div>

        <div class="mb-2">
            <label class="form-label fw-semibold mb-1">Nhập tin nhắn (hỏi tự do hoặc yêu cầu trích xuất)</label>
            <textarea class="form-control" id="aiPrompt" rows="3">Trích xuất danh sách thiết bị từ hợp đồng. Mỗi thiết bị gồm serialNumber, modelName, manufactureYear, currentLocation.</textarea>
        </div>

        <div class="d-flex flex-wrap gap-2 mb-2">
            <button type="button" class="btn btn-success btn-sm" id="sendChatBtn">Gửi chat thường</button>
            <button type="button" class="btn btn-success btn-sm" id="extractAiBtn">Trích xuất list device</button>
            <button type="button" class="btn btn-outline-secondary btn-sm" id="fillContractInfoBtn">Điền thông tin hợp đồng</button>
        </div>

        <div id="aiStatus"></div>
        <pre class="mt-2 p-2 bg-dark text-white rounded" id="aiRawOutput" style="max-height: 220px; overflow: auto; display: none;"></pre>
    </div>
</div>

<script>
    (function () {
        const ctx = '${pageContext.request.contextPath}';
        const chatBubbleBtn = document.getElementById('chatBubbleBtn');
        const closeChatbotBtn = document.getElementById('closeChatbotBtn');
        const chatbotPanel = document.getElementById('chatbotPanel');
        const chatbotBody = document.getElementById('chatbotBody');
        const sendChatBtn = document.getElementById('sendChatBtn');
        const extractAiBtn = document.getElementById('extractAiBtn');
        const addRowBtn = document.getElementById('addRowBtn');
        const tableBody = document.getElementById('deviceTableBody');
        const aiStatus = document.getElementById('aiStatus');
        const aiRawOutput = document.getElementById('aiRawOutput');
        const fillContractInfoBtn = document.getElementById('fillContractInfoBtn');

        let latestAiData = null;
        const chatHistory = [];
        const modelOptionsHtml = (function () {
            const firstSelect = document.querySelector('select[name="modelIds"]');
            return firstSelect ? firstSelect.innerHTML : '<option value="">-- Chọn model --</option>';
        })();

        function addMessage(text, type) {
            const msg = document.createElement('div');
            msg.className = 'chat-msg ' + type;
            msg.textContent = text;
            chatbotBody.appendChild(msg);
            chatbotBody.scrollTop = chatbotBody.scrollHeight;
        }

        async function askChatbot(extractionMode) {
            const fileInput = document.getElementById('aiSourceFile');
            const prompt = document.getElementById('aiPrompt').value || '';
            const file = fileInput.files[0];
            const apiKey = document.getElementById('geminiApiKey').value || '';

            if (!prompt.trim()) {
                aiStatus.innerHTML = '<div class="alert alert-warning mb-0">Vui lòng nhập nội dung chat.</div>';
                return;
            }

            if (extractionMode && !file) {
                aiStatus.innerHTML = '<div class="alert alert-warning mb-0">Muốn trích xuất list device thì cần upload file PDF/ảnh.</div>';
                return;
            }

            addMessage(prompt, 'user');

            const formData = new FormData();
            formData.append('message', prompt);
            formData.append('extractionMode', extractionMode ? 'true' : 'false');
            formData.append('history', JSON.stringify(chatHistory));
            if (file) {
                formData.append('sourceFile', file);
            }
            if (apiKey.trim()) {
                formData.append('apiKey', apiKey.trim());
            }

            aiStatus.innerHTML = '<div class="alert alert-info mb-0">AI đang trả lời...</div>';
            aiRawOutput.style.display = 'none';

            try {
                const res = await fetch(ctx + '/manager/contracts/ai-chat', {
                    method: 'POST',
                    body: formData
                });
                const data = await res.json();
                if (!data.success) {
                    throw new Error(data.message || 'AI trả về lỗi không xác định');
                }

                const reply = data.reply || '';
                addMessage(reply, 'bot');
                chatHistory.push({ role: 'user', content: prompt });
                chatHistory.push({ role: 'assistant', content: reply });
                aiStatus.innerHTML = '<div class="alert alert-success mb-0">AI đã trả lời.</div>';
                aiRawOutput.style.display = 'block';
                aiRawOutput.textContent = reply;

                if (extractionMode && data.structured && data.data) {
                    latestAiData = data.data;
                    const devices = latestAiData.devices || [];
                    if (devices.length > 0) {
                        tableBody.innerHTML = '';
                        devices.forEach(function (d) {
                            tableBody.appendChild(createRow(d));
                        });
                        bindRemoveButtons();
                    }
                }
            } catch (err) {
                aiStatus.innerHTML = '<div class="alert alert-danger mb-0">Lỗi AI: ' + err.message + '</div>';
                addMessage('Lỗi: ' + err.message, 'bot');
            }
        }

        function createRow(device) {
            const tr = document.createElement('tr');

            const serialTd = document.createElement('td');
            serialTd.innerHTML = '<input type="text" class="form-control" name="serialNumbers" required>';

            const modelTd = document.createElement('td');
            const modelSelect = document.createElement('select');
            modelSelect.name = 'modelIds';
            modelSelect.className = 'form-select';
            modelSelect.innerHTML = modelOptionsHtml;
            modelTd.appendChild(modelSelect);

            const purchaseDateTd = document.createElement('td');
            purchaseDateTd.innerHTML = '<input type="date" class="form-control" name="purchaseDates">';

            const manufactureYearTd = document.createElement('td');
            manufactureYearTd.innerHTML = '<input type="number" class="form-control" name="manufactureYears" min="1990" max="2100">';

            const locationTd = document.createElement('td');
            locationTd.innerHTML = '<input type="text" class="form-control" name="currentLocations">';

            const removeTd = document.createElement('td');
            removeTd.className = 'text-center';
            removeTd.innerHTML = '<button type="button" class="btn btn-sm btn-outline-danger remove-row-btn">×</button>';

            tr.appendChild(serialTd);
            tr.appendChild(modelTd);
            tr.appendChild(purchaseDateTd);
            tr.appendChild(manufactureYearTd);
            tr.appendChild(locationTd);
            tr.appendChild(removeTd);

            if (device) {
                tr.querySelector('input[name="serialNumbers"]').value = device.serialNumber || '';
                tr.querySelector('input[name="manufactureYears"]').value = device.manufactureYear || '';
                tr.querySelector('input[name="currentLocations"]').value = device.currentLocation || '';

                if (device.modelName) {
                    const option = Array.prototype.find.call(modelSelect.options, function (op) {
                        return op.textContent.trim() === device.modelName.trim();
                    });
                    if (option) {
                        modelSelect.value = option.value;
                    }
                }
            }
            return tr;
        }

        function bindRemoveButtons() {
            tableBody.querySelectorAll('.remove-row-btn').forEach(function (btn) {
                btn.onclick = function () {
                    if (tableBody.rows.length === 1) {
                        tableBody.rows[0].querySelector('input[name="serialNumbers"]').value = '';
                        tableBody.rows[0].querySelector('input[name="manufactureYears"]').value = '';
                        tableBody.rows[0].querySelector('input[name="currentLocations"]').value = '';
                        tableBody.rows[0].querySelector('input[name="purchaseDates"]').value = '';
                        tableBody.rows[0].querySelector('select[name="modelIds"]').value = '';
                        return;
                    }
                    btn.closest('tr').remove();
                };
            });
        }

        chatBubbleBtn.addEventListener('click', function () {
            chatbotPanel.style.display = 'block';
            chatBubbleBtn.style.display = 'none';
        });

        closeChatbotBtn.addEventListener('click', function () {
            chatbotPanel.style.display = 'none';
            chatBubbleBtn.style.display = 'inline-block';
        });

        addRowBtn.addEventListener('click', function () {
            tableBody.appendChild(createRow());
            bindRemoveButtons();
        });

        sendChatBtn.addEventListener('click', async function () {
            await askChatbot(false);
        });

        extractAiBtn.addEventListener('click', async function () {
            await askChatbot(true);
        });

        fillContractInfoBtn.addEventListener('click', function () {
            if (!latestAiData || !latestAiData.contract) {
                aiStatus.innerHTML = '<div class="alert alert-warning mb-0">Chưa có dữ liệu hợp đồng từ AI.</div>';
                return;
            }

            const c = latestAiData.contract;
            if (c.contractNumber) {
                const view = document.getElementById('contractNumberView');
                view.textContent = c.contractNumber + ' (AI nhận diện)';
            }

            aiStatus.innerHTML = '<div class="alert alert-info mb-0">Đã điền thông tin hợp đồng nhận diện được (hiển thị tham khảo).</div>';
            addMessage('Mình đã điền thông tin hợp đồng nhận diện được.', 'bot');
        });

        bindRemoveButtons();
    })();
</script>
