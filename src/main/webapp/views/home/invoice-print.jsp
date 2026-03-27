<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn ${invoice.invoiceCode}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Segoe UI', Arial, sans-serif;
            color: #333;
        }

        /* Cấu hình khổ giấy A4 */
        .invoice-container {
            width: 210mm;
            min-height: 297mm;
            margin: 20px auto;
            background: white;
            padding: 20mm;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            position: relative;
        }

        .company-logo {
            font-size: 28px;
            font-weight: 900;
            color: #2563eb;
        }

        .invoice-header {
            border-bottom: 2px solid #2563eb;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }

        .watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 100px;
            color: rgba(25, 135, 84, 0.08); /* Màu xanh nhạt cho chữ PAID */
            font-weight: bold;
            z-index: 0;
            pointer-events: none;
        }

        .watermark.unpaid {
            color: rgba(220, 53, 69, 0.05); /* Màu đỏ nhạt cho chữ UNPAID */
        }

        .content-wrap {
            position: relative;
            z-index: 1;
        }

        /* Ẩn các nút bấm khi xuất ra file PDF */
        @media print {
            body {
                background-color: white;
                margin: 0;
            }
            .invoice-container {
                margin: 0;
                padding: 10mm;
                box-shadow: none;
                width: 100%;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>

<div class="text-center mt-4 mb-3 no-print">
    <button onclick="window.print()" class="btn btn-primary btn-lg rounded-pill shadow-sm px-4">
        <i class="fas fa-file-pdf me-2"></i> Tải PDF / In Hóa Đơn
    </button>

</div>

<div class="invoice-container">

    <c:choose>
        <c:when test="${invoice.paymentStatus == 'PAID'}">
            <div class="watermark">ĐÃ THANH TOÁN</div>
        </c:when>
        <c:otherwise>
            <div class="watermark unpaid">CHƯA THANH TOÁN</div>
        </c:otherwise>
    </c:choose>

    <div class="content-wrap">
        <div class="invoice-header d-flex justify-content-between align-items-center">
            <div>
                <div class="company-logo"><i class="fas fa-bolt text-warning"></i> GEN-CMS</div>
                <div class="text-muted mt-1 small">Công ty CP Dịch vụ Máy phát điện Gen-CMS</div>
                <div class="text-muted small">MST: 0101234567 | Hotline: 1900 8888</div>
            </div>
            <div class="text-end">
                <h2 class="text-uppercase fw-bold text-secondary mb-0">HÓA ĐƠN DỊCH VỤ</h2>
                <div class="fw-bold mt-1">Mã số: <span class="text-danger">${invoice.invoiceCode}</span></div>
                <div class="small">Ngày xuất: <fmt:formatDate value="${invoice.issuedDate}" pattern="dd/MM/yyyy"/></div>
            </div>
        </div>

        <div class="row mb-5">
            <div class="col-sm-6">
                <h6 class="text-muted text-uppercase fw-bold mb-2">Khách hàng:</h6>
                <div class="fw-bold fs-5">${invoice.customerName}</div>
                <div>Email: ${invoice.customerEmail}</div>
            </div>
            <div class="col-sm-6 text-end">
                <h6 class="text-muted text-uppercase fw-bold mb-2">Trạng thái thanh toán:</h6>
                <c:choose>
                    <c:when test="${invoice.paymentStatus == 'PAID'}">
                        <span class="badge bg-success fs-6"><i class="fas fa-check-circle me-1"></i> ĐÃ THANH TOÁN</span>
                        <div class="small mt-1 text-muted">Phương thức: ${invoice.paymentMethod}</div>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-danger fs-6"><i class="fas fa-clock me-1"></i> CHỜ THANH TOÁN</span>
                        <div class="small mt-1 text-danger">Hạn chót: <fmt:formatDate value="${invoice.dueDate}" pattern="dd/MM/yyyy"/></div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <table class="table table-bordered border-secondary mb-4">
            <thead class="table-light border-secondary">
            <tr>
                <th class="text-center" width="5%">STT</th>
                <th>Nội dung / Phụ tùng bảo trì</th>
                <th class="text-center" width="10%">SL</th>
                <th class="text-end" width="20%">Đơn giá</th>
                <th class="text-end" width="20%">Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${details}" varStatus="loop">
                <tr>
                    <td class="text-center">${loop.index + 1}</td>
                    <td>${item.description}</td>
                    <td class="text-center">${item.quantity}</td>
                    <td class="text-end"><fmt:formatNumber value="${item.unitPrice}" pattern="#,##0"/> đ</td>
                    <td class="text-end fw-bold"><fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/> đ</td>
                </tr>
            </c:forEach>

            <tr class="table-light">
                <td colspan="2" class="fw-bold text-end">Phí nhân công bảo trì:</td>
                <td class="text-center">1</td>
                <td class="text-end"><fmt:formatNumber value="${invoice.laborCost}" pattern="#,##0"/> đ</td>
                <td class="text-end fw-bold"><fmt:formatNumber value="${invoice.laborCost}" pattern="#,##0"/> đ</td>
            </tr>
            </tbody>
        </table>

        <div class="row">
            <div class="col-5">
                <div class="mt-4 p-3 bg-light rounded small text-muted">
                    <strong>Ghi chú:</strong> Vui lòng thanh toán đầy đủ trước hạn chót để đảm bảo quyền lợi bảo hành hệ thống.
                </div>
            </div>
            <div class="col-7">
                <table class="table table-borderless table-sm text-end">
                    <tr>
                        <td>Cộng tiền dịch vụ:</td>
                        <td width="35%" class="fw-bold"><fmt:formatNumber value="${invoice.subtotal}" pattern="#,##0"/> đ</td>
                    </tr>
                    <tr>
                        <td>Thuế GTGT (${invoice.taxRate}%):</td>
                        <td class="fw-bold"><fmt:formatNumber value="${invoice.taxAmount}" pattern="#,##0"/> đ</td>
                    </tr>
                    <tr class="border-top border-dark">
                        <td class="fs-5 fw-bold text-danger text-nowrap">TỔNG THANH TOÁN:</td>
                        <td class="fs-5 fw-bold text-danger"><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,##0"/> đ</td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="text-center mt-5 pt-4">
            <p class="fst-italic text-muted">Cảm ơn Quý khách đã sử dụng dịch vụ của chúng tôi!</p>
        </div>
    </div>
</div>

</body>
</html>