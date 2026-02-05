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
                        <option value="NEW" ${param.status == 'NEW' ? 'selected' : ''}>Mới (Cần xử lý)</option>
                        <option value="VERIFIED" ${param.status == 'VERIFIED' ? 'selected' : ''}>Đã xác minh</option>
                        <option value="WAITING_MANAGER" ${param.status == 'WAITING_MANAGER' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
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
                            <td class="ps-4 fw-bold text-secondary">${(currentPage - 1) * 5 + loop.index + 1}</td>

                            <td>
                                <div>
                                    <span class="badge bg-warning text-dark mb-1">
                                        <c:choose>
                                            <c:when test="${req.info.issueType == 'MAINTENANCE'}">Bảo dưỡng</c:when>
                                            <c:when test="${req.info.issueType == 'REPLACEMENT'}">Thay phụ tùng</c:when>
                                            <c:when test="${req.info.issueType == 'BROKEN'}">Lỗi / Hỏng</c:when>
                                            <c:when test="${req.info.issueType == 'OTHER'}">Vấn đề khác</c:when>
                                            <c:otherwise>${not empty req.info.issueType ? req.info.issueType : 'Sự cố khác'}</c:otherwise>
                                            </c:choose>
                                    </span>
                                    <div class="fw-bold text-truncate" style="max-width: 250px;" title="${req.info.title}">
                                            ${req.info.title}
                                    </div>
                                    <div class="small text-muted mt-1">
                                        <i class="far fa-clock me-1"></i> <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <div class="small">
                                    <c:choose>
                                        <c:when test="${not empty prod}">
                                            <div class="fw-bold text-primary"><i class="fas fa-server me-1"></i> ${prod.modelName}</div>
                                            <div class="text-muted"><i class="fas fa-barcode me-1"></i> ${prod.serialNumber}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-danger"><i class="fas fa-exclamation-circle me-1"></i> Không tìm thấy (ID: ${req.info.productId})</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>

                            <td>
                                <div class="small">
                                    <div class="fw-bold">${req.info.reporterName}</div>
                                    <div class="text-muted"><i class="fas fa-phone-alt me-1"></i> ${req.info.reporterPhone}</div>
                                </div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${req.status == 'NEW'}"><span class="badge bg-danger rounded-pill">Mới</span></c:when>
                                    <c:when test="${req.status == 'VERIFIED'}"><span class="badge bg-info text-dark rounded-pill">Đã xác minh</span></c:when>
                                    <c:when test="${req.status == 'WAITING_MANAGER'}"><span class="badge bg-warning text-dark rounded-pill">Chờ duyệt</span></c:when>
                                    <c:when test="${req.status == 'APPROVED'}"><span class="badge bg-primary rounded-pill">Đã duyệt</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary rounded-pill">${req.status}</span></c:otherwise>
                                </c:choose>
                            </td>

                            <td class="text-end pe-4">
                                <c:choose>
                                    <c:when test="${req.status == 'NEW'}">
                                        <a href="<c:url value='/staff/incident/verify?id=${req.id}'/>" class="btn btn-sm btn-outline-danger">
                                            <i class="fas fa-check-circle me-1"></i> Xác minh
                                        </a>
                                    </c:when>
                                    <c:when test="${req.status == 'VERIFIED'}">
                                        <a href="<c:url value='/staff/incident/escalate?id=${req.id}'/>" class="btn btn-sm btn-primary">
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
                        <a class="page-link"
                           href="<c:url value='/staff/incident-list'>
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
                            <a class="page-link"
                               href="<c:url value='/staff/incident-list'>
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
                        <a class="page-link"
                           href="<c:url value='/staff/incident-list'>
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