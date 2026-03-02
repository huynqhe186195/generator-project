<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card { border-radius: 12px; border: none; }
  .thumb-img { width: 90px; height: 90px; object-fit: contain; border-radius: 14px; background: #fff; }
</style>

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Chi tiết Brand</h3>
      <div class="text-muted small">Xem thông tin brand</div>
    </div>

    <div class="d-flex gap-2">
      <a href="${ctx}/it/brands" class="btn btn-outline-secondary btn-sm">
        <i class="fas fa-arrow-left me-1"></i> Quay lại
      </a>
      <a href="${ctx}/it/brands/edit?id=${brand.id}" class="btn btn-warning btn-sm">
        <i class="fas fa-edit me-1"></i> Sửa
      </a>
    </div>
  </div>

  <div class="card shadow-sm">
    <div class="card-body bg-light">
      <div class="d-flex align-items-center gap-3 flex-wrap">
        <div>
          <c:choose>
            <c:when test="${not empty brand.logoUrl and fn:startsWith(brand.logoUrl, 'http')}">
              <img src="${fn:escapeXml(brand.logoUrl)}" class="thumb-img border shadow-sm" alt="logo">
            </c:when>
            <c:when test="${not empty brand.logoUrl}">
              <img src="${ctx}/${fn:escapeXml(brand.logoUrl)}" class="thumb-img border shadow-sm" alt="logo">
            </c:when>
            <c:otherwise>
              <img src="https://via.placeholder.com/90x90?text=LOGO" class="thumb-img border shadow-sm" alt="logo">
            </c:otherwise>
          </c:choose>
        </div>

        <div class="flex-grow-1">
          <div class="text-muted small">Brand</div>
          <div class="fs-4 fw-bold text-primary">${fn:escapeXml(brand.name)}</div>
          <div class="text-muted">
            ID: <b>#${brand.id}</b> • Slug: <span class="badge bg-light text-dark border">${fn:escapeXml(brand.slug)}</span>
          </div>
        </div>
      </div>

      <hr>

      <div class="row g-3">
        <div class="col-md-4">
          <div class="text-muted small">ID</div>
          <div class="fw-semibold">#${brand.id}</div>
        </div>

        <div class="col-md-4">
          <div class="text-muted small">Name</div>
          <div class="fw-semibold">${fn:escapeXml(brand.name)}</div>
        </div>

        <div class="col-md-4">
          <div class="text-muted small">Slug</div>
          <div class="fw-semibold">${fn:escapeXml(brand.slug)}</div>
        </div>

        <div class="col-md-12">
          <div class="text-muted small">Logo URL / Path</div>
          <div class="fw-semibold">
            <c:choose>
              <c:when test="${not empty brand.logoUrl}">
                <code>${fn:escapeXml(brand.logoUrl)}</code>
              </c:when>
              <c:otherwise>
                <span class="text-muted">Chưa có</span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

    </div>
  </div>

</div>