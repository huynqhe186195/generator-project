<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <title>Danh sách Yêu cầu Bảo trì</title>

            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="text-secondary">Quản lý Yêu cầu Bảo trì</h3>
                </div>

                <div class="card shadow mb-4 border-0">
                    <div class="card-body bg-light rounded">
                        <form action="<c:url value='/staff/incident-list'/>" method="get" class="row g-3">
                            <div class="col-md-2">
                                <label class="form-label small text-muted mb-1">Từ ngày:</label>
                                <input type="date" name="fromDate" value="${param.fromDate}" class="form-control">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small text-muted mb-1">Đến ngày:</label>
                                <input type="date" name="toDate" value="${param.toDate}" class="form-control">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small text-muted mb-1">Trạng thái:</label>
                                <select class="form-select" name="status">
                                    <option value="">-- Tất cả --</option>
                                    <option value="NEW" ${param.status=='NEW' ? 'selected' : '' }>Mới (Cần xử lý)
                                    </option>
                                    <option value="VERIFIED" ${param.status=='VERIFIED' ? 'selected' : '' }>Đã xác minh
                                    </option>
                                    <option value="WAITING_MANAGER" ${param.status=='WAITING_MANAGER' ? 'selected' : ''
                                        }>Chờ duyệt</option>
                                    <option value="APPROVED" ${param.status=='APPROVED' ? 'selected' : '' }>Đã duyệt
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-secondary w-100">
                                    <i class="fas fa-filter me-2"></i> Lọc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow border-0">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light text-secondary">
                                    <tr>
                                        <th class="py-3 ps-4">#</th>
                                        <th class="py-3">Chi tiết Sự cố</th>
                                        <th class="py-3">Máy / Thiết bị</th>
                                        <th class="py-3">Người báo</th>
                                        <th class="py-3">Trạng thái</th>
                                        <th class="py-3 text-end pe-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listRequests}" var="req" varStatus="loop">
                                        <c:set var="prod" value="${relatedProducts[req.id]}" />
                                        <tr>
                                            <td class="ps-4 fw-bold text-secondary">${(currentPage - 1) * 5 + loop.index
                                                + 1}</td>

                                            <td>
                                                <div>
                                                    <span class="badge bg-warning text-dark mb-1">
                                                        <c:choose>
                                                            <c:when test="${req.info.issueType == 'MAINTENANCE'}">Bảo
                                                                dưỡng</c:when>
                                                            <c:when test="${req.info.issueType == 'REPLACEMENT'}">Thay
                                                                phụ tùng</c:when>
                                                            <c:when test="${req.info.issueType == 'BROKEN'}">Lỗi / Hỏng
                                                            </c:when>
                                                            <c:when test="${req.info.issueType == 'OTHER'}">Vấn đề khác
                                                            </c:when>
                                                            <c:otherwise>${not empty req.info.issueType ?
                                                                req.info.issueType : 'Sự cố khác'}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div class="fw-bold text-truncate" style="max-width: 250px;"
                                                        title="${req.info.title}">
                                                        ${req.info.title}
                                                    </div>
                                                    <div class="small text-muted mt-1">
                                                        <i class="far fa-clock me-1"></i>
                                                        <fmt:formatDate value="${req.createdAt}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                </div>
                                            </td>

                                            <td>
                                                <div class="small">
                                                    <c:choose>
                                                        <c:when test="${not empty prod}">
                                                            <div class="fw-bold text-primary"><i
                                                                    class="fas fa-server me-1"></i> ${prod.modelName}
                                                            </div>
                                                            <div class="text-muted"><i class="fas fa-barcode me-1"></i>
                                                                ${prod.serialNumber}</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-danger"><i
                                                                    class="fas fa-exclamation-circle me-1"></i> Không
                                                                tìm thấy (ID: ${req.info.productId})</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <td>
                                                <div class="small">
                                                    <div class="fw-bold">${req.info.reporterName}</div>
                                                    <div class="text-muted"><i class="fas fa-phone-alt me-1"></i>
                                                        ${req.info.reporterPhone}</div>
                                                </div>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${req.status == 'NEW'}"><span
                                                            class="badge bg-danger rounded-pill">Mới</span></c:when>
                                                    <c:when test="${req.status == 'VERIFIED'}"><span
                                                            class="badge bg-info text-dark rounded-pill">Đã xác
                                                            minh</span></c:when>
                                                    <c:when test="${req.status == 'WAITING_MANAGER'}"><span
                                                            class="badge bg-warning text-dark rounded-pill">Chờ
                                                            duyệt</span></c:when>
                                                    <c:when test="${req.status == 'APPROVED'}"><span
                                                            class="badge bg-primary rounded-pill">Đã duyệt</span>
                                                    </c:when>
                                                    <c:otherwise><span
                                                            class="badge bg-secondary rounded-pill">${req.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-end pe-4">
                                                <c:choose>
                                                    <c:when test="${req.status == 'NEW'}">
                                                        <a href="<c:url value='/staff/incident/verify?id=${req.id}'/>"
                                                            class="btn btn-sm btn-outline-danger">
                                                            <i class="fas fa-check-circle me-1"></i> Xác minh
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${req.status == 'VERIFIED'}">
                                                        <a href="<c:url value='/staff/incident/escalate?id=${req.id}'/>"
                                                            class="btn btn-sm btn-primary">
                                                            <i class="fas fa-paper-plane me-1"></i> Gửi yêu cầu
                                                        </a>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer bg-white py-3">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-end mb-0">

                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/staff/incident-list'>
                                    <c:param name='page' value='${currentPage - 1}'/>
                                    <c:param name='status' value='${param.status}'/>
                                    <c:param name='fromDate' value='${param.fromDate}'/>
                                    <c:param name='toDate' value='${param.toDate}'/>
                                 </c:url>" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="<c:url value='/staff/incident-list'>
                                        <c:param name='page' value='${i}'/>
                                        <c:param name='status' value='${param.status}'/>
                                        <c:param name='fromDate' value='${param.fromDate}'/>
                                        <c:param name='toDate' value='${param.toDate}'/>
                                     </c:url>">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/staff/incident-list'>
                                    <c:param name='page' value='${currentPage + 1}'/>
                                    <c:param name='status' value='${param.status}'/>
                                    <c:param name='fromDate' value='${param.fromDate}'/>
                                    <c:param name='toDate' value='${param.toDate}'/>
                                 </c:url>" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>

                            </ul>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="verifyModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <form action="<c:url value='/staff/incident/escalate'/>" method="POST">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title">
                                    <i class="fas fa-clipboard-check me-2"></i>Xác minh Yêu cầu & Trình duyệt Manager
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>

                            <div class="modal-body bg-light">
                                <input type="hidden" name="incident_id" id="modalIncidentId" />

                                <div class="row">
                                    <div class="col-lg-6 border-end">
                                        <h6 class="text-uppercase text-secondary fw-bold mb-3 border-bottom pb-2">
                                            <i class="fas fa-info-circle me-1"></i> Thông tin Sự cố & Hợp đồng
                                        </h6>

                                        <div class="card card-body shadow-sm border-0">
                                            <div class="row g-2">
                                                <div class="col-12">
                                                    <label class="small text-muted">Sự cố:</label>
                                                    <div class="fw-bold" id="modalTitle"></div>
                                                </div>
                                                <div class="col-12">
                                                    <label class="small text-muted">Mô tả của khách:</label>
                                                    <div class="fst-italic bg-light p-2 rounded" id="modalDesc"></div>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="small text-muted">Số Hợp đồng:</label>
                                                    <div class="fw-bold text-primary" id="modalContract"></div>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="small text-muted">Serial Máy:</label>
                                                    <div class="fw-bold text-dark" id="modalSerial"></div>
                                                </div>
                                                <div class="col-12 mt-2">
                                                    <div class="alert alert-info py-1 px-2 small mb-0">
                                                        <i class="fas fa-info-circle me-1"></i>
                                                        Vui lòng đối chiếu số HĐ và Serial trên hệ thống trước khi gửi
                                                        duyệt.
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-6 ps-4">
                                        <h6 class="text-uppercase text-secondary fw-bold mb-3 border-bottom pb-2">
                                            <i class="fas fa-user-cog me-1"></i> Đề xuất phương án
                                        </h6>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Đề xuất Kỹ thuật viên:</label>
                                            <select name="technician_id" class="form-select border-primary" required>
                                                <option value="">-- Chọn nhân viên phù hợp --</option>
                                                <c:forEach items="${listTechnicians}" var="tech">
                                                    <option value="${tech.id}">
                                                        ${tech.fullName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="form-text">Manager sẽ xem xét đề xuất này và duyệt cuối cùng.
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Đánh giá mức độ ưu tiên:</label>
                                            <select name="priority" class="form-select">
                                                <option value="LOW">Thấp (Không gấp)</option>
                                                <option value="MEDIUM" selected>Trung bình</option>
                                                <option value="HIGH">Cao (Cần xử lý sớm)</option>
                                                <option value="CRITICAL">Nghiêm trọng (Xử lý ngay)</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Loại hình xử lý:</label>
                                            <select name="type" class="form-select">
                                                <option value="REPAIR">Sửa chữa sự cố (Repair)</option>
                                                <option value="INSPECTION">Kiểm tra hiện trường (Inspection)</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Ghi chú trình Manager:</label>
                                            <textarea name="staff_note" class="form-control" rows="3"
                                                placeholder="Ví dụ: Đã check hợp đồng còn hạn, lỗi này có vẻ do phần cứng..."></textarea>
                                        </div>

                                        <div class="form-check mb-4">
                                            <input class="form-check-input" type="checkbox" id="confirmCheck" required>
                                            <label class="form-check-label small" for="confirmCheck">
                                                Tôi xác nhận đã kiểm tra thông tin hợp đồng và sự cố này là hợp lệ.
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-outline-danger me-auto" onclick="rejectIncident()">
                                    <i class="fas fa-times me-1"></i> Từ chối yêu cầu
                                </button>

                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="fas fa-paper-plane me-2"></i> Trình duyệt Manager
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                function openVerifyModal(button) {
                    // Lấy dữ liệu từ nút bấm
                    const id = button.getAttribute('data-id');
                    const title = button.getAttribute('data-title');
                    const desc = button.getAttribute('data-desc');
                    // const imageSrc = button.getAttribute('data-image'); // Bỏ dòng này
                    const contract = button.getAttribute('data-contract');
                    const serial = button.getAttribute('data-serial');

                    // Điền vào Modal
                    document.getElementById('modalIncidentId').value = id;
                    document.getElementById('modalTitle').innerText = title;
                    document.getElementById('modalDesc').innerText = desc || "Không có mô tả";
                    document.getElementById('modalContract').innerText = contract || "N/A";
                    document.getElementById('modalSerial').innerText = serial || "N/A";

                    // --- ĐÃ XÓA PHẦN LOGIC XỬ LÝ ẢNH (imgEl, noImgEl...) TẠI ĐÂY ---

                    // Mở Modal
                    var myModal = new bootstrap.Modal(document.getElementById('verifyModal'));
                    myModal.show();
                }

                function rejectIncident() {
                    if (confirm('Bạn có chắc chắn muốn TỪ CHỐI yêu cầu này không?')) {
                        alert("Chức năng từ chối sẽ được phát triển sau (hoặc bạn có thể tự thêm form action).");
                    }
                }
            </script>
