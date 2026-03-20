<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <title>Chi tiết Hợp đồng #${c.contractNumber}</title>
    <style>
        .contract-hero {
            border-radius: 14px;
            background: linear-gradient(120deg, #0d6efd 0%, #1f78ff 55%, #4da3ff 100%);
            color: #fff;
            padding: 20px 24px;
            box-shadow: 0 10px 24px rgba(13, 110, 253, 0.25);
        }
        .soft-card {
            border: 0;
            border-radius: 12px;
            box-shadow: 0 8px 22px rgba(18, 38, 63, 0.08);
        }
        .soft-card .card-header {
            border-bottom: 1px solid #edf2f7;
            background: #f8fafc;
            font-weight: 600;
        }
        .status-pill { font-size: 12px; padding: 7px 12px; border-radius: 999px; }
        .section-title { font-size: 14px; text-transform: uppercase; letter-spacing: .4px; color: #64748b; }
        .kv-table td { padding: .5rem 0; }
        .timeline-table td, .timeline-table th { vertical-align: middle; }
        .owner-trigger {
            color: #198754;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .5rem;
        }
        .owner-trigger:hover { color: #146c43; }
        .device-detail-card {
            border: 1px solid #e9eef5;
            border-radius: 12px;
            padding: 14px 16px;
            background: #f8fbff;
        }
        .device-detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: .75rem;
        }
        .device-detail-item {
            background: #fff;
            border: 1px solid #eef2f7;
            border-radius: 10px;
            padding: .75rem;
        }
        .device-detail-item .label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .4px;
            color: #64748b;
            margin-bottom: .25rem;
        }
    </style>
</head>

<body>
<div class="container mt-4 mb-5">

    <c:if test="${param.msg == 'terminated_success'}">
        <div class="alert alert-success">Hợp đồng đã được chấm dứt và ghi nhận lịch sử sự kiện.</div>
    </c:if>
    <c:if test="${param.msg == 'terminate_note_required'}">
        <div class="alert alert-warning">Lý do OTHER yêu cầu nhập ghi chú chi tiết.</div>
    </c:if>

    <div class="contract-hero mb-4 d-flex flex-wrap justify-content-between align-items-center gap-3">
        <div>
            <div class="section-title text-white-50 mb-1">Contract Detail</div>
            <h4 class="mb-1"><i class="fa fa-file-contract me-2"></i>Hợp đồng: ${c.contractNumber}</h4>
            <div class="small text-white-50">Ngày tạo: <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager/contracts" class="btn btn-light btn-sm">
                <i class="fa fa-arrow-left"></i> Danh sách
            </a>
            <c:if test="${c.status != 'TERMINATED'}">
                <a class="btn btn-warning btn-sm fw-bold" href="${pageContext.request.contextPath}/manager/contracts?action=assignSerialForm&id=${c.id}">
                    <i class="fa fa-plus"></i> Gán serial
                </a>
            </c:if>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="card soft-card mb-4">
                <div class="card-header"><i class="fa fa-info-circle text-primary"></i> Tổng quan hợp đồng</div>
                <div class="card-body">
                    <table class="table table-borderless kv-table mb-0">
                        <tr>
                            <td class="text-muted" style="width:45%;">Trạng thái</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'PENDING_SERIAL'}"><span class="badge bg-warning text-dark status-pill">PENDING SERIAL</span></c:when>
                                    <c:when test="${c.status == 'ACTIVE'}"><span class="badge bg-success status-pill">ACTIVE</span></c:when>
                                    <c:when test="${c.status == 'EXPIRED'}"><span class="badge bg-danger status-pill">EXPIRED</span></c:when>
                                    <c:when test="${c.status == 'TERMINATED'}"><span class="badge bg-secondary status-pill">TERMINATED</span></c:when>
                                    <c:otherwise><span class="badge bg-dark status-pill">${c.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Ngày bắt đầu</td>
                            <td class="fw-semibold"><fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Ngày kết thúc</td>
                            <td class="fw-semibold text-danger"><fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <c:if test="${c.terminatedAt != null}">
                            <tr>
                                <td class="text-muted">Thời điểm chấm dứt</td>
                                <td class="fw-semibold"><fmt:formatDate value="${c.terminatedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                        </c:if>
                    </table>

                    <c:if test="${c.status == 'PENDING_SERIAL'}">
                        <div class="alert alert-warning mt-3 mb-0">Hợp đồng chưa có thiết bị, vui lòng gán serial để tạo tài sản.</div>
                    </c:if>

                    <c:if test="${c.status == 'TERMINATED' && terminatedEvent != null}">
                        <div class="alert alert-secondary mt-3 mb-0">
                            <div><b>Reason code:</b> ${terminatedEvent.reasonCode}</div>
                            <div><b>Lý do:</b> ${empty terminatedEvent.terminatedReason ? '—' : terminatedEvent.terminatedReason}</div>
                            <div><b>Decision doc:</b> ${empty terminatedEvent.decisionDoc ? '—' : terminatedEvent.decisionDoc}</div>
                            <div><b>Ghi chú:</b> ${empty terminatedEvent.note ? '—' : terminatedEvent.note}</div>
                            <div><b>Actor:</b> ${empty terminatedEvent.actorId ? '—' : terminatedEvent.actorId}</div>
                        </div>
                    </c:if>

                    <c:if test="${c.status != 'TERMINATED'}">
                        <form class="mt-3" method="post" action="${pageContext.request.contextPath}/manager/contracts">
                            <input type="hidden" name="action" value="terminate"/>
                            <input type="hidden" name="id" value="${c.id}"/>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <label class="form-label mb-1">Reason code</label>
                                    <select name="reasonCode" class="form-select form-select-sm">
                                        <option value="CONTRACT_VIOLATION">CONTRACT_VIOLATION</option>
                                        <option value="NON_PAYMENT">NON_PAYMENT</option>
                                        <option value="OTHER">OTHER</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label mb-1">Decision doc</label>
                                    <input type="text" name="decisionDoc" class="form-control form-control-sm" placeholder="QĐ-123/2026"/>
                                </div>
                                <div class="col-12">
                                    <label class="form-label mb-1">Lý do chấm dứt</label>
                                    <input type="text" name="terminatedReason" class="form-control form-control-sm"/>
                                </div>
                                <div class="col-12">
                                    <label class="form-label mb-1">Ghi chú (bắt buộc nếu OTHER)</label>
                                    <textarea name="note" rows="2" class="form-control form-control-sm"></textarea>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-danger btn-sm mt-3" onclick="return confirm('Bạn chắc chắn muốn chấm dứt hợp đồng này?');">
                                <i class="fa fa-ban"></i> Chấm dứt hợp đồng
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <div class="card soft-card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fa fa-user-tie text-success"></i> Khách hàng / Chủ sở hữu</span>
                    <span class="badge bg-primary">${products != null ? products.size() : 0} thiết bị</span>
                </div>
                <div class="card-body">
                    <div class="d-flex flex-column gap-2">
                        <a class="fw-bold fs-5 owner-trigger" data-bs-toggle="collapse" href="#ownerDevices" role="button" aria-expanded="true" aria-controls="ownerDevices">
                            <span>${u.fullName}</span>
                            <i class="fa fa-chevron-down small"></i>
                        </a>
                        <div><i class="fa fa-envelope text-muted me-2"></i>${u.email}</div>
                        <div><i class="fa fa-phone text-muted me-2"></i>${u.phone != null ? u.phone : 'Chưa cập nhật'}</div>
                    </div>

                    <div class="collapse show mt-3" id="ownerDevices">
                        <div class="border-top pt-3">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="fw-semibold text-primary">
                                    <i class="fa fa-server me-2"></i>Danh sách thiết bị thuộc hợp đồng
                                </div>
                                <span class="text-muted small">Bấm tên chủ sở hữu để thu gọn / mở rộng</span>
                            </div>

                            <c:choose>
                                <c:when test="${products == null || products.isEmpty()}">
                                    <div class="text-muted">Chưa có thiết bị nào được gán cho hợp đồng này.</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column gap-3">
                                        <c:forEach var="x" items="${products}">
                                            <div class="device-detail-card">
                                                <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
                                                    <div>
                                                        <div class="fw-bold text-primary fs-6">${not empty x.modelName ? x.modelName : (not empty x.brandName ? x.brandName : 'Thiết bị chưa có tên')}</div>
                                                        <div class="text-muted small">Serial: <span class="fw-semibold">${x.serialNumber}</span></div>
                                                    </div>
                                                    <span class="badge ${x.status == 'RUNNING' ? 'bg-success' : 'bg-warning text-dark'}">${empty x.status ? 'Chưa cập nhật trạng thái' : x.status}</span>
                                                </div>
                                                <div class="device-detail-grid">
                                                    <div class="device-detail-item">
                                                        <div class="label">Brand</div>
                                                        <div class="fw-semibold">${not empty x.brandName ? x.brandName : '—'}</div>
                                                    </div>
                                                    <div class="device-detail-item">
                                                        <div class="label">Category</div>
                                                        <div class="fw-semibold">${not empty x.categoryName ? x.categoryName : '—'}</div>
                                                    </div>
                                                    <div class="device-detail-item">
                                                        <div class="label">Năm sản xuất</div>
                                                        <div class="fw-semibold">${x.manufactureYear != null ? x.manufactureYear : 'N/A'}</div>
                                                    </div>
                                                    <div class="device-detail-item">
                                                        <div class="label">Vị trí lắp đặt</div>
                                                        <div class="fw-semibold">${not empty x.currentLocation ? x.currentLocation : 'Chưa cập nhật'}</div>
                                                    </div>
                                                    <div class="device-detail-item">
                                                        <div class="label">Giờ chạy</div>
                                                        <div class="fw-semibold">${x.totalRunningHours}h</div>
                                                    </div>
                                                    <div class="device-detail-item">
                                                        <div class="label">Ngày mua</div>
                                                        <div class="fw-semibold"><fmt:formatDate value="${x.purchaseDate}" pattern="dd/MM/yyyy"/></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="card soft-card">
                <div class="card-header"><i class="fa fa-stream text-dark"></i> Timeline sự kiện hợp đồng</div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-sm table-striped mb-0 timeline-table">
                            <thead class="table-light">
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
                                    <td><span class="badge bg-info text-dark">${ev.eventType}</span></td>
                                    <td>${empty ev.oldStatus ? '—' : ev.oldStatus} → ${empty ev.newStatus ? '—' : ev.newStatus}</td>
                                    <td>${empty ev.reasonCode ? '—' : ev.reasonCode}</td>
                                    <td>${empty ev.actorId ? '—' : ev.actorId}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty contractEvents}">
                                <tr><td colspan="5" class="text-center text-muted py-3">Chưa có sự kiện nào cho hợp đồng này.</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
