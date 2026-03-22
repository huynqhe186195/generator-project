<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Technician Capability Management</title>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-primary mb-1"><i class="fa fa-user-gear me-2"></i>Technician Capability Management</h2>
            <div class="text-muted">Manager quản lý profile điều phối, skill assignment, unavailable blocks và skill catalog.</div>
        </div>
        <a href="${pageContext.request.contextPath}/manager/home" class="btn btn-outline-secondary">
            <i class="fa fa-arrow-left me-2"></i>Quay lại dashboard
        </a>
    </div>

    <c:if test="${not empty messageKey}">
        <div class="alert ${fn:contains(messageKey, 'error') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show" role="alert">
            <strong>Kết quả:</strong> ${messageKey}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom">
                    <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-users me-2"></i>Danh sách technician</h5>
                </div>
                <div class="card-body p-0">
                    <div class="list-group list-group-flush">
                        <c:forEach items="${technicians}" var="tech">
                            <a class="list-group-item list-group-item-action ${selectedTechnicianId == tech.id ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/manager/technician-capability?technicianId=${tech.id}">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="fw-semibold">${tech.fullName}</div>
                                        <div class="small ${selectedTechnicianId == tech.id ? 'text-white-50' : 'text-muted'}">#${tech.id} • ${tech.email}</div>
                                    </div>
                                    <span class="badge ${tech.status == 1 ? 'bg-success' : 'bg-secondary'}">${tech.status == 1 ? 'Active' : 'Inactive'}</span>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <c:if test="${not empty selectedTechnician}">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body bg-primary bg-gradient text-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="small text-uppercase opacity-75">Technician đang chọn</div>
                                <h4 class="mb-1 fw-bold">${selectedTechnician.fullName}</h4>
                                <div class="opacity-75">ID #${selectedTechnician.id} • ${selectedTechnician.email}</div>
                            </div>
                            <span class="badge bg-light text-dark">Capability Config</span>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="row g-4">
                <div class="col-12">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom">
                            <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-id-card me-2"></i>Edit profile</h5>
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
                                    <button type="submit" class="btn btn-primary px-4"><i class="fa fa-save me-2"></i>Lưu profile</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-xl-6">
                    <div class="card shadow-sm border-0 h-100">
                        <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-shield-halved me-2"></i>Assign / remove skills</h5>
                            <span class="badge bg-info text-dark">${fn:length(assignedSkills)} assigned</span>
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
                                    <button type="submit" class="btn btn-outline-primary"><i class="fa fa-plus me-2"></i>Assign skill</button>
                                </div>
                            </form>

                            <div class="table-responsive">
                                <table class="table table-sm align-middle">
                                    <thead class="table-light">
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
                                                    <div class="fw-semibold">${skill.skillCode}</div>
                                                    <div class="small text-muted">${skill.skillName}</div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty skill.expiresAt}">
                                                            <fmt:formatDate value="${skill.expiresAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Không hết hạn</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge ${skill.catalogActive ? 'bg-success' : 'bg-secondary'}">${skill.catalogActive ? 'Catalog active' : 'Catalog inactive'}</span>
                                                </td>
                                                <td class="text-end">
                                                    <form method="post" action="${pageContext.request.contextPath}/manager/technician-capability" class="d-inline">
                                                        <input type="hidden" name="action" value="remove_skill">
                                                        <input type="hidden" name="technicianId" value="${selectedTechnicianId}">
                                                        <input type="hidden" name="skillCode" value="${skill.skillCode}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fa fa-trash me-1"></i>Remove</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty assignedSkills}">
                                            <tr><td colspan="4" class="text-center text-muted py-4">Technician này chưa được gán skill nào.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-6">
                    <div class="card shadow-sm border-0 h-100">
                        <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-calendar-xmark me-2"></i>Add unavailable block</h5>
                            <span class="badge bg-warning text-dark">${fn:length(unavailabilityList)} blocks</span>
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
                                    <button type="submit" class="btn btn-outline-warning"><i class="fa fa-calendar-plus me-2"></i>Thêm block</button>
                                </div>
                            </form>

                            <div class="table-responsive">
                                <table class="table table-sm align-middle">
                                    <thead class="table-light">
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
                                            <tr><td colspan="2" class="text-center text-muted py-4">Chưa có unavailable block nào.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom">
                            <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-book me-2"></i>Catalog management</h5>
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
                                    <button type="submit" class="btn btn-outline-success w-100"><i class="fa fa-save me-2"></i>Lưu</button>
                                </div>
                            </form>

                            <div class="table-responsive">
                                <table class="table table-bordered align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${skillCatalog}" var="item">
                                            <tr>
                                                <td class="fw-semibold">${item.code}</td>
                                                <td>${item.name}</td>
                                                <td><span class="badge ${item.activeStatus ? 'bg-success' : 'bg-secondary'}">${item.activeStatus ? 'Active' : 'Inactive'}</span></td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty skillCatalog}">
                                            <tr><td colspan="3" class="text-center text-muted py-4">Skill catalog đang trống.</td></tr>
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
</div>
