<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
    .thumb-img { width: 84px; height: 84px; object-fit: cover; border-radius: 14px; }
    .thumb-sm { width: 58px; height: 58px; object-fit: cover; border-radius: 10px; cursor: pointer; }
</style>

<div class="container-fluid py-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold mb-0">Sửa mẫu sản phẩm</h3>
        <div class="d-flex gap-2">
            <a href="${ctx}/it/products/detail?id=${pm.id}" class="btn btn-outline-info btn-sm">Chi tiết</a>
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
                    <label class="form-label fw-bold">Tên *</label>
                    <input type="text" name="name" class="form-control" required value="${fn:escapeXml(pm.name)}">
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Đường dẫn tĩnh</label>
                    <input type="text" name="slug" class="form-control" value="${fn:escapeXml(pm.slug)}">
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Hãng *</label>
                    <select class="form-select" name="brandId" required>
                        <option value="">-- Chọn hãng --</option>
                        <c:forEach items="${brands}" var="b">
                            <option value="${b.id}" ${pm.brandId == b.id ? 'selected' : ''}>${b.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Danh mục *</label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.id}" ${pm.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Xuất xứ</label>
                    <input type="text" name="origin" class="form-control" value="${fn:escapeXml(pm.origin)}">
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Loại nhiên liệu *</label>
                    <select class="form-select" name="fuelType" required>
                        <option value="">-- Chọn --</option>
                        <option value="DIESEL" ${pm.fuelType == 'DIESEL' ? 'selected' : ''}>Dầu diesel</option>
                        <option value="GASOLINE" ${pm.fuelType == 'GASOLINE' ? 'selected' : ''}>Xăng</option>
                        <option value="OTHER" ${pm.fuelType == 'OTHER' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">Công suất</label>
                    <input type="number" step="0.01" name="power" class="form-control" value="${pm.power}">
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-bold">Trạng thái *</label>
                    <select class="form-select" name="status" required>
                        <option value="">-- Chọn --</option>
                        <option value="ACTIVE" ${pm.status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="INACTIVE" ${pm.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động</option>
                        <option value="COMING_SOON" ${pm.status == 'COMING_SOON' ? 'selected' : ''}>Sắp ra mắt</option>
                    </select>
                </div>

                <!-- ẢNH: ảnh đại diện + thư viện ảnh + xoá + tải thêm -->
                <div class="col-12">
                    <label class="form-label fw-bold">Hình ảnh sản phẩm</label>

                    <!-- Ảnh đại diện -->
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <c:choose>
                            <c:when test="${not empty pm.imageUrl}">
                                <img id="thumbPreview" class="thumb-img border"
                                     src="${fn:startsWith(pm.imageUrl,'http') ? pm.imageUrl : ctx.concat('/').concat(pm.imageUrl)}"
                                     alt="Ảnh đại diện">
                            </c:when>
                            <c:otherwise>
                                <img id="thumbPreview" class="thumb-img border"
                                     src="https://via.placeholder.com/84x84?text=IMG" alt="Ảnh đại diện">
                            </c:otherwise>
                        </c:choose>

                        <div class="flex-grow-1">
                            <input type="file" name="imageFile" class="form-control" accept="image/*"
                                   onchange="if(this.files && this.files[0]){document.getElementById('thumbPreview').src=URL.createObjectURL(this.files[0]);}">
                            <small class="text-muted">Chọn ảnh đại diện mới nếu muốn thay đổi</small>
                        </div>
                    </div>

                    <!-- Thư viện ảnh hiện có -->
                    <c:if test="${not empty images}">
                        <div class="border rounded p-3">
                            <div class="fw-bold mb-2">Thư viện ảnh hiện có (chọn để xóa)</div>

                            <div class="d-flex flex-wrap gap-3">
                                <c:forEach items="${images}" var="img">
                                    <div class="d-flex flex-column align-items-center" style="width: 92px;">
                                        <img class="thumb-img border"
                                             src="${fn:startsWith(img.imageUrl,'http') ? img.imageUrl : ctx.concat('/').concat(img.imageUrl)}"
                                             alt="Ảnh thư viện">
                                        <div class="form-check mt-2">
                                            <input class="form-check-input" type="checkbox"
                                                   name="deleteImageIds" value="${img.id}" id="del-${img.id}">
                                            <label class="form-check-label small" for="del-${img.id}">Xóa</label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Tải thêm nhiều ảnh -->
                    <div class="mt-3">
                        <input type="file" name="imageFiles" class="form-control" accept="image/*" multiple>
                        <small class="text-muted">Chọn thêm nhiều ảnh để bổ sung vào thư viện ảnh</small>
                    </div>
                </div>

                <!-- PDF xuất động -->
                <div class="col-md-6">
                    <label class="form-label fw-bold">Tệp PDF thông tin sản phẩm</label>
                    <div class="d-flex align-items-center gap-2">
                        <a href="${ctx}/it/products/pdf?id=${pm.id}" target="_blank" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-file-pdf me-1"></i> Xuất PDF
                        </a>
                        <span class="text-muted small">Tệp PDF được tạo tự động từ dữ liệu hiện tại</span>
                    </div>
                </div>

                <div class="col-12">
                    <label class="form-label fw-bold">Mô tả</label>
                    <textarea name="description" class="form-control" rows="3">${fn:escapeXml(pm.description)}</textarea>
                </div>

                <div class="col-12">
                    <label class="form-label fw-bold">Thông số kỹ thuật</label>
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