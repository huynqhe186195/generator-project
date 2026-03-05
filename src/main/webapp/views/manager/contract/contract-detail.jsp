<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <title>Chi tiết Hợp đồng #${c.contractNumber}</title>
</head>

<body>
<div class="container mt-4">

    <c:if test="${param.msg == 'terminated_success'}">
        <div class="alert alert-success">Hợp đồng đã được chấm dứt và ghi nhận lịch sử sự kiện.</div>
    </c:if>
    <c:if test="${param.msg == 'terminate_note_required'}">
        <div class="alert alert-warning">Lý do OTHER yêu cầu nhập ghi chú chi tiết.</div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-0 text-primary">
                <i class="fa fa-file-contract"></i> Hợp đồng: ${c.contractNumber}
            </h3>
            <span class="text-muted small">
                Ngày tạo: <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
            </span>
        </div>

        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager/contracts" class="btn btn-secondary">
                <i class="fa fa-arrow-left"></i> Danh sách
            </a>

            <c:if test="${c.status != 'TERMINATED'}">
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/manager/contracts?action=assignSerialForm&id=${c.id}">
                    <i class="fa fa-plus"></i> Gán serial
                </a>
            </c:if>
        </div>
    </div>

    <div class="row">
        <!-- LEFT -->
        <div class="col-md-5">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light fw-bold">
                    <i class="fa fa-info-circle text-primary"></i> Thông tin chung
                </div>
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr>
                            <td class="text-muted w-50">Trạng thái:</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'PENDING_SERIAL'}">
                                        <span class="badge bg-warning text-dark px-3 py-2">CHƯA GÁN SERIAL</span>
                                    </c:when>
                                    <c:when test="${c.status == 'ACTIVE'}">
                                        <span class="badge bg-success px-3 py-2">HIỆU LỰC (ACTIVE)</span>
                                    </c:when>
                                    <c:when test="${c.status == 'EXPIRED'}">
                                        <span class="badge bg-danger px-3 py-2">HẾT HẠN (EXPIRED)</span>
                                    </c:when>
                                    <c:when test="${c.status == 'TERMINATED'}">
                                        <span class="badge bg-secondary px-3 py-2">ĐÃ HỦY (TERMINATED)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary px-3 py-2">${c.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Ngày bắt đầu:</td>
                            <td class="fw-bold"><fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Ngày kết thúc:</td>
                            <td class="fw-bold text-danger"><fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <c:if test="${c.terminatedAt != null}">
                            <tr>
                                <td class="text-muted">Thời điểm chấm dứt:</td>
                                <td class="fw-bold text-secondary"><fmt:formatDate value="${c.terminatedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                        </c:if>
                    </table>

                    <c:if test="${c.status == 'PENDING_SERIAL'}">
                        <div class="alert alert-warning mt-3 mb-0">
                            Hợp đồng đã import nhưng chưa có thiết bị (serial). Hãy bấm <b>Gán serial</b> để tạo tài sản cho khách hàng.
                        </div>
                    </c:if>

                    <c:if test="${c.status == 'TERMINATED' && terminatedEvent != null}">
                        <div class="alert alert-secondary mt-3 mb-0">
                            <div><b>Lý do mã:</b> ${terminatedEvent.reasonCode}</div>
                            <div><b>Lý do chi tiết:</b> ${terminatedEvent.terminatedReason}</div>
                            <div><b>Decision Doc:</b> ${empty terminatedEvent.decisionDoc ? '—' : terminatedEvent.decisionDoc}</div>
                            <div><b>Ghi chú:</b> ${empty terminatedEvent.note ? '—' : terminatedEvent.note}</div>
                            <div><b>Người chấm dứt:</b> #${terminatedEvent.actorId}</div>
                            <div><b>Meta:</b> ${empty terminatedEvent.meta ? '—' : terminatedEvent.meta}</div>
                        </div>
                    </c:if>

                    <c:if test="${c.status != 'TERMINATED'}">
                        <form class="mt-3" method="post" action="${pageContext.request.contextPath}/manager/contracts">
                            <input type="hidden" name="action" value="terminate"/>
                            <input type="hidden" name="id" value="${c.id}"/>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <label class="form-label">Reason code</label>
                                    <select name="reasonCode" class="form-select">
                                        <option value="CONTRACT_VIOLATION">CONTRACT_VIOLATION</option>
                                        <option value="NON_PAYMENT">NON_PAYMENT</option>
                                        <option value="OTHER">OTHER</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Decision doc</label>
                                    <input type="text" name="decisionDoc" class="form-control" placeholder="QĐ-123/2026"/>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Lý do vi phạm/chấm dứt</label>
                                    <input type="text" name="terminatedReason" class="form-control" placeholder="Nhập lý do"/>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Ghi chú (bắt buộc nếu OTHER)</label>
                                    <textarea name="note" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-danger btn-sm mt-2"
                                    onclick="return confirm('Bạn chắc chắn muốn chấm dứt hợp đồng này?');">
                                <i class="fa fa-ban"></i> Chấm dứt hợp đồng
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light fw-bold">
                    <i class="fa fa-user-tie text-success"></i> Khách hàng / Chủ sở hữu
                </div>
                <div class="card-body">
                    <h5 class="card-title text-success">${u.fullName}</h5>
                    <p class="card-text mb-1"><i class="fa fa-envelope w-25 text-center"></i> ${u.email}</p>
                    <p class="card-text mb-1"><i class="fa fa-phone w-25 text-center"></i> ${u.phone != null ? u.phone : 'Chưa cập nhật'}</p>
                </div>
            </div>

            <!-- LIST PRODUCTS -->
            <div class="card shadow-sm">
                <div class="card-header bg-light fw-bold d-flex justify-content-between align-items-center">
                    <span><i class="fa fa-server text-primary"></i> Danh sách thiết bị</span>
                    <span class="badge bg-primary">${products != null ? products.size() : 0}</span>
                </div>
                <div class="card-body p-0">

                    <c:choose>
                        <c:when test="${products == null || products.isEmpty()}">
                            <div class="p-3 text-muted">
                                Chưa có thiết bị nào được gán cho hợp đồng này.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Serial</th>
                                        <th>Tên thiết bị</th>
                                        <th class="text-end">Giờ chạy</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="x" items="${products}">
                                        <tr style="cursor:pointer"
                                            class="${(p != null && p.serialNumber == x.serialNumber) ? 'table-primary' : ''}"
                                            onclick="window.location='${pageContext.request.contextPath}/manager/contracts?action=detail&id=${c.id}&serial=${x.serialNumber}'">
                                            <td class="fw-bold">${x.serialNumber}</td>
                                            <td title="${x.modelName}">
                                                <c:choose>
                                                    <c:when test="${not empty x.modelName}">${x.modelName}</c:when>
                                                    <c:when test="${not empty x.brandName}">${x.brandName}</c:when>
                                                    <c:when test="${not empty x.modelId}">Model ID: ${x.modelId}</c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">${x.totalRunningHours}h</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
            <div class="card shadow-sm mt-4">
                <div class="card-header bg-light fw-bold">
                    <i class="fa fa-stream text-dark"></i> Timeline sự kiện hợp đồng
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-sm table-striped mb-0">
                            <thead>
                            <tr>
                                <th>Thời gian</th>
                                <th>Event</th>
                                <th>Status</th>
                                <th>Reason</th>
                                <th>Actor</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="ev" items="${contractEvents}">
                                <tr>
                                    <td><fmt:formatDate value="${ev.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>${ev.eventType}</td>
                                    <td>${ev.oldStatus} → ${ev.newStatus}</td>
                                    <td>${empty ev.reasonCode ? '—' : ev.reasonCode}</td>
                                    <td>${empty ev.actorId ? '—' : ev.actorId}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty contractEvents}">
                                <tr><td colspan="5" class="text-center text-muted">Chưa có sự kiện.</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT -->
        <div class="col-md-7">
            <div class="card shadow border-primary h-100">
                <div class="card-header bg-primary text-white d-flex justify-content-between">
                    <span class="fw-bold"><i class="fa fa-server"></i> HỒ SƠ THIẾT BỊ</span>

                    <c:choose>
                        <c:when test="${p != null}">
                            <span class="badge bg-white text-primary">Serial: ${p.serialNumber}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-white text-primary">Chưa chọn thiết bị</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card-body">
                    <c:if test="${p == null}">
                        <div class="text-muted">
                            Chưa có thiết bị để hiển thị. Hãy gán serial trước hoặc chọn thiết bị ở danh sách.
                        </div>
                    </c:if>

                    <c:if test="${p != null}">
                        <div class="row text-center mb-4">
                            <div class="col-4 border-end">
                                <h2 class="text-primary mb-0"><i class="fa fa-bolt"></i></h2>
                                <small class="text-muted">Brand</small>
                                <div class="fw-bold text-truncate" title="${p.brandName}">
                                    ${p.brandName != null ? p.brandName : '—'}
                                </div>

                            </div>

                            <div class="col-4 border-end">
                                <h2 class="text-warning mb-0"><i class="fa fa-clock"></i></h2>
                                <small class="text-muted">Category</small>
                                <div class="fw-bold text-truncate" title="${p.categoryName}">
                                    ${p.categoryName != null ? p.categoryName : '—'}
                                </div>
                            </div>

                            <div class="col-4">
                                <h2 class="text-info mb-0"><i class="fa fa-calendar-check"></i></h2>
                                <small class="text-muted">Năm SX</small>
                                <div class="fw-bold">${p.manufactureYear != null ? p.manufactureYear : 'N/A'}</div>
                            </div>
                        </div>

                        <h6 class="border-bottom pb-2">Thông tin vận hành hiện tại</h6>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between">
                                <span>Vị trí lắp đặt:</span>
                                <span class="fw-bold">${p.currentLocation != null ? p.currentLocation : 'Chưa cập nhật'}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span>Trạng thái máy:</span>
                                <span class="fw-bold text-${p.status == 'RUNNING' ? 'success' : 'warning'}">
                                    ${p.status}
                                </span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span>Lần bảo trì gần nhất:</span>
                                <span class="text-muted">--/--/----</span>
                            </li>
                        </ul>

                        <div class="mt-4 text-end">
                            <a href="#" class="btn btn-outline-danger btn-sm">
                                <i class="fa fa-exclamation-circle"></i> Xem lịch sử báo hỏng
                            </a>
                            <a href="#" class="btn btn-outline-success btn-sm">
                                <i class="fa fa-tools"></i> Lịch sử bảo trì
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
