<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <head>
                    <title>Duyệt yêu cầu hệ thống</title>
                </head>

                <body>
                    <div class="card shadow-sm">
                        <div
                            class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-tasks me-2"></i> Danh sách yêu cầu cần duyệt</h5>
                            <span class="badge bg-light text-primary">Chờ xử lý: ${requests.size()}</span>
                        </div>

                        <div class="card-body">
                            <c:if test="${param.msg == 'success'}">
                                <div class="alert alert-success alert-dismissible fade show">
                                    <i class="fas fa-check-circle"></i> Xử lý yêu cầu thành công!
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            <c:if test="${param.msg == 'error'}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fas fa-exclamation-circle"></i> Đã xảy ra lỗi: ${not empty flashError ?
                                    flashError : "Có lỗi xảy ra trong quá trình xử lý yêu cầu."}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            <c:if test="${param.msg == 'not_found'}">
                                <div class="alert alert-warning alert-dismissible fade show">
                                    <i class="fas fa-file-excel"></i> Không tìm thấy file Excel của request này.
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <div class="table-responsive">
                                <table class="table table-hover table-bordered align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="text-center">ID</th>
                                            <th>Người gửi</th>
                                            <th>Loại yêu cầu</th>
                                            <th>Chi tiết yêu cầu</th>
                                            <th>Ngày gửi</th>
                                            <th class="text-center" style="width: 200px;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="req" items="${requests}">
                                            <tr>
                                                <td class="text-center fw-bold text-muted">#${req.id}</td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-light rounded-circle p-2 me-2">
                                                            <i class="fas fa-user-tie text-secondary"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Manager ID: ${req.senderId}</strong><br>
                                                            <small class="text-muted">Quản lý</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${req.requestType == 'CREATE_USER'}">
                                                            <span class="badge bg-info text-dark">
                                                                <i class="fas fa-user-plus"></i> Tạo tài khoản
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${req.requestType == 'NEW_USER'}">
                                                            <span class="badge bg-primary">
                                                                <i class="fas fa-file-excel"></i> Import user từ Excel
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${req.requestType}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:set var="payload" value="${requestPayloads[req.id]}" />
                                                    <c:choose>
                                                        <c:when test="${req.requestType == 'CREATE_USER'}">
                                                            <div class="small">
                                                                <div><span class="text-muted">Họ tên:</span>
                                                                    <strong>${payload['fullName']}</strong></div>
                                                                <div><span class="text-muted">Email:</span>
                                                                    <strong>${payload['email']}</strong></div>
                                                                <div><span class="text-muted">SĐT:</span>
                                                                    <strong>${payload['phone']}</strong></div>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${req.requestType == 'NEW_USER'}">
                                                            <div class="small">
                                                                <div><span class="text-muted">File Excel:</span>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty payload['excelFileUrl']}">
                                                                            <code>${payload['excelFileUrl']}</code>
                                                                        </c:when>
                                                                        <c:otherwise>Không có dữ liệu</c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <c:if test="${not empty payload['uploadedAt']}">
                                                                    <div><span class="text-muted">Uploaded:</span>
                                                                        ${payload['uploadedAt']}</div>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="small text-muted"
                                                                style="max-width: 460px; white-space: pre-wrap; word-break: break-word;">
                                                                ${fn:escapeXml(req.requestData)}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <i class="far fa-clock me-1"></i> ${req.createdAt}
                                                </td>
                                                <td class="text-center">
                                                    <c:if test="${req.requestType == 'NEW_USER'}">
                                                        <a class="btn btn-outline-primary btn-sm mb-1"
                                                            href="<c:url value='/admin/requests?action=download&id=${req.id}'/>">
                                                            <i class="fas fa-download"></i> Tải file
                                                        </a>
                                                        <br>
                                                    </c:if>

                                                    <button type="button" class="btn btn-success btn-sm"
                                                        data-request-id="${req.id}"
                                                        data-request-type="${fn:escapeXml(req.requestType)}"
                                                        onclick="openApproveModal(this)">
                                                        <c:choose>
                                                            <c:when test="${req.requestType == 'NEW_USER'}">
                                                                <button type="submit" class="btn btn-success btn-sm"
                                                                    onclick="return confirm('Xác nhận import user từ file Excel và duyệt request?')">
                                                                    <i class="fas fa-check"></i> Import &amp; Hoàn thành
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-check"></i> Duyệt
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </button>

                                                    <button type="button" class="btn btn-danger btn-sm"
                                                        onclick="openRejectModal(${req.id})">
                                                        <i class="fas fa-times"></i> Hủy
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty requests}">
                                            <tr>
                                                <td colspan="6" class="text-center py-5 text-muted">
                                                    <i class="fas fa-clipboard-check fa-3x mb-3"></i><br>
                                                    Không có yêu cầu nào đang chờ xử lý.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="modal fade" id="rejectModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="<c:url value='/admin/requests'/>" method="post">
                                    <div class="modal-header bg-danger text-white">
                                        <h5 class="modal-title">Từ chối yêu cầu</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="reject">
                                        <input type="hidden" name="requestId" id="rejectIdInput">

                                        <div class="mb-3">
                                            <label class="form-label">Lý do từ chối:</label>
                                            <textarea name="adminNote" class="form-control" rows="3" required
                                                placeholder="Nhập lý do..."></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="modal fade" id="approveModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="<c:url value='/admin/requests'/>" method="post">
                                    <div class="modal-header bg-success text-white">
                                        <h5 class="modal-title" id="approveModalTitle">Duyệt yêu cầu</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="requestId" id="approveIdInput">

                                        <div class="mb-0">
                                            <label class="form-label">Phản hồi gửi Manager:</label>
                                            <textarea name="responseMessage" class="form-control" rows="3" required
                                                placeholder="Nhập phản hồi..."></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-success">Xác nhận duyệt</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <script>
                        function openRejectModal(id) {
                            document.getElementById('rejectIdInput').value = id;
                            var myModal = new bootstrap.Modal(document.getElementById('rejectModal'));
                            myModal.show();
                        }

                        function openApproveModal(button) {
                            const id = button.getAttribute('data-request-id');
                            const requestType = button.getAttribute('data-request-type');
                            document.getElementById('approveIdInput').value = id;
                            const title = document.getElementById('approveModalTitle');
                            if (title) {
                                title.textContent = requestType === 'NEW_USER' ? 'Import user & duyệt yêu cầu' : 'Duyệt yêu cầu tạo tài khoản';
                            }
                            var myModal = new bootstrap.Modal(document.getElementById('approveModal'));
                            myModal.show();
                        }
                    </script>
                </body>
