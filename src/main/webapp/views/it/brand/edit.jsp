<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card { border-radius: 12px; border: none; }
  .thumb-img { width: 70px; height: 70px; object-fit: contain; border-radius: 12px; background: #fff; }
</style>

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Sửa Brand</h3>
      <div class="text-muted small">ID: #${brand.id}</div>
    </div>

    <div class="d-flex gap-2">
      <a href="${ctx}/it/brands/detail?id=${brand.id}" class="btn btn-outline-secondary btn-sm">
        <i class="fas fa-arrow-left me-1"></i> Quay lại
      </a>
    </div>
  </div>

  <c:if test="${param.msg == 'name_required'}">
    <div class="alert alert-warning">Vui lòng nhập tên brand.</div>
  </c:if>
  <c:if test="${param.msg == 'exists'}">
    <div class="alert alert-warning">Tên brand bị trùng với brand khác.</div>
  </c:if>
  <c:if test="${param.msg == 'invalid_image'}">
    <div class="alert alert-warning">File ảnh không hợp lệ (png/jpg/jpeg/webp).</div>
  </c:if>
  <c:if test="${param.msg == 'failed'}">
    <div class="alert alert-danger">Update thất bại, vui lòng thử lại.</div>
  </c:if>

  <div class="card shadow-sm">
    <div class="card-body bg-light">
      <form action="${ctx}/it/brands/edit" method="post" enctype="multipart/form-data" class="row g-3">
        <input type="hidden" name="id" value="${brand.id}" />

        <div class="col-md-12">
          <label class="form-label small fw-bold">Logo hiện tại</label>
          <div class="d-flex align-items-center gap-3">
            <c:choose>
              <c:when test="${not empty brand.logoUrl and fn:startsWith(brand.logoUrl, 'http')}">
                <img src="${fn:escapeXml(brand.logoUrl)}" class="thumb-img border shadow-sm" alt="logo">
              </c:when>
              <c:when test="${not empty brand.logoUrl}">
                <img src="${ctx}/${fn:escapeXml(brand.logoUrl)}" class="thumb-img border shadow-sm" alt="logo">
              </c:when>
              <c:otherwise>
                <img src="https://via.placeholder.com/70x70?text=LOGO" class="thumb-img border shadow-sm" alt="logo">
              </c:otherwise>
            </c:choose>

            <div class="small text-muted">
              <div><b>logo_url:</b> <code>${fn:escapeXml(brand.logoUrl)}</code></div>
              <div class="form-text">Bạn có thể upload logo mới hoặc nhập link/path mới.</div>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <label class="form-label small fw-bold">Tên brand <span class="text-danger">*</span></label>
          <input type="text" name="name" class="form-control form-control-sm" required
                 value="${fn:escapeXml(brand.name)}">
        </div>

        <div class="col-md-6">
          <label class="form-label small fw-bold">Slug</label>
          <input type="text" name="slug" class="form-control form-control-sm"
                 value="${fn:escapeXml(brand.slug)}">
        </div>

        <div class="col-md-6">
          <label class="form-label small fw-bold">Upload logo mới</label>
          <input type="file" name="logoFile" class="form-control form-control-sm"
                 accept=".png,.jpg,.jpeg,.webp">
        </div>

        <div class="col-md-6">
          <label class="form-label small fw-bold">Hoặc nhập Logo URL/Path mới</label>
          <input type="text" name="logoUrl" class="form-control form-control-sm"
                 placeholder="https://... hoặc uploads/brands/..."
                 value="">
          <div class="form-text">Nếu muốn giữ logo cũ, tick “Giữ logo cũ”.</div>
        </div>

        <div class="col-md-12">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" value="1" id="keepLogo" name="keepLogo" checked>
            <label class="form-check-label" for="keepLogo">
              Giữ logo cũ (nếu không upload logo mới)
            </label>
          </div>
        </div>

        <div class="col-12 d-flex gap-2">
          <button type="submit" class="btn btn-primary btn-sm px-4">
            <i class="fas fa-save me-1"></i> Cập nhật
          </button>
          <a href="${ctx}/it/brands/detail?id=${brand.id}" class="btn btn-outline-secondary btn-sm px-4">
            Huỷ
          </a>
        </div>

      </form>
    </div>
  </div>

</div>