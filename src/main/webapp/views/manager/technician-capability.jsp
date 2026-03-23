<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Technician Capability Management</title>

<style>
    :root {
        --cap-bg: linear-gradient(180deg, #f3f7ff 0%, #f8fafc 45%, #eef4ff 100%);
        --cap-border: rgba(148, 163, 184, 0.22);
        --cap-text: #0f172a;
        --cap-muted: #64748b;
        --cap-primary: #2563eb;
        --cap-primary-dark: #1d4ed8;
        --cap-primary-soft: #dbeafe;
        --cap-success-soft: #dcfce7;
        --cap-warning-soft: #fef3c7;
        --cap-danger-soft: #fee2e2;
        --cap-surface: rgba(255, 255, 255, 0.88);
        --cap-shadow: 0 24px 60px rgba(15, 23, 42, 0.12);
    }

    body {
        background: var(--cap-bg);
    }

    .capability-shell {
        max-width: 1480px;
        margin: 0 auto;
        color: var(--cap-text);
    }

    .hero-card {
        position: relative;
        border: 0;
        border-radius: 32px;
        overflow: hidden;
        color: #fff;
        background:
            radial-gradient(circle at top right, rgba(125, 211, 252, 0.35), transparent 26%),
            radial-gradient(circle at left bottom, rgba(59, 130, 246, 0.32), transparent 28%),
            linear-gradient(135deg, #020617 0%, #0f172a 24%, #1d4ed8 62%, #38bdf8 100%);
        box-shadow: 0 30px 70px rgba(15, 23, 42, 0.24);
    }

    .hero-card::after {
        content: "";
        position: absolute;
        inset: auto -120px -120px auto;
        width: 320px;
        height: 320px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.08);
        filter: blur(10px);
    }

    .hero-grid {
        position: relative;
        z-index: 1;
        display: grid;
        grid-template-columns: minmax(0, 1.3fr) minmax(320px, 0.9fr);
        gap: 28px;
        align-items: stretch;
    }

    .hero-chip,
    .metric-badge,
    .badge-soft,
    .status-dot {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border-radius: 999px;
        font-weight: 700;
    }

    .hero-chip {
        padding: 10px 16px;
        background: rgba(255, 255, 255, 0.14);
        border: 1px solid rgba(255, 255, 255, 0.16);
        font-size: 0.9rem;
    }

    .hero-title {
        font-size: clamp(2rem, 3vw, 3rem);
        font-weight: 800;
        line-height: 1.08;
        margin-bottom: 14px;
    }

    .hero-subtitle {
        max-width: 760px;
        color: rgba(255, 255, 255, 0.82);
        font-size: 1rem;
        line-height: 1.7;
        margin-bottom: 0;
    }

    .hero-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 28px;
    }

    .action-btn {
        border-radius: 16px;
        padding: 11px 18px;
        font-weight: 700;
        box-shadow: none;
    }

    .hero-overview {
        display: grid;
        gap: 16px;
    }

    .overview-card {
        border-radius: 24px;
        padding: 20px;
        background: rgba(255, 255, 255, 0.12);
        border: 1px solid rgba(255, 255, 255, 0.14);
        backdrop-filter: blur(10px);
    }

    .overview-card h6,
    .overview-card p {
        margin: 0;
    }

    .overview-card h6 {
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(255, 255, 255, 0.72);
    }

    .overview-card strong {
        display: block;
        margin-top: 8px;
        font-size: 1.75rem;
        line-height: 1;
    }

    .overview-card p {
        margin-top: 10px;
        color: rgba(255, 255, 255, 0.76);
        line-height: 1.55;
    }

    .glass-card,
    .section-card,
    .mini-panel {
        border: 1px solid var(--cap-border);
        border-radius: 28px;
        background: var(--cap-surface);
        backdrop-filter: blur(14px);
        box-shadow: var(--cap-shadow);
    }

    .section-card {
        overflow: hidden;
    }

    .section-card .card-header,
    .glass-card .card-header {
        padding: 1.4rem 1.5rem 1.1rem;
        background: linear-gradient(180deg, rgba(255,255,255,0.96) 0%, rgba(248,250,252,0.92) 100%);
        border-bottom: 1px solid rgba(226, 232, 240, 0.92);
    }

    .section-card .card-body,
    .glass-card .card-body {
        padding: 1.5rem;
    }

    .panel-title {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 1.35rem;
        font-weight: 800;
        margin: 0;
        color: #334155;
    }

    .panel-title i {
        width: 42px;
        height: 42px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 14px;
        background: linear-gradient(135deg, #eff6ff, #dbeafe);
        color: var(--cap-primary-dark);
    }

    .section-hint {
        margin-top: 10px;
        color: var(--cap-muted);
        line-height: 1.65;
        font-size: 0.96rem;
    }

    .tech-sidebar {
        padding: 18px;
    }

    .tech-sidebar-top {
        display: flex;
        justify-content: space-between;
        gap: 16px;
        align-items: flex-start;
        margin-bottom: 18px;
    }

    .tech-sidebar-title {
        margin: 0;
        font-size: 1.4rem;
        font-weight: 800;
        color: #334155;
    }

    .tech-sidebar-copy {
        margin-top: 6px;
        color: var(--cap-muted);
        line-height: 1.6;
    }

    .metric-badge,
    .badge-soft {
        padding: 8px 14px;
        font-size: 0.82rem;
    }

    .metric-badge {
        color: var(--cap-primary-dark);
        background: var(--cap-primary-soft);
    }

    .badge-soft-primary { background: var(--cap-primary-soft); color: var(--cap-primary-dark); }
    .badge-soft-success { background: var(--cap-success-soft); color: #15803d; }
    .badge-soft-warning { background: var(--cap-warning-soft); color: #b45309; }
    .badge-soft-muted { background: #e2e8f0; color: #475569; }
    .badge-soft-danger { background: var(--cap-danger-soft); color: #b91c1c; }

    .technician-list {
        display: grid;
        gap: 14px;
        max-height: 1040px;
        overflow: auto;
        padding-right: 4px;
    }

    .tech-list-item {
        display: block;
        border-radius: 24px;
        padding: 18px;
        text-decoration: none;
        color: inherit;
        background: linear-gradient(180deg, rgba(255,255,255,0.94) 0%, rgba(248,250,252,0.92) 100%);
        border: 1px solid rgba(226, 232, 240, 0.95);
        box-shadow: 0 12px 24px rgba(148, 163, 184, 0.12);
        transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
    }

    .tech-list-item:hover {
        transform: translateY(-2px);
        color: inherit;
        box-shadow: 0 18px 32px rgba(37, 99, 235, 0.14);
        border-color: rgba(96, 165, 250, 0.5);
    }

    .tech-list-item.active {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 45%, #e0f2fe 100%);
        border-color: rgba(37, 99, 235, 0.45);
        box-shadow: 0 20px 34px rgba(37, 99, 235, 0.18);
    }

    .tech-avatar {
        width: 52px;
        height: 52px;
        border-radius: 18px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #dbeafe, #bfdbfe);
        color: var(--cap-primary-dark);
        font-size: 1.15rem;
        flex-shrink: 0;
    }

    .tech-name {
        font-size: 1.08rem;
        font-weight: 800;
        color: #0f172a;
    }

    .tech-meta,
    .mini-copy {
        color: var(--cap-muted);
        line-height: 1.6;
    }

    .status-dot {
        padding: 7px 12px;
        font-size: 0.78rem;
    }

    .sticky-side {
        position: sticky;
        top: 18px;
    }

    .selected-tech-card {
        padding: 24px 26px;
        background:
            radial-gradient(circle at top right, rgba(147, 197, 253, 0.2), transparent 30%),
            linear-gradient(135deg, rgba(255,255,255,0.96) 0%, rgba(239,246,255,0.92) 100%);
    }

    .selected-tech-grid {
        display: grid;
        grid-template-columns: minmax(0, 1.2fr) minmax(260px, 0.8fr);
        gap: 18px;
        align-items: center;
    }

    .selected-tech-main {
        display: flex;
        gap: 18px;
        align-items: center;
    }

    .selected-tech-avatar {
        width: 72px;
        height: 72px;
        border-radius: 24px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #1d4ed8, #60a5fa);
        color: #fff;
        font-size: 1.4rem;
        box-shadow: 0 16px 32px rgba(37, 99, 235, 0.22);
        flex-shrink: 0;
    }

    .eyebrow {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 7px 12px;
        border-radius: 999px;
        background: rgba(37, 99, 235, 0.12);
        color: var(--cap-primary-dark);
        font-size: 0.8rem;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        margin-bottom: 12px;
    }

    .selected-tech-name {
        margin: 0;
        font-size: clamp(1.6rem, 2vw, 2.2rem);
        font-weight: 800;
    }

    .meta-row {
        display: flex;
        flex-wrap: wrap;
        gap: 10px 16px;
        margin-top: 8px;
        color: var(--cap-muted);
    }

    .metrics-stack {
        display: grid;
        gap: 12px;
    }

    .mini-panel {
        padding: 16px 18px;
    }

    .mini-label {
        font-size: 0.78rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        font-weight: 800;
        color: var(--cap-muted);
    }

    .mini-value {
        display: block;
        margin-top: 8px;
        font-size: 1.4rem;
        font-weight: 800;
        color: var(--cap-text);
    }

    .content-grid {
        display: grid;
        grid-template-columns: minmax(0, 1.3fr) minmax(320px, 0.7fr);
        gap: 24px;
    }

    .profile-spotlight {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 14px;
        margin-bottom: 22px;
    }

    .spotlight-card {
        border-radius: 20px;
        padding: 16px 18px;
        background: linear-gradient(180deg, #f8fbff 0%, #eef4ff 100%);
        border: 1px solid rgba(191, 219, 254, 0.82);
    }

    .spotlight-card strong {
        display: block;
        font-size: 1.1rem;
        margin-top: 6px;
    }

    .profile-form-shell {
        border-radius: 24px;
        padding: 20px;
        background: linear-gradient(180deg, rgba(248,250,252,0.96) 0%, rgba(255,255,255,0.98) 100%);
        border: 1px solid rgba(226, 232, 240, 0.9);
    }

    .helper-grid {
        display: grid;
        gap: 14px;
    }

    .helper-card {
        border-radius: 22px;
        padding: 18px;
        border: 1px solid rgba(226, 232, 240, 0.92);
        background: linear-gradient(180deg, rgba(255,255,255,0.96) 0%, rgba(248,250,252,0.96) 100%);
    }

    .helper-card i {
        width: 42px;
        height: 42px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 14px;
        margin-bottom: 14px;
        background: #eff6ff;
        color: var(--cap-primary-dark);
    }

    .helper-card h6 {
        margin: 0 0 8px;
        font-size: 1rem;
        font-weight: 800;
        color: #1e293b;
    }

    .helper-card p,
    .helper-card ul {
        margin: 0;
        color: var(--cap-muted);
        line-height: 1.7;
    }

    .helper-card ul {
        padding-left: 18px;
    }

    .form-label {
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 8px;
    }

    .form-control,
    .form-select {
        min-height: 52px;
        border-radius: 16px;
        border: 1px solid rgba(148, 163, 184, 0.42);
        background: rgba(255, 255, 255, 0.98);
        padding-inline: 15px;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: rgba(59, 130, 246, 0.72);
        box-shadow: 0 0 0 0.22rem rgba(59, 130, 246, 0.14);
    }

    .switch-card {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
        padding: 16px 18px;
        border-radius: 18px;
        background: #eff6ff;
        border: 1px solid rgba(191, 219, 254, 0.95);
    }

    .switch-card .form-check {
        margin: 0;
    }

    .form-check-input {
        width: 2.8rem;
        height: 1.55rem;
        cursor: pointer;
    }

    .stack-card {
        height: 100%;
    }

    .form-section {
        padding: 18px;
        border-radius: 22px;
        background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
        border: 1px solid rgba(226, 232, 240, 0.92);
        margin-bottom: 18px;
    }

    .form-section:last-child {
        margin-bottom: 0;
    }

    .form-section-title {
        display: flex;
        justify-content: space-between;
        gap: 14px;
        align-items: flex-start;
        margin-bottom: 16px;
    }

    .table-wrap {
        border-radius: 22px;
        border: 1px solid rgba(226, 232, 240, 0.92);
        overflow: hidden;
        background: #fff;
    }

    .table-modern {
        margin-bottom: 0;
    }

    .table-modern thead th {
        border-bottom: 1px solid #e2e8f0;
        background: #f8fafc;
        color: #334155;
        font-weight: 800;
        white-space: nowrap;
        padding: 15px 16px;
    }

    .table-modern tbody td {
        vertical-align: middle;
        border-color: #edf2f7;
        padding: 15px 16px;
    }

    .table-modern tbody tr:hover {
        background: #f8fbff;
    }

    .table-code {
        font-weight: 800;
        color: #0f172a;
        word-break: break-word;
    }

    .empty-state {
        padding: 30px 16px;
        text-align: center;
        color: var(--cap-muted);
        font-weight: 600;
    }

    .catalog-form {
        padding: 18px;
        border-radius: 22px;
        background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
        border: 1px solid rgba(191, 219, 254, 0.76);
        margin-bottom: 20px;
    }

    .alert-floating {
        border: 0;
        border-radius: 22px;
        box-shadow: 0 20px 40px rgba(15, 23, 42, 0.12);
    }

    @media (max-width: 1199.98px) {
        .hero-grid,
        .content-grid,
        .selected-tech-grid {
            grid-template-columns: 1fr;
        }

        .sticky-side {
            position: static;
        }

        .profile-spotlight {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }
    }

    @media (max-width: 767.98px) {
        .capability-shell {
            padding-inline: 6px;
        }

        .hero-card,
        .glass-card,
        .section-card,
        .mini-panel {
            border-radius: 22px;
        }

        .hero-actions,
        .tech-sidebar-top,
        .selected-tech-main,
        .form-section-title,
        .switch-card {
            flex-direction: column;
            align-items: flex-start;
        }

        .profile-spotlight {
            grid-template-columns: 1fr;
        }

        .section-card .card-header,
        .glass-card .card-header,
        .section-card .card-body,
        .glass-card .card-body,
        .tech-sidebar,
        .selected-tech-card {
            padding-left: 1rem;
            padding-right: 1rem;
        }
    }
</style>

<div class="container-fluid py-4 capability-shell">
    <div class="card hero-card mb-4">
        <div class="card-body p-4 p-xl-5">
            <div class="hero-grid">
                <div>
                    <div class="hero-chip mb-3"><i class="fa fa-cogs"></i> Manager workspace • Capability center</div>
                    <h1 class="hero-title">Làm mới màn Technician Capability để nhìn gọn, rõ và dễ thao tác hơn.</h1>
                    <p class="hero-subtitle">Màn hình này được tổ chức lại theo dạng dashboard: chọn technician ở cột trái, xem nhanh trạng thái ở đầu trang, chỉnh profile trong khu vực chính và quản lý skill / unavailable block / catalog theo từng cụm nội dung rõ ràng.</p>
                    <div class="hero-actions">
                        <a href="${pageContext.request.contextPath}/manager/home" class="btn btn-light text-primary action-btn">
                            <i class="fa fa-arrow-left me-2"></i>Quay lại dashboard
                        </a>
                        <span class="hero-chip"><i class="fa fa-check-circle"></i>Dữ liệu sẵn sàng cho recommendation & scheduling</span>
                    </div>
                </div>

                <div class="hero-overview">
                    <div class="overview-card">
                        <h6>Tổng technician</h6>
                        <strong>${fn:length(technicians)}</strong>
                        <p>Danh sách điều phối đang có trong hệ thống để manager chọn và cấu hình năng lực.</p>
                    </div>
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <div class="overview-card h-100">
                                <h6>Assigned skills</h6>
                                <strong>${fn:length(assignedSkills)}</strong>
                                <p>Số skill đang gắn với technician được chọn.</p>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="overview-card h-100">
                                <h6>Unavailable blocks</h6>
                                <strong>${fn:length(unavailabilityList)}</strong>
                                <p>Các khoảng thời gian bận để engine tránh gợi ý sai.</p>
                            </div>
                        </div>
                    </div>
                    <div class="overview-card">
                        <h6>Skill catalog</h6>
                        <strong>${fn:length(skillCatalog)}</strong>
                        <p>Danh mục skill chuẩn dùng làm nguồn duy nhất để gán năng lực cho technician.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty messageKey}">
        <div class="alert ${fn:contains(messageKey, 'error') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show alert-floating mb-4" role="alert">
            <strong>Kết quả:</strong> ${messageKey}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4 align-items-start">
        <div class="col-xl-4 col-xxl-3">
            <div class="glass-card sticky-side">
                <div class="tech-sidebar">
                    <div class="tech-sidebar-top">
                        <div>
                            <h2 class="tech-sidebar-title">Danh sách technician</h2>
                            <p class="tech-sidebar-copy">Chọn một technician để xem nhanh hồ sơ điều phối, skill được gán và các block unavailable.</p>
                        </div>
                        <span class="metric-badge"><i class="fa fa-users"></i>${fn:length(technicians)} users</span>
                    </div>

                    <div class="technician-list">
                        <c:forEach items="${technicians}" var="tech">
                            <a class="tech-list-item ${selectedTechnicianId == tech.id ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/manager/technician-capability?technicianId=${tech.id}">
                                <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="tech-avatar"><i class="fa fa-user"></i></div>
                                        <div>
                                            <div class="tech-name">${tech.fullName}</div>
                                            <div class="tech-meta">#${tech.id} • ${tech.email}</div>
                                        </div>
                                    </div>
                                    <span class="status-dot ${tech.status == 1 ? 'badge-soft-success' : 'badge-soft-muted'}">${tech.status == 1 ? 'Active' : 'Inactive'}</span>
                                </div>
                                <div class="mini-copy">Bấm để chỉnh profile làm việc, kỹ năng và lịch unavailable của technician này.</div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8 col-xxl-9">
            <c:if test="${not empty selectedTechnician}">
                <div class="section-card selected-tech-card mb-4">
                    <div class="selected-tech-grid">
                        <div class="selected-tech-main">
                            <div class="selected-tech-avatar"><i class="fa fa-user"></i></div>
                            <div>
                                <div class="eyebrow"><i class="fa fa-crosshairs"></i>Technician đang chọn</div>
                                <h3 class="selected-tech-name">${selectedTechnician.fullName}</h3>
                                <div class="meta-row">
                                    <span><i class="fa fa-hashtag me-1"></i>${selectedTechnician.id}</span>
                                    <span><i class="fa fa-envelope me-1"></i>${selectedTechnician.email}</span>
                                </div>
                            </div>
                        </div>
                        <div class="metrics-stack">
                            <div class="mini-panel">
                                <span class="mini-label">Skills assigned</span>
                                <span class="mini-value">${fn:length(assignedSkills)}</span>
                                <div class="mini-copy">Theo dõi số skill đang dùng cho recommendation.</div>
                            </div>
                            <div class="mini-panel">
                                <span class="mini-label">Unavailable blocks</span>
                                <span class="mini-value">${fn:length(unavailabilityList)}</span>
                                <div class="mini-copy">Các block này sẽ chặn lịch được đề xuất.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="content-grid mb-4">
                <div class="section-card stack-card">
                    <div class="card-header">
                        <h4 class="panel-title"><i class="fa fa-id-card"></i>Profile điều phối</h4>
                        <div class="section-hint">Cấu hình giờ làm việc, mức tải tối đa trong ngày và timezone theo đúng hành vi điều phối thực tế của technician.</div>
                    </div>
                    <div class="card-body">
                        <div class="profile-spotlight">
                            <div class="spotlight-card">
                                <span class="mini-label">Giờ bắt đầu</span>
                                <strong>${not empty workingHoursStartValue ? workingHoursStartValue : '--:--'}</strong>
                            </div>
                            <div class="spotlight-card">
                                <span class="mini-label">Giờ kết thúc</span>
                                <strong>${not empty workingHoursEndValue ? workingHoursEndValue : '--:--'}</strong>
                            </div>
                            <div class="spotlight-card">
                                <span class="mini-label">Tải tối đa / ngày</span>
                                <strong>${profile.maxTasksPerDay}</strong>
                            </div>
                        </div>

                        <div class="profile-form-shell">
                            <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3">
                                <input type="hidden" name="action" value="save_profile">
                                <input type="hidden" name="technicianId" value="${selectedTechnicianId}">

                                <div class="col-md-4">
                                    <label class="form-label">Start</label>
                                    <input type="time" class="form-control" name="workingHoursStart" value="${workingHoursStartValue}" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">End</label>
                                    <input type="time" class="form-control" name="workingHoursEnd" value="${workingHoursEndValue}" required>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Max task/day</label>
                                    <input type="number" class="form-control" min="1" name="maxTasksPerDay" value="${profile.maxTasksPerDay}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Timezone</label>
                                    <input type="text" class="form-control" name="timezoneName" value="${profile.timezoneName}" placeholder="Asia/Ho_Chi_Minh">
                                </div>
                                <div class="col-12">
                                    <div class="switch-card">
                                        <div>
                                            <div class="fw-bold text-dark mb-1">Kích hoạt profile điều phối</div>
                                            <div class="mini-copy">Bật trạng thái này nếu hồ sơ sẵn sàng tham gia recommendation.</div>
                                        </div>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" role="switch" name="activeStatus" id="activeStatus" value="1" ${profile.activeStatus ? 'checked' : ''}>
                                            <label class="form-check-label fw-semibold ms-2" for="activeStatus">Profile active</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 d-flex justify-content-end">
                                    <button type="submit" class="btn btn-primary action-btn px-4">
                                        <i class="fa fa-save me-2"></i>Lưu profile
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="helper-grid">
                    <div class="helper-card">
                        <i class="fa fa-lightbulb-o"></i>
                        <h6>Cách dùng nhanh</h6>
                        <p>Chọn technician ở cột trái, chỉnh khung giờ làm việc trước, sau đó cập nhật skill và unavailable block để engine có dữ liệu sạch hơn.</p>
                    </div>
                    <div class="helper-card">
                        <i class="fa fa-bolt"></i>
                        <h6>Gợi ý vận hành</h6>
                        <ul>
                            <li>Timezone nên thống nhất theo múi giờ vận hành thực tế.</li>
                            <li>Max task/day nên phản ánh công suất trung bình an toàn.</li>
                            <li>Unavailable block chỉ nhập các khoảng bận thật sự cần chặn lịch.</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="section-card stack-card">
                        <div class="card-header d-flex justify-content-between align-items-start gap-3 flex-wrap">
                            <div>
                                <h4 class="panel-title"><i class="fa fa-shield-halved"></i>Skills của technician</h4>
                                <div class="section-hint">Mỗi dòng đại diện cho một record trong bảng <strong>technician_skills</strong>. Thiết kế mới ưu tiên thao tác gán skill và quét trạng thái nhanh hơn.</div>
                            </div>
                            <span class="badge-soft badge-soft-primary">${fn:length(assignedSkills)} assigned</span>
                        </div>
                        <div class="card-body">
                            <div class="form-section">
                                <div class="form-section-title">
                                    <div>
                                        <div class="fw-bold text-dark">Gán skill mới</div>
                                        <div class="mini-copy">Chỉ hiển thị các skill đang active trong catalog.</div>
                                    </div>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3">
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
                                    <div class="col-12 d-flex justify-content-end">
                                        <button type="submit" class="btn btn-outline-primary action-btn">
                                            <i class="fa fa-plus me-2"></i>Assign skill
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <div class="table-wrap">
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
                                                        <div class="table-code">${skill.skillCode}</div>
                                                        <div class="mini-copy">${skill.skillName}</div>
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
                                                <tr><td colspan="4" class="empty-state">Technician này chưa có skill nào được gán.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="section-card stack-card">
                        <div class="card-header d-flex justify-content-between align-items-start gap-3 flex-wrap">
                            <div>
                                <h4 class="panel-title"><i class="fa fa-calendar-times-o"></i>Unavailable blocks</h4>
                                <div class="section-hint">Dùng để chặn những khoảng thời gian technician không thể nhận việc. Bảng bên dưới bám theo dữ liệu trong <strong>technician_unavailability</strong>.</div>
                            </div>
                            <span class="badge-soft badge-soft-warning">${fn:length(unavailabilityList)} blocks</span>
                        </div>
                        <div class="card-body">
                            <div class="form-section">
                                <div class="form-section-title">
                                    <div>
                                        <div class="fw-bold text-dark">Thêm unavailable block</div>
                                        <div class="mini-copy">Nên nhập theo mốc thời gian chính xác để scheduler tránh xung đột.</div>
                                    </div>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3">
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
                                    <div class="col-12 d-flex justify-content-end">
                                        <button type="submit" class="btn btn-outline-warning action-btn">
                                            <i class="fa fa-calendar-plus me-2"></i>Thêm block
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <div class="table-wrap">
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
            </div>

            <div class="section-card mt-4">
                <div class="card-header d-flex justify-content-between align-items-start gap-3 flex-wrap">
                    <div>
                        <h4 class="panel-title"><i class="fa fa-book"></i>Skill catalog management</h4>
                        <div class="section-hint">Khu vực catalog được chuyển sang dạng panel rõ ràng hơn để dễ phân biệt phần tạo skill mới và bảng danh mục chuẩn của hệ thống.</div>
                    </div>
                    <span class="badge-soft badge-soft-success">${fn:length(skillCatalog)} skills</span>
                </div>
                <div class="card-body">
                    <div class="catalog-form">
                        <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="row g-3 align-items-end">
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
                                <div class="switch-card h-100">
                                    <div>
                                        <div class="fw-bold text-dark">Catalog active</div>
                                        <div class="mini-copy">Cho phép gán skill này.</div>
                                    </div>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" role="switch" name="catalogActive" id="catalogActive" value="1" checked>
                                        <label class="form-check-label visually-hidden" for="catalogActive">Active</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 d-grid">
                                <button type="submit" class="btn btn-outline-success action-btn h-100"><i class="fa fa-save me-2"></i>Lưu</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-wrap">
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
                                            <td class="table-code">${item.code}</td>
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
