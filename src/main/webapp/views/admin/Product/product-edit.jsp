<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Chỉnh sửa sản phẩm</title>

<div class="container-fluid">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="text-secondary mb-1">Chỉnh sửa sản phẩm</h3>
            <div class="text-muted">Mã sản phẩm: <span class="fw-bold">#${p.id}</span></div>
        </div>

        <div class="d-flex gap-2">
            <a class="btn btn-outline-secondary"
               href="<c:url value='/admin/product/detail?id=${p.id}'/>">
                <i class="fas fa-arrow-left me-2"></i>Quay lại chi tiết
            </a>

            <a class="btn btn-outline-secondary"
               href="<c:url value='/admin/product/product-list'/>">
                Danh sách
            </a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:set var="errs" value="${errors}" />

    <div class="card shadow border-0">
        <div class="card-body">

            <form method="post"
                  action="<c:url value='/admin/product-update'/>"
                  enctype="multipart/form-data"
                  class="row g-3">

                <input type="hidden" name="id" value="${p.id}" />

                <!-- ===== Thông tin cơ bản ===== -->
                <div class="col-12 col-md-6">
                    <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="name" value="${p.name}" required />
                    <c:if test="${not empty errs.name}">
                        <div class="text-danger small mt-1">${errs.name}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label">Số Serial</label>
                    <input type="text" class="form-control" name="serialNumber" value="${p.serialNumber}" />
                    <c:if test="${not empty errs.serialNumber}">
                        <div class="text-danger small mt-1">${errs.serialNumber}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Model</label>
                    <input type="text" class="form-control" name="model" value="${p.model}" />
                    <c:if test="${not empty errs.model}">
                        <div class="text-danger small mt-1">${errs.model}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Xuất xứ</label>
                    <input type="text" class="form-control" name="origin" value="${p.origin}" />
                    <c:if test="${not empty errs.origin}">
                        <div class="text-danger small mt-1">${errs.origin}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Năm sản xuất</label>
                    <input type="number" class="form-control" name="manufactureYear" value="${p.manufactureYear}" />
                    <c:if test="${not empty errs.manufactureYear}">
                        <div class="text-danger small mt-1">${errs.manufactureYear}</div>
                    </c:if>
                </div>

                <!-- ===== Brand / Category ===== -->
                <div class="col-12 col-md-6">
                    <label class="form-label">Thương hiệu <span class="text-danger">*</span></label>
                    <select class="form-select" name="brandId" required>
                        <option value="">-- Chọn thương hiệu --</option>
                        <c:forEach items="${brands}" var="b">
                            <option value="${b.id}" <c:if test="${p.brandId == b.id}">selected</c:if>>
                                    ${b.name}
                            </option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty errs.brandId}">
                        <div class="text-danger small mt-1">${errs.brandId}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-6">
                    <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.id}" <c:if test="${p.categoryId == c.id}">selected</c:if>>
                                    ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty errs.categoryId}">
                        <div class="text-danger small mt-1">${errs.categoryId}</div>
                    </c:if>
                </div>

                <!-- ===== Thông số kỹ thuật ===== -->
                <div class="col-12 col-md-4">
                    <label class="form-label">Công suất Prime (kVA)</label>
                    <input type="number" step="0.01" class="form-control" name="powerPrime" value="${p.powerPrime}" />
                    <c:if test="${not empty errs.powerPrime}">
                        <div class="text-danger small mt-1">${errs.powerPrime}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Công suất Standby (kVA)</label>
                    <input type="number" step="0.01" class="form-control" name="powerStandby" value="${p.powerStandby}" />
                    <c:if test="${not empty errs.powerStandby}">
                        <div class="text-danger small mt-1">${errs.powerStandby}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Điện áp</label>
                    <input type="text" class="form-control" name="voltage" value="${p.voltage}" />
                    <c:if test="${not empty errs.voltage}">
                        <div class="text-danger small mt-1">${errs.voltage}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Dung tích bình nhiên liệu</label>
                    <input type="number" step="0.01" class="form-control" name="fuelTankCapacity" value="${p.fuelTankCapacity}" />
                    <c:if test="${not empty errs.fuelTankCapacity}">
                        <div class="text-danger small mt-1">${errs.fuelTankCapacity}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Loại nhiên liệu <span class="text-danger">*</span></label>
                    <select class="form-select" name="fuelType" required>
                        <option value="">-- Chọn --</option>
                        <c:forEach items="${fuelOptions}" var="f">
                            <option value="${f}" <c:if test="${p.fuelType == f}">selected</c:if>>
                                <c:choose>
                                    <c:when test="${f == 'DIESEL'}">Dầu Diesel</c:when>
                                    <c:when test="${f == 'GASOLINE'}">Xăng</c:when>
                                    <c:otherwise>${f}</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty errs.fuelType}">
                        <div class="text-danger small mt-1">${errs.fuelType}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-4">
                    <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                    <select class="form-select" name="status" required>
                        <option value="">-- Chọn --</option>
                        <c:forEach items="${statusOptions}" var="s">
                            <option value="${s}" <c:if test="${p.status == s}">selected</c:if>>
                                <c:choose>
                                    <c:when test="${s == 'READY'}">Sẵn sàng</c:when>
                                    <c:when test="${s == 'RUNNING'}">Đang chạy</c:when>
                                    <c:when test="${s == 'MAINTENANCE'}">Bảo trì</c:when>
                                    <c:when test="${s == 'BROKEN'}">Hỏng</c:when>
                                    <c:otherwise>${s}</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty errs.status}">
                        <div class="text-danger small mt-1">${errs.status}</div>
                    </c:if>
                </div>

                <!-- ===== Khác ===== -->
                <div class="col-12 col-md-6">
                    <label class="form-label">Vị trí hiện tại</label>
                    <input type="text" class="form-control" name="currentLocation" value="${p.currentLocation}" />
                    <c:if test="${not empty errs.currentLocation}">
                        <div class="text-danger small mt-1">${errs.currentLocation}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-3">
                    <label class="form-label">Tổng giờ vận hành</label>
                    <input type="number" step="0.1" class="form-control" name="totalRunningHours" value="${p.totalRunningHours}" />
                    <c:if test="${not empty errs.totalRunningHours}">
                        <div class="text-danger small mt-1">${errs.totalRunningHours}</div>
                    </c:if>
                </div>

                <div class="col-12 col-md-3">
                    <label class="form-label">Mã khách hàng</label>
                    <input type="number" class="form-control" name="customerId" value="${p.customerId}" />
                    <c:if test="${not empty errs.customerId}">
                        <div class="text-danger small mt-1">${errs.customerId}</div>
                    </c:if>
                </div>

                <!-- ===== Ảnh ===== -->
                <div class="col-12">
                    <label class="form-label">Ảnh sản phẩm</label>
                    <input type="file" class="form-control" name="imageFile" accept=".png,.jpg,.jpeg,.webp,.gif" />

                    <c:if test="${not empty errs.imageFile}">
                        <div class="text-danger small mt-1">${errs.imageFile}</div>
                    </c:if>

                    <div class="form-text">
                        Nếu không chọn ảnh mới, hệ thống sẽ giữ ảnh hiện tại.
                    </div>

                    <c:if test="${not empty p.imageUrl}">
                        <div class="mt-2">
                            <div class="text-muted mb-1">Ảnh hiện tại:</div>
                            <img src="<c:url value='${p.imageUrl}'/>"
                                 class="rounded border"
                                 style="width:160px;height:100px;object-fit:cover;">
                        </div>
                    </c:if>
                </div>

                <!-- ===== Action ===== -->
                <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                    <a class="btn btn-outline-secondary" href="<c:url value='/admin/product/detail?id=${p.id}'/>">
                        Huỷ
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                    </button>
                </div>

            </form>

        </div>
    </div>

</div>
