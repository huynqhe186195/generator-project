<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    .name-link {
        color: inherit; /* Kế thừa màu đen/tối mặc định của khung chứa */
        text-decoration: none; /* Bỏ gạch chân mặc định của thẻ a */
        transition: color 0.2s ease-in-out; /* Đổi màu mượt */
    }

    .name-link:hover {
        color: #0d6efd; /* Chuyển sang màu xanh dương khi trỏ chuột vào */
        text-decoration: none; /* Vẫn không gạch chân khi hover */
    }
</style>
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
                                                            <%-- Bọc tên máy bằng thẻ a và dùng class name-link --%>
                                                            <div class="fw-bold text-primary">
                                                                <a href="<c:url value='/staff/product/detail?id=${prod.id}'/>"
                                                                   class="name-link"
                                                                   title="Xem chi tiết thiết bị">
                                                                    <i class="fas fa-server me-1"></i> ${prod.modelName}
                                                                </a>
                                                            </div>
                                                            <div class="text-muted mt-1">
                                                                <i class="fas fa-barcode me-1"></i> ${prod.serialNumber}
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-danger">
                                                                <i class="fas fa-exclamation-circle me-1"></i> Không tìm thấy (ID: ${req.info.productId})
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <td>
                                                <div class="small">
                                                    <div class="fw-bold">
                                                            <%-- Thẻ a bọc lấy tên người báo --%>
                                                        <a href="<c:url value='/staff/user-information?id=${prod.customerId}'/>"
                                                           class="name-link"
                                                           title="Xem chi tiết hồ sơ khách hàng">
                                                                ${req.info.reporterName}
                                                        </a>
                                                    </div>
                                                    <div class="text-muted mt-1">
                                                        <i class="fas fa-phone-alt me-1"></i> ${req.info.reporterPhone}
                                                    </div>
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
                                                    <c:when test="${req.status == 'TASK_CREATED'}"><span
                                                            class="badge bg-secondary rounded-pill">Đã giao task</span>
                                                    </c:when>
                                                    <c:otherwise><span
                                                            class="badge bg-secondary rounded-pill">${req.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-end pe-4">
                                                <div class="d-flex justify-content-end gap-2">

                                                        <%-- THÊM MỚI: Nút Xem chi tiết (Luôn hiển thị) --%>
                                                    <a href="<c:url value='/staff/incident-view?id=${req.id}'/>"
                                                       class="btn btn-sm btn-outline-info" title="Xem chi tiết yêu cầu">
                                                        <i class="fas fa-eye"></i>
                                                    </a>

                                                        <%-- Các nút thao tác theo trạng thái (Giữ nguyên logic cũ) --%>
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
                                                        <c:when test="${req.status == 'APPROVED'}">
                                                            <form action="<c:url value='/staff/assign-task'/>" method="post" style="display: inline;">
                                                                <input type="hidden" name="id" value="${req.id}">
                                                                <button type="submit" class="btn btn-sm btn-success" onclick="return confirm('Xác nhận tạo task bảo trì cho yêu cầu này?')">
                                                                    <i class="fas fa-tools me-1"></i> Gửi task
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                    </c:choose>

                                                </div>
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
