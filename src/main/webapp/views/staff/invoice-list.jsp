<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<%-- CHỈ CẦN THẺ TITLE (Sitemesh sẽ tự bốc thẻ này nhét lên Head của file Decorator) --%>
<title>Quản lý Hóa đơn | Gen-CMS</title>

<%-- TOÀN BỘ PHẦN BODY CHÍNH CỦA TRANG (Không có navbar, không có footer) --%>
<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary"><i class="fas fa-file-invoice-dollar me-2"></i>Quản lý Hóa đơn</h3>
    </div>

    <%-- 1. FORM LỌC & TÌM KIẾM --%>
    <div class="card shadow-sm border-0 mb-4 rounded-4">
        <div class="card-body p-4">
            <form action="<c:url value='/staff/management'/>" method="get" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="invoice-list">
                <input type="hidden" name="page" value="1">

                <div class="col-md-4">
                    <label class="form-label fw-bold text-muted small">TỪ KHÓA</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="keyword" class="form-control border-start-0 ps-0 bg-light"
                               placeholder="Mã hóa đơn, tên khách hàng..." value="${keyword}">
                    </div>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold text-muted small">TRẠNG THÁI</label>
                    <select name="status" class="form-select bg-light" onchange="this.form.submit()">
                        <option value="">-- Tất cả trạng thái --</option>
                        <option value="UNPAID" ${status == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                        <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-bold text-muted small">HIỂN THỊ</label>
                    <select name="pageSize" class="form-select bg-light" onchange="this.form.submit()">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 dòng</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 dòng</option>
                        <option value="15" ${pageSize == 15 ? 'selected' : ''}>15 dòng</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 dòng</option>
                    </select>
                </div>

                <div class="col-md-3 text-end d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-primary px-4 rounded-pill fw-bold shadow-sm">Tìm kiếm</button>
                    <a href="<c:url value='/staff/management?action=invoice-list'/>" class="btn btn-light border rounded-pill px-4 fw-bold">Đặt lại</a>
                </div>
            </form>
        </div>
    </div>

    <%-- 2. BẢNG HIỂN THỊ DỮ LIỆU --%>
    <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-primary text-white">
                <tr>
                    <th class="ps-4 py-3 text-uppercase font-weight-bold" style="font-size: 0.85rem">Mã Hóa Đơn</th>
                    <th class="py-3 text-uppercase font-weight-bold" style="font-size: 0.85rem">Khách hàng</th>
                    <th class="py-3 text-uppercase font-weight-bold" style="font-size: 0.85rem">Ngày tạo</th>
                    <th class="py-3 text-end text-uppercase font-weight-bold" style="font-size: 0.85rem">Tổng tiền</th>
                    <th class="py-3 text-center text-uppercase font-weight-bold" style="font-size: 0.85rem">Trạng thái</th>
                    <th class="pe-4 py-3 text-center text-uppercase font-weight-bold" style="font-size: 0.85rem">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${invoices}" var="inv">
                    <tr>
                        <td class="ps-4 fw-bold text-primary font-monospace">${inv.invoiceCode}</td>
                        <td>
                            <div class="fw-bold text-dark">${inv.customerName}</div>
                            <div class="small text-muted"><i class="fas fa-envelope me-1"></i>${inv.customerEmail}</div>
                        </td>
                        <td><fmt:formatDate value="${inv.issuedDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="text-end fw-bold text-danger"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,###"/> đ</td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${inv.paymentStatus == 'PAID'}">
                                    <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2"><i class="fas fa-check-circle me-1"></i>Đã thanh toán</span>
                                </c:when>
                                <c:when test="${inv.paymentStatus == 'UNPAID'}">
                                    <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3 py-2"><i class="fas fa-clock me-1"></i>Chưa thanh toán</span>
                                </c:when>
                                <c:when test="${inv.paymentStatus == 'CANCELLED'}">
                                    <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-2"><i class="fas fa-times-circle me-1"></i>Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary rounded-pill px-3 py-2">${inv.paymentStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="pe-4 text-center">
                            <a href="<c:url value='/staff/invoice/detail?id=${inv.id}'/>" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-bold" title="Xem chi tiết">
                                <i class="fas fa-eye me-1"></i>Xem
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty invoices}">
                    <tr>
                        <td colspan="6" class="text-center py-5 text-muted">
                            <i class="fas fa-box-open fa-3x mb-3 opacity-25"></i>
                            <h5 class="fw-bold">Không tìm thấy dữ liệu hóa đơn nào.</h5>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <%-- 3. PHÂN TRANG --%>
        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white py-3 border-top-0">
                <nav>
                    <ul class="pagination justify-content-center mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link shadow-sm border-0" href="<c:url value='/staff/management'><c:param name='action' value='invoice-list'/><c:param name='page' value='${currentPage - 1}'/><c:param name='pageSize' value='${pageSize}'/><c:param name='keyword' value='${keyword}'/><c:param name='status' value='${status}'/></c:url>">Trước</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link shadow-sm border-0 mx-1 rounded-2" href="<c:url value='/staff/management'><c:param name='action' value='invoice-list'/><c:param name='page' value='${i}'/><c:param name='pageSize' value='${pageSize}'/><c:param name='keyword' value='${keyword}'/><c:param name='status' value='${status}'/></c:url>">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link shadow-sm border-0" href="<c:url value='/staff/management'><c:param name='action' value='invoice-list'/><c:param name='page' value='${currentPage + 1}'/><c:param name='pageSize' value='${pageSize}'/><c:param name='keyword' value='${keyword}'/><c:param name='status' value='${status}'/></c:url>">Sau</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</div>