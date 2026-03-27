<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Gửi yêu cầu lên Manager</title>

<div class="container mt-4">
    <div class="mb-3">
        <a href="<c:url value='/staff/incident-list'/>" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="fas fa-paper-plane me-2"></i>BƯỚC 2: PHÂN CÔNG & GỬI MANAGER</h5>
                </div>

                <div class="card-body bg-light p-4">
                    <form action="<c:url value='/staff/request-manager'/>" method="POST">
                        <input type="hidden" name="incident_id" value="${req.id}" />
                        <input type="hidden" name="selected_recommendation_code" id="selectedRecommendationCode" />
                        <input type="hidden" name="selected_recommendation_title" id="selectedRecommendationTitle" />
                        <input type="hidden" name="selected_suggested_technician_ids" id="selectedSuggestedTechnicianIds" />
                        <input type="hidden" name="selected_suggested_technician_id" id="selectedSuggestedTechnicianId" />
                        <input type="hidden" name="selected_suggested_technician_name" id="selectedSuggestedTechnicianName" />
                        <input type="hidden" name="selected_required_skill_codes" id="selectedRequiredSkillCodes" />

                        <div class="alert alert-primary d-flex align-items-center mb-4 border-0 shadow-sm">
                            <i class="fas fa-info-circle fa-2x me-3"></i>
                            <div>
                                <div class="text-uppercase small fw-bold opacity-75">Đang xử lý yêu cầu:</div>
                                <div class="fw-bold">${req.info.title}</div>
                                <div class="small">Thiết bị: <strong>${prod.modelName}</strong> (SN: ${prod.serialNumber})</div>
                            </div>
                        </div>

                        <c:if test="${not empty planRecommendations}">
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header bg-white border-bottom">
                                    <h6 class="mb-0 fw-bold text-primary"><i class="fas fa-lightbulb me-2"></i>Gợi ý phương án xử lý & kỹ thuật viên phù hợp</h6>
                                </div>
                                <div class="card-body bg-light">
                                    <div class="row g-3">
                                        <c:forEach items="${planRecommendations}" var="recommendation">
                                            <div class="col-lg-6">
                                                <div class="card h-100 border recommendation-card"
                                                     data-code="${recommendation.recommendationCode}"
                                                     data-title="${recommendation.title}"
                                                     data-work-type="${recommendation.recommendedWorkType}"
                                                     data-priority="${recommendation.recommendedPriority}"
                                                     data-duration="${recommendation.recommendedDurationMinutes}"
                                                     data-tech-count="${recommendation.recommendedTechnicianCount}"
                                                     data-service-location="${recommendation.recommendedServiceLocation}"
                                                     data-parts-note="${recommendation.recommendedPartsNote}"
                                                     data-requires-parts="${recommendation.requiresPartsPreparation}"
                                                     data-suggested-technician-ids="<c:forEach items='${recommendation.technicianSuggestions}' var='tech' varStatus='loop'>${tech.technicianId}<c:if test='${!loop.last}'>,</c:if></c:forEach>"
                                                     data-suggested-technician-id="${not empty recommendation.technicianSuggestions ? recommendation.technicianSuggestions[0].technicianId : ''}"
                                                     data-suggested-technician-name="${not empty recommendation.technicianSuggestions ? fn:escapeXml(recommendation.technicianSuggestions[0].technicianName) : ''}"
                                                     data-required-skill-codes="<c:forEach items='${recommendation.requiredSkills}' var='skill' varStatus='loop'>${skill.skillCode}<c:if test='${!loop.last}'>,</c:if></c:forEach>">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                                            <div>
                                                                <div class="fw-bold text-dark">${recommendation.title}</div>
                                                                <div class="small text-muted">${recommendation.reasonSummary}</div>
                                                            </div>
                                                            <span class="badge bg-primary">${recommendation.confidenceScore}%</span>
                                                        </div>

                                                        <div class="row g-2 small mb-3">
                                                            <div class="col-6"><strong>Work type:</strong> ${recommendation.recommendedWorkType}</div>
                                                            <div class="col-6"><strong>Ưu tiên:</strong> ${recommendation.recommendedPriority}</div>
                                                            <div class="col-6"><strong>Thời lượng:</strong> ${recommendation.recommendedDurationMinutes} phút</div>
                                                            <div class="col-6"><strong>Số kỹ thuật viên:</strong> ${recommendation.recommendedTechnicianCount}</div>
                                                        </div>

                                                        <div class="mb-2">
                                                            <div class="small fw-bold text-secondary mb-1">Kỹ năng đề xuất</div>
                                                            <div class="d-flex flex-wrap gap-2">
                                                                <c:forEach items="${recommendation.requiredSkills}" var="skill">
                                                                    <span class="badge ${skill.importanceLevel == 'REQUIRED' ? 'bg-danger-subtle text-danger border border-danger-subtle' : 'bg-warning-subtle text-warning border border-warning-subtle'}">
                                                                        ${skill.skillName}
                                                                    </span>
                                                                </c:forEach>
                                                            </div>
                                                        </div>

                                                        <div class="mb-3">
                                                            <div class="small fw-bold text-secondary mb-1">Danh sách kỹ thuật viên phù hợp</div>
                                                            <c:choose>
                                                                <c:when test="${not empty recommendation.technicianSuggestions}">
                                                                    <c:forEach items="${recommendation.technicianSuggestions}" var="tech" varStatus="techLoop">
                                                                        <div class="border rounded p-2 mb-2 bg-white technician-suggestion-item ${techLoop.first ? 'border-primary' : ''}"
                                                                             data-tech-id="${tech.technicianId}"
                                                                             data-tech-name="${fn:escapeXml(tech.technicianName)}">
                                                                            <div class="d-flex justify-content-between align-items-start gap-2">
                                                                                <div>
                                                                                    <div class="fw-semibold">${tech.technicianName}</div>
                                                                                    <div class="small text-muted">${tech.summary}</div>
                                                                                </div>
                                                                                <div class="text-end">
                                                                                    <span class="badge ${tech.matchScore >= 80 ? 'bg-success' : tech.matchScore >= 60 ? 'bg-warning text-dark' : 'bg-secondary'}">${tech.matchScore} điểm</span>
                                                                                    <button type="button"
                                                                                            class="btn btn-link btn-sm text-decoration-none p-0 ms-2 select-tech-btn"
                                                                                            data-tech-id="${tech.technicianId}"
                                                                                            data-tech-name="${fn:escapeXml(tech.technicianName)}">
                                                                                        Chọn người này
                                                                                    </button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="small text-muted">Chưa có kỹ thuật viên đủ kỹ năng bắt buộc trong thời điểm hiện tại.</div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <button type="button" class="btn btn-outline-primary btn-sm apply-recommendation-btn">
                                                            <i class="fas fa-magic me-1"></i>Áp dụng gợi ý này
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <div class="card bg-white border-0 shadow-sm p-3">
                            <h6 class="text-secondary fw-bold mb-3 border-bottom pb-2">Tạo phương án xử lý trình Manager</h6>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Loại hình xử lý</label>
                                    <select name="type" id="planTypeInput" class="form-select">
                                        <option value="REPAIR">Sửa chữa (Repair)</option>
                                        <option value="REPLACEMENT">Thay thế phụ tùng</option>
                                        <option value="INSPECTION">Kiểm tra hiện trường (Inspection)</option>
                                        <option value="PERIODIC">Bảo trì định kỳ (Maintenance)</option>

                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Mức độ ưu tiên</label>
                                    <select name="priority" id="planPriorityInput" class="form-select">
                                        <option value="LOW">Thấp (Không gấp)</option>
                                        <option value="MEDIUM" selected>Trung bình</option>
                                        <option value="HIGH">Cao (Ưu tiên xử lý)</option>
                                        <option value="CRITICAL">Khẩn cấp (Xử lý ngay)</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Thời lượng dự kiến (phút)</label>
                                    <input type="number" name="estimated_duration_minutes" id="estimatedDurationInput" class="form-control" min="30" step="30" value="120" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Số kỹ thuật viên cần</label>
                                    <input type="number" name="required_technician_count" id="technicianCountInput" class="form-control" min="1" max="1" value="1" readonly required>
                                    <div class="form-text">Mỗi báo cáo sự cố chỉ phân công 1 kỹ thuật viên chính để xử lý.</div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Địa điểm xử lý</label>
                                    <input type="text" name="service_location" id="serviceLocationInput" class="form-control" value="${not empty incidentEntity.locationSnapshot ? incidentEntity.locationSnapshot : prod.currentLocation}" placeholder="Địa điểm thực hiện sửa chữa">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold d-block">Cần chuẩn bị phụ tùng</label>
                                    <div class="form-check form-switch mt-2">
                                        <input class="form-check-input" type="checkbox" name="requires_parts_preparation" id="requiresPartsPreparation" value="1">
                                        <label class="form-check-label" for="requiresPartsPreparation">Có chuẩn bị vật tư/phụ tùng trước</label>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-bold">Ghi chú vật tư / kỹ năng cần</label>
                                    <textarea name="parts_note" id="partsNoteInput" class="form-control" rows="2" placeholder="Ví dụ: Kiểm tra ATS, chuẩn bị lọc gió và dây curoa nếu cần..."></textarea>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-bold">Ghi chú trình Manager</label>
                                    <textarea name="staff_note" id="staffNoteInput" class="form-control" rows="3" placeholder="Ví dụ: Khách báo cần xử lý gấp vào buổi sáng..."></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="text-end mt-4">
                            <button type="submit" class="btn btn-primary px-5 fw-bold shadow">
                                <i class="fas fa-paper-plane me-2"></i>Trình duyệt Manager
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const recommendationButtons = document.querySelectorAll('.apply-recommendation-btn');
        const recommendationCards = document.querySelectorAll('.recommendation-card');
        const typeInput = document.getElementById('planTypeInput');
        const priorityInput = document.getElementById('planPriorityInput');
        const durationInput = document.getElementById('estimatedDurationInput');
        const technicianCountInput = document.getElementById('technicianCountInput');
        const serviceLocationInput = document.getElementById('serviceLocationInput');
        const requiresPartsPreparationInput = document.getElementById('requiresPartsPreparation');
        const partsNoteInput = document.getElementById('partsNoteInput');
        const staffNoteInput = document.getElementById('staffNoteInput');
        const selectedRecommendationCode = document.getElementById('selectedRecommendationCode');
        const selectedRecommendationTitle = document.getElementById('selectedRecommendationTitle');
        const selectedSuggestedTechnicianIds = document.getElementById('selectedSuggestedTechnicianIds');
        const selectedSuggestedTechnicianId = document.getElementById('selectedSuggestedTechnicianId');
        const selectedSuggestedTechnicianName = document.getElementById('selectedSuggestedTechnicianName');
        const selectedRequiredSkillCodes = document.getElementById('selectedRequiredSkillCodes');

        function highlightSelectedTechnician(card, technicianId) {
            const suggestionItems = card.querySelectorAll('.technician-suggestion-item');
            suggestionItems.forEach(function (item) {
                const isSelected = (item.dataset.techId || '') === String(technicianId || '');
                item.classList.toggle('border-primary', isSelected);
                item.classList.toggle('shadow-sm', isSelected);
            });
        }

        function syncSelectedTechnician(card) {
            const selectedSuggestion = card.querySelector('.technician-suggestion-item.border-primary') || card.querySelector('.technician-suggestion-item');
            if (!selectedSuggestion) {
                card.dataset.suggestedTechnicianId = '';
                card.dataset.suggestedTechnicianName = '';
                return;
            }
            card.dataset.suggestedTechnicianId = selectedSuggestion.dataset.techId || '';
            card.dataset.suggestedTechnicianName = selectedSuggestion.dataset.techName || '';
        }

        function applyRecommendationFromCard(card) {
            if (!card) {
                return;
            }
            syncSelectedTechnician(card);
            recommendationCards.forEach(function (item) {
                item.classList.remove('border-primary', 'shadow');
            });
            card.classList.add('border-primary', 'shadow');

            typeInput.value = card.dataset.workType || typeInput.value;
            priorityInput.value = card.dataset.priority || priorityInput.value;
            durationInput.value = card.dataset.duration || durationInput.value;
            technicianCountInput.value = '1';
            serviceLocationInput.value = card.dataset.serviceLocation || serviceLocationInput.value;
            partsNoteInput.value = card.dataset.partsNote || partsNoteInput.value;
            requiresPartsPreparationInput.checked = card.dataset.requiresParts === 'true';
            if (staffNoteInput && !staffNoteInput.value.trim()) {
                staffNoteInput.value = card.dataset.title ? ('Dựa trên gợi ý: ' + card.dataset.title) : staffNoteInput.value;
            }
            selectedRecommendationCode.value = card.dataset.code || '';
            selectedRecommendationTitle.value = card.dataset.title || '';
            selectedSuggestedTechnicianIds.value = card.dataset.suggestedTechnicianIds || '';
            selectedSuggestedTechnicianId.value = card.dataset.suggestedTechnicianId || '';
            selectedSuggestedTechnicianName.value = card.dataset.suggestedTechnicianName || '';
            selectedRequiredSkillCodes.value = card.dataset.requiredSkillCodes || '';
        }

        recommendationButtons.forEach(function (button) {
            button.addEventListener('click', function () {
                applyRecommendationFromCard(button.closest('.recommendation-card'));
            });
        });

        document.querySelectorAll('.select-tech-btn').forEach(function (button) {
            button.addEventListener('click', function () {
                const card = button.closest('.recommendation-card');
                if (!card) {
                    return;
                }
                const technicianId = button.dataset.techId || '';
                const technicianName = button.dataset.techName || '';
                card.dataset.suggestedTechnicianId = technicianId;
                card.dataset.suggestedTechnicianName = technicianName;
                highlightSelectedTechnician(card, technicianId);
                applyRecommendationFromCard(card);
            });
        });

        if (recommendationButtons.length) {
            applyRecommendationFromCard(recommendationButtons[0].closest('.recommendation-card'));
        }
    })();
</script>
