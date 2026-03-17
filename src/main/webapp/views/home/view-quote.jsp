<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Báo giá Sửa chữa | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root{
            --primary:#4e73df;
            --secondary:#224abe;
            --ink:#101828;
            --muted:#667085;
            --bg:#f6f7fb;
        }

        html, body { height: 100%; }
        body{
            display:flex;
            flex-direction:column;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: var(--bg);
            color: var(--ink);
        }

        /* NAVBAR */
        .navbar-landing{
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 14px 0;
            box-shadow: 0 10px 25px rgba(0,0,0,.08);
        }
        .navbar-brand{ font-weight: 900; color:#fff !important; font-size: 1.6rem; }
        .nav-link{ color: rgba(255,255,255,.92) !important; font-weight: 600; }
        .user-dropdown-toggle{
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 999px; padding: 8px 14px !important; color: #fff !important;
        }

        /* MAIN CONTENT */
        main{ flex:1; padding: 40px 0; }
        .card-custom {
            border-radius: 16px;
            border: none;
            box-shadow: 0 8px 24px rgba(16,24,40,.06);
            overflow: hidden;
            background: #fff;
        }
        .card-header-soft {
            background: #f8fafc;
            border-bottom: 1px solid #eaecf0;
            padding: 16px 20px;
            font-weight: bold;
            color: var(--primary);
        }

        .table th { background: #f8fafc; color: #475467; font-size: 0.85rem; text-transform: uppercase; }
        .total-box { background: #fffcf5; border: 1px dashed #f5c066; border-radius: 12px; padding: 20px; }

        footer{ background:#111827; color:#9ca3af; padding: 26px 0; margin-top: auto; }
        footer a{ color:#fff; text-decoration: none; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-landing">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>"><i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link dropdown-toggle user-dropdown-toggle" href="#" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-1"></i> ${user.fullName}
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<main>
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="fas fa-file-invoice-dollar text-primary me-2"></i>Chi tiết Báo Giá Sửa Chữa</h3>
                <p class="text-muted mb-0">Vui lòng kiểm tra chi phí dự kiến trước khi xác nhận sửa chữa.</p>
            </div>
            <a href="<c:url value='/product-list'/>" class="btn btn-outline-secondary rounded-pill fw-bold px-4">
                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
            </a>
        </div>

        <div class="row g-4">
            <%-- =============================================== --%>
            <%-- CỘT TRÁI: THÔNG TIN THIẾT BỊ & VẬT TƯ             --%>
            <%-- =============================================== --%>
            <div class="col-lg-8">

                <div class="card-custom mb-4">
                    <div class="card-header-soft"><i class="fas fa-server me-2"></i>Thông tin thiết bị</div>
                    <div class="card-body p-4">
                        <div class="row">
                            <div class="col-sm-6 mb-3 mb-sm-0">
                                <div class="text-muted small mb-1">Tên máy / Model:</div>
                                <div class="fw-bold fs-5 text-dark">${product.modelName}</div>
                            </div>
                            <div class="col-sm-6">
                                <div class="text-muted small mb-1">Số Serial:</div>
                                <div class="fw-bold fs-5 text-dark font-monospace">${product.serialNumber}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-custom">
                    <div class="card-header-soft"><i class="fas fa-tools me-2"></i>Đề xuất vật tư thay thế</div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-4">Tên Vật Tư</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-end pe-4">Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty repairRequest.materials}">
                                    <tr><td colspan="4" class="text-center py-4 text-muted">Không có vật tư đề xuất.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${repairRequest.materials}" var="mat">
                                        <tr>
                                            <td class="ps-4 fw-bold text-dark">
                                                <c:choose>
                                                    <c:when test="${not empty mat.partName}">${mat.partName}</c:when>
                                                    <c:otherwise>Vật tư ID: ${mat.sparePartId}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">${mat.quantityUsed}</span>
                                            </td>
                                            <td class="text-end text-muted">
                                                <fmt:formatNumber value="${mat.unitPrice}" pattern="#,###"/> VNĐ
                                            </td>
                                            <td class="text-end pe-4 fw-bold text-primary">
                                                <fmt:formatNumber value="${mat.costAtTime}" pattern="#,###"/> VNĐ
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- =============================================== --%>
            <%-- CỘT PHẢI: TỔNG KẾT CHI PHÍ & NÚT PHẢN HỒI         --%>
            <%-- =============================================== --%>
            <div class="col-lg-4">
                <div class="card-custom position-sticky" style="top: 90px;">
                    <div class="card-header-soft text-center"><i class="fas fa-receipt me-2"></i>Tổng kết chi phí</div>
                    <div class="card-body p-4">

                        <%-- Mở khóa phần Tổng tiền vật tư và Phí nhân công --%>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">Tổng tiền vật tư:</span>
                            <span class="fw-bold"><fmt:formatNumber value="${repairRequest.partsTotal}" pattern="#,###"/> VNĐ</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">Phí nhân công:</span>
                            <span class="fw-bold"><fmt:formatNumber value="${repairRequest.laborCost}" pattern="#,###"/> VNĐ</span>
                        </div>

                        <hr class="my-4 border-secondary opacity-25">

                        <div class="total-box mb-4">
                            <div class="text-center text-uppercase fw-bold text-muted small mb-2">Tổng Thanh Toán</div>
                            <h2 class="fw-bold text-danger text-center mb-0">
                                <%-- Đổi thành grandTotal --%>
                                <fmt:formatNumber value="${repairRequest.grandTotal}" pattern="#,###"/> VNĐ
                            </h2>
                        </div>

                        <c:choose>
                            <c:when test="${systemReq.status == 'WAITING_CUSTOMER'}">
                                <div class="d-grid gap-3">
                                    <button class="btn btn-success btn-lg fw-bold rounded-pill shadow-sm" onclick="submitQuoteResponse('ACCEPT')">
                                        <i class="fas fa-check-circle me-2"></i>Đồng ý Sửa Chữa
                                    </button>
                                    <button class="btn btn-outline-danger fw-bold rounded-pill" onclick="submitQuoteResponse('REJECT')">
                                        <i class="fas fa-times-circle me-2"></i>Từ chối Báo Giá
                                    </button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-secondary text-center fw-bold rounded-3 mb-0">
                                    <i class="fas fa-info-circle me-1"></i> Báo giá này đã được phản hồi.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<footer>
    <div class="container text-center">
        <div class="small">&copy; 2024 Gen-CMS Corporation. Bảo lưu mọi quyền.</div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Hàm xử lý khi khách hàng bấm Đồng ý hoặc Từ chối
    function submitQuoteResponse(action) {
        let confirmMsg = action === 'ACCEPT'
            ? "Bạn xác nhận ĐỒNG Ý với mức phí này? Hệ thống sẽ cử kỹ thuật viên tiến hành sửa chữa ngay."
            : "Bạn chắc chắn muốn TỪ CHỐI báo giá này? Yêu cầu bảo trì sẽ bị hủy.";

        if(confirm(confirmMsg)) {
            // Thay đổi đường dẫn này trỏ tới Controller xử lý của bạn
            const url = "<c:url value='/user/repair-quote/respond'/>?action=" + action + "&requestId=${systemReq.id}&productId=${product.id}";

            fetch(url, { method: 'POST' })
                .then(response => {
                    if(!response.ok) throw new Error("Có lỗi xảy ra, vui lòng thử lại!");
                    return response.text();
                })
                .then(data => {
                    alert(action === 'ACCEPT' ? "Cảm ơn bạn đã xác nhận. Chúng tôi sẽ tiến hành sửa chữa!" : "Đã hủy yêu cầu sửa chữa.");
                    window.location.href = "<c:url value='/product-list'/>"; // Trở về trang danh sách máy
                })
                .catch(err => alert(err.message));
        }
    }
</script>
</body>
</html>