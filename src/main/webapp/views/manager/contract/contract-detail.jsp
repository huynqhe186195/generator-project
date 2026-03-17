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
                <div class="card-header"><i class="fa fa-user-tie text-success"></i> Khách hàng / Chủ sở hữu</div>
                <div class="card-body">
                    <button type="button" class="owner-name-btn" id="ownerNameToggle">
                        ${u.fullName}
                    </button>
                    <div class="small text-muted">Nhấn vào tên để xem chi tiết khách hàng và toàn bộ thiết bị đang sở hữu.</div>

                    <div id="ownerDetailPanel" class="owner-detail-panel">
                        <div class="mb-2"><i class="fa fa-envelope text-muted me-2"></i>${u.email}</div>
                        <div class="mb-3"><i class="fa fa-phone text-muted me-2"></i>${u.phone != null ? u.phone : 'Chưa cập nhật'}</div>

                        <div class="fw-semibold mb-2">Thiết bị khách hàng đang sở hữu</div>
                        <c:choose>
                            <c:when test="${customerDevices == null || customerDevices.isEmpty()}">
                                <div class="text-muted">Khách hàng chưa sở hữu thiết bị nào.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-sm table-bordered mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th>Serial</th>
                                            <th>Model</th>
                                            <th>Trạng thái</th>
                                            <th>Vị trí</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="d" items="${customerDevices}">
                                            <tr>
                                                <td class="fw-semibold">${d.serialNumber}</td>
                                                <td>${not empty d.modelName ? d.modelName : '—'}</td>
                                                <td>${not empty d.status ? d.status : '—'}</td>
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

            <div class="card soft-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fa fa-server text-primary"></i> Thiết bị thuộc hợp đồng</span>
                    <span class="badge bg-primary">${products != null ? products.size() : 0}</span>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${products == null || products.isEmpty()}">
                            <div class="p-3 text-muted">Chưa có thiết bị nào được gán cho hợp đồng này.</div>
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
                                            <td class="fw-semibold">${x.serialNumber}</td>
                                            <td>${not empty x.modelName ? x.modelName : (not empty x.brandName ? x.brandName : '—')}</td>
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
        </div>

        <div class="col-lg-7">
            <div class="card soft-card mb-4">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <span><i class="fa fa-microchip"></i> Hồ sơ thiết bị</span>
                    <span class="badge bg-light text-primary">${p != null ? p.serialNumber : 'Chưa chọn thiết bị'}</span>
                </div>
                <div class="card-body">
                    <c:if test="${p == null}">
                        <div class="text-muted">Chưa có thiết bị để hiển thị. Hãy gán serial trước hoặc chọn thiết bị ở danh sách.</div>
                    </c:if>

                    <c:if test="${p != null}">
                        <div class="row g-3 mb-3 text-center">
                            <div class="col-md-4"><div class="p-3 border rounded"><div class="small text-muted">Brand</div><div class="fw-bold">${p.brandName != null ? p.brandName : '—'}</div></div></div>
                            <div class="col-md-4"><div class="p-3 border rounded"><div class="small text-muted">Category</div><div class="fw-bold">${p.categoryName != null ? p.categoryName : '—'}</div></div></div>
                            <div class="col-md-4"><div class="p-3 border rounded"><div class="small text-muted">Năm SX</div><div class="fw-bold">${p.manufactureYear != null ? p.manufactureYear : 'N/A'}</div></div></div>
                        </div>

                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between"><span>Vị trí lắp đặt</span><span class="fw-semibold">${p.currentLocation != null ? p.currentLocation : 'Chưa cập nhật'}</span></li>
                            <li class="list-group-item d-flex justify-content-between"><span>Trạng thái máy</span><span class="fw-semibold text-${p.status == 'RUNNING' ? 'success' : 'warning'}">${p.status}</span></li>
                            <li class="list-group-item d-flex justify-content-between"><span>Lần bảo trì gần nhất</span><span class="text-muted">--/--/----</span></li>
                        </ul>
                    </c:if>
                </div>
            </div>

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
