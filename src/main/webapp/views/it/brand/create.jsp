<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card { border-radius: 12px; border: none; }
</style>

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Thêm Brand (Upload logo)</h3>
      <div class="text-muted small">Upload ảnh hoặc nhập link logo</div>
    </div>

    <a href="${ctx}/it/brands" class="btn btn-outline-secondary btn-sm">
      <i class="fas fa-arrow-left me-1"></i> Quay lại
    </a>
  </div>

  <c:if test="${param.msg == 'name_required'}">
    <div class="alert alert-warning">Vui lòng nhập tên brand.</div>
  </c:if>
  <c:if test="${param.msg == 'exists'}">
    <div class="alert alert-warning">Brand đã tồn tại (trùng tên).</div>
  </c:if>
  <c:if test="${param.msg == 'invalid_image'}">
    <div class="alert alert-warning">File ảnh không hợp lệ (chỉ png/jpg/jpeg/webp).</div>
  </c:if>
  <c:if test="${param.msg == 'failed'}">
    <div class="alert alert-danger">Thêm brand thất bại, vui lòng thử lại.</div>
  </c:if>

  <div class="card shadow-sm">
    <div class="card-body bg-light">
      <form action="${ctx}/it/brands/create" method="post" enctype="multipart/form-data" class="row g-3">

        <div class="col-md-6">
          <label class="form-label small fw-bold">Tên brand <span class="text-danger">*</span></label>
          <input type="text" name="name" class="form-control form-control-sm" required
                 placeholder="VD: Honda, Hyundai...">
        </div>

        <div class="col-md-6">
          <label class="form-label small fw-bold">Slug (có thể để trống)</label>
          <input type="text" name="slug" class="form-control form-control-sm"
                 placeholder="VD: honda, hyundai...">
          <div class="form-text">Để trống sẽ tự tạo từ tên.</div>
        </div>

        <div class="col-md-6">
          <label class="form-label small fw-bold">Upload logo (ảnh)</label>
          <input type="file" name="logoFile" class="form-control form-control-sm"
                 accept=".png,.jpg,.jpeg,.webp">
          <div class="form-text">Nếu upload file thì hệ thống lưu vào uploads/brands/</div>
        </div>

        <div class="col-md-6">
          <label class="form-label small fw-bold">Hoặc nhập Logo URL (link)</label>
          <input type="text" name="logoUrl" class="form-control form-control-sm"
                 placeholder="https://...">
          <div class="form-text">Nếu không upload file, sẽ dùng link này.</div>
        </div>

        <div class="col-12 d-flex gap-2">
          <button type="submit" class="btn btn-primary btn-sm px-4">
            <i class="fas fa-save me-1"></i> Lưu
          </button>
          <a href="${ctx}/it/brands" class="btn btn-outline-secondary btn-sm px-4">Huỷ</a>
        </div>

      </form>
    </div>
  </div>

</div>