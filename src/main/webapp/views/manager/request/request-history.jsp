<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <title>Quản lý Yêu cầu</title>
</head>

<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary"><i class="fa fa-paper-plane"></i> Yêu cầu gửi Admin</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createRequestModal">
            <i class="fa fa-plus-circle"></i> Tạo yêu cầu mới
        </button>
    </div>

    <c:if test="${param.msg == 'success'}">
        <div class="alert alert-success">Gửi yêu cầu thành công! Admin sẽ nhận được ngay.</div>
    </c:if>
    <c:if test="${param.msg == 'duplicate'}">
        <div class="alert alert-warning">Yêu cầu cho Email này đang chờ xử lý rồi!</div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Loại yêu cầu</th>
                        <th>Nội dung gửi</th>
                        <th>Ngày gửi</th>
                        <th>Trạng thái</th>
                        <th>Phản hồi của Admin</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${requests}">
                        <tr>
                            <td>#${req.id}</td>
                            <td>
                                <c:if test="${req.requestType == 'CREATE_USER'}">
                                    <span class="badge bg-info text-dark">Tạo tài khoản</span>
                                </c:if>
                                <c:if test="${req.requestType != 'CREATE_USER'}">
                                    ${req.requestType}
                                </c:if>
                            </td>
                            <td><code class="text-muted small">${req.requestData}</code></td>
                            <td>${req.createdAt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${req.status == 'PENDING'}">
                                        <span class="badge bg-warning text-dark">Đang chờ</span>
                                    </c:when>
                                    <c:when test="${req.status == 'APPROVED'}">
                                        <span class="badge bg-success">Đã duyệt</span>
                                    </c:when>
                                    <c:when test="${req.status == 'REJECTED'}">
                                        <span class="badge bg-danger">Bị từ chối</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td class="text-danger fw-bold">${req.responseMessage}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requests}">
                        <tr><td colspan="6" class="text-center">Bạn chưa gửi yêu cầu nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="createRequestModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="requests" method="post">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Gửi yêu cầu cấp tài khoản</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create_account">

                        <div class="mb-3">
                            <label class="form-label">Email khách hàng <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control" required placeholder="customer@example.com">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" class="form-control" required placeholder="Nguyễn Văn A">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" placeholder="0912...">
                        </div>

                        <div class="alert alert-info small">
                            <i class="fa fa-info-circle"></i> Sau khi Admin duyệt, mật khẩu sẽ được gửi tự động vào email này.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Gửi ngay</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>