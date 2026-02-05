<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="fw-bold text-dark mb-0">Thêm Product Model</h3>
    <a href="${ctx}/it/products" class="btn btn-outline-secondary btn-sm">Quay lại</a>
  </div>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
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

        <div class="col-md-6">
          <label class="form-label fw-bold">Brand *</label>
          <select class="form-select" name="brandId" required>
            <option value="">-- Chọn hãng --</option>
            <c:forEach items="${brands}" var="b">
              <c:set var="selectedBrand" value="${(not empty preBrandId and preBrandId == b.id)}" />
              <option value="${b.id}" ${selectedBrand ? 'selected' : ''}>${b.name}</option>
            </c:forEach>
          </select>
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

        <!-- ✅ Upload image -->
        <div class="col-md-6">
          <label class="form-label fw-bold">Image (optional)</label>
          <input type="file" name="imageFile" class="form-control" accept="image/*">
          <small class="text-muted">Lưu vào /uploads/product-models</small>
        </div>

        <div class="col-md-6">
          <label class="form-label fw-bold">Image (optional)</label>
          <input type="file" name="imageFile" class="form-control" accept="image/*">
          <small class="text-muted">Lưu vào /uploads/product-models</small>
        </div>

        <!-- ❌ BỎ manualFile luôn -->

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

      <!-- Gợi ý nhỏ cho user -->
      <div class="text-muted small mt-2">
        * PDF thông tin sản phẩm sẽ được xuất tự động ở trang Detail (nút "Xuất PDF").

      </form>

    </div>
  </div>
</div>
