<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Đặt múi giờ mặc định cho toàn trang để hiển thị giờ chuẩn Việt Nam --%>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Hóa đơn | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary"><i class="fas fa-file-invoice-dollar me-2"></i>Quản lý Hóa đơn</h3>
    </div>

    <%-- ========================================== --%>
    <%-- 1. FORM LỌC & TÌM KIẾM                      --%>
    <%-- ========================================== --%>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <%-- Form gọi về StaffManagementController thay vì InvoiceListController --%>
            <form action="<c:url value='/staff/management'/>" method="get" class="row g-3 align-items-end">

                <%-- Bắt buộc: Truyền action để Controller biết điều hướng vào hàm nào --%>
                <input type="hidden" name="action" value="invoice-list">

                <%-- Đặt lại trang về 1 mỗi khi đổi điều kiện lọc --%>
                <input type="hidden" name="page" value="1">

                <%-- Tìm kiếm bằng Từ khóa --%>
                <div class="col-md-4">
                    <label class="form-label fw-bold">Từ khóa</label>
                    <input type="text" name="keyword" class="form-control"
                           placeholder="Mã hóa đơn, tên khách hàng..." value="${keyword}">
                </div>

                <%-- Lọc theo Trạng thái --%>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Trạng thái</label>
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="">-- Tất cả trạng thái --</option>
                        <option value="UNPAID" ${status == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                        <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>

                <%-- Tùy chọn Số bản ghi hiển thị (PageSize) --%>
                <div class="col-md-2">
                    <label class="form-label fw-bold">Hiển thị</label>
                    <select name="pageSize" class="form-select" onchange="this.form.submit()">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 dòng</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 dòng</option>
                        <option value="15" ${pageSize == 15 ? 'selected' : ''}>15 dòng</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 dòng</option>
                    </select>
                </div>

                <%-- Các nút thao tác --%>
                <div class="col-md-3 text-end d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="fas fa-search me-1"></i>Tìm
                    </button>
                    <a href="<c:url value='/staff/management?action=invoice-list'/>" class="btn btn-light border">
                        <i class="fas fa-sync-alt me-1"></i>Đặt lại
                    </a>
                </div>
            </form>
        </div>
    </div>

    <%-- ========================================== --%>
    <%-- 2. BẢNG HIỂN THỊ DỮ LIỆU                    --%>
    <%-- ========================================== --%>
    <div class="card shadow-sm border-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-primary text-white">
                <tr>
                    <th class="ps-4 py-3">Mã Hóa Đơn</th>
                    <th class="py-3">Khách hàng</th>
                    <th class="py-3">Ngày tạo</th>
                    <th class="py-3 text-end">Tổng tiền</th>
                    <th class="py-3 text-center">Trạng thái</th>
                    <th class="pe-4 py-3 text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${invoices}" var="inv">
                    <tr>
                        <td class="ps-4 fw-bold text-primary">${inv.invoiceCode}</td>
                        <td>
                            <div class="fw-bold text-dark">${inv.customerName}</div>
                            <div class="small text-muted">${inv.customerEmail}</div>
                        </td>
                        <td><fmt:formatDate value="${inv.issuedDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="text-end fw-bold text-danger">
                            <fmt:formatNumber value="${inv.totalAmount}" pattern="#,###"/> đ
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${inv.paymentStatus == 'PAID'}">
                                    <span class="badge bg-success rounded-pill px-3 py-2">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${inv.paymentStatus == 'UNPAID'}">
                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-2">Chưa thanh toán</span>
                                </c:when>
                                <c:when test="${inv.paymentStatus == 'CANCELLED'}">
                                    <span class="badge bg-danger rounded-pill px-3 py-2">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary rounded-pill px-3 py-2">${inv.paymentStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="pe-4 text-center">
                            <a href="#" class="btn btn-sm btn-outline-primary rounded-pill px-3" title="Xem chi tiết">
                                <i class="fas fa-eye me-1"></i>Xem
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <%-- Trường hợp không có dữ liệu --%>
                <c:if test="${empty invoices}">
                    <tr>
                        <td colspan="6" class="text-center py-5 text-muted">
                            <i class="fas fa-box-open fa-3x mb-3 opacity-25"></i>
                            <h5>Không tìm thấy dữ liệu hóa đơn nào.</h5>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <%-- ========================================== --%>
        <%-- 3. PHÂN TRANG (PAGINATION)                  --%>
        <%-- ========================================== --%>
        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white py-3">
                <nav>
                    <ul class="pagination justify-content-center mb-0">

                            <%-- Nút Lùi (Previous) --%>
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/staff/management'>
                                <c:param name='action' value='invoice-list'/>
                                <c:param name='page' value='${currentPage - 1}'/>
                                <c:param name='pageSize' value='${pageSize}'/>
                                <c:param name='keyword' value='${keyword}'/>
                                <c:param name='status' value='${status}'/>
                            </c:url>">Trước</a>
                        </li>

                            <%-- Danh sách các số trang --%>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="<c:url value='/staff/management'>
                                    <c:param name='action' value='invoice-list'/>
                                    <c:param name='page' value='${i}'/>
                                    <c:param name='pageSize' value='${pageSize}'/>
                                    <c:param name='keyword' value='${keyword}'/>
                                    <c:param name='status' value='${status}'/>
                                </c:url>">${i}</a>
                            </li>
                        </c:forEach>

                            <%-- Nút Tới (Next) --%>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/staff/management'>
                                <c:param name='action' value='invoice-list'/>
                                <c:param name='page' value='${currentPage + 1}'/>
                                <c:param name='pageSize' value='${pageSize}'/>
                                <c:param name='keyword' value='${keyword}'/>
                                <c:param name='status' value='${status}'/>
                            </c:url>">Sau</a>
                        </li>

                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>