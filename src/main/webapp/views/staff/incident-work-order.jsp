<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Tạo work order</title>

<div class="container mt-4">
    <div class="mb-3">
        <a href="<c:url value='/staff/incident-list'/>" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-success text-white">
            <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Tạo work order từ plan đã duyệt</h5>
        </div>
        <div class="card-body">
            <c:if test="${param.error == 'conflict_schedule'}">
                <div class="alert alert-danger">
                    Kỹ thuật viên đã có lịch trùng trong khung giờ này. Vui lòng chọn kỹ thuật viên khác hoặc đổi thời gian.
                </div>
                <c:if test="${not empty alternativeTechnicianViews}">
                    <div class="alert alert-info">
                        <div class="fw-bold mb-2"><i class="fas fa-user-check me-2"></i>Gợi ý kỹ thuật viên rảnh đúng khung giờ (đã lọc kỹ năng phù hợp)</div>
                        <div class="small text-muted mb-2">Staff không cần nhớ skill từng kỹ thuật viên: hệ thống tự lọc người đạt yêu cầu và ưu tiên theo mức độ phù hợp.</div>
                        <div class="d-grid gap-2">
                            <c:forEach items="${alternativeTechnicianViews}" var="altTech">
                                <button type="button"
                                        class="btn btn-sm btn-outline-primary text-start js-select-tech d-flex justify-content-between align-items-center"
                                        data-tech-id="${altTech.technicianId}">
                                    <span>
                                        <span class="fw-semibold">${altTech.technicianName}</span>
                                        <span class="text-muted small">(${altTech.technicianEmail})</span>
                                        <c:if test="${not altTech.activeProfile}">
                                            <span class="badge bg-secondary ms-2">Profile chưa active</span>
                                        </c:if>
                                        <c:if test="${altTech.recommended}">
                                            <span class="badge bg-success ms-2">Đề xuất ban đầu</span>
                                        </c:if>
                                    </span>
                                    <span class="badge bg-light text-dark border">
                                        ${altTech.currentTaskCount}
                                        <c:if test="${not empty altTech.maxTasksPerDay}">
                                            /${altTech.maxTasksPerDay}
                                        </c:if>
                                        task hôm nay
                                    </span>
                                </button>
                                <c:if test="${not empty altTech.matchScore or not empty altTech.recommendationSummary}">
                                    <div class="small text-muted ms-2 mb-2">
                                        <c:if test="${not empty altTech.matchScore}">
                                            Điểm phù hợp: <span class="fw-semibold">${altTech.matchScore}</span>.
                                        </c:if>
                                        <c:if test="${not empty altTech.recommendationSummary}">
                                            ${altTech.recommendationSummary}
                                        </c:if>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty alternativeTimeSuggestions}">
                    <div class="alert alert-warning">
                        <div class="fw-bold mb-2"><i class="fas fa-clock me-2"></i>Gợi ý giờ thay thế với technician hiện tại</div>
                        <div class="d-flex flex-wrap gap-2">
                            <c:forEach items="${alternativeTimeSuggestions}" var="slot">
                                <button type="button"
                                        class="btn btn-sm btn-outline-dark js-apply-slot"
                                        data-start="${slot.start}"
                                        data-end="${slot.end}">
                                    ${slot.start} → ${slot.end}
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </c:if>
            <c:if test="${param.error == 'invalid_time'}">
                <div class="alert alert-warning">
                    Thời gian kết thúc phải lớn hơn thời gian bắt đầu.
                </div>
            </c:if>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="small text-muted">Sự cố</div>
                    <div class="fw-bold">${incidentEntity.title}</div>
                </div>
                <div class="col-md-6">
                    <div class="small text-muted">Thiết bị</div>
                    <div class="fw-bold">${prod.modelName} (SN: ${prod.serialNumber})</div>
                </div>
                <div class="col-md-4">
                    <div class="small text-muted">Plan</div>
                    <div class="fw-bold">#${incidentPlan.id} - ${incidentPlan.workType}</div>
                </div>
                <div class="col-md-4">
                    <div class="small text-muted">Thời lượng dự kiến</div>
                    <div class="fw-bold">${incidentPlan.estimatedDurationMinutes} phút</div>
                </div>
                <div class="col-md-4">
                    <div class="small text-muted">Địa điểm</div>
                    <div class="fw-bold">${incidentPlan.serviceLocation}</div>
                </div>
            </div>


            <div class="card border-0 shadow-sm mb-4 bg-light">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                        <div>
                            <h6 class="mb-1 fw-bold text-dark"><i class="fas fa-user-clock me-2 text-primary"></i>Lịch trình kỹ thuật viên</h6>
                            <div class="small text-muted">Chỉ tải lịch của kỹ thuật viên đang chọn để staff biết ngay người đó bận hay rảnh, không cần preload toàn bộ danh sách.</div>
                        </div>
                    </div>

                    <div id="technicianAvailabilityEmpty" class="alert alert-secondary mb-0">
                        Chọn kỹ thuật viên và thời gian dự kiến để xem lịch thực tế của người đó.
                        <c:if test="${not empty recommendedTechnicianId}">
                            <div class="mt-2 small">Hệ thống pre-select kỹ thuật viên theo đề xuất staff đã gửi kèm plan trước đó (không phải Manager phân công).</div>
                        </c:if>
                    </div>

                    <div id="technicianAvailabilityPanel" class="d-none">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                            <div>
                                <div class="fw-bold" id="availabilityTechnicianName">-</div>
                                <div class="small text-muted" id="availabilityWindowLabel"></div>
                            </div>
                            <span class="badge" id="availabilityStatusBadge">Đang tải</span>
                        </div>
                        <div id="availabilityConflictAlert" class="alert alert-warning d-none"></div>
                        <div id="availabilitySchedules"></div>
                    </div>
                </div>
            </div>

            <form action="<c:url value='/staff/assign-task'/>" method="post" class="row g-3">
                <input type="hidden" name="id" value="${req.id}">

                <div class="col-md-6">
                    <label class="form-label fw-bold">Kỹ thuật viên chính</label>
                    <select name="technicianId" id="technicianIdSelect" class="form-select" required>
                        <option value="">-- Chọn kỹ thuật viên --</option>
                        <c:forEach items="${listTechnicians}" var="tech">
                            <option value="${tech.id}" ${selectedTechnicianId == tech.id ? 'selected' : ''}>${tech.fullName} - ${tech.email}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold">Bắt đầu</label>
                    <input type="datetime-local" name="scheduledStart" id="scheduledStartInput" class="form-control" value="${preferredScheduledStart}" required>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold">Kết thúc</label>
                    <input type="datetime-local" name="scheduledEnd" id="scheduledEndInput" class="form-control" value="${preferredScheduledEnd}" required>
                </div>
                <div class="col-12 text-end">
                    <button type="submit" class="btn btn-success px-4">
                        <i class="fas fa-check-circle me-2"></i>Tạo work order
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    (function () {
        const technicianSelect = document.getElementById('technicianIdSelect');
        const scheduledStartInput = document.getElementById('scheduledStartInput');
        const scheduledEndInput = document.getElementById('scheduledEndInput');
        const emptyState = document.getElementById('technicianAvailabilityEmpty');
        const panel = document.getElementById('technicianAvailabilityPanel');
        const technicianName = document.getElementById('availabilityTechnicianName');
        const windowLabel = document.getElementById('availabilityWindowLabel');
        const statusBadge = document.getElementById('availabilityStatusBadge');
        const conflictAlert = document.getElementById('availabilityConflictAlert');
        const schedulesContainer = document.getElementById('availabilitySchedules');

        function escapeHtml(value) {
            return String(value || '')
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function formatDateTime(rawValue) {
            if (!rawValue) {
                return '-';
            }
            const parsed = new Date(rawValue);
            if (Number.isNaN(parsed.getTime())) {
                return rawValue;
            }
            const day = String(parsed.getDate()).padStart(2, '0');
            const month = String(parsed.getMonth() + 1).padStart(2, '0');
            const year = parsed.getFullYear();
            const hours = String(parsed.getHours()).padStart(2, '0');
            const minutes = String(parsed.getMinutes()).padStart(2, '0');
            return day + '/' + month + '/' + year + ' ' + hours + ':' + minutes;
        }

        function renderSchedules(items) {
            if (!items || !items.length) {
                schedulesContainer.innerHTML = '<div class="alert alert-success mb-0">Không có lịch nào trong khoảng thời gian đang xem.</div>';
                return;
            }

            const html = items.map(function (item) {
                const serial = item.productSerialNumber ? ' | SN: ' + escapeHtml(item.productSerialNumber) : '';
                return '' +
                    '<div class="border rounded p-3 mb-2 bg-white">' +
                        '<div class="fw-semibold">' + formatDateTime(item.scheduledStart) + ' - ' + formatDateTime(item.scheduledEnd) + '</div>' +
                        '<div class="small text-muted">' + escapeHtml(item.type) + ' | WO #' + escapeHtml(item.maintenanceId) + serial + '</div>' +
                        '<div>' + escapeHtml(item.description) + '</div>' +
                    '</div>';
            }).join('');
            schedulesContainer.innerHTML = html;
        }

        function setLoadingState() {
            emptyState.classList.add('d-none');
            panel.classList.remove('d-none');
            technicianName.textContent = 'Đang tải...';
            windowLabel.textContent = '';
            statusBadge.className = 'badge bg-secondary';
            statusBadge.textContent = 'Đang tải';
            conflictAlert.classList.add('d-none');
            schedulesContainer.innerHTML = '<div class="small text-muted">Đang tải lịch...</div>';
        }

        function resetAvailability() {
            emptyState.classList.remove('d-none');
            panel.classList.add('d-none');
            conflictAlert.classList.add('d-none');
            schedulesContainer.innerHTML = '';
        }

        async function loadAvailability() {
            const technicianId = technicianSelect ? technicianSelect.value : '';
            if (!technicianId) {
                resetAvailability();
                return;
            }

            setLoadingState();
            const params = new URLSearchParams({ technicianId: technicianId });
            if (scheduledStartInput && scheduledStartInput.value) {
                params.set('scheduledStart', scheduledStartInput.value);
            }
            if (scheduledEndInput && scheduledEndInput.value) {
                params.set('scheduledEnd', scheduledEndInput.value);
            }

            try {
                const response = await fetch('<c:url value="/staff/technician-availability"/>' + '?' + params.toString(), {
                    headers: { 'Accept': 'application/json' }
                });
                const data = await response.json();
                if (!response.ok) {
                    throw new Error(data.message || 'Không thể tải lịch kỹ thuật viên');
                }

                technicianName.textContent = data.technicianName || 'Kỹ thuật viên';
                windowLabel.textContent = 'Khung đang xem: ' + formatDateTime(data.windowStart) + ' - ' + formatDateTime(data.windowEnd);
                if (data.hasConflict) {
                    statusBadge.className = 'badge bg-danger';
                    statusBadge.textContent = 'Trùng lịch';
                    conflictAlert.className = 'alert alert-danger';
                    conflictAlert.textContent = 'Kỹ thuật viên này đang có lịch trùng với khung giờ bạn chọn.';
                } else {
                    statusBadge.className = 'badge bg-success';
                    statusBadge.textContent = 'Có thể phân công';
                    conflictAlert.classList.add('d-none');
                }
                renderSchedules(data.schedules || []);
            } catch (error) {
                statusBadge.className = 'badge bg-danger';
                statusBadge.textContent = 'Lỗi tải dữ liệu';
                technicianName.textContent = 'Không thể tải lịch';
                conflictAlert.className = 'alert alert-warning';
                conflictAlert.textContent = error.message || 'Không thể tải lịch kỹ thuật viên.';
                schedulesContainer.innerHTML = '';
            }
        }

        if (technicianSelect) {
            technicianSelect.addEventListener('change', loadAvailability);
        }
        if (scheduledStartInput) {
            scheduledStartInput.addEventListener('change', loadAvailability);
        }
        if (scheduledEndInput) {
            scheduledEndInput.addEventListener('change', loadAvailability);
        }

        if (technicianSelect && technicianSelect.value && scheduledStartInput && scheduledStartInput.value && scheduledEndInput && scheduledEndInput.value) {
            loadAvailability();
        }

        document.querySelectorAll('.js-select-tech').forEach(function (button) {
            button.addEventListener('click', function () {
                if (!technicianSelect) {
                    return;
                }
                technicianSelect.value = button.dataset.techId || '';
                loadAvailability();
            });
        });

        document.querySelectorAll('.js-apply-slot').forEach(function (button) {
            button.addEventListener('click', function () {
                if (!scheduledStartInput || !scheduledEndInput) {
                    return;
                }
                scheduledStartInput.value = button.dataset.start || '';
                scheduledEndInput.value = button.dataset.end || '';
                loadAvailability();
            });
        });
    })();
</script>
