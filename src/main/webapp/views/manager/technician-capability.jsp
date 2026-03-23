<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Technician Capability Management</title>

<style>
    :root {
        --cap-page-bg: #f5f7fb;
        --cap-card-bg: #ffffff;
        --cap-border: #e2e8f0;
        --cap-text: #0f172a;
        --cap-muted: #64748b;
        --cap-primary: #2563eb;
        --cap-primary-soft: #dbeafe;
        --cap-success-soft: #dcfce7;
        --cap-warning-soft: #fef3c7;
        --cap-danger-soft: #fee2e2;
        --cap-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
    }

    body {
        background: var(--cap-page-bg);
    }

    .capability-shell {
        max-width: 1460px;
        margin: 0 auto;
        color: var(--cap-text);
    }

    .page-head {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 16px;
        margin-bottom: 20px;
    }

    .page-title {
        margin: 0;
        font-size: 2rem;
        font-weight: 800;
    }

    .page-copy {
        margin: 8px 0 0;
        color: var(--cap-muted);
        line-height: 1.7;
    }

    .page-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
    }

    .layout-grid {
        display: grid;
        grid-template-columns: 360px minmax(0, 1fr);
        gap: 24px;
        align-items: start;
    }

    .management-card {
        background: var(--cap-card-bg);
        border: 1px solid var(--cap-border);
        border-radius: 24px;
        box-shadow: var(--cap-shadow);
        overflow: hidden;
    }

    .management-card + .management-card {
        margin-top: 20px;
    }

    .management-card .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        padding: 18px 22px;
        background: #fff;
        border-bottom: 1px solid var(--cap-border);
    }

    .management-card .card-body {
        padding: 22px;
    }

    .card-title {
        margin: 0;
        font-size: 1.2rem;
        font-weight: 800;
        color: #1e293b;
    }

    .card-copy {
        margin: 6px 0 0;
        color: var(--cap-muted);
        line-height: 1.6;
        font-size: 0.95rem;
    }

    .badge-soft {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 0.82rem;
        font-weight: 700;
    }

    .badge-soft-primary { background: var(--cap-primary-soft); color: #1d4ed8; }
    .badge-soft-success { background: var(--cap-success-soft); color: #15803d; }
    .badge-soft-warning { background: var(--cap-warning-soft); color: #b45309; }
    .badge-soft-danger { background: var(--cap-danger-soft); color: #b91c1c; }
    .badge-soft-muted { background: #e2e8f0; color: #475569; }

    .btn-round {
        border-radius: 14px;
        font-weight: 700;
        padding: 10px 16px;
    }

    .sidebar-sticky {
        position: sticky;
        top: 18px;
    }

    .sidebar-summary {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 12px;
        margin-bottom: 18px;
    }

    .summary-box {
        background: #f8fafc;
        border: 1px solid var(--cap-border);
        border-radius: 18px;
        padding: 14px 16px;
    }

    .summary-label {
        display: block;
        color: var(--cap-muted);
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.04em;
    }

    .summary-value {
        display: block;
        margin-top: 8px;
        font-size: 1.4rem;
        font-weight: 800;
    }

    .technician-list {
        display: grid;
        gap: 12px;
        max-height: 980px;
        overflow: auto;
        padding-right: 4px;
    }

    .tech-item {
        display: block;
        padding: 16px;
        border: 1px solid var(--cap-border);
        border-radius: 20px;
        text-decoration: none;
        color: inherit;
        background: #fff;
        transition: all 0.18s ease;
    }

    .tech-item:hover {
        border-color: #93c5fd;
        box-shadow: 0 10px 24px rgba(37, 99, 235, 0.12);
        color: inherit;
    }

    .tech-item.active {
        border-color: #60a5fa;
        background: #eff6ff;
        box-shadow: 0 12px 28px rgba(37, 99, 235, 0.14);
    }

    .tech-item-top {
        display: flex;
        justify-content: space-between;
        gap: 12px;
        align-items: flex-start;
    }

    .tech-name {
        margin: 0;
        font-size: 1rem;
        font-weight: 800;
    }

    .tech-meta {
        margin-top: 6px;
        color: var(--cap-muted);
        font-size: 0.92rem;
        line-height: 1.55;
    }

    .main-stack {
        display: grid;
        gap: 20px;
    }

    .selected-strip {
        display: grid;
        grid-template-columns: minmax(0, 1.2fr) repeat(2, minmax(160px, 0.4fr));
        gap: 14px;
        align-items: stretch;
    }

    .selected-main,
    .selected-mini {
        border: 1px solid var(--cap-border);
        border-radius: 20px;
        padding: 18px 20px;
        background: #f8fbff;
    }

    .selected-eyebrow,
    .mini-label {
        display: block;
        color: var(--cap-muted);
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    .selected-name {
        margin: 8px 0 0;
        font-size: 1.6rem;
        font-weight: 800;
    }

    .selected-meta {
        margin-top: 10px;
        color: var(--cap-muted);
        line-height: 1.7;
    }

    .mini-value {
        display: block;
        margin-top: 8px;
        font-size: 1.35rem;
        font-weight: 800;
    }

    .profile-grid,
    .two-column-grid {
        display: grid;
        gap: 20px;
    }

    .profile-grid {
        grid-template-columns: repeat(4, minmax(0, 1fr));
    }

    .two-column-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .field-card {
        border: 1px solid var(--cap-border);
        border-radius: 18px;
        padding: 16px;
        background: #f8fafc;
    }

    .field-title {
        margin-bottom: 8px;
        font-weight: 700;
        color: #1e293b;
    }

    .form-label {
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 8px;
    }

    .form-control,
    .form-select {
        min-height: 48px;
        border-radius: 14px;
        border: 1px solid #cbd5e1;
        background: #fff;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #60a5fa;
        box-shadow: 0 0 0 0.18rem rgba(59, 130, 246, 0.12);
    }

    .switch-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        padding: 16px 18px;
        background: #f8fafc;
        border: 1px solid var(--cap-border);
        border-radius: 18px;
    }

    .form-check-input {
        width: 2.8rem;
        height: 1.45rem;
    }

    .table-shell {
        border: 1px solid var(--cap-border);
        border-radius: 18px;
        overflow: hidden;
        background: #fff;
    }

    .table-modern {
        margin: 0;
    }

    .table-modern thead th {
        background: #f8fafc;
        color: #334155;
        font-weight: 800;
        border-bottom: 1px solid var(--cap-border);
        padding: 14px 16px;
        white-space: nowrap;
    }

    .table-modern tbody td {
        padding: 14px 16px;
        vertical-align: middle;
        border-color: #edf2f7;
    }

    .table-modern tbody tr:hover {
        background: #fafcff;
    }

    .code-text {
        font-weight: 800;
        color: #0f172a;
    }

    .sub-text {
        display: block;
        margin-top: 4px;
        color: var(--cap-muted);
        font-size: 0.92rem;
        line-height: 1.55;
    }

    .empty-state {
        text-align: center;
        color: var(--cap-muted);
        padding: 28px 16px;
        font-weight: 600;
    }

    @media (max-width: 1199.98px) {
        .layout-grid,
        .selected-strip,
        .profile-grid,
        .two-column-grid {
            grid-template-columns: 1fr;
        }

        .sidebar-sticky {
            position: static;
        }
    }

    @media (max-width: 767.98px) {
        .page-head,
        .management-card .card-header,
        .switch-row {
            flex-direction: column;
            align-items: flex-start;
        }

        .management-card .card-body,
        .management-card .card-header {
            padding: 16px;
        }

        .sidebar-summary {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="container-fluid py-4 capability-shell">
    <div class="page-head">
        <div>
            <h1 class="page-title">Technician Capability Management</h1>
            <p class="page-copy">Giao diện được chuyển về kiểu quản lý theo list: chọn technician ở cột trái, chỉnh profile ở trên và quản lý skill / unavailable / skill catalog bằng các bảng danh sách rõ ràng.</p>
        </div>
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/manager/home" class="btn btn-light border btn-round text-primary">
                <i class="fa fa-arrow-left me-2"></i>Quay lại dashboard
            </a>
        </div>
    </div>

    <c:if test="${not empty messageKey}">
        <div class="alert ${fn:contains(messageKey, 'error') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show rounded-4 border-0 shadow-sm mb-4" role="alert">
            <strong>Kết quả:</strong> ${messageKey}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="layout-grid">
        <div class="sidebar-sticky">
            <div class="management-card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Technician management</h2>
                        <p class="card-copy">Danh sách technician để chọn và chỉnh capability.</p>
                    </div>
                    <span class="badge-soft badge-soft-primary">${fn:length(technicians)} users</span>
                </div>
                <div class="card-body">
                    <div class="sidebar-summary">
                        <div class="summary-box">
                            <span class="summary-label">Assigned skills</span>
                            <span class="summary-value">${fn:length(assignedSkills)}</span>
                        </div>
                        <div class="summary-box">
                            <span class="summary-label">Blocks</span>
                            <span class="summary-value">${fn:length(unavailabilityList)}</span>
                        </div>
                    </div>

                    <div class="technician-list">
                        <c:forEach items="${technicians}" var="tech">
                            <a class="tech-item ${selectedTechnicianId == tech.id ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/manager/technician-capability?technicianId=${tech.id}">
                                <div class="tech-item-top">
                                    <div>
                                        <h3 class="tech-name">${tech.fullName}</h3>
                                        <div class="tech-meta">#${tech.id} • ${tech.email}</div>
                                    </div>
                                    <span class="badge-soft ${tech.status == 1 ? 'badge-soft-success' : 'badge-soft-muted'}">${tech.status == 1 ? 'Active' : 'Inactive'}</span>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="main-stack">
            <c:if test="${not empty selectedTechnician}">
                <div class="management-card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Technician đang chọn</h2>
                            <p class="card-copy">Thông tin tóm tắt của technician hiện tại.</p>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="selected-strip">
                            <div class="selected-main">
                                <span class="selected-eyebrow">Technician</span>
                                <h3 class="selected-name">${selectedTechnician.fullName}</h3>
                                <div class="selected-meta">ID #${selectedTechnician.id} • ${selectedTechnician.email}</div>
                            </div>
                            <div class="selected-mini">
                                <span class="mini-label">Skills</span>
                                <span class="mini-value">${fn:length(assignedSkills)}</span>
                            </div>
                            <div class="selected-mini">
                                <span class="mini-label">Unavailable blocks</span>
                                <span class="mini-value">${fn:length(unavailabilityList)}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="management-card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Profile điều phối</h2>
                        <p class="card-copy">Cập nhật giờ làm việc, tải tối đa và timezone của technician.</p>
                    </div>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3">
                        <input type="hidden" name="action" value="save_profile">
                        <input type="hidden" name="technicianId" value="${selectedTechnicianId}">

                        <div class="col-lg-3 col-md-6">
                            <div class="field-card">
                                <label class="form-label">Start</label>
                                <input type="time" class="form-control" name="workingHoursStart" value="${workingHoursStartValue}" required>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="field-card">
                                <label class="form-label">End</label>
                                <input type="time" class="form-control" name="workingHoursEnd" value="${workingHoursEndValue}" required>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="field-card">
                                <label class="form-label">Max task/day</label>
                                <input type="number" class="form-control" min="1" name="maxTasksPerDay" value="${profile.maxTasksPerDay}">
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="field-card">
                                <label class="form-label">Timezone</label>
                                <input type="text" class="form-control" name="timezoneName" value="${profile.timezoneName}" placeholder="Asia/Ho_Chi_Minh">
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="switch-row">
                                <div>
                                    <div class="field-title">Profile active</div>
                                    <div class="sub-text">Bật khi technician sẵn sàng tham gia recommendation.</div>
                                </div>
                                <div class="form-check form-switch m-0">
                                    <input class="form-check-input" type="checkbox" role="switch" name="activeStatus" id="activeStatus" value="1" ${profile.activeStatus ? 'checked' : ''}>
                                    <label class="form-check-label ms-2 fw-semibold" for="activeStatus">Kích hoạt</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-primary btn-round px-4">
                                <i class="fa fa-save me-2"></i>Lưu profile
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="two-column-grid">
                <div class="management-card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Skills của technician</h2>
                            <p class="card-copy">Danh sách skill đã gán cho technician đang chọn.</p>
                        </div>
                        <span class="badge-soft badge-soft-primary">${fn:length(assignedSkills)} assigned</span>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3 mb-4">
                            <input type="hidden" name="action" value="assign_skill">
                            <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                            <div class="col-md-7">
                                <label class="form-label">Skill</label>
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
                                <label class="form-label">Expires at</label>
                                <input type="datetime-local" class="form-control" name="expiresAt">
                            </div>
                            <div class="col-12 text-end">
                                <button type="submit" class="btn btn-outline-primary btn-round">
                                    <i class="fa fa-plus me-2"></i>Assign skill
                                </button>
                            </div>
                        </form>

                        <div class="table-shell">
                            <div class="table-responsive">
                                <table class="table table-modern align-middle">
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
                                                    <span class="code-text">${skill.skillCode}</span>
                                                    <span class="sub-text">${skill.skillName}</span>
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
                                                        <button type="submit" class="btn btn-sm btn-outline-danger btn-round"><i class="fa fa-trash me-1"></i>Remove</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty assignedSkills}">
                                            <tr><td colspan="4" class="empty-state">Technician này chưa có skill nào được gán.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="management-card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Unavailable blocks</h2>
                            <p class="card-copy">Danh sách khoảng thời gian technician không thể nhận việc.</p>
                        </div>
                        <span class="badge-soft badge-soft-warning">${fn:length(unavailabilityList)} blocks</span>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3 mb-4">
                            <input type="hidden" name="action" value="add_unavailability">
                            <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                            <div class="col-md-6">
                                <label class="form-label">Unavailable start</label>
                                <input type="datetime-local" class="form-control" name="unavailableStart" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Unavailable end</label>
                                <input type="datetime-local" class="form-control" name="unavailableEnd" required>
                            </div>
                            <div class="col-12 text-end">
                                <button type="submit" class="btn btn-outline-warning btn-round">
                                    <i class="fa fa-calendar-plus me-2"></i>Thêm block
                                </button>
                            </div>
                        </form>

                        <div class="table-shell">
                            <div class="table-responsive">
                                <table class="table table-modern align-middle">
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

            <div class="management-card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Skill catalog management</h2>
                        <p class="card-copy">Danh sách skill catalog chuẩn của hệ thống để technician được gán từ đây.</p>
                    </div>
                    <span class="badge-soft badge-soft-success">${fn:length(skillCatalog)} skills</span>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3 mb-4 align-items-end">
                        <input type="hidden" name="action" value="save_catalog">
                        <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                        <div class="col-md-3">
                            <label class="form-label">Skill code</label>
                            <input type="text" class="form-control" name="catalogCode" placeholder="FIELD_INSPECTION" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label">Skill name</label>
                            <input type="text" class="form-control" name="catalogName" placeholder="Khảo sát hiện trường" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label d-block">Active</label>
                            <div class="form-check form-switch m-0 pt-2">
                                <input class="form-check-input" type="checkbox" role="switch" name="catalogActive" id="catalogActive" value="1" checked>
                                <label class="form-check-label ms-2" for="catalogActive">Kích hoạt</label>
                            </div>
                        </div>
                        <div class="col-md-2 text-md-end">
                            <button type="submit" class="btn btn-outline-success btn-round w-100">
                                <i class="fa fa-save me-2"></i>Lưu
                            </button>
                        </div>
                    </form>

                    <div class="table-shell">
                        <div class="table-responsive">
                            <table class="table table-modern align-middle">
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
                                            <td><span class="code-text">${item.code}</span></td>
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
</div>
