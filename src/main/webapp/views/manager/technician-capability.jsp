<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Technician Capability Management</title>

<style>
    .capability-shell {
        max-width: 1440px;
        margin: 0 auto;
    }

    .hero-card {
        border: 0;
        border-radius: 24px;
        overflow: hidden;
        background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 55%, #38bdf8 100%);
        color: #fff;
        box-shadow: 0 20px 50px rgba(15, 23, 42, 0.18);
    }

    .hero-chip,
    .stat-chip {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 14px;
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.16);
        border: 1px solid rgba(255, 255, 255, 0.18);
        font-weight: 600;
        font-size: 0.92rem;
    }

    .glass-card,
    .section-card {
        border: 0;
        border-radius: 22px;
        box-shadow: 0 18px 36px rgba(15, 23, 42, 0.08);
        overflow: hidden;
        background: #fff;
    }

    .section-card .card-header,
    .glass-card .card-header {
        background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        border-bottom: 1px solid #e2e8f0;
        padding: 1rem 1.25rem;
    }

    .section-card .card-body,
    .glass-card .card-body {
        padding: 1.25rem;
    }

    .technician-list {
        max-height: 860px;
        overflow: auto;
    }

    .tech-list-item {
        border: 0;
        border-bottom: 1px solid #edf2f7;
        padding: 16px 18px;
        transition: all 0.2s ease;
    }

    .tech-list-item:hover {
        background: #f8fbff;
    }

    .tech-list-item.active {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #0f172a;
        border-left: 4px solid #2563eb;
    }

    .tech-meta {
        color: #64748b;
        font-size: 0.9rem;
    }

    .badge-soft {
        border-radius: 999px;
        padding: 7px 12px;
        font-weight: 700;
        font-size: 0.78rem;
    }

    .badge-soft-primary { background: #dbeafe; color: #1d4ed8; }
    .badge-soft-success { background: #dcfce7; color: #15803d; }
    .badge-soft-warning { background: #fef3c7; color: #b45309; }
    .badge-soft-muted { background: #e5e7eb; color: #4b5563; }
    .badge-soft-danger { background: #fee2e2; color: #b91c1c; }

    .summary-strip {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 14px;
        margin-top: 18px;
    }

    .summary-box {
        background: rgba(255, 255, 255, 0.12);
        border: 1px solid rgba(255, 255, 255, 0.18);
        border-radius: 18px;
        padding: 16px 18px;
    }

    .summary-box .label {
        font-size: 0.82rem;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        opacity: 0.8;
    }

    .summary-box .value {
        font-size: 1.4rem;
        font-weight: 800;
        margin-top: 4px;
    }

    .section-hint {
        margin-top: 8px;
        font-size: 0.92rem;
        color: #64748b;
        line-height: 1.5;
    }

    .info-banner {
        border: 1px solid #dbeafe;
        background: linear-gradient(135deg, #eff6ff 0%, #f8fbff 100%);
        border-radius: 18px;
        padding: 16px 18px;
    }

    .help-mini-card {
        border-radius: 18px;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        padding: 14px 16px;
        height: 100%;
    }

    .form-control,
    .form-select {
        border-radius: 14px;
        min-height: 46px;
        border-color: #cbd5e1;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #60a5fa;
        box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.12);
    }

    .action-btn {
        border-radius: 14px;
        padding: 10px 16px;
        font-weight: 700;
    }

    .table-modern thead th {
        border-bottom: 0;
        background: #f8fafc;
        color: #334155;
        font-weight: 800;
        white-space: nowrap;
    }

    .table-modern tbody td {
        vertical-align: middle;
        border-color: #edf2f7;
    }

    .empty-state {
        padding: 28px 16px;
        text-align: center;
        color: #64748b;
        font-weight: 500;
    }

    .sticky-side {
        position: sticky;
        top: 18px;
    }
</style>

<div class="container-fluid py-3 capability-shell">
    <div class="card hero-card mb-4">
        <div class="card-body p-4 p-lg-5">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
                <div>
                    <div class="hero-chip mb-3"><i class="fa fa-user-gear"></i> Manager Workspace</div>
                    <h1 class="h2 fw-bold mb-2">Technician Capability Management</h1>
                    <p class="mb-0 opacity-75">Quản lý dữ liệu nguồn cho recommendation và scheduling: hồ sơ điều phối, kỹ năng, unavailable blocks và skill catalog.</p>
                </div>
                <div class="text-lg-end">
                    <a href="${pageContext.request.contextPath}/manager/home" class="btn btn-light action-btn text-primary">
                        <i class="fa fa-arrow-left me-2"></i>Quay lại dashboard
                    </a>
                </div>
            </div>

            <div class="summary-strip">
                <div class="summary-box">
                    <div class="label">Technicians</div>
                    <div class="value">${fn:length(technicians)}</div>
                </div>
                <div class="summary-box">
                    <div class="label">Assigned skills</div>
                    <div class="value">${fn:length(assignedSkills)}</div>
                </div>
                <div class="summary-box">
                    <div class="label">Unavailable blocks</div>
                    <div class="value">${fn:length(unavailabilityList)}</div>
                </div>
                <div class="summary-box">
                    <div class="label">Skill catalog</div>
                    <div class="value">${fn:length(skillCatalog)}</div>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty messageKey}">
        <div class="alert ${fn:contains(messageKey, 'error') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show rounded-4 shadow-sm border-0 mb-4" role="alert">
            <strong>Kết quả:</strong> ${messageKey}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="info-banner mb-4">
        <div class="row g-3 align-items-stretch">
            <div class="col-lg-6">
                <div class="help-mini-card">
                    <div class="fw-bold text-primary mb-2"><i class="fa fa-shield-halved me-2"></i>`technician_skills` dùng để làm gì?</div>
                    <div class="text-muted">Bảng này lưu <strong>kỹ năng mà từng technician đang có</strong>. Recommendation sẽ đọc bảng này để biết technician nào đủ skill bắt buộc cho một incident plan.</div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="help-mini-card">
                    <div class="fw-bold text-warning mb-2"><i class="fa fa-calendar-xmark me-2"></i>`technician_unavailability` dùng để làm gì?</div>
                    <div class="text-muted">Bảng này lưu <strong>các khoảng thời gian technician không thể nhận việc</strong> như nghỉ phép, training, hoặc bị block. Recommendation và lịch phân công sẽ dùng nó để tránh xếp sai người, sai giờ.</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 align-items-start">
        <div class="col-xl-4">
            <div class="glass-card sticky-side">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="mb-1 fw-bold text-secondary"><i class="fa fa-users me-2"></i>Danh sách technician</h5>
                        <div class="small text-muted">Chọn technician để chỉnh capability.</div>
                    </div>
                    <span class="badge-soft badge-soft-primary">${fn:length(technicians)} users</span>
                </div>
                <div class="card-body p-0 technician-list">
                    <div class="list-group list-group-flush">
                        <c:forEach items="${technicians}" var="tech">
                            <a class="list-group-item list-group-item-action tech-list-item ${selectedTechnicianId == tech.id ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/manager/technician-capability?technicianId=${tech.id}">
                                <div class="d-flex justify-content-between align-items-start gap-2">
                                    <div>
                                        <div class="fw-bold">${tech.fullName}</div>
                                        <div class="tech-meta mt-1">#${tech.id} • ${tech.email}</div>
                                    </div>
                                    <span class="badge-soft ${tech.status == 1 ? 'badge-soft-success' : 'badge-soft-muted'}">${tech.status == 1 ? 'Active' : 'Inactive'}</span>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8">
            <c:if test="${not empty selectedTechnician}">
                <div class="section-card mb-4">
                    <div class="card-body d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
                        <div>
                            <div class="small text-uppercase text-muted fw-bold mb-1">Technician đang chọn</div>
                            <h4 class="mb-1 fw-bold text-dark">${selectedTechnician.fullName}</h4>
                            <div class="text-muted">ID #${selectedTechnician.id} • ${selectedTechnician.email}</div>
                        </div>
                        <div class="d-flex flex-wrap gap-2">
                            <span class="badge-soft badge-soft-primary">Skills: ${fn:length(assignedSkills)}</span>
                            <span class="badge-soft badge-soft-warning">Blocks: ${fn:length(unavailabilityList)}</span>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="section-card mb-4">
                <div class="card-header">
                    <h5 class="mb-1 fw-bold text-secondary"><i class="fa fa-id-card me-2"></i>Profile điều phối</h5>
                    <div class="section-hint">Cấu hình service area, home base, giờ làm việc và mức tải tối đa trong ngày cho technician.</div>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3">
                        <input type="hidden" name="action" value="save_profile">
                        <input type="hidden" name="technicianId" value="${selectedTechnicianId}">

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Service area</label>
                            <input type="text" class="form-control" name="serviceArea" value="${profile.serviceArea}" placeholder="Ví dụ: HCM, Bình Dương">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Home base</label>
                            <input type="text" class="form-control" name="homeBase" value="${profile.homeBase}" placeholder="Ví dụ: Thủ Đức">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Start</label>
                            <input type="time" class="form-control" name="workingHoursStart" value="${workingHoursStartValue}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">End</label>
                            <input type="time" class="form-control" name="workingHoursEnd" value="${workingHoursEndValue}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Max task/day</label>
                            <input type="number" class="form-control" min="1" name="maxTasksPerDay" value="${profile.maxTasksPerDay}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Timezone</label>
                            <input type="text" class="form-control" name="timezoneName" value="${profile.timezoneName}" placeholder="Asia/Ho_Chi_Minh">
                        </div>
                        <div class="col-12">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="activeStatus" id="activeStatus" value="1" ${profile.activeStatus ? 'checked' : ''}>
                                <label class="form-check-label" for="activeStatus">Profile active và sẵn sàng dùng cho recommendation</label>
                            </div>
                        </div>
                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-primary action-btn px-4"><i class="fa fa-save me-2"></i>Lưu profile</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="section-card h-100">
                        <div class="card-header d-flex justify-content-between align-items-center gap-2">
                            <div>
                                <h5 class="mb-1 fw-bold text-secondary"><i class="fa fa-shield-halved me-2"></i>Skills của technician</h5>
                                <div class="section-hint">Mỗi dòng ở đây tương ứng một record trong bảng <strong>`technician_skills`</strong>.</div>
                            </div>
                            <span class="badge-soft badge-soft-primary">${fn:length(assignedSkills)} assigned</span>
                        </div>
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3 mb-4">
                                <input type="hidden" name="action" value="assign_skill">
                                <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                                <div class="col-md-7">
                                    <label class="form-label fw-semibold">Skill</label>
                                    <select class="form-select" name="skillCode" required>
                                        <option value="">-- Chọn skill --</option>
                                        <c:forEach items="${skillCatalog}" var="skill">
                                            <c:if test="${skill.activeStatus}">
                                                <option value="${skill.code}">${skill.code} - ${skill.name}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label fw-semibold">Expires at</label>
                                    <input type="datetime-local" class="form-control" name="expiresAt">
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-outline-primary action-btn"><i class="fa fa-plus me-2"></i>Assign skill</button>
                                </div>
                            </form>

                            <div class="table-responsive">
                                <table class="table table-modern align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Skill</th>
                                            <th>Expires</th>
                                            <th>Status</th>
                                            <th class="text-end">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${assignedSkills}" var="skill">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold">${skill.skillCode}</div>
                                                    <div class="small text-muted">${skill.skillName}</div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty skill.expiresAt}">
                                                            <fmt:formatDate value="${skill.expiresAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-soft badge-soft-muted">Không hết hạn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge-soft ${skill.catalogActive ? 'badge-soft-success' : 'badge-soft-muted'}">${skill.catalogActive ? 'Catalog active' : 'Catalog inactive'}</span>
                                                </td>
                                                <td class="text-end">
                                                    <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="d-inline">
                                                        <input type="hidden" name="action" value="remove_skill">
                                                        <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                                                        <input type="hidden" name="skillCode" value="${skill.skillCode}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger action-btn"><i class="fa fa-trash me-1"></i>Remove</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty assignedSkills}">
                                            <tr><td colspan="4" class="empty-state">Technician này chưa được gán skill nào.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="section-card h-100">
                        <div class="card-header d-flex justify-content-between align-items-center gap-2">
                            <div>
                                <h5 class="mb-1 fw-bold text-secondary"><i class="fa fa-calendar-xmark me-2"></i>Unavailable blocks</h5>
                                <div class="section-hint">Mỗi dòng ở đây tương ứng một khoảng thời gian trong bảng <strong>`technician_unavailability`</strong>.</div>
                            </div>
                            <span class="badge-soft badge-soft-warning">${fn:length(unavailabilityList)} blocks</span>
                        </div>
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3 mb-4">
                                <input type="hidden" name="action" value="add_unavailability">
                                <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Unavailable start</label>
                                    <input type="datetime-local" class="form-control" name="unavailableStart" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Unavailable end</label>
                                    <input type="datetime-local" class="form-control" name="unavailableEnd" required>
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-outline-warning action-btn"><i class="fa fa-calendar-plus me-2"></i>Thêm block</button>
                                </div>
                            </form>

                            <div class="table-responsive">
                                <table class="table table-modern align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Từ</th>
                                            <th>Đến</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${unavailabilityList}" var="item">
                                            <tr>
                                                <td><fmt:formatDate value="${item.unavailableStart}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td><fmt:formatDate value="${item.unavailableEnd}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty unavailabilityList}">
                                            <tr><td colspan="2" class="empty-state">Chưa có unavailable block nào.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="section-card mt-4">
                <div class="card-header d-flex justify-content-between align-items-center gap-2">
                    <div>
                        <h5 class="mb-1 fw-bold text-secondary"><i class="fa fa-book me-2"></i>Skill catalog management</h5>
                        <div class="section-hint">Danh mục skill chuẩn của hệ thống. Technician chỉ được gán skill từ catalog này.</div>
                    </div>
                    <span class="badge-soft badge-soft-success">${fn:length(skillCatalog)} skills</span>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3 mb-4">
                        <input type="hidden" name="action" value="save_catalog">
                        <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Skill code</label>
                            <input type="text" class="form-control" name="catalogCode" placeholder="FIELD_INSPECTION" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label fw-semibold">Skill name</label>
                            <input type="text" class="form-control" name="catalogName" placeholder="Khảo sát hiện trường" required>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" role="switch" name="catalogActive" id="catalogActive" value="1" checked>
                                <label class="form-check-label" for="catalogActive">Active</label>
                            </div>
                        </div>
                        <div class="col-md-2 d-flex align-items-end justify-content-end">
                            <button type="submit" class="btn btn-outline-success action-btn w-100"><i class="fa fa-save me-2"></i>Lưu</button>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-modern align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${skillCatalog}" var="item">
                                    <tr>
                                        <td class="fw-bold">${item.code}</td>
                                        <td>${item.name}</td>
                                        <td><span class="badge-soft ${item.activeStatus ? 'badge-soft-success' : 'badge-soft-muted'}">${item.activeStatus ? 'Active' : 'Inactive'}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty skillCatalog}">
                                    <tr><td colspan="3" class="empty-state">Skill catalog đang trống.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
