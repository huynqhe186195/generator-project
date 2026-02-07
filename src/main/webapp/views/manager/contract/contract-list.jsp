<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <title>Danh sách Hợp đồng</title>
</head>

<body>
<div class="container-fluid">
    <h2 class="mb-4 text-primary fw-bold">Quản lý Hợp đồng Bảo trì</h2>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm border-danger">
            <h5 class="alert-heading fs-6"><i class="fa fa-exclamation-triangle"></i> Có lỗi xảy ra!</h5>
            <p class="mb-0">${errorMessage}</p>

            <c:if test="${not empty missingEmail}">
                <hr>
                <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-2">
                        <span>
                            <i class="fa fa-user-times"></i> Email <strong>${missingEmail}</strong> chưa có tài khoản.
                            Bạn có muốn gửi yêu cầu Admin tạo mới không?
                        </span>

                    <form action="${pageContext.request.contextPath}/manager/contracts" method="post" class="d-inline">
                        <input type="hidden" name="action" value="request_account">
                        <input type="hidden" name="email" value="${missingEmail}">
                        <input type="hidden" name="fullName" value="${missingFullName}">
                        <input type="hidden" name="phone" value="${missingPhone}">

                        <button type="submit" class="btn btn-warning btn-sm fw-bold text-dark shadow-sm">
                            <i class="fa fa-paper-plane"></i> Gửi yêu cầu ngay
                        </button>
                    </form>
                </div>
            </c:if>

            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.msg == 'success'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fa fa-file-import"></i> Import hợp đồng thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.msg == 'create_success'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fa fa-check-circle"></i> Tạo mới hợp đồng thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.msg == 'request_success'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fa fa-check-circle"></i> Đã gửi yêu cầu tạo tài khoản thành công! Vui lòng chờ Admin duyệt.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.msg == 'request_duplicate'}">
        <div class="alert alert-warning alert-dismissible fade show">
            <i class="fa fa-clock"></i> Yêu cầu cho email này đang chờ xử lý. Không cần gửi lại.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.msg == 'update_success'}">
        <div class="alert alert-info alert-dismissible fade show">
            <i class="fa fa-save"></i> Cập nhật thông tin thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.msg == 'delete_success'}">
        <div class="alert alert-warning alert-dismissible fade show">
            <i class="fa fa-trash"></i> Đã xóa hợp đồng khỏi hệ thống.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-center">
                <div class="col-md-8">
                    <form action="${pageContext.request.contextPath}/manager/contracts" method="get" class="d-flex gap-2">
                        <input type="hidden" name="action" value="list">

                        <div class="input-group">
                            <span class="input-group-text"><i class="fa fa-search"></i></span>
                            <input type="text" name="keyword" class="form-control"
                                   placeholder="Nhập số HĐ, Email khách, Serial máy..."
                                   value="${currentKeyword}">
                        </div>

                        <select name="status" class="form-select w-25">
                            <option value="">- Tất cả trạng thái -</option>
                            <option value="PENDING_SERIAL" ${currentStatus == 'PENDING_SERIAL' ? 'selected' : ''}>
                                Chưa gán serial
                            </option>
                            <option value="ACTIVE" ${currentStatus == 'ACTIVE' ? 'selected' : ''}>Đang hiệu lực</option>
                            <option value="EXPIRED" ${currentStatus == 'EXPIRED' ? 'selected' : ''}>Hết hạn</option>
                            <option value="TERMINATED" ${currentStatus == 'TERMINATED' ? 'selected' : ''}>Đã hủy</option>
                        </select>

                        <button type="submit" class="btn btn-primary px-4">Lọc</button>
                    </form>
                </div>

                <div class="col-md-4 text-end">
                    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#importModal">
                        <i class="fa fa-file-word"></i> Import từ File
                    </button>
                    <a href="${pageContext.request.contextPath}/manager/contracts?action=create_view" class="btn btn-outline-primary">
                        <i class="fa fa-plus"></i> Tạo mới
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover table-striped mb-0 align-middle">
                <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Số Hợp đồng</th>
                    <th>Khách hàng</th>
                    <th>Hiệu lực từ</th>
                    <th>Đến ngày</th>
                    <th>Trạng thái</th>
                    <th class="text-center" style="width: 150px;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${contracts}" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <td class="fw-bold text-primary">${c.contractNumber}</td>
                        <td>${c.customerName}</td>
                        <td>${c.startDate}</td>
                        <td>${c.endDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${c.status == 'PENDING_SERIAL'}">
                                    <span class="badge bg-warning text-dark">Chưa gán serial</span>
                                </c:when>
                                <c:when test="${c.status == 'ACTIVE'}">
                                    <span class="badge bg-success">Hiệu lực</span>
                                </c:when>
                                <c:when test="${c.status == 'EXPIRED'}">
                                    <span class="badge bg-danger">Hết hạn</span>
                                </c:when>
                                <c:when test="${c.status == 'TERMINATED'}">
                                    <span class="badge bg-secondary">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${c.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/manager/contracts?action=detail&id=${c.id}"
                               class="btn btn-sm btn-info" title="Xem chi tiết">
                                <i class="fa fa-eye"></i>
                            </a>

                            <a href="${pageContext.request.contextPath}/manager/contracts?action=edit_view&id=${c.id}"
                               class="btn btn-sm btn-warning" title="Sửa thông tin">
                                <i class="fa fa-edit"></i>
                            </a>

                            <a href="${pageContext.request.contextPath}/manager/contracts?action=delete&id=${c.id}"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn xóa Hợp đồng số ${c.contractNumber}?\\nDữ liệu sẽ không thể khôi phục!');"
                               title="Xóa hợp đồng">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty contracts}">
                    <tr>
                        <td colspan="8" class="text-center py-4 text-muted">
                            <i class="fa fa-box-open fa-2x mb-2"></i><br>
                            Không tìm thấy hợp đồng nào phù hợp.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="importModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/manager/contracts" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="import">

                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="fa fa-file-word"></i> Import Hợp đồng</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Chọn file Word (.docx)</label>
                        <input type="file" name="contractFile" class="form-control" accept=".docx" required>
                    </div>
                    <div class="alert alert-info small">
                        <strong>Lưu ý định dạng file:</strong>
                        <ul class="mb-0 ps-3">
                            <li>Phải có dòng: <code>Số : .../HĐMB</code></li>
                            <li>Phải có email khách tại Bên A: <code>Email: ...</code></li>
                            <li><b>Luồng mới:</b> file có/không có serial đều import được; serial sẽ gán ở màn riêng.</li>
                        </ul>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-success">Tải lên & Xử lý</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
