<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn ${invoice.invoiceCode} | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background-color: #f0f2f5; font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }

        /* GIAO DIỆN TỜ GIẤY A4 TRÊN WEB */
        .invoice-wrapper { max-width: 900px; margin: 0 auto; }
        .invoice-paper {
            background: #fff;
            padding: 50px;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        /* TRANG TRÍ HÓA ĐƠN */
        .company-name { font-weight: 800; color: #2563eb; font-size: 1.4rem; letter-spacing: 0.5px; }
        .invoice-title { font-weight: 900; color: #1e293b; font-size: 2rem; letter-spacing: 2px; }
        .section-title { font-weight: 700; color: #475569; border-bottom: 2px solid #e2e8f0; padding-bottom: 5px; margin-bottom: 15px; font-size: 1.1rem; }

        /* BẢNG CHI TIẾT */
        .table-invoice th { background-color: #f8fafc !important; color: #334155; font-weight: 700; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #cbd5e1 !important; padding: 12px; }
        .table-invoice td { padding: 12px; vertical-align: middle; border-bottom: 1px solid #e2e8f0; }
        .summary-row td { border: none; padding: 8px 12px; }
        .grand-total { background-color: #eff6ff; border-radius: 6px; }

        /* PANEL THAO TÁC (KHÔNG IN) */
        .action-panel { background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 40px; border-left: 5px solid #2563eb; }

        /* CSS CHUẨN KHI IN RA GIẤY A4 */
        @media print {
            body { background: #fff !important; margin: 0; padding: 0; }
            .no-print, .navbar-landing, footer { display: none !important; }
            .invoice-wrapper { max-width: 100% !important; margin: 0 !important; width: 100% !important; }
            .invoice-paper { box-shadow: none !important; padding: 0 !important; margin: 0 !important; border-radius: 0 !important; }
            .grand-total { background-color: transparent !important; border: 2px solid #000 !important; }
            .table-invoice th { border-bottom: 2px solid #000 !important; }
            .table-invoice td { border-bottom: 1px solid #ccc !important; }
        }
    </style>
</head>
<body>

<div class="container py-4 invoice-wrapper">

    <%-- CÁC NÚT ĐIỀU HƯỚNG TRÊN CÙNG (ẨN KHI IN) --%>
    <div class="d-flex justify-content-between align-items-center mb-4 no-print">
        <a href="<c:url value='/staff/invoice-list'/>" class="btn btn-outline-secondary rounded-pill px-4 fw-bold">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
        <div>
            <button onclick="window.print()" class="btn btn-primary rounded-pill px-4 shadow-sm fw-bold">
                <i class="fas fa-print me-2"></i>In Hóa Đơn / Xuất PDF
            </button>
        </div>
    </div>

    <%-- THÔNG BÁO HỆ THỐNG (ẨN KHI IN) --%>
    <c:if test="${param.message == 'payment_success'}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm no-print"><i class="fas fa-check-circle me-2"></i> Xác nhận thu tiền thành công! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>

    <%-- ========================================== --%>
    <%-- TỜ HÓA ĐƠN CHÍNH (SẼ ĐƯỢC IN RA)            --%>
    <%-- ========================================== --%>
    <div class="invoice-paper">

        <%-- HEADER HÓA ĐƠN --%>
        <div class="row mb-5 align-items-center">
            <div class="col-sm-6">
                <div class="company-name mb-1"><i class="fas fa-bolt text-warning me-2"></i>GEN-CMS CORPORATION</div>
                <div class="text-muted small lh-lg">
                    <i class="fas fa-map-marker-alt me-2"></i>Khu Công nghệ cao, Quận 9, TP. Hồ Chí Minh<br>
                    <i class="fas fa-phone-alt me-2"></i>Hotline: 1900 8888<br>
                    <i class="fas fa-envelope me-2"></i>Email: billing@gen-cms.vn
                </div>
            </div>
            <div class="col-sm-6 text-sm-end mt-4 mt-sm-0">
                <h1 class="invoice-title mb-2">HÓA ĐƠN</h1>
                <div class="fw-bold text-secondary mb-1">Mã số: ${invoice.invoiceCode}</div>
                <div class="text-muted small">Ngày lập: <fmt:formatDate value="${invoice.issuedDate}" pattern="dd/MM/yyyy" /></div>

                <%-- Trạng thái thanh toán (Hiển thị mộc đóng dấu) --%>
                <div class="mt-3">
                    <c:choose>
                        <c:when test="${invoice.paymentStatus == 'PAID'}">
                            <span class="badge border border-success text-success bg-white px-3 py-2 fs-6 rounded-pill text-uppercase" style="border-width: 2px !important;"><i class="fas fa-check-circle me-1"></i> Đã Thu Tiền</span>
                        </c:when>
                        <c:when test="${invoice.paymentStatus == 'CANCELLED'}">
                            <span class="badge border border-danger text-danger bg-white px-3 py-2 fs-6 rounded-pill text-uppercase" style="border-width: 2px !important;"><i class="fas fa-times-circle me-1"></i> Đã Hủy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge border border-warning text-warning bg-white px-3 py-2 fs-6 rounded-pill text-uppercase" style="border-width: 2px !important;"><i class="fas fa-clock me-1"></i> Chưa Thanh Toán</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%-- THÔNG TIN KHÁCH HÀNG --%>
        <div class="row mb-5">
            <div class="col-sm-12">
                <h5 class="section-title">THÔNG TIN KHÁCH HÀNG (BILL TO)</h5>
                <div class="fw-bold fs-5 mb-1 text-dark">${invoice.customerName}</div>
                <div class="text-muted mb-1"><i class="fas fa-envelope me-2"></i>${invoice.customerEmail}</div>
                <div class="text-muted"><i class="fas fa-file-contract me-2"></i>Tham chiếu Phiếu bảo trì: #<strong>${invoice.maintenanceId}</strong></div>
            </div>
        </div>

        <%-- BẢNG CHI TIẾT DỊCH VỤ --%>
            <%-- BẢNG CHI TIẾT DỊCH VỤ & VẬT TƯ THAY THẾ --%>
            <div class="table-responsive mb-4">
                <table class="table table-invoice mb-0">
                    <thead>
                    <tr>
                        <th width="5%" class="text-center">STT</th>
                        <th width="45%">Nội dung dịch vụ / Tên phụ tùng</th>
                        <th width="15%" class="text-center">Số lượng</th>
                        <th width="15%" class="text-end">Đơn giá</th>
                        <th width="20%" class="text-end">Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <%-- NẾU CÓ CHI TIẾT VẬT TƯ: In ra từng món đồ đã thay --%>
                        <c:when test="${not empty quoteDetails}">
                            <c:forEach items="${quoteDetails}" var="detail" varStatus="loop">
                                <tr>
                                    <td class="text-center fw-bold text-muted">${loop.index + 1}</td>
                                    <td>
                                        <div class="fw-bold text-dark">${detail.description}</div>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge border border-secondary text-dark px-2">${detail.quantity}</span>
                                    </td>
                                    <td class="text-end"><fmt:formatNumber value="${detail.unitPrice}" pattern="#,###"/></td>
                                    <td class="text-end fw-bold text-primary"><fmt:formatNumber value="${detail.totalPrice}" pattern="#,###"/></td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <%-- TRƯỜNG HỢP DỰ PHÒNG: Nếu Hóa đơn không có chi tiết (VD: Hóa đơn cũ), in ra 1 dòng tổng quát --%>
                        <c:otherwise>
                            <tr>
                                <td class="text-center fw-bold">1</td>
                                <td>
                                    <div class="fw-bold text-dark">Chi phí sửa chữa / Bảo trì thiết bị</div>
                                    <div class="small text-muted">Theo yêu cầu bảo trì mã số #${invoice.maintenanceId}</div>
                                </td>
                                <td class="text-center">1</td>
                                <td class="text-end"><fmt:formatNumber value="${invoice.subtotal}" pattern="#,###"/></td>
                                <td class="text-end fw-bold text-primary"><fmt:formatNumber value="${invoice.subtotal}" pattern="#,###"/></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

        <%-- TỔNG KẾT TIỀN --%>
        <div class="row mb-5">
            <div class="col-sm-7 col-12 text-muted small lh-lg">
                <strong>Ghi chú:</strong><br>
                - Hóa đơn có giá trị thanh toán trong vòng 7 ngày kể từ ngày xuất.<br>
                - Vui lòng ghi rõ mã hóa đơn <strong>${invoice.invoiceCode}</strong> trong nội dung chuyển khoản.<br>
                <c:if test="${invoice.paymentStatus == 'PAID' && not empty invoice.note}">
                    - Ghi chú thu tiền: <em>${invoice.note}</em>
                </c:if>
            </div>

            <div class="col-sm-5 col-12">
                <table class="table table-sm table-borderless summary-row text-end">
                    <tr>
                        <td class="text-muted">Cộng tiền dịch vụ:</td>
                        <td class="fw-bold"><fmt:formatNumber value="${invoice.subtotal}" pattern="#,###"/> đ</td>
                    </tr>
                    <tr>
                        <td class="text-muted border-bottom pb-3">Thuế GTGT (VAT <fmt:formatNumber value="${invoice.taxRate}" pattern="#.#"/>%):</td>
                        <td class="fw-bold border-bottom pb-3"><fmt:formatNumber value="${invoice.taxAmount}" pattern="#,###"/> đ</td>
                    </tr>
                    <tr class="grand-total">
                        <td class="pt-3 pb-3 text-uppercase fw-bold text-dark">Tổng tiền thanh toán:</td>
                        <td class="pt-3 pb-3 fw-bold fs-4 text-danger"><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,###"/> đ</td>
                    </tr>
                </table>
            </div>
        </div>

        <%-- CHỮ KÝ --%>
        <div class="row mt-5 pt-4 text-center">
            <div class="col-6">
                <div class="fw-bold text-dark mb-5">Khách hàng</div>
                <div class="text-muted small mt-5">(Ký và ghi rõ họ tên)</div>
            </div>
            <div class="col-6">
                <div class="fw-bold text-dark mb-1">Người lập hóa đơn</div>
                <div class="text-muted small mb-4">Ngày ... tháng ... năm 202...</div>
                <div class="fw-bold mt-4 pt-3">${invoice.createdByName != null ? invoice.createdByName : 'Bộ phận kế toán'}</div>
            </div>
        </div>

    </div>

    <%-- ========================================== --%>
    <%-- PANEL THAO TÁC CỦA STAFF (ẨN KHI IN)        --%>
    <%-- ========================================== --%>
    <c:if test="${invoice.paymentStatus == 'UNPAID'}">
        <div class="action-panel no-print">
            <h5 class="fw-bold mb-4"><i class="fas fa-keyboard me-2"></i>Thao tác dành cho Nhân viên</h5>

            <div class="row g-5">
                    <%-- CẬP NHẬT THUẾ --%>
                <div class="col-md-5 border-end">
                    <h6 class="fw-bold text-muted small text-uppercase mb-3">1. Điều chỉnh mức thuế VAT</h6>
                    <form action="<c:url value='/staff/invoice/detail'/>" method="post" class="d-flex align-items-center">
                        <input type="hidden" name="action" value="update_tax">
                        <input type="hidden" name="invoiceId" value="${invoice.id}">

                        <div class="input-group">
                            <input type="number" step="0.1" min="0" max="100" name="taxRate" class="form-control" value="${invoice.taxRate}">
                            <span class="input-group-text bg-light fw-bold">%</span>
                            <button class="btn btn-outline-primary fw-bold px-4" type="submit">Cập nhật</button>
                        </div>
                    </form>
                    <div class="small text-muted mt-2">Tổng tiền sẽ được hệ thống tự động tính lại.</div>
                </div>

                    <%-- XÁC NHẬN THU TIỀN --%>
                <div class="col-md-7">
                    <h6 class="fw-bold text-muted small text-uppercase mb-3">2. Xác nhận khách đã thanh toán</h6>
                    <form action="<c:url value='/staff/invoice/detail'/>" method="post" onsubmit="return confirm('Xác nhận đã thu đủ tiền từ khách hàng này?');">
                        <input type="hidden" name="action" value="confirm_payment">
                        <input type="hidden" name="invoiceId" value="${invoice.id}">

                        <div class="row g-3">
                            <div class="col-sm-5">
                                <select name="paymentMethod" class="form-select" required>
                                    <option value="Chuyển khoản">Chuyển khoản</option>
                                    <option value="Tiền mặt">Tiền mặt</option>
                                </select>
                            </div>
                            <div class="col-sm-7">
                                <input type="text" name="note" class="form-control" placeholder="Ghi chú (Mã giao dịch...)">
                            </div>
                            <div class="col-12 mt-3">
                                <button type="submit" class="btn btn-success w-100 rounded-pill fw-bold py-2">
                                    <i class="fas fa-check-circle me-2"></i>Chốt hóa đơn & Đã thu tiền
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:if>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>