<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container-fluid py-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold text-dark mb-0">Thêm Product Model</h3>
        <a href="${ctx}/it/products" class="btn btn-outline-secondary btn-sm">Quay lại</a>
    </div>

    <!-- Error từ ProductModelAddController -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- Error/Success từ BrandAddController redirect về -->
    <c:if test="${not empty param.brandError}">
        <div class="alert alert-danger">
            <c:choose>
                <c:when test="${param.brandError == 'NameRequired'}">Tên Brand không được để trống.</c:when>
                <c:when test="${param.brandError == 'InsertFailed'}">Không thể thêm Brand. Vui lòng thử lại.</c:when>
                <c:otherwise>Lỗi thêm Brand.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${not empty param.brandAdded}">
        <div class="alert alert-success">Đã thêm Brand thành công!</div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body">

            <form action="${ctx}/it/products/add" method="post" enctype="multipart/form-data" class="row g-3">

                <div class="col-md-6">
                    <label class="form-label fw-bold">Name *</label>
                    <input type="text" name="name" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Slug (optional)</label>
                    <input type="text" name="slug" class="form-control" placeholder="Tự sinh nếu để trống">
                </div>

                <!-- Brand + nút thêm Brand -->
                <div class="col-md-6">
                    <label class="form-label fw-bold">Brand *</label>

                    <div class="d-flex gap-2">
                        <select class="form-select" name="brandId" required>
                            <option value="">-- Chọn hãng --</option>
                            <c:forEach items="${brands}" var="b">
                                <c:set var="selectedBrand" value="${(not empty preBrandId and preBrandId == b.id)}" />
                                <option value="${b.id}" ${selectedBrand ? 'selected' : ''}>${b.name}</option>
                            </c:forEach>
                        </select>

                        <button type="button" class="btn btn-outline-primary"
                                data-bs-toggle="modal" data-bs-target="#addBrandModal">
                            + Brand
                        </button>
                    </div>
                    <small class="text-muted">Nếu chưa có hãng, bấm “+ Brand” để thêm nhanh.</small>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Category *</label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.id}">${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Origin</label>
                    <input type="text" name="origin" class="form-control" placeholder="VD: Japan">
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Fuel type *</label>
                    <select class="form-select" name="fuelType" required>
                        <option value="">-- Chọn --</option>
                        <option value="DIESEL">DIESEL</option>
                        <option value="GASOLINE">GASOLINE</option>
                        <option value="OTHER">OTHER</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Power</label>
                    <input type="number" step="0.01" name="power" class="form-control" placeholder="VD: 150.00">
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Status *</label>
                    <select class="form-select" name="status" required>
                        <option value="">-- Chọn --</option>
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="INACTIVE">INACTIVE</option>
                        <option value="COMING_SOON">COMING_SOON</option>
                    </select>
                </div>

                <!-- Upload nhiều ảnh -->
                <div class="col-md-6">
                    <label class="form-label fw-bold">Images (optional)</label>
                    <input type="file" name="imageFiles" class="form-control" accept="image/*" multiple>
                    <small class="text-muted">Có thể chọn nhiều ảnh. Lưu vào /uploads/product-models</small>
                </div>

                <div class="col-12">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="3"></textarea>
                </div>

                <div class="col-12">
                    <label class="form-label fw-bold">Specifications</label>
                    <textarea name="specifications" class="form-control" rows="3"></textarea>
                </div>

                <div class="col-12 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Lưu</button>
                    <a href="${ctx}/it/products" class="btn btn-outline-secondary">Hủy</a>
                </div>

            </form>

            <div class="text-muted small mt-2">
                * PDF thông tin sản phẩm sẽ được xuất tự động ở trang Detail (nút "Xuất PDF").
            </div>

        </div>
    </div>
</div>

<!-- ================== MODAL: ADD BRAND ================== -->
<div class="modal fade" id="addBrandModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Thêm Brand</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form action="${ctx}/it/brands/add" method="post">
                <div class="modal-body">
                    <!-- quay lại trang add product và auto chọn brand mới -->
                    <input type="hidden" name="returnUrl" value="${ctx}/it/products/add" />

                    <div class="mb-3">
                        <label class="form-label fw-bold">Name *</label>
                        <input type="text" name="name" class="form-control" required />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Slug (optional)</label>
                        <input type="text" name="slug" class="form-control" placeholder="Tự sinh nếu để trống" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Logo URL (optional)</label>
                        <input type="text" name="logoUrl" class="form-control" placeholder="https://..." />
                    </div>

                    <small class="text-muted">
                        Sau khi lưu Brand, hệ thống sẽ quay lại form Product và tự chọn Brand vừa tạo.
                    </small>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu Brand</button>
                </div>
            </form>

        </div>
    </div>
</div>

<!-- Auto open modal nếu add brand bị lỗi -->
<c:if test="${not empty param.brandError}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var modalEl = document.getElementById('addBrandModal');
            if (modalEl && window.bootstrap) {
                new bootstrap.Modal(modalEl).show();
            }
        });
    </script>
</c:if>
