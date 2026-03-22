<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                            <div class="small text-muted">Hiển thị lịch trong 7 ngày tới để staff biết ai đang bận và ai còn trống trước khi giao task.</div>
                        </div>
                        <div class="small text-muted">
                            <fmt:formatDate value="${scheduleWindowStart}" pattern="dd/MM/yyyy HH:mm" />
                            -
                            <fmt:formatDate value="${scheduleWindowEnd}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                    </div>

                    <div class="row g-3">
                        <c:forEach items="${listTechnicians}" var="tech">
                            <c:set var="techSchedules" value="${technicianSchedules[tech.id]}" />
                            <div class="col-md-6">
                                <div class="card h-100 border ${empty techSchedules ? 'border-success' : 'border-warning'} technician-schedule-card" data-tech-id="${tech.id}">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                            <div>
                                                <div class="fw-bold">${tech.fullName}</div>
                                                <div class="small text-muted">${tech.email}</div>
                                            </div>
                                            <c:choose>
                                                <c:when test="${empty techSchedules}">
                                                    <span class="badge bg-success">Đang rảnh</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">${techSchedules.size()} lịch sắp tới</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <c:choose>
                                            <c:when test="${empty techSchedules}">
                                                <div class="small text-success mb-0">Chưa có lịch nào trong khung 7 ngày tới.</div>
                                            </c:when>
                                            <c:otherwise>
                                                <ul class="list-group list-group-flush small">
                                                    <c:forEach items="${techSchedules}" var="schedule">
                                                        <li class="list-group-item px-0">
                                                            <div class="fw-semibold">
                                                                <fmt:formatDate value="${schedule.scheduledStart}" pattern="dd/MM HH:mm" />
                                                                -
                                                                <fmt:formatDate value="${schedule.scheduledEnd}" pattern="HH:mm" />
                                                            </div>
                                                            <div class="text-muted">
                                                                ${schedule.type} | WO #${schedule.maintenanceId}
                                                                <c:if test="${not empty schedule.productSerialNumber}">
                                                                    | SN: ${schedule.productSerialNumber}
                                                                </c:if>
                                                            </div>
                                                            <div>${schedule.description}</div>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
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
                            <option value="${tech.id}">${tech.fullName} - ${tech.email}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold">Bắt đầu</label>
                    <input type="datetime-local" name="scheduledStart" class="form-control" required>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold">Kết thúc</label>
                    <input type="datetime-local" name="scheduledEnd" class="form-control" required>
                </div>

                <div class="col-12">
                    <div class="alert alert-info mb-0">
                        Manager đã duyệt plan. Ở bước này staff mới chốt lịch thực tế và gán kỹ thuật viên để tạo work order.
                    </div>
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
        const scheduleCards = document.querySelectorAll('.technician-schedule-card');

        function highlightSelectedTechnician() {
            const selectedId = technicianSelect ? technicianSelect.value : '';
            scheduleCards.forEach(function (card) {
                const isSelected = selectedId && card.dataset.techId === selectedId;
                card.classList.toggle('border-primary', !!isSelected);
                card.classList.toggle('shadow', !!isSelected);
            });
        }

        if (technicianSelect) {
            technicianSelect.addEventListener('change', highlightSelectedTechnician);
            highlightSelectedTechnician();
        }
    })();
</script>
