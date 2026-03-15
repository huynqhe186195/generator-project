<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
            <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center">
                <div>
                    <h6 class="mb-1"><i class="fa fa-robot text-primary"></i> Chatbot AI trích xuất thiết bị</h6>
                    <div class="text-muted small">Upload PDF/ảnh hợp đồng, AI sẽ trả list device và tự điền vào bảng phía dưới.</div>
                </div>
                <button type="button" class="btn btn-primary" id="toggleAiPanelBtn">
                    Mở chatbot AI
                </button>
            </div>

            <div id="aiPanel" class="border rounded p-3 mt-3" style="display: none; background: #fafcff;">
                <div class="mb-2 small text-muted">Bạn có thể đặt câu hỏi để bóc tách đúng nghiệp vụ trước khi fill dữ liệu.</div>
                <div class="row g-2">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">File hợp đồng (PDF/ảnh)</label>
                        <input type="file" class="form-control" id="aiSourceFile" accept="application/pdf,image/*">
                    </div>
                    <div class="col-md-8">
                        <label class="form-label fw-semibold">Prompt</label>
                        <textarea class="form-control" id="aiPrompt" rows="3">Trích xuất danh sách thiết bị từ hợp đồng. Mỗi thiết bị gồm serialNumber, modelName, manufactureYear, currentLocation.</textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Gemini API key (nếu server chưa cấu hình)</label>
                        <input type="password" class="form-control" id="geminiApiKey" placeholder="AIza...">
                        <div class="form-text">Nếu server đã cấu hình GEMINI_API_KEY thì có thể để trống.</div>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <button type="button" class="btn btn-success" id="extractAiBtn">Trích xuất bằng AI</button>
                    <button type="button" class="btn btn-outline-secondary" id="fillContractInfoBtn">Điền thông tin hợp đồng vào form</button>
                </div>

                <div class="mt-3" id="aiStatus"></div>
                <pre class="mt-2 p-2 bg-dark text-white rounded" id="aiRawOutput" style="max-height: 220px; overflow: auto; display: none;"></pre>
            </div>
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
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

<script>
    (function () {
        const ctx = '${pageContext.request.contextPath}';
        const aiPanel = document.getElementById('aiPanel');
        const toggleAiPanelBtn = document.getElementById('toggleAiPanelBtn');
        const extractAiBtn = document.getElementById('extractAiBtn');
        const addRowBtn = document.getElementById('addRowBtn');
        const tableBody = document.getElementById('deviceTableBody');
        const aiStatus = document.getElementById('aiStatus');
        const aiRawOutput = document.getElementById('aiRawOutput');
        const fillContractInfoBtn = document.getElementById('fillContractInfoBtn');

        let latestAiData = null;
        const modelOptionsHtml = (function () {
            const firstSelect = document.querySelector('select[name="modelIds"]');
            return firstSelect ? firstSelect.innerHTML : '<option value="">-- Chọn model --</option>';
        })();

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

        toggleAiPanelBtn.addEventListener('click', function () {
            const isHidden = aiPanel.style.display === 'none';
            aiPanel.style.display = isHidden ? 'block' : 'none';
            toggleAiPanelBtn.textContent = isHidden ? 'Ẩn chatbot AI' : 'Mở chatbot AI';
        });

        addRowBtn.addEventListener('click', function () {
            tableBody.appendChild(createRow());
            bindRemoveButtons();
        });

        extractAiBtn.addEventListener('click', async function () {
            const fileInput = document.getElementById('aiSourceFile');
            const prompt = document.getElementById('aiPrompt').value || '';
            const file = fileInput.files[0];
            const apiKey = document.getElementById('geminiApiKey').value || '';

            if (!file) {
                aiStatus.innerHTML = '<div class="alert alert-warning mb-0">Vui lòng chọn file trước khi trích xuất.</div>';
                return;
            }

            const formData = new FormData();
            formData.append('sourceFile', file);
            formData.append('prompt', prompt);
            if (apiKey.trim()) {
                formData.append('apiKey', apiKey.trim());
            }

            aiStatus.innerHTML = '<div class="alert alert-info mb-0">Đang gọi AI...</div>';
            aiRawOutput.style.display = 'none';

            try {
                const res = await fetch(ctx + '/manager/contracts/ai-extract', {
                    method: 'POST',
                    body: formData
                });

                const data = await res.json();
                if (!data.success) {
                    throw new Error(data.message || 'AI trả về lỗi không xác định');
                }

                latestAiData = data.data || {};
                aiStatus.innerHTML = '<div class="alert alert-success mb-0">Trích xuất thành công. Đã tự động điền list device.</div>';
                aiRawOutput.style.display = 'block';
                aiRawOutput.textContent = data.raw || JSON.stringify(latestAiData, null, 2);

                const devices = latestAiData.devices || [];
                if (devices.length > 0) {
                    tableBody.innerHTML = '';
                    devices.forEach(function (d) {
                        tableBody.appendChild(createRow(d));
                    });
                    bindRemoveButtons();
                }
            } catch (err) {
                aiStatus.innerHTML = '<div class="alert alert-danger mb-0">Lỗi AI: ' + err.message + '</div>';
            }
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
        });

        bindRemoveButtons();
    })();
</script>
