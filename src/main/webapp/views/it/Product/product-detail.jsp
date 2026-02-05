<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<title>Chi tiết sản phẩm</title>

<div class="container-fluid">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="text-secondary mb-1">Chi tiết sản phẩm</h3>
            <div class="text-muted">Mã sản phẩm: <span class="fw-bold">#${p.id}</span></div>
        </div>

        <div class="d-flex gap-2">
            <a class="btn btn-outline-secondary" href="<c:url value='/admin/product/product-list'/>">
            <a class="btn btn-outline-secondary" href="<c:url value='/admin/product/product-list'/>">
                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
            </a>

            <a class="btn btn-info text-white" href="<c:url value='/admin/product-update?id=${p.id}'/>">
                <i class="fas fa-edit me-2"></i>Chỉnh sửa
            </a>
        </div>
    </div>

    <div class="row g-4">

        <!-- HÌNH ẢNH -->
        <div class="col-12 col-lg-4">
            <div class="card shadow border-0">
                <div class="card-body">
                    <h5 class="text-secondary mb-3">Hình ảnh sản phẩm</h5>

                    <c:choose>
                        <c:when test="${not empty p.imageUrl}">
                            <img src="<c:url value='${p.imageUrl}'/>"
                                 class="img-fluid rounded border"
                                 style="width:100%;max-height:320px;object-fit:cover;"
                                 alt="img-${p.id}">
                        </c:when>
                        <c:otherwise>
                            <div class="text-muted">Chưa có hình ảnh</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- THÔNG TIN -->
        <div class="col-12 col-lg-8">
            <div class="card shadow border-0">
                <div class="card-body">

                    <h5 class="text-secondary mb-3">Thông tin sản phẩm</h5>

                    <div class="table-responsive">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td class="text-muted" style="width:220px;">Tên sản phẩm</td>
                                <td class="fw-bold">${p.name}</td>
                            </tr>

                            <tr>
                                <td class="text-muted">Số Serial</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.serialNumber}">${p.serialNumber}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Model</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.model}">${p.model}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Xuất xứ</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.origin}">${p.origin}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Năm sản xuất</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.manufactureYear}">${p.manufactureYear}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Thương hiệu</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.brand}">${p.brand.name}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Loại nhiên liệu</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.fuelType}">${p.fuelType}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Công suất Prime (kVA)</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.powerPrime}">${p.powerPrime}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Công suất Standby (kVA)</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.powerStandby}">${p.powerStandby}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Điện áp</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.voltage}">${p.voltage}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Dung tích bình nhiên liệu</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.fuelTankCapacity}">${p.fuelTankCapacity}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Vị trí hiện tại</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.currentLocation}">${p.currentLocation}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Trạng thái</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.status}">${p.status}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Tổng giờ vận hành</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.totalRunningHours}">${p.totalRunningHours}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Khách hàng</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.customerName}">${p.customerName}</c:when>
                                        <c:otherwise><span class="text-muted">Chưa gán khách hàng</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Ngày tạo</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.createdAt}">
                                            <fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <td class="text-muted">Cập nhật lần cuối</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.updatedAt}">
                                            <fmt:formatDate value="${p.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                        </table>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>
