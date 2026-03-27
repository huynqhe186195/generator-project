<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<title>Hóa đơn ${invoice.invoiceCode} | Gen-CMS</title>

<style>
    /* GIAO DIỆN TỜ GIẤY A4 TRÊN WEB */
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
    .action-panel {
        background: #fff;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.06);
        border-top: 5px solid #0d6efd;
    }

    /* CSS CHUẨN KHI IN RA GIẤY A4 */
    /* CSS CHUẨN KHI IN RA GIẤY A4 */
    /* CSS CHUẨN KHI IN RA GIẤY A4 */
    @media print {
        /* 1. Giao việc căn lề cho trình duyệt (Lề 1.5cm an toàn) */
        @page {
            size: A4 portrait;
            margin: 15mm;
        }

        /* 2. Reset Body: Tuyệt đối KHÔNG dùng padding ở body khi in */
        body {
            background: #fff !important;
            margin: 0 !important;
            padding: 0 !important;
            width: 100% !important;
        }

        /* 3. Ép khung Container của Bootstrap co lại vừa khít 100% tờ giấy */
        .container, .container-fluid, .container-xl, .container-lg {
            width: 100% !important;
            max-width: 100% !important;
            min-width: 100% !important;
            padding: 0 !important;
            margin: 0 !important;
        }

        /* 4. ẨN TRIỆT ĐỂ mọi râu ria của Layout (Nút bấm, Menu...) */
        .no-print, header, footer, aside, nav, .sidebar, #sidebar, .topbar, .navbar, button, .menu-toggle {
            display: none !important;
        }

        /* 5. Cột trái (Tờ hóa đơn) chiếm trọn vẹn 100% chiều ngang */
        .col-lg-8 {
            flex: 0 0 100% !important;
            max-width: 100% !important;
            width: 100% !important;
            padding: 0 !important;
        }

        /* 6. Ẩn hoàn toàn cột Panel thao tác bên phải */
        .col-lg-4 {
            display: none !important;
        }

        /* 7. Reset ranh giới tờ giấy trên web để hòa làm 1 với giấy A4 thật */
        .invoice-paper {
            box-shadow: none !important;
            padding: 0 !important;
            margin: 0 !important;
            border: none !important;
        }

        /* 8. Fix lỗi âm lề (Negative Margin) của Bootstrap làm tràn viền */
        .row {
            margin-left: 0 !important;
            margin-right: 0 !important;
        }

        .table-invoice th { border-bottom: 2px solid #000 !important; color: #000 !important; }
        .table-invoice td { border-bottom: 1px solid #ccc !important; color: #000 !important; }
    }
</style>

<%-- Dùng container-xl để có đủ không gian rộng cho 2 cột chạy song song --%>
<div class="container-xl py-4">

    <%-- CÁC NÚT ĐIỀU HƯỚNG TRÊN CÙNG (ẨN KHI IN) --%>
    <div class="d-flex justify-content-between align-items-center mb-4 no-print">
        <a href="<c:url value='/staff/invoice-list'/>" class="btn btn-outline-secondary rounded-pill px-4 fw-bold">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
        <div>
            <button onclick="window.print()" class="btn btn-secondary rounded-pill px-4 shadow-sm fw-bold">
                <i class="fas fa-print me-2"></i>In Hóa Đơn / Xuất PDF
            </button>
        </div>
    </div>

    <%-- THÔNG BÁO HỆ THỐNG (ẨN KHI IN) --%>
    <c:if test="${param.message == 'tax_updated'}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm no-print"><i class="fas fa-check-circle me-2"></i> Đã cập nhật lại mức Thuế VAT! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${param.message == 'vnpay_sent'}">
        <div class="alert alert-primary alert-dismissible fade show shadow-sm no-print"><i class="fas fa-paper-plane me-2"></i> Đã gửi Email kèm Link thanh toán VNPay cho khách hàng! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>

    <%-- ========================================== --%>
    <%-- GRID 2 CỘT: HÓA ĐƠN (TRÁI) - THAO TÁC (PHẢI) --%>
    <%-- ========================================== --%>
    <div class="row g-4">

        <%-- CỘT TRÁI (8/12): TỜ HÓA ĐƠN A4 --%>
        <div class="col-lg-8">
            <div class="invoice-paper">
                <%-- HEADER HÓA ĐƠN --%>
                <div class="row mb-5 align-items-center">
                    <div class="col-sm-6">
                        <div class="company-name mb-1"><i class="fas fa-bolt text-warning me-2"></i>GEN-CMS CORPORATION</div>
                        <div class="text-muted small lh-lg">
                            <i class="fas fa-map-marker-alt me-2"></i>Khu Công nghệ cao, Hòa Lạc, Hà Nội<br>
                            <i class="fas fa-phone-alt me-2"></i>Hotline: 1900 8888<br>
                            <i class="fas fa-envelope me-2"></i>Email: billing@gen-cms.vn
                        </div>
                    </div>
                    <div class="col-sm-6 text-sm-end mt-4 mt-sm-0">
                        <h1 class="invoice-title mb-2">HÓA ĐƠN</h1>
                        <div class="fw-bold text-secondary mb-1">Mã số: ${invoice.invoiceCode}</div>
                        <div class="text-muted small">Ngày lập: <fmt:formatDate value="${invoice.issuedDate}" pattern="dd/MM/yyyy" /></div>

                        <%-- Trạng thái thanh toán --%>
                        <div class="mt-3">
                            <c:choose>
                                <c:when test="${invoice.paymentStatus == 'PAID'}">
                                    <span class="badge border border-success text-success bg-white px-3 py-2 fs-6 rounded-pill text-uppercase" style="border-width: 2px !important;"><i class="fas fa-check-circle me-1"></i> Đã Thanh Toán</span>
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
                            <c:when test="${not empty quoteDetails}">
                                <c:forEach items="${quoteDetails}" var="detail" varStatus="loop">
                                    <tr>
                                        <td class="text-center fw-bold text-muted">${loop.index + 1}</td>
                                        <td><div class="fw-bold text-dark">${detail.description}</div></td>
                                        <td class="text-center"><span class="badge border border-secondary text-dark px-2">${detail.quantity}</span></td>
                                        <td class="text-end"><fmt:formatNumber value="${detail.unitPrice}" pattern="#,###"/></td>
                                        <td class="text-end fw-bold text-primary"><fmt:formatNumber value="${detail.totalPrice}" pattern="#,###"/></td>
                                    </tr>
                                </c:forEach>





                            </c:when>
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
                    <div class="col-sm-6 col-12 text-muted small lh-lg">
                        <strong>Phương thức thanh toán:</strong> Chuyển khoản qua Cổng VNPay.<br>
                        <strong>Thời hạn thanh toán:</strong> <fmt:formatDate value="${invoice.dueDate}" pattern="dd/MM/yyyy" /><br>
                        <c:if test="${invoice.paymentStatus == 'PAID' && not empty invoice.note}">
                            <strong>Mã giao dịch VNPay:</strong> <em>${invoice.note}</em>
                        </c:if>
                    </div>

                    <div class="col-sm-6 col-12">
                        <table class="table table-sm table-borderless summary-row text-end">
                            <c:if test="${not empty quoteDetails}">
                                <tr>
                                    <td class="text-muted">Tổng tiền vật tư:</td>
                                        <%-- Thêm invoice. nếu biến partsTotal nằm trong object invoice --%>
                                    <td class="fw-bold"><fmt:formatNumber value="${invoice.subtotal-invoice.laborCost}" pattern="#,##0"/> đ</td>
                                </tr>
                                <tr>
                                    <td class="text-muted border-bottom pb-3">Phí nhân công:</td>
                                        <%-- Thêm invoice.laborCost cho đồng bộ với bảng ở trên --%>
                                    <td class="fw-bold border-bottom pb-3"><fmt:formatNumber value="${empty invoice.laborCost ? 0 : invoice.laborCost}" pattern="#,##0"/> đ</td>
                                </tr>
                            </c:if>
                            <tr>
                                <td class="text-muted pt-3">Cộng tiền dịch vụ (Trước thuế):</td>
                                <td class="fw-bold pt-3"><fmt:formatNumber value="${invoice.subtotal}" pattern="#,###"/> đ</td>
                            </tr>
                            <tr>
                                <td class="text-muted border-bottom pb-3">Thuế GTGT (VAT <fmt:formatNumber value="${invoice.taxRate}" pattern="#.#"/>%):</td>
                                <td class="fw-bold border-bottom pb-3"><fmt:formatNumber value="${invoice.taxAmount}" pattern="#,###"/> đ</td>
                            </tr>
                            <tr class="grand-total">
                                <td class="pt-3 pb-3 text-uppercase fw-bold text-dark text-nowrap">Tổng thanh toán:</td>
                                <td class="pt-3 pb-3 fw-bold fs-4 text-primary text-nowrap"><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,###"/> đ</td>
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
        </div>

        <%-- CỘT PHẢI (4/12): PANEL THAO TÁC CỦA STAFF --%>
        <div class="col-lg-4 no-print">
            <c:if test="${invoice.paymentStatus == 'UNPAID'}">
                <div class="action-panel position-sticky" style="top: 20px;">
                    <h5 class="fw-bold mb-4 text-dark"><i class="fas fa-cogs text-primary me-2"></i>Thao tác nghiệp vụ</h5>

                        <%-- 1. CẬP NHẬT THUẾ --%>
                    <div class="mb-4 pb-4 border-bottom border-light">
                        <h6 class="fw-bold text-muted small text-uppercase mb-3">1. Điều chỉnh thuế VAT</h6>
                        <form action="<c:url value='/staff/invoice/detail'/>" method="post">
                            <input type="hidden" name="action" value="update_tax">
                            <input type="hidden" name="invoiceId" value="${invoice.id}">

                            <div class="input-group">
                                <input type="number" step="0.1" min="0" max="100" name="taxRate" class="form-control" value="${invoice.taxRate}">
                                <span class="input-group-text bg-light fw-bold">%</span>
                                <button class="btn btn-outline-primary fw-bold px-3" type="submit">Lưu</button>
                            </div>
                        </form>
                    </div>

                        <%-- 2. GỬI YÊU CẦU THANH TOÁN VNPAY --%>
                    <div>
                        <h6 class="fw-bold text-muted small text-uppercase mb-3">2. Yêu cầu thanh toán</h6>

                        <div class="alert alert-info small border-0 bg-info bg-opacity-10 text-primary-emphasis rounded-3">
                            <i class="fas fa-info-circle me-1"></i> Hệ thống sẽ tạo Link thanh toán <strong>VNPay</strong> và tự động gửi Email hóa đơn đến địa chỉ <strong>${invoice.customerEmail}</strong>.
                        </div>

                        <form action="<c:url value='/staff/invoice/detail'/>" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn gửi Yêu cầu thanh toán VNPay cho khách hàng này không?');">
                            <input type="hidden" name="action" value="send_vnpay">
                            <input type="hidden" name="invoiceId" value="${invoice.id}">

                            <button type="submit" class="btn btn-primary w-100 rounded-pill fw-bold py-3 shadow-sm mt-2">
                                <i class="fas fa-paper-plane me-2"></i>Gửi Hóa Đơn & Link VNPay
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>

            <%-- Nếu Hóa đơn đã thanh toán / Hủy --%>
            <c:if test="${invoice.paymentStatus != 'UNPAID'}">
                <div class="action-panel position-sticky" style="top: 20px;">
                    <div class="text-center py-4">
                        <c:choose>
                            <c:when test="${invoice.paymentStatus == 'PAID'}">
                                <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                <h5 class="fw-bold text-success">Khách đã thanh toán</h5>
                                <p class="text-muted small mb-0">Hóa đơn này đã được thanh toán thành công qua cổng VNPay. Bạn không thể thao tác thêm.</p>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-ban fa-3x text-danger mb-3"></i>
                                <h5 class="fw-bold text-danger">Hóa đơn đã hủy</h5>
                                <p class="text-muted small mb-0">Hóa đơn này đã bị hủy bỏ.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>