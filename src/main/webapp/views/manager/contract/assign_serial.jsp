<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                height: min(620px, 76vh);
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
                display: flex;
                flex-direction: column;
                height: calc(100% - 48px);
                background: #f8fbff;
            }

            .chat-messages {
                flex: 1;
                overflow-y: auto;
                padding: 12px;
            }

            .chat-msg {
                border-radius: 12px;
                padding: 10px 12px;
                margin-bottom: 10px;
                max-width: 90%;
                font-size: 14px;
                white-space: pre-wrap;
                word-break: break-word;
            }

            .chat-msg.user {
                background: #dbe8ff;
                margin-left: auto;
            }

            .chat-msg.bot {
                background: #ffffff;
                border: 1px solid #d9e7ff;
            }

            .chat-composer {
                border-top: 1px solid #e4ecff;
                background: #fff;
                padding: 10px;
            }

            .chat-file-pill {
                display: none;
                align-items: center;
                gap: 8px;
                background: #eef4ff;
                border: 1px solid #d6e3ff;
                color: #225;
                border-radius: 999px;
                padding: 5px 10px;
                font-size: 12px;
                margin-bottom: 8px;
            }

            .chat-input-row {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .chat-input {
                flex: 1;
                border: 1px solid #d4ddf5;
                border-radius: 12px;
                padding: 9px 12px;
                outline: none;
            }

            .chat-icon-btn {
                border: none;
                width: 38px;
                height: 38px;
                border-radius: 10px;
                background: #eff4ff;
                color: #2e6ef7;
            }

            .chat-send-btn {
                border: none;
                width: 38px;
                height: 38px;
                border-radius: 10px;
                background: #2e6ef7;
                color: #fff;
            }
        </style>

        <div class="container py-4" style="max-width: 1100px;">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <h3 class="mb-1 fw-bold">Tạo thiết bị cho hợp đồng</h3>
                    <div class="text-muted">Bước 2: thêm danh sách thiết bị thủ công hoặc trích xuất bằng AI từ PDF/ảnh.
                    </div>
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
                                <span class="text-muted ms-2">contractId: ${contract.id} | customerId:
                                    ${contract.customerId}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm mb-3">
                <div class="card-body">

                    <form method="post" action="${pageContext.request.contextPath}/manager/contracts" id="deviceForm">
                        <input type="hidden" name="action" value="assignSerialSubmit" />
                        <input type="hidden" name="contractId" value="${contract.id}" />

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="mb-0">Danh sách thiết bị</h6>
                            <button type="button" class="btn btn-outline-primary btn-sm" id="addRowBtn">+ Thêm
                                dòng</button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered align-middle" id="deviceTable">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 25%;">Model</th>
                                        <th style="width: 18%;">Serial <span class="text-danger">*</span></th>
                                        <th style="width: 17%;">Ngày mua</th>
                                        <th style="width: 14%;">Năm sản xuất</th>
                                        <th>Vị trí hiện tại</th>
                                        <th style="width: 70px;">Xóa</th>
                                    </tr>
                                </thead>
                                <tbody id="deviceTableBody">
                                    <tr>
                                        <td>
                                            <select name="modelIds" class="form-select">
                                                <option value="">-- Chọn model --</option>
                                                <c:forEach var="m" items="${models}">
                                                    <option value="${m.id}">${m.name}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><input type="text" class="form-control" name="serialNumbers" required></td>
                                        <td><input type="date" class="form-control" name="purchaseDates"></td>
                                        <td><input type="number" class="form-control" name="manufactureYears" min="1990"
                                                max="2100"></td>
                                        <td><input type="text" class="form-control" name="currentLocations"></td>
                                        <td class="text-center"><button type="button"
                                                class="btn btn-sm btn-outline-danger remove-row-btn">×</button></td>
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
                <strong>AI trợ lý hợp đồng</strong>
                <button type="button" class="btn btn-sm btn-light" id="closeChatbotBtn">×</button>
            </div>

            <div class="chatbot-body">
                <div class="chat-messages" id="chatMessages">
                    <div class="chat-msg bot">Xin chào 👋 Bạn có thể hỏi bất cứ điều gì. Nếu muốn AI bóc tách list
                        device thì bấm icon ảnh để đính kèm PDF/snapshot rồi gửi tin nhắn.</div>
                </div>

                <div class="chat-composer">
                    <input type="file" id="aiSourceFile" accept="application/pdf,image/*" style="display:none;">
                    <input type="password" id="geminiApiKey" placeholder="Gemini API key (tuỳ chọn)"
                        class="form-control form-control-sm mb-2" style="display:none;">

                    <div class="chat-file-pill" id="chatFilePill">
                        <i class="fa fa-paperclip"></i>
                        <span id="chatFileName"></span>
                        <button type="button" class="btn btn-sm btn-link p-0" id="removeFileBtn">x</button>
                    </div>

                    <div class="chat-input-row">
                        <button type="button" class="chat-icon-btn" id="attachFileBtn" title="Đính kèm PDF/ảnh">
                            <i class="fa fa-image"></i>
                        </button>
                        <input type="text" class="chat-input" id="chatInput" placeholder="Câu hỏi của bạn là gì?">
                        <button type="button" class="chat-send-btn" id="sendChatBtn" title="Gửi">
                            <i class="fa fa-paper-plane"></i>
                        </button>
                    </div>
                    <div class="small text-muted mt-2" id="chatStatus"></div>
                </div>
            </div>
        </div>

        <script>
            (function () {
                const ctx = '${pageContext.request.contextPath}';

                const chatBubbleBtn = document.getElementById('chatBubbleBtn');
                const closeChatbotBtn = document.getElementById('closeChatbotBtn');
                const chatbotPanel = document.getElementById('chatbotPanel');
                const chatMessages = document.getElementById('chatMessages');

                const addRowBtn = document.getElementById('addRowBtn');
                const tableBody = document.getElementById('deviceTableBody');
                const contractNumberView = document.getElementById('contractNumberView');

                const aiSourceFile = document.getElementById('aiSourceFile');
                const geminiApiKey = document.getElementById('geminiApiKey');
                const attachFileBtn = document.getElementById('attachFileBtn');
                const removeFileBtn = document.getElementById('removeFileBtn');
                const chatFilePill = document.getElementById('chatFilePill');
                const chatFileName = document.getElementById('chatFileName');
                const chatInput = document.getElementById('chatInput');
                const sendChatBtn = document.getElementById('sendChatBtn');
                const chatStatus = document.getElementById('chatStatus');

                const chatHistory = [];
                const modelOptionsHtml = (function () {
                    const firstSelect = document.querySelector('select[name="modelIds"]');
                    return firstSelect ? firstSelect.innerHTML : '<option value="">-- Chọn model --</option>';
                })();

                function addMessage(text, type) {
                    const msg = document.createElement('div');
                    msg.className = 'chat-msg ' + type;
                    msg.textContent = text;
                    chatMessages.appendChild(msg);
                    chatMessages.scrollTop = chatMessages.scrollHeight;
                }

                function updateFilePill() {
                    const file = aiSourceFile.files[0];
                    if (file) {
                        chatFilePill.style.display = 'inline-flex';
                        chatFileName.textContent = file.name;
                    } else {
                        chatFilePill.style.display = 'none';
                        chatFileName.textContent = '';
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

                    tr.appendChild(modelTd);
                    tr.appendChild(serialTd);
                    tr.appendChild(purchaseDateTd);
                    tr.appendChild(manufactureYearTd);
                    tr.appendChild(locationTd);
                    tr.appendChild(removeTd);

                    if (device) {
                        tr.querySelector('input[name="serialNumbers"]').value = device.serialNumber || '';
                        tr.querySelector('input[name="manufactureYears"]').value = device.manufactureYear || '';
                        tr.querySelector('input[name="currentLocations"]').value = device.currentLocation || '';
                        tr.querySelector('input[name="purchaseDates"]').value = device.purchaseDate || '';

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

                async function askChatbot() {
                    const prompt = chatInput.value || '';
                    const file = aiSourceFile.files[0];
                    const apiKey = geminiApiKey.value || '';
                    const extractionMode = !!file;

                    if (!prompt.trim()) {
                        chatStatus.textContent = 'Vui lòng nhập nội dung chat.';
                        return;
                    }

                    addMessage(prompt, 'user');
                    chatInput.value = '';

                    const formData = new FormData();
                    formData.append('message', prompt);
                    formData.append('extractionMode', extractionMode ? 'true' : 'false');
                    formData.append('contractId', '${contract.id}');
                    formData.append('history', JSON.stringify(chatHistory));
                    if (file) {
                        formData.append('sourceFile', file);
                    }
                    if (apiKey.trim()) {
                        formData.append('apiKey', apiKey.trim());
                    }

                    chatStatus.textContent = 'AI đang trả lời...';

                    try {
                        const res = await fetch(ctx + '/manager/contracts/ai-chat', {
                            method: 'POST',
                            body: formData
                        });
                        const data = await res.json();
                        if (!data.success) {
                            throw new Error(data.message || 'AI trả về lỗi không xác định');
                        }

                        const rawReply = data.reply || '';
                        let displayReply = rawReply;

                        if (data.structured && data.data) {
                            const extracted = data.data;
                            const devices = extracted.devices || [];

                            if (extracted.answer && extracted.answer.trim()) {
                                displayReply = extracted.answer.trim();
                            } else if (devices.length > 0) {
                                displayReply = 'Mình đã phân tích file và tìm thấy ' + devices.length + ' thiết bị.';
                            } else {
                                displayReply = 'Mình đã phân tích file, nhưng chưa tìm thấy dữ liệu thiết bị rõ ràng.';
                            }

                            if (devices.length > 0) {
                                tableBody.innerHTML = '';
                                devices.forEach(function (d) {
                                    tableBody.appendChild(createRow(d));
                                });
                                bindRemoveButtons();
                                addMessage('Mình đã tự điền ' + devices.length + ' thiết bị vào bảng bên dưới.', 'bot');
                            }

                            if (data.savedSourceFile) {
                                addMessage('Đã lưu file nguồn: ' + data.savedSourceFile, 'bot');
                            }

                            if (extracted.contract && extracted.contract.contractNumber) {
                                contractNumberView.textContent = extracted.contract.contractNumber + ' (AI nhận diện)';
                            }
                        }

                        addMessage(displayReply, 'bot');
                        chatHistory.push({ role: 'user', content: prompt });
                        chatHistory.push({ role: 'assistant', content: displayReply });
                        chatStatus.textContent = 'Đã nhận phản hồi từ AI.';
                    } catch (err) {
                        chatStatus.textContent = 'Lỗi: ' + err.message;
                        addMessage('Lỗi: ' + err.message, 'bot');
                    }
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

                attachFileBtn.addEventListener('click', function () {
                    aiSourceFile.click();
                });

                aiSourceFile.addEventListener('change', updateFilePill);

                removeFileBtn.addEventListener('click', function () {
                    aiSourceFile.value = '';
                    updateFilePill();
                });

                sendChatBtn.addEventListener('click', async function () {
                    await askChatbot();
                });

                chatInput.addEventListener('keydown', async function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        await askChatbot();
                    }
                });

                bindRemoveButtons();
            })();
        </script>
