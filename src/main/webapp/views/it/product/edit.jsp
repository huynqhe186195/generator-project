<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
    .thumb-img { width: 84px; height: 84px; object-fit: cover; border-radius: 14px; }
</style>

<div class="container-fluid py-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold mb-0">Sửa Product Model</h3>
        <div class="d-flex gap-2">
            <a href="${ctx}/it/products/detail?id=${pm.id}" class="btn btn-outline-info btn-sm">Detail</a>
            <a href="${ctx}/it/products" class="btn btn-outline-secondary btn-sm">Quay lại</a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body">

            <form action="${ctx}/it/products/edit" method="post" enctype="multipart/form-data" class="row g-3">
                <input type="hidden" name="id" value="${pm.id}"/>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Name *</label>
                    <input type="text" name="name" class="form-control" required value="${fn:escapeXml(pm.name)}">
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Slug</label>
                    <input type="text" name="slug" class="form-control" value="${fn:escapeXml(pm.slug)}">
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Brand *</label>
                    <select class="form-select" name="brandId" required>
                        <option value="">-- Chọn hãng --</option>
                        <c:forEach items="${brands}" var="b">
                            <option value="${b.id}" ${pm.brandId == b.id ? 'selected' : ''}>${b.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Category *</label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.id}" ${pm.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Origin</label>
                    <input type="text" name="origin" class="form-control" value="${fn:escapeXml(pm.origin)}">
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Fuel type *</label>
                    <select class="form-select" name="fuelType" required>
                        <option value="">-- Chọn --</option>
                        <option value="DIESEL" ${pm.fuelType == 'DIESEL' ? 'selected' : ''}>DIESEL</option>
                        <option value="GASOLINE" ${pm.fuelType == 'GASOLINE' ? 'selected' : ''}>GASOLINE</option>
                        <option value="OTHER" ${pm.fuelType == 'OTHER' ? 'selected' : ''}>OTHER</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Power</label>
                    <input type="number" step="0.01" name="power" class="form-control" value="${pm.power}">
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Status *</label>
                    <select class="form-select" name="status" required>
                        <option value="">-- Chọn --</option>
                        <option value="ACTIVE" ${pm.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${pm.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        <option value="COMING_SOON" ${pm.status == 'COMING_SOON' ? 'selected' : ''}>COMING_SOON</option>
                    </select>
                </div>

                <!-- current image -->
                <div class="col-md-6">
                    <label class="form-label fw-bold">Ảnh hiện tại</label>
                    <div class="d-flex align-items-center gap-3">
                        <c:choose>
                            <c:when test="${not empty pm.imageUrl}">
                                <img class="thumb-img border"
                                     src="${fn:startsWith(pm.imageUrl,'http') ? pm.imageUrl : ctx.concat('/').concat(pm.imageUrl)}"
                                     alt="image">
                            </c:when>
                            <c:otherwise>
                                <img class="thumb-img border" src="https://via.placeholder.com/84x84?text=IMG" alt="image">
                            </c:otherwise>
                        </c:choose>

                        <div class="flex-grow-1">
                            <input type="file" name="imageFile" class="form-control" accept="image/*">
                            <small class="text-muted">Chọn ảnh mới (nếu muốn thay)</small>
                        </div>
                    </div>
                </div>

                <!-- current manual -->
                <div class="col-md-6">
                    <label class="form-label fw-bold">Manual PDF hiện tại</label>
                    <div class="d-flex align-items-center gap-3">
                        <div>
                            <c:choose>
                                <c:when test="${not empty pm.manualUrl}">
                                    <a href="${fn:startsWith(pm.manualUrl,'http') ? pm.manualUrl : ctx.concat('/').concat(pm.manualUrl)}"
                                       target="_blank" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-file-pdf me-1"></i> Xem/Tải
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Không có</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">PDF thông tin sản phẩm</label>
                            <div class="d-flex align-items-center gap-2">
                                <a href="${ctx}/it/products/pdf?id=${pm.id}" target="_blank" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-file-pdf me-1"></i> Xuất PDF
                                </a>
                                <span class="text-muted small">PDF được tạo tự động từ dữ liệu hiện tại</span>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="col-12">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="3">${fn:escapeXml(pm.description)}</textarea>
                </div>

                <div class="col-12">
                    <label class="form-label fw-bold">Specifications</label>
                    <textarea name="specifications" class="form-control" rows="3">${fn:escapeXml(pm.specifications)}</textarea>
                </div>

                <div class="col-12 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Lưu thay đổi
                    </button>
                    <a href="${ctx}/it/products/detail?id=${pm.id}" class="btn btn-outline-secondary">Hủy</a>
                </div>

            </form>

        </div>
    </div>
</div>
