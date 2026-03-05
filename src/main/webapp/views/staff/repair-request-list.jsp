<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<title>Danh sách Báo giá Sửa chữa</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Quản lý Báo giá Sửa chữa (Từ Kỹ thuật viên)</h3>
    </div>

    <div class="d-flex flex-wrap gap-2 mb-3">
        <a href="<c:url value='/staff/customer-requests'/>" class="btn btn-sm btn-outline-primary">
            <i class="fas fa-inbox me-1"></i>Xem yêu cầu từ khách hàng
        </a>
        <a href="<c:url value='/staff/contracts'/>" class="btn btn-sm btn-outline-info">
            <i class="fas fa-file-contract me-1"></i>Danh sách hợp đồng
        </a>
    </div>

    <div class="card shadow mb-4 border-0">
        <div class="card-body bg-light rounded">
            <form action="<c:url value='/staff/repair-request-list'/>" method="get" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label small text-muted mb-1">Trạng thái Báo giá:</label>
                    <select class="form-select" name="status">
                        <option value="">-- Tất cả --</option>
                        <option value="WAITING_STAFF" ${currentStatus == 'WAITING_STAFF' ? 'selected' : '' }>Mới (Chờ xử lý)</option>
                        <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : '' }>Đã trình Manager</option>
                        <option value="APPROVED" ${currentStatus == 'APPROVED' ? 'selected' : '' }>Manager đã duyệt</option>
                        <option value="REJECTED" ${currentStatus == 'REJECTED' ? 'selected' : '' }>Bị từ chối</option>
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
                                            Mã bảo trì: <span class="text-primary">#${req.info.maintenanceId}</span>
                                        </div>
                                        <div class="small text-muted mt-1">
                                            <i class="far fa-clock me-1"></i>
                                            <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </td>

                                    <td>
                                        <div class="small">
                                            <div class="fw-bold text-dark"><i class="fas fa-user-cog me-1"></i> KTV ID: ${req.senderId}</div>
                                            <c:if test="${not empty req.info.technicianId}">
                                                <div class="text-muted">Mã NV: ${req.info.technicianId}</div>
                                            </c:if>
                                        </div>
                                    </td>

                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${not empty req.info.grandTotal}">
                                                <div class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${req.info.grandTotal}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
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
                                            <c:otherwise>
                                                <span class="badge bg-secondary rounded-pill px-3">${req.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <c:choose>
                                            <c:when test="${req.status == 'APPROVED'}">
                                                <a href="<c:url value='/staff/repair-request/send-quote?requestId=${req.id}'/>"
                                                   class="btn btn-sm btn-success">
                                                    <i class="fas fa-paper-plane me-1"></i> Gửi báo giá
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="<c:url value='/staff/repair-request/view?requestId=${req.id}'/>"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye me-1"></i> Xem chi tiết
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
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
                                <c:param name='status' value='${currentStatus}'/>
                            </c:url>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="<c:url value='/staff/repair-request-list'>
                                    <c:param name='page' value='${i}'/>
                                    <c:param name='status' value='${currentStatus}'/>
                                </c:url>">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/staff/repair-request-list'>
                                <c:param name='page' value='${currentPage + 1}'/>
                                <c:param name='status' value='${currentStatus}'/>
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