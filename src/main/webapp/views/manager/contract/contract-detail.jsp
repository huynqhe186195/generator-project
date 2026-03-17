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
            border-radius: 14px;
            box-shadow: 0 10px 26px rgba(18, 38, 63, 0.10);
            overflow: hidden;
        }
        .soft-card .card-header {
            border-bottom: 1px solid #edf2f7;
            background: linear-gradient(180deg, #f9fbff 0%, #f2f7ff 100%);
            font-weight: 700;
            color: #1f2a44;
        }
        .status-pill { font-size: 12px; padding: 7px 12px; border-radius: 999px; }
        .section-title { font-size: 14px; text-transform: uppercase; letter-spacing: .4px; color: #64748b; }
        .kv-table td { padding: .5rem 0; }
        .timeline-table td, .timeline-table th { vertical-align: middle; }
        .overview-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 12px;
        }
        .overview-item {
            border: 1px solid #edf2ff;
            border-radius: 10px;
            background: #fff;
            padding: 10px 12px;
        }
        .overview-item .label { font-size: 12px; color: #6b7280; margin-bottom: 4px; }
        .overview-item .value { font-weight: 700; color: #1f2937; }
        .owner-name-btn {
            border: 0;
            padding: 0;
            background: transparent;
            font-size: 30px;
            font-weight: 700;
            color: #198754;
            text-align: left;
        }
        .owner-name-btn:hover { text-decoration: underline; color: #157347; }
        .owner-detail-panel {
            margin-top: 12px;
            border: 1px dashed #cde7d8;
            background: #f7fffb;
            border-radius: 10px;
            padding: 12px;
            display: none;
        }
        .owner-detail-panel.show { display: block; }
        .contract-sidebar { position: sticky; top: 90px; }
        @media (max-width: 991.98px) { .contract-sidebar { position: static; top: auto; } }
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
        <div class="col-lg-8">
            <div class="card soft-card mb-4">
                <div class="card-header"><i class="fa fa-info-circle text-primary"></i> Tổng quan hợp đồng</div>
                <div class="card-body">
                    <div class="overview-grid">
                        <div class="overview-item">
                            <div class="label">Trạng thái</div>
                            <div class="value">
                                <c:choose>
                                    <c:when test="${c.status == 'PENDING_SERIAL'}"><span class="badge bg-warning text-dark status-pill">PENDING SERIAL</span></c:when>
                                    <c:when test="${c.status == 'ACTIVE'}"><span class="badge bg-success status-pill">ACTIVE</span></c:when>
                                    <c:when test="${c.status == 'EXPIRED'}"><span class="badge bg-danger status-pill">EXPIRED</span></c:when>
                                    <c:when test="${c.status == 'TERMINATED'}"><span class="badge bg-secondary status-pill">TERMINATED</span></c:when>
                                    <c:otherwise><span class="badge bg-dark status-pill">${c.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="overview-item">
                            <div class="label">Ngày ký</div>
                            <div class="value"><fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/></div>
                        </div>
                        <div class="overview-item">
                            <div class="label">Ngày bắt đầu</div>
                            <div class="value"><fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/></div>
                        </div>
                        <div class="overview-item">
                            <div class="label">Ngày kết thúc</div>
                            <div class="value text-danger"><fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></div>
                        </div>
                    </div>
                    <c:if test="${c.terminatedAt != null}">
                        <div class="overview-item mb-2">
                            <div class="label">Thời điểm chấm dứt</div>
                            <div class="value"><fmt:formatDate value="${c.terminatedAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                        </div>
                    </c:if>

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

            <div class="card soft-card">
                <div class="card-header d-flex justify-content-between align-items-center"><span><i class="fa fa-stream text-dark"></i> Timeline sự kiện hợp đồng</span><span class="badge bg-light text-dark">${contractEvents != null ? contractEvents.size() : 0}</span></div>
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

        <div class="col-lg-4">
            <div class="contract-sidebar">
                <div class="card soft-card mb-4">
                    <div class="card-header"><i class="fa fa-user-tie text-success"></i> Khách hàng / Chủ sở hữu</div>
                    <div class="card-body">
                        <button type="button" class="owner-name-btn" id="ownerNameToggle">
                            ${u.fullName}
                        </button>
                        <div class="small text-muted">Nhấn vào tên để xem chi tiết khách hàng và thiết bị của khách trong hợp đồng hiện tại.</div>

                        <div id="ownerDetailPanel" class="owner-detail-panel">
                            <div class="mb-2"><i class="fa fa-envelope text-muted me-2"></i>${u.email}</div>
                            <div class="mb-3"><i class="fa fa-phone text-muted me-2"></i>${u.phone != null ? u.phone : 'Chưa cập nhật'}</div>

                            <div class="fw-semibold mb-2 d-flex justify-content-between align-items-center">
                                <span>Thiết bị thuộc hợp đồng hiện tại</span>
                                <span class="badge bg-primary">${products != null ? products.size() : 0}</span>
                            </div>
                            <c:choose>
                                <c:when test="${products == null || products.isEmpty()}">
                                    <div class="text-muted">Hợp đồng hiện tại chưa có thiết bị nào được gán.</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-sm table-bordered mb-0">
                                            <thead class="table-light">
                                            <tr>
                                                <th>Serial</th>
                                                <th>Model</th>
                                                <th>Trạng thái</th>
                                                <th class="text-end">Giờ chạy</th>
                                                <th>Năm SX</th>
                                                <th>Vị trí</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="d" items="${products}">
                                                <tr>
                                                    <td class="fw-semibold">${d.serialNumber}</td>
                                                    <td>${not empty d.modelName ? d.modelName : (not empty d.brandName ? d.brandName : '—')}</td>
                                                    <td>${not empty d.status ? d.status : '—'}</td>
                                                    <td class="text-end">${d.totalRunningHours}h</td>
                                                    <td>${d.manufactureYear != null ? d.manufactureYear : 'N/A'}</td>
                                                    <td>${not empty d.currentLocation ? d.currentLocation : '—'}</td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const ownerNameToggle = document.getElementById('ownerNameToggle');
        const ownerDetailPanel = document.getElementById('ownerDetailPanel');
        if (!ownerNameToggle || !ownerDetailPanel) {
            return;
        }

        ownerNameToggle.addEventListener('click', function () {
            ownerDetailPanel.classList.toggle('show');
        });
    })();
</script>
</body>
