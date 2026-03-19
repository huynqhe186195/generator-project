<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo sự cố | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root{ --primary:#4e73df; --secondary:#224abe; --bg:#f6f7fb; }
        body{ background: var(--bg); font-family: 'Segoe UI', sans-serif; }

        .navbar-landing{
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 14px 0;
        }
        .navbar-brand{ font-weight: 900; color:#fff !important; font-size: 1.6rem; }

        .report-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: none;
            overflow: hidden;
        }
        .report-header {
            background: #dc3545;
            color: white;
            padding: 20px;
            text-align: center;
        }

        /* Style cho ô Read-only máy */
        .device-badge {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
            padding: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            font-weight: bold;
        }

        .form-label {
            font-weight: 700;
            color: #555;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-landing">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>"><i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS</a>
        <div class="ms-auto text-white">Xin chào, <strong>${user.fullName}</strong></div>
    </div>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">

            <div class="mb-4">
                <a href="javascript:history.back()" class="text-decoration-none text-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>
            </div>

            <div class="card report-card">
                <div class="report-header">
                    <h4 class="mb-0 fw-bold"><i class="fas fa-exclamation-triangle me-2"></i>Báo Cáo Sự Cố</h4>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="<c:url value='/customer/incident/create'/>" method="POST">

                        <div class="mb-4">
                            <label class="form-label">Thiết bị gặp sự cố <span class="text-danger">*</span></label>

                            <c:set var="targetContract" value="" />
                            <c:forEach items="${myContracts}" var="c">
                                <c:if test="${c.productId == param.productId}">
                                    <c:set var="targetContract" value="${c}" />
                                </c:if>
                            </c:forEach>

                            <c:choose>
                                <%-- TRƯỜNG HỢP 1: Đã chọn máy từ trước (Hiển thị cố định) --%>
                                <c:when test="${not empty targetContract}">
                                    <div class="device-badge">
                                        <i class="fas fa-server fa-2x me-3"></i>
                                        <div>
                                            <div class="text-uppercase small text-muted">Máy phát điện:</div>
                                            <div class="fs-5 text-dark">
                                                    ${targetContract.productName}
                                            </div>
                                            <div class="small text-muted">
                                                SN: <span class="font-monospace fw-bold">${targetContract.serialNumber}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="hidden" name="contractId" value="${targetContract.id}">
                                </c:when>

                                <%-- TRƯỜNG HỢP 2: Chọn từ danh sách --%>
                                <c:otherwise>
                                    <select name="contractId" class="form-select py-3" required>
                                        <option value="">-- Vui lòng chọn máy --</option>
                                        <c:forEach items="${myContracts}" var="c">
                                            <option value="${c.id}">
                                                    ${c.productName} - (SN: ${c.serialNumber})
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="form-text mt-2">Chọn máy theo Tên và số Serial.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="form-label">Loại sự cố <span class="text-danger">*</span></label>
                                <select name="issueType" class="form-select py-2" required>
                                    <option value="">-- Chọn loại yêu cầu --</option>
                                    <option value="MAINTENANCE">Bảo dưỡng định kỳ</option>
                                    <option value="REPLACEMENT">Thay thế phụ tùng</option>
                                    <option value="BROKEN">Báo Lỗi / Hỏng hóc</option>
                                    <option value="OTHER">Vấn đề khác</option>
                                </select>
                            </div>

                            <div class="col-md-6 mb-4">
                                <label class="form-label">Ngày đề xuất kiểm tra</label>
                                <input type="date" name="preferredDate" class="form-control py-2">
                                <div class="form-text small">Để trống nếu cần gấp ngay lập tức.</div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Tiêu đề ngắn <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control py-2" placeholder="VD: Máy kêu to khi chạy tải..." required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Mô tả chi tiết hiện tượng</label>
                            <textarea name="description" class="form-control" rows="5" placeholder="Mô tả kỹ hơn: Đèn báo lỗi gì sáng? Xảy ra khi nào?"></textarea>
                        </div>

                        <div class="d-flex justify-content-end gap-3 mt-5">
                            <a href="javascript:history.back()" class="btn btn-light px-4">Hủy bỏ</a>
                            <button type="submit" class="btn btn-danger px-5 fw-bold shadow-sm">
                                <i class="fas fa-paper-plane me-2"></i>Gửi Báo Cáo
                            </button>
                        </div>

                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="/views/customer/common/ai-chat-widget.jsp" />

</body>
</html>