<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <title>Quản lý năng lực kỹ thuật viên</title>

                <style>
                    :root {
                        --cap-page-bg: #f5f7fb;
                        --cap-card-bg: #ffffff;
                        --cap-border: #e2e8f0;
                        --cap-text: #0f172a;
                        --cap-muted: #64748b;
                        --cap-primary-soft: #dbeafe;
                        --cap-success-soft: #dcfce7;
                        --cap-warning-soft: #fef3c7;
                        --cap-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
                    }

                    body {
                        background: var(--cap-page-bg);
                    }

                    .capability-shell {
                        max-width: 1320px;
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
                        max-width: 860px;
                    }

                    .btn-round {
                        border-radius: 14px;
                        font-weight: 700;
                        padding: 10px 16px;
                    }

                    .accordion-shell {
                        display: grid;
                        gap: 18px;
                    }

                    .section-card,
                    .inner-card,
                    .selected-box,
                    .field-card {
                        background: var(--cap-card-bg);
                        border: 1px solid var(--cap-border);
                        border-radius: 22px;
                        box-shadow: var(--cap-shadow);
                    }

                    .accordion-button {
                        background: #fff;
                        color: var(--cap-text);
                        box-shadow: none !important;
                        padding: 20px 22px;
                        border-radius: 22px !important;
                    }

                    .accordion-button:not(.collapsed) {
                        background: #fff;
                        color: var(--cap-text);
                    }

                    .section-head,
                    .inner-card-header,
                    .tech-item-top {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        gap: 12px;
                    }

                    .section-title,
                    .inner-title {
                        margin: 0;
                        font-size: 1.1rem;
                        font-weight: 800;
                        color: #1e293b;
                    }

                    .section-copy,
                    .inner-copy,
                    .sub-text {
                        margin: 6px 0 0;
                        color: var(--cap-muted);
                        line-height: 1.6;
                        font-size: 0.94rem;
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

                    .badge-soft-primary {
                        background: var(--cap-primary-soft);
                        color: #1d4ed8;
                    }

                    .badge-soft-success {
                        background: var(--cap-success-soft);
                        color: #15803d;
                    }

                    .badge-soft-warning {
                        background: var(--cap-warning-soft);
                        color: #b45309;
                    }

                    .badge-soft-muted {
                        background: #e2e8f0;
                        color: #475569;
                    }

                    .section-body {
                        padding: 0 22px 22px;
                        display: grid;
                        gap: 18px;
                    }

                    .management-grid {
                        display: grid;
                        grid-template-columns: 340px minmax(0, 1fr);
                        gap: 18px;
                        align-items: start;
                    }

                    .inner-card-header,
                    .inner-card-body {
                        padding: 18px;
                    }

                    .inner-card-header {
                        border-bottom: 1px solid var(--cap-border);
                    }

                    .technician-list {
                        display: grid;
                        gap: 10px;
                        max-height: 740px;
                        overflow: auto;
                    }

                    .tech-item {
                        display: block;
                        padding: 14px 16px;
                        border: 1px solid var(--cap-border);
                        border-radius: 16px;
                        text-decoration: none;
                        color: inherit;
                        background: #fff;
                        transition: all 0.18s ease;
                    }

                    .tech-item:hover {
                        color: inherit;
                        border-color: #93c5fd;
                        box-shadow: 0 8px 20px rgba(37, 99, 235, 0.1);
                    }

                    .tech-item.active {
                        background: #eff6ff;
                        border-color: #60a5fa;
                    }

                    .tech-name {
                        margin: 0;
                        font-size: 0.98rem;
                        font-weight: 700;
                    }

                    .tech-meta {
                        margin-top: 6px;
                        color: var(--cap-muted);
                        font-size: 0.88rem;
                        line-height: 1.55;
                    }

                    .selected-grid,
                    .dual-grid,
                    .field-grid {
                        display: grid;
                        gap: 16px;
                    }

                    .selected-grid {
                        grid-template-columns: repeat(3, minmax(0, 1fr));
                    }

                    .dual-grid {
                        grid-template-columns: repeat(2, minmax(0, 1fr));
                    }

                    .field-grid {
                        grid-template-columns: repeat(4, minmax(0, 1fr));
                    }

                    .selected-box,
                    .field-card {
                        padding: 16px;
                        background: #f8fafc;
                    }

                    .selected-label {
                        display: block;
                        color: var(--cap-muted);
                        font-size: 0.8rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.04em;
                    }

                    .selected-value {
                        display: block;
                        margin-top: 8px;
                        font-size: 1.3rem;
                        font-weight: 800;
                    }

                    .field-title,
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
                        border: 1px solid var(--cap-border);
                        border-radius: 18px;
                        padding: 16px 18px;
                        background: #f8fafc;
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

                    .empty-state {
                        text-align: center;
                        color: var(--cap-muted);
                        padding: 28px 16px;
                        font-weight: 600;
                    }

                    @media (max-width: 1199.98px) {

                        .management-grid,
                        .selected-grid,
                        .dual-grid,
                        .field-grid {
                            grid-template-columns: 1fr;
                        }
                    }

                    @media (max-width: 767.98px) {

                        .page-head,
                        .section-head,
                        .inner-card-header,
                        .tech-item-top,
                        .switch-row {
                            flex-direction: column;
                            align-items: flex-start;
                        }

                        .section-body,
                        .accordion-button,
                        .inner-card-header,
                        .inner-card-body {
                            padding-left: 16px;
                            padding-right: 16px;
                        }
                    }
                </style>

                <c:set var="isCatalogSection" value="${param.section == 'catalog'}" />
                <c:set var="isTechnicianSection" value="${empty param.section || param.section == 'technicians'}" />

                <div class="container-fluid py-4 capability-shell">
                    <div class="page-head">
                        <div>
                            <h1 class="page-title">Quản lý năng lực kỹ thuật viên</h1>
                            <p class="page-copy">
                                <c:choose>
                                    <c:when test="${isCatalogSection}">
                                        Bạn đang ở tab <strong>Quản lý danh sách kỹ năng</strong>. Tab này chỉ hiển thị
                                        dữ liệu danh mục kỹ năng và không trộn với phần quản lý kỹ thuật viên.
                                    </c:when>
                                    <c:otherwise>
                                        Bạn đang ở tab <strong>Quản lý danh sách kỹ thuật viên</strong>. Tab này chỉ
                                        hiển thị dữ liệu kỹ thuật viên, hồ sơ điều phối, kỹ năng được gán và khoảng bận.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/manager/home"
                            class="btn btn-light border btn-round text-primary"><i
                                class="fa fa-arrow-left me-2"></i>Quay lại dashboard</a>
                    </div>

                    <c:if test="${not empty messageKey}">
                        <div class="alert ${fn:contains(messageKey, 'error') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show rounded-4 border-0 shadow-sm mb-4"
                            role="alert">
                            <strong>Kết quả:</strong> ${messageKey}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${isTechnicianSection}">
                            <div class="section-card p-3 p-lg-4">
                                <div class="section-head mb-3">
                                    <div>
                                        <h2 class="section-title">Quản lý danh sách kỹ thuật viên</h2>
                                    </div>
                                    <span class="badge-soft badge-soft-primary">${fn:length(technicians)} kỹ thuật
                                        viên</span>
                                </div>

                                <div class="management-grid">
                                    <div class="inner-card">
                                        <div class="inner-card-header">
                                            <div>
                                                <h3 class="inner-title">Danh sách kỹ thuật viên</h3>
                                            </div>
                                        </div>
                                        <div class="inner-card-body">
                                            <div class="technician-list">
                                                <c:forEach items="${technicians}" var="tech">
                                                    <a class="tech-item ${selectedTechnicianId == tech.id ? 'active' : ''}"
                                                        href="${pageContext.request.contextPath}/manager/technician-capability?section=technicians&technicianId=${tech.id}">
                                                        <div class="tech-item-top">
                                                            <div>
                                                                <h4 class="tech-name">${tech.fullName}</h4>
                                                                <div class="tech-meta">Mã #${tech.id} • ${tech.email}
                                                                </div>
                                                            </div>
                                                            <span
                                                                class="badge-soft ${tech.status == 1 ? 'badge-soft-success' : 'badge-soft-muted'}">${tech.status
                                                                == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}</span>
                                                        </div>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-3">
                                        <c:choose>
                                            <c:when test="${not empty selectedTechnician}">
                                                <div class="inner-card">
                                                    <div class="inner-card-header">
                                                        <div>
                                                            <h3 class="inner-title">Kỹ thuật viên đang chọn</h3>
                                                        </div>
                                                    </div>
                                                    <div class="inner-card-body">
                                                        <div class="selected-grid">
                                                            <div class="selected-box">
                                                                <span class="selected-label">Kỹ thuật viên</span>
                                                                <span
                                                                    class="selected-value">${selectedTechnician.fullName}</span>
                                                                <div class="sub-text">Mã #${selectedTechnician.id} •
                                                                    ${selectedTechnician.email}</div>
                                                            </div>
                                                            <div class="selected-box">
                                                                <span class="selected-label">Kỹ năng đã gán</span>
                                                                <span
                                                                    class="selected-value">${fn:length(assignedSkills)}</span>
                                                            </div>
                                                            <div class="selected-box">
                                                                <span class="selected-label">Khoảng bận</span>
                                                                <span
                                                                    class="selected-value">${fn:length(unavailabilityList)}</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="inner-card">
                                                    <div class="inner-card-header">
                                                        <div>
                                                            <h3 class="inner-title">Hồ sơ điều phối</h3>
                                                        </div>
                                                    </div>
                                                    <div class="inner-card-body">
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/manager/technician-capability"
                                                            class="row g-3">
                                                            <input type="hidden" name="action" value="save_profile">
                                                            <input type="hidden" name="technicianId"
                                                                value="${selectedTechnicianId}">
                                                            <input type="hidden" name="section" value="technicians">
                                                            <div class="col-12">
                                                                <div class="field-grid">
                                                                    <div class="field-card"><label
                                                                            class="form-label">Bắt đầu làm
                                                                            việc</label><input type="time"
                                                                            class="form-control"
                                                                            name="workingHoursStart"
                                                                            value="${workingHoursStartValue}" required>
                                                                    </div>
                                                                    <div class="field-card"><label
                                                                            class="form-label">Kết thúc làm
                                                                            việc</label><input type="time"
                                                                            class="form-control" name="workingHoursEnd"
                                                                            value="${workingHoursEndValue}" required>
                                                                    </div>
                                                                    <div class="field-card"><label
                                                                            class="form-label">Tối đa
                                                                            việc/ngày</label><input type="number"
                                                                            class="form-control" min="1"
                                                                            name="maxTasksPerDay"
                                                                            value="${profile.maxTasksPerDay}"></div>
                                                                    <div class="field-card"><label
                                                                            class="form-label">Múi giờ</label><input
                                                                            type="text" class="form-control"
                                                                            name="timezoneName"
                                                                            value="${profile.timezoneName}"
                                                                            placeholder="Asia/Ho_Chi_Minh"></div>
                                                                </div>
                                                            </div>
                                                            <div class="col-12">
                                                                <div class="switch-row">
                                                                    <div>
                                                                        <div class="field-title">Trạng thái hồ sơ</div>
                                                                        <div class="sub-text">Bật nếu kỹ thuật viên sẵn
                                                                            sàng tham gia đề xuất phân công.</div>
                                                                    </div>
                                                                    <div class="form-check form-switch m-0"><input
                                                                            class="form-check-input" type="checkbox"
                                                                            role="switch" name="activeStatus"
                                                                            id="activeStatus" value="1"
                                                                            ${profile.activeStatus ? 'checked' : ''
                                                                            }><label
                                                                            class="form-check-label ms-2 fw-semibold"
                                                                            for="activeStatus">Đang hoạt động</label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-12 text-end"><button type="submit"
                                                                    class="btn btn-primary btn-round px-4"><i
                                                                        class="fa fa-save me-2"></i>Lưu hồ sơ</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>

                                                <div class="dual-grid">
                                                    <div class="inner-card">
                                                        <div class="inner-card-header">
                                                            <div>
                                                                <h3 class="inner-title">Kỹ năng của kỹ thuật viên</h3>
                                                            </div><span
                                                                class="badge-soft badge-soft-primary">${fn:length(assignedSkills)}
                                                                mục</span>
                                                        </div>
                                                        <div class="inner-card-body">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/manager/technician-capability"
                                                                class="row g-3 mb-4">
                                                                <input type="hidden" name="action" value="assign_skill">
                                                                <input type="hidden" name="technicianId"
                                                                    value="${selectedTechnicianId}">
                                                                <input type="hidden" name="section" value="technicians">
                                                                <div class="col-md-7"><label class="form-label">Chọn kỹ
                                                                        năng</label><select class="form-select"
                                                                        name="skillCode" required>
                                                                        <option value="">-- Chọn kỹ năng --</option>
                                                                        <c:forEach items="${skillCatalog}" var="skill">
                                                                            <c:if test="${skill.activeStatus}">
                                                                                <option value="${skill.code}">
                                                                                    ${skill.code} - ${skill.name}
                                                                                </option>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </select></div>
                                                                <div class="col-12 text-end"><button type="submit"
                                                                        class="btn btn-outline-primary btn-round"><i
                                                                            class="fa fa-plus me-2"></i>Gán kỹ
                                                                        năng</button></div>
                                                            </form>
                                                            <div class="table-shell">
                                                                <div class="table-responsive">
                                                                    <table class="table table-modern align-middle">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Kỹ năng</th>
                                                                                <th>Trạng thái</th>
                                                                                <th class="text-end">Thao tác</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:forEach items="${assignedSkills}"
                                                                                var="skill">
                                                                                <tr>
                                                                                    <td><span
                                                                                            class="code-text">${skill.skillCode}</span>
                                                                                        <div class="sub-text">
                                                                                            ${skill.skillName}</div>
                                                                                    </td>
                                                                                    <td><span
                                                                                            class="badge-soft ${skill.catalogActive ? 'badge-soft-success' : 'badge-soft-muted'}">${skill.catalogActive
                                                                                            ? 'Đang dùng' : 'Ngừng
                                                                                            dùng'}</span></td>
                                                                                    <td class="text-end">
                                                                                        <form method="post"
                                                                                            action="${pageContext.request.contextPath}/manager/technician-capability"
                                                                                            class="d-inline"><input
                                                                                                type="hidden"
                                                                                                name="action"
                                                                                                value="remove_skill"><input
                                                                                                type="hidden"
                                                                                                name="technicianId"
                                                                                                value="${selectedTechnicianId}"><input
                                                                                                type="hidden"
                                                                                                name="section"
                                                                                                value="technicians"><input
                                                                                                type="hidden"
                                                                                                name="skillCode"
                                                                                                value="${skill.skillCode}"><button
                                                                                                type="submit"
                                                                                                class="btn btn-sm btn-outline-danger btn-round"><i
                                                                                                    class="fa fa-trash me-1"></i>Xoá</button>
                                                                                        </form>
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                            <c:if test="${empty assignedSkills}">
                                                                                <tr>
                                                                                    <td colspan="4" class="empty-state">
                                                                                        Kỹ thuật viên này chưa có kỹ
                                                                                        năng nào được gán.</td>
                                                                                </tr>
                                                                            </c:if>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="inner-card">
                                                        <div class="inner-card-header">
                                                            <div>
                                                                <h3 class="inner-title">Khoảng thời gian không nhận việc
                                                                </h3>
                                                            </div><span
                                                                class="badge-soft badge-soft-warning">${fn:length(unavailabilityList)}
                                                                mục</span>
                                                        </div>
                                                        <div class="inner-card-body">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/manager/technician-capability"
                                                                class="row g-3 mb-4">
                                                                <input type="hidden" name="action"
                                                                    value="add_unavailability">
                                                                <input type="hidden" name="technicianId"
                                                                    value="${selectedTechnicianId}">
                                                                <input type="hidden" name="section" value="technicians">
                                                                <div class="col-md-6"><label class="form-label">Bắt đầu
                                                                        bận</label><input type="datetime-local"
                                                                        class="form-control" name="unavailableStart"
                                                                        required></div>
                                                                <div class="col-md-6"><label class="form-label">Kết thúc
                                                                        bận</label><input type="datetime-local"
                                                                        class="form-control" name="unavailableEnd"
                                                                        required></div>
                                                                <div class="col-12 text-end"><button type="submit"
                                                                        class="btn btn-outline-warning btn-round"><i
                                                                            class="fa fa-calendar-plus me-2"></i>Thêm
                                                                        khoảng bận</button></div>
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
                                                                            <c:forEach items="${unavailabilityList}"
                                                                                var="item">
                                                                                <tr>
                                                                                    <td>
                                                                                        <fmt:formatDate
                                                                                            value="${item.unavailableStart}"
                                                                                            pattern="dd/MM/yyyy HH:mm" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <fmt:formatDate
                                                                                            value="${item.unavailableEnd}"
                                                                                            pattern="dd/MM/yyyy HH:mm" />
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                            <c:if test="${empty unavailabilityList}">
                                                                                <tr>
                                                                                    <td colspan="2" class="empty-state">
                                                                                        Chưa có khoảng bận nào.</td>
                                                                                </tr>
                                                                            </c:if>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="inner-card">
                                                    <div class="inner-card-body">
                                                        <div class="empty-state">Hãy chọn một kỹ thuật viên trong danh
                                                            sách bên trái để bắt đầu quản lý.</div>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="section-card p-3 p-lg-4">
                                <div class="section-head mb-3">
                                    <div>
                                        <h2 class="section-title">Quản lý danh sách kỹ năng</h2>
                                    </div>
                                    <span class="badge-soft badge-soft-success">${fn:length(skillCatalog)} kỹ
                                        năng</span>
                                </div>

                                <div class="inner-card">
                                    <div class="inner-card-header">
                                        <div>
                                            <h3 class="inner-title">Danh mục kỹ năng</h3>
                                        </div>
                                    </div>
                                    <div class="inner-card-body">
                                        <form method="post"
                                            action="${pageContext.request.contextPath}/manager/technician-capability"
                                            class="row g-3 mb-4 align-items-end">
                                            <input type="hidden" name="action" value="save_catalog">
                                            <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                                            <input type="hidden" name="section" value="catalog">
                                            <input type="hidden" name="catalogPage" value="${catalogPage}">
                                            <div class="col-md-3"><label class="form-label">Mã kỹ năng</label><input
                                                    type="text" class="form-control" name="catalogCode"
                                                    id="catalogCodeInput" placeholder="FIELD_INSPECTION" required></div>
                                            <div class="col-md-5"><label class="form-label">Tên kỹ năng</label><input
                                                    type="text" class="form-control" name="catalogName"
                                                    id="catalogNameInput" placeholder="Khảo sát hiện trường" required>
                                            </div>
                                            <div class="col-md-2"><label class="form-label d-block">Trạng thái</label>
                                                <div class="form-check form-switch m-0 pt-2"><input
                                                        class="form-check-input" type="checkbox" role="switch"
                                                        name="catalogActive" id="catalogActive" value="1" checked><label
                                                        class="form-check-label ms-2" for="catalogActive">Kích
                                                        hoạt</label></div>
                                            </div>
                                            <div class="col-md-2 text-md-end"><button type="submit"
                                                    class="btn btn-outline-success btn-round w-100"
                                                    id="catalogSubmitButton"><i class="fa fa-save me-2"></i>Lưu</button>
                                            </div>
                                            <div class="col-12 text-end d-none" id="catalogCancelWrap">
                                                <button type="button" class="btn btn-sm btn-outline-secondary btn-round"
                                                    id="catalogCancelEdit"><i class="fa fa-times me-1"></i>Huỷ chỉnh
                                                    sửa</button>
                                            </div>
                                        </form>
                                        <div class="table-shell">
                                            <div class="table-responsive">
                                                <table class="table table-modern align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th>Mã</th>
                                                            <th>Tên kỹ năng</th>
                                                            <th>Trạng thái</th>
                                                            <th class="text-end">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${skillCatalogPageItems}" var="item">
                                                            <tr>
                                                                <td><span class="code-text">${item.code}</span></td>
                                                                <td>${item.name}</td>
                                                                <td><span
                                                                        class="badge-soft ${item.activeStatus ? 'badge-soft-success' : 'badge-soft-muted'}">${item.activeStatus
                                                                        ? 'Hoạt động' : 'Ngừng hoạt động'}</span></td>
                                                                <td class="text-end"><button type="button"
                                                                        class="btn btn-sm btn-outline-primary btn-round js-edit-catalog"
                                                                        data-code="${item.code}"
                                                                        data-name="${fn:escapeXml(item.name)}"
                                                                        data-active="${item.activeStatus}"><i
                                                                            class="fa fa-pen me-1"></i>Sửa</button>
                                                                    <form method="post"
                                                                        action="${pageContext.request.contextPath}/manager/technician-capability"
                                                                        class="d-inline ms-1"><input type="hidden"
                                                                            name="action" value="delete_catalog"><input
                                                                            type="hidden" name="technicianId"
                                                                            value="${selectedTechnicianId}"><input
                                                                            type="hidden" name="section"
                                                                            value="catalog"><input type="hidden"
                                                                            name="catalogPage"
                                                                            value="${catalogPage}"><input type="hidden"
                                                                            name="catalogCode"
                                                                            value="${item.code}"><button type="submit"
                                                                            class="btn btn-sm btn-outline-danger btn-round"
                                                                            onclick="return confirm('Xoá kỹ năng ${item.code}? Nếu kỹ năng đã được gán, hệ thống sẽ chuyển về trạng thái ngừng hoạt động.');"><i
                                                                                class="fa fa-trash me-1"></i>Xoá</button>
                                                                    </form>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <c:if test="${empty skillCatalogPageItems}">
                                                            <tr>
                                                                <td colspan="4" class="empty-state">Danh mục kỹ năng
                                                                    đang trống.</td>
                                                            </tr>
                                                        </c:if>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        <c:if test="${catalogTotalPages > 1}">
                                            <nav class="mt-3" aria-label="Phân trang kỹ năng">
                                                <ul class="pagination pagination-sm justify-content-end mb-0">
                                                    <c:forEach begin="1" end="${catalogTotalPages}" var="pageNo">
                                                        <li class="page-item ${pageNo == catalogPage ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="<c:url value='/manager/technician-capability'><c:param name='section' value='catalog'/><c:param name='technicianId' value='${selectedTechnicianId}'/><c:param name='catalogPage' value='${pageNo}'/></c:url>">${pageNo}</a>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </nav>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <script>
                    (function () {
                        const codeInput = document.getElementById('catalogCodeInput');
                        const nameInput = document.getElementById('catalogNameInput');
                        const activeInput = document.getElementById('catalogActive');
                        const submitButton = document.getElementById('catalogSubmitButton');
                        const cancelWrap = document.getElementById('catalogCancelWrap');
                        const cancelButton = document.getElementById('catalogCancelEdit');
                        if (!codeInput || !nameInput || !activeInput || !submitButton) {
                            return;
                        }

                        function resetForm() {
                            codeInput.removeAttribute('readonly');
                            codeInput.value = '';
                            nameInput.value = '';
                            activeInput.checked = true;
                            submitButton.innerHTML = '<i class="fa fa-save me-2"></i>Lưu';
                            if (cancelWrap) {
                                cancelWrap.classList.add('d-none');
                            }
                        }

                        document.querySelectorAll('.js-edit-catalog').forEach(function (button) {
                            button.addEventListener('click', function () {
                                codeInput.value = button.dataset.code || '';
                                codeInput.setAttribute('readonly', 'readonly');
                                nameInput.value = button.dataset.name || '';
                                activeInput.checked = (button.dataset.active || '').toLowerCase() === 'true';
                                submitButton.innerHTML = '<i class="fa fa-save me-2"></i>Cập nhật';
                                if (cancelWrap) {
                                    cancelWrap.classList.remove('d-none');
                                }
                            });
                        });

                        if (cancelButton) {
                            cancelButton.addEventListener('click', resetForm);
                        }
                    })();
                </script>