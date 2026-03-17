<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết máy: ${productModel.name} | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f4f7fc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card { border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-radius: 12px; margin-bottom: 24px; }
        .card-header { border-bottom: 1px solid rgba(0,0,0,0.05); background-color: #fff; border-radius: 12px 12px 0 0 !important; padding: 1rem 1.5rem; }
        .text-primary-custom { color: #4e73df; }
        .bg-primary-custom { background-color: #4e73df; }

        /* Chống vỡ ảnh */
        .product-img-wrapper { width: 100%; height: 220px; border-radius: 8px; overflow: hidden; margin-bottom: 1rem; background-color: #fff; border: 1px solid #eee; display: flex; align-items: center; justify-content: center; }
        .product-img-wrapper img { width: 100%; height: 100%; object-fit: cover; }

        .list-group-item { border-color: rgba(0,0,0,0.05); padding: 12px 0; background: transparent; }
        .stat-box { background: #f8fafc; border-radius: 8px; padding: 15px; border: 1px solid #e2e8f0; height: 100%; }
        .stat-box-title { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700; color: #64748b; margin-bottom: 8px; }
        .stat-box-value { font-size: 1.1rem; font-weight: 600; color: #1e293b; }
    </style>
</head>
<body>

<div class="container-fluid py-4 px-lg-5">

    <%-- ========================================== --%>
    <%-- HEADER & BREADCRUMB                        --%>
    <%-- ========================================== --%>
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
        <div>
            <a href="javascript:history.back()" class="btn btn-sm btn-light border mb-2 shadow-sm">
                <i class="fas fa-arrow-left me-1"></i> Quay lại
            </a>
            <h3 class="fw-bold text-gray-800 mb-0"><i class="fas fa-server text-primary-custom me-2"></i>Hồ sơ Thiết bị</h3>
        </div>

    </div>

    <div class="row">
        <%-- ========================================== --%>
        <%-- CỘT TRÁI: THÔNG TIN CỦA RIÊNG MÁY (PRODUCT)--%>
        <%-- ========================================== --%>
        <div class="col-xl-4 col-lg-5">
            <div class="card border-top border-primary border-4">
                <div class="card-body p-4 text-center">

                    <%-- Hình ảnh máy chống vỡ --%>
                    <div class="product-img-wrapper shadow-sm">
                        <c:choose>
                            <c:when test="${not empty productModel.imageUrl}">
                                <c:set var="imgSrc" value="${productModel.imageUrl}" />
                                <%-- Xử lý nếu url chưa có dấu / ở đầu --%>
                                <c:if test="${!imgSrc.startsWith('/')}">
                                    <c:set var="imgSrc" value="/${imgSrc}" />
                                </c:if>
                                <img src="${pageContext.request.contextPath}${imgSrc}" alt="${productModel.name}">
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-bolt fa-4x text-primary-custom opacity-50"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h5 class="fw-bold text-dark mb-1">${productModel.name}</h5>
                    <div class="text-muted font-monospace fs-6 mb-3">S/N: <strong class="text-primary">${product.serialNumber}</strong></div>

                    <%-- Trạng thái máy --%>
                    <div class="mb-4">
                        <c:choose>
                            <c:when test="${product.status == 'RUNNING'}">
                                <span class="badge bg-success px-3 py-2 rounded-pill fw-medium"><i class="fas fa-check-circle me-1"></i> Đang chạy (Running)</span>
                            </c:when>
                            <c:when test="${product.status == 'READY'}">
                                <span class="badge bg-info text-dark px-3 py-2 rounded-pill fw-medium"><i class="fas fa-box me-1"></i> Sẵn sàng (Lưu kho)</span>
                            </c:when>
                            <c:when test="${product.status == 'MAINTENANCE' || product.status == 'REPAIRING'}">
                                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-medium"><i class="fas fa-tools me-1"></i> Đang bảo trì/sửa chữa</span>
                            </c:when>
                            <c:when test="${product.status == 'BROKEN'}">
                                <span class="badge bg-danger px-3 py-2 rounded-pill fw-medium"><i class="fas fa-exclamation-triangle me-1"></i> Đang báo lỗi</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary px-3 py-2 rounded-pill fw-medium">${product.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Chi tiết riêng của máy (Dùng List Group cho đều và đẹp) --%>
                    <ul class="list-group list-group-flush text-start mt-2">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span class="text-muted"><i class="fas fa-map-marker-alt text-danger me-2 w-15px"></i>Vị trí hiện tại:</span>
                            <span class="fw-bold text-dark text-end ms-3">${not empty product.currentLocation ? product.currentLocation : 'Chưa xác định'}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span class="text-muted"><i class="fas fa-calendar-alt text-primary me-2 w-15px"></i>Năm sản xuất:</span>
                            <span class="fw-bold text-dark">${product.manufactureYear != null ? product.manufactureYear : 'N/A'}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span class="text-muted"><i class="fas fa-clock text-warning me-2 w-15px"></i>Tổng giờ chạy:</span>
                            <span class="fw-bold text-dark">${product.totalRunningHours} giờ</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <%-- ========================================== --%>
        <%-- CỘT PHẢI: THÔNG SỐ MODEL & HỢP ĐỒNG        --%>
        <%-- ========================================== --%>
        <div class="col-xl-8 col-lg-7">

            <%-- Panel 1: Thông số kỹ thuật chung --%>
            <div class="card">
                <div class="card-header">
                    <h6 class="m-0 fw-bold text-primary-custom"><i class="fas fa-cogs me-2"></i>Thông số kỹ thuật dòng máy</h6>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-sm-6 col-md-3">
                            <div class="stat-box">
                                <div class="stat-box-title">Công suất</div>
                                <div class="stat-box-value text-primary"><i class="fas fa-tachometer-alt me-1 opacity-50"></i> ${not empty productModel.power ? productModel.power : '--'} <small class="text-muted fs-6">kVA</small></div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <div class="stat-box">
                                <div class="stat-box-title">Nhiên liệu</div>
                                <div class="stat-box-value">
                                    <i class="fas fa-gas-pump me-1 text-danger opacity-75"></i>
                                    <c:choose>
                                        <c:when test="${productModel.fuelType == 'DIESEL'}">Dầu Diesel</c:when>
                                        <c:when test="${productModel.fuelType == 'GASOLINE'}">Xăng</c:when>
                                        <c:otherwise>${not empty productModel.fuelType ? productModel.fuelType : '--'}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <div class="stat-box">
                                <div class="stat-box-title">Xuất xứ</div>
                                <div class="stat-box-value"><i class="fas fa-globe-asia me-1 text-success opacity-75"></i> ${not empty productModel.origin ? productModel.origin : '--'}</div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <div class="stat-box">
                                <div class="stat-box-title">Ngày nhập kho</div>
                                <div class="stat-box-value">
                                    <i class="fas fa-shopping-cart me-1 text-info opacity-75"></i>
                                    <c:choose>
                                        <c:when test="${not empty product.purchaseDate}"><fmt:formatDate value="${product.purchaseDate}" pattern="dd/MM/yyyy" /></c:when>
                                        <c:otherwise>--/--/----</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 mt-3">
                            <div class="stat-box-title mb-2">Mô tả thiết bị</div>
                            <div class="p-3 bg-light rounded border text-secondary" style="font-size: 0.95rem; line-height: 1.6;">
                                ${not empty productModel.description ? productModel.description : 'Không có thông tin mô tả chi tiết cho dòng máy này.'}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Panel 2: Thông tin Hợp đồng --%>
            <c:choose>
                <c:when test="${not empty contract}">
                    <div class="card border-0" style="border-left: 5px solid #1cc88a !important;">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h6 class="m-0 fw-bold text-success"><i class="fas fa-file-signature me-2"></i>Hợp đồng đang gắn kèm</h6>
                            <a href="<c:url value='/staff/contract/detail?id=${contract.id}'/>" class="btn btn-sm btn-outline-success fw-bold">
                                Xem HĐ <i class="fas fa-arrow-right ms-1"></i>
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="row align-items-center g-4">
                                <div class="col-md-5 border-end-md text-center text-md-start">
                                    <div class="text-muted small fw-bold text-uppercase mb-1">Mã Hợp Đồng</div>
                                    <h4 class="fw-bold text-dark mb-2">${contract.contractNumber}</h4>
                                    <div>
                                        <c:choose>
                                            <c:when test="${contract.status == 'ACTIVE'}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2">Đang hiệu lực</span>
                                            </c:when>
                                            <c:when test="${contract.status == 'EXPIRED'}">
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary px-3 py-2">Hết hạn</span>
                                            </c:when>
                                            <c:when test="${contract.status == 'TERMINATED'}">
                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-3 py-2">Đã thanh lý/Hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning bg-opacity-10 text-warning border border-warning px-3 py-2">${contract.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="col-md-7 ps-md-4">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="bg-success bg-opacity-10 text-success rounded-circle p-2 me-3"><i class="fas fa-calendar-check fa-fw"></i></div>
                                        <div>
                                            <div class="small text-muted fw-bold text-uppercase">Ngày bắt đầu</div>
                                            <div class="fw-bold fs-5 text-dark"><fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy" /></div>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-danger bg-opacity-10 text-danger rounded-circle p-2 me-3"><i class="fas fa-calendar-times fa-fw"></i></div>
                                        <div>
                                            <div class="small text-muted fw-bold text-uppercase">Ngày kết thúc</div>
                                            <div class="fw-bold fs-5 text-dark"><fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy" /></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <%-- Nếu máy nằm trong kho, chưa có HĐ --%>
                    <div class="card bg-transparent shadow-none border" style="border: 2px dashed #cbd5e1 !important;">
                        <div class="card-body text-center py-5">
                            <div class="d-inline-flex align-items-center justify-content-center bg-light rounded-circle mb-3" style="width: 80px; height: 80px;">
                                <i class="fas fa-warehouse fa-2x text-secondary opacity-50"></i>
                            </div>
                            <h5 class="text-secondary fw-bold mb-2">Thiết bị đang lưu kho</h5>
                            <p class="text-muted small mb-0">Máy phát điện này hiện không được gắn với bất kỳ Hợp đồng thuê nào.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>