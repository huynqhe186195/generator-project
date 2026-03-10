<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<title>Danh sách Báo giá Sửa chữa</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Quản lý Báo giá Sửa chữa (Từ Kỹ thuật viên)</h3>
    </div>

    <div class="card shadow mb-4 border-0">
        <div class="card-body bg-light rounded">
            <form action="<c:url value='/staff/repair-request-list'/>" method="get" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label small text-muted mb-1">Từ ngày:</label>
                    <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                </div>
                <div class="col-md-3">
                    <label class="form-label small text-muted mb-1">Đến ngày:</label>
                    <input type="date" class="form-control" name="toDate" value="${toDate}">
                </div>
                <div class="col-md-4">
                    <label class="form-label small text-muted mb-1">Trạng thái Báo giá:</label>
                    <select class="form-select" name="status">
                        <option value="">-- Tất cả --</option>
                        <option value="WAITING_STAFF" ${status == 'WAITING_STAFF' ? 'selected' : '' }>Mới (Chờ xử lý)</option>
                        <option value="PENDING" ${status == 'PENDING' ? 'selected' : '' }>Đã trình Manager</option>
                        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : '' }>Manager đã duyệt</option>
                        <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : '' }>Bị từ chối</option>


                        <option value="WAITING_CUSTOMER" ${status == 'WAITING_CUSTOMER' ? 'selected' : '' }>Chờ khách duyệt</option>
                        <option value="APPROVED_BY_CUSTOMER" ${status == 'APPROVED_BY_CUSTOMER' ? 'selected' : '' }>Khách đã duyệt</option>
                        <option value="REJECTED_BY_CUSTOMER" ${status == 'REJECTED_BY_CUSTOMER' ? 'selected' : '' }>Khách từ chối</option>

                        <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : '' }>Đã hoàn thành</option>
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
                        <th class="py-3 ps-4"># Request ID</th>
                        <th class="py-3">Thông tin Yêu cầu</th>
                        <th class="py-3">Người gửi (KTV)</th>
                        <th class="py-3 text-end">Tổng tiền vật tư</th>
                        <th class="py-3 text-center">Trạng thái</th>
                        <th class="py-3 text-end pe-4">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty listRequests}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-5">
                                    <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                                    <p class="mb-0">Không có dữ liệu báo giá nào.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${listRequests}" var="req" varStatus="loop">
                                <tr>
                                    <td class="ps-4 fw-bold text-secondary">#${req.id}</td>

                                    <td>
                                        <div class="fw-bold text-dark mb-1">
                                            Máy: <span class="text-primary">
                                                <c:choose>
                                                    <c:when test="${not empty relatedProducts[req.id]}">
                                                        ${relatedProducts[req.id].name} </c:when>
                                                    <c:otherwise>Không xác định</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="small text-muted mb-1">
                                            Mã bảo trì: <strong>#${req.info.maintenanceId}</strong>
                                        </div>
                                        <div class="small text-muted mt-1">
                                            <i class="far fa-clock me-1"></i>
                                            <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </td>

                                    <td>
                                        <div class="small">
                                            <div class="fw-bold text-dark">
                                                <i class="fas fa-user-tie me-1 text-primary"></i>
                                                    <%-- Hiển thị Tên KTV lấy từ Map dựa trên ID của Request --%>
                                                    ${technicianNames[req.id]}
                                            </div>
                                            <div class="text-muted mt-1" style="font-size: 0.8rem;">
                                                    <%-- Hiển thị Mã KTV bóc từ JSON (req.info), bỏ dấu .0 --%>
                                                Mã NV: <fmt:formatNumber value="${req.info.technicianId}" maxFractionDigits="0" />
                                            </div>
                                        </div>
                                    </td>

                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${not empty req.info.partsTotal}">
                                                <div class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${req.info.partsTotal}" pattern="#,###"/> VNĐ
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted fst-italic">Chưa có giá</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${req.status == 'WAITING_STAFF'}">
                                                <span class="badge bg-danger rounded-pill px-3">Cần duyệt</span>
                                            </c:when>
                                            <c:when test="${req.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark rounded-pill px-3">Đã trình Sếp</span>
                                            </c:when>
                                            <c:when test="${req.status == 'APPROVED'}">
                                                <span class="badge bg-success rounded-pill px-3">Đã duyệt</span>
                                            </c:when>


                                            <c:when test="${req.status == 'WAITING_CUSTOMER'}">
                                                <span class="badge bg-info text-dark rounded-pill px-3"><i class="fas fa-hourglass-half me-1"></i>Chờ khách duyệt</span>
                                            </c:when>
                                            <c:when test="${req.status == 'APPROVED_BY_CUSTOMER'}">
                                                <span class="badge bg-primary rounded-pill px-3"><i class="fas fa-check-double me-1"></i>Khách đã duyệt</span>
                                            </c:when>
                                            <c:when test="${req.status == 'REJECTED_BY_CUSTOMER'}">
                                                <span class="badge bg-dark rounded-pill px-3"><i class="fas fa-times me-1"></i>Khách từ chối</span>
                                            </c:when>

                                            <c:when test="${req.status == 'COMPLETED'}">
                                                <span class="badge bg-info rounded-pill px-3">Hoàn thành</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary rounded-pill px-3">${req.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <div class="d-flex justify-content-end gap-2 align-items-center">

                                                <%-- NÚT XEM CHI TIẾT (Luôn luôn hiển thị ở mọi trạng thái) --%>
                                            <a href="<c:url value='/staff/repair-request/view?requestId=${req.id}'/>"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-eye me-1"></i> Xem
                                            </a>

                                                <%-- NÚT GỬI BÁO GIÁ (Chỉ hiện khi Sếp đã duyệt) --%>
                                            <c:if test="${req.status == 'APPROVED'}">
                                                <a href="<c:url value='/staff/repair-request/send-quote?requestId=${req.id}'/>"
                                                   class="btn btn-sm btn-success">
                                                    <i class="fas fa-paper-plane me-1"></i> Gửi báo giá
                                                </a>
                                            </c:if>

                                                <%-- NÚT TẠO HÓA ĐƠN (Chỉ hiện khi đã hoàn thành) --%>
                                            <c:if test="${req.status == 'COMPLETED'}">
                                                <form action="<c:url value='/staff/invoice/create'/>" method="POST" class="m-0 p-0">
                                                    <input type="hidden" name="requestId" value="${req.id}">
                                                    <button type="submit" class="btn btn-sm btn-warning text-dark"
                                                            onclick="return confirm('Bạn có chắc chắn muốn xuất hóa đơn cho yêu cầu #${req.id} này?');">
                                                        <i class="fas fa-file-invoice-dollar me-1"></i> Tạo hóa đơn
                                                    </button>
                                                </form>
                                            </c:if>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <c:if test="${not empty totalPages && totalPages > 1}">
            <div class="card-footer bg-white py-3">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-end mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/staff/repair-request-list'>
                                <c:param name='page' value='${currentPage - 1}'/>
                                <c:param name='status' value='${status}'/>
                                <c:param name='fromDate' value='${fromDate}'/>
                                <c:param name='toDate' value='${toDate}'/>
                            </c:url>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="<c:url value='/staff/repair-request-list'>
                                    <c:param name='page' value='${i}'/>
                                    <c:param name='status' value='${status}'/>
                                    <c:param name='fromDate' value='${fromDate}'/>
                                    <c:param name='toDate' value='${toDate}'/>
                                </c:url>">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/staff/repair-request-list'>
                                <c:param name='page' value='${currentPage + 1}'/>
                                <c:param name='status' value='${status}'/>
                                <c:param name='fromDate' value='${fromDate}'/>
                                <c:param name='toDate' value='${toDate}'/>
                            </c:url>" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</div>