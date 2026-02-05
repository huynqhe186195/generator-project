<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card { border-radius: 12px; border: none; }
  .thumb-lg { width: 140px; height: 140px; object-fit: cover; border-radius: 16px; }
  .label { font-size: 0.8rem; color: #6c757d; }
  .value { font-weight: 600; }
  .status-active { color: #28a745; font-weight: 700; }
  .status-locked { color: #dc3545; font-weight: 700; }
  .status-coming { color: #f6c23e; font-weight: 800; }
</style>

<div class="container-fluid py-4">

  <!-- HEADER -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <div>
      <h3 class="fw-bold mb-1">${pm.name}</h3>
      <div class="text-muted small">
        ID: #${pm.id} | Slug: ${pm.slug}
      </div>
    </div>

    <div class="d-flex gap-2">
      <a href="${ctx}/it/products" class="btn btn-outline-secondary btn-sm">
        <i class="fas fa-arrow-left me-1"></i> Quay lại
      </a>

      <a href="${ctx}/it/products/edit?id=${pm.id}" class="btn btn-warning btn-sm">
        <i class="fas fa-edit me-1"></i> Sửa
      </a>

      <!-- ✅ Xuất PDF động -->
      <a href="${ctx}/it/products/pdf?id=${pm.id}" class="btn btn-outline-primary btn-sm" target="_blank">
        <i class="fas fa-file-pdf me-1"></i> Xuất PDF
      </a>

      <!-- ✅ DELETE -->
      <a href="${ctx}/it/products/delete?id=${pm.id}"
         class="btn btn-danger btn-sm"
         onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không? Hành động không thể hoàn tác!');">
        <i class="fas fa-trash me-1"></i> Xóa
      </a>
    </div>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">

      <!-- BASIC INFO -->
      <div class="row g-4">
        <!-- IMAGE -->
        <div class="col-md-3 text-center">
          <c:choose>
            <c:when test="${not empty pm.imageUrl}">
              <img src="${fn:startsWith(pm.imageUrl,'http') ? pm.imageUrl : ctx.concat('/').concat(pm.imageUrl)}"
                   class="thumb-lg shadow-sm border" alt="image">
            </c:when>
            <c:otherwise>
              <img src="https://via.placeholder.com/140x140?text=IMG"
                   class="thumb-lg shadow-sm border" alt="image">
            </c:otherwise>
          </c:choose>
        </div>

        <!-- MAIN FIELDS -->
        <div class="col-md-9">
          <div class="row g-3">

            <div class="col-md-4">
              <div class="label">Brand</div>
              <div class="value">${brandName}</div>
            </div>

            <div class="col-md-4">
              <div class="label">Category</div>
              <div class="value">${categoryName}</div>
            </div>

            <div class="col-md-4">
              <div class="label">Origin</div>
              <div class="value"><c:out value="${pm.origin}" default="-" /></div>
            </div>

            <div class="col-md-4">
              <div class="label">Fuel type</div>
              <div class="value">${pm.fuelType}</div>
            </div>

            <div class="col-md-4">
              <div class="label">Power</div>
              <div class="value">
                <c:choose>
                  <c:when test="${not empty pm.power}">${pm.power}</c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="col-md-4">
              <div class="label">Status</div>
              <div class="value">
                <c:choose>
                  <c:when test="${pm.status == 'ACTIVE'}">
                    <span class="status-active"><i class="fas fa-check-circle me-1"></i>ACTIVE</span>
                  </c:when>
                  <c:when test="${pm.status == 'COMING_SOON'}">
                    <span class="status-coming"><i class="fas fa-clock me-1"></i>COMING_SOON</span>
                  </c:when>
                  <c:otherwise>
                    <span class="status-locked"><i class="fas fa-ban me-1"></i>INACTIVE</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="col-md-4">
              <div class="label">Created at</div>
              <div class="value">
                <c:choose>
                  <c:when test="${not empty pm.createdAt}">
                    <fmt:formatDate value="${pm.createdAt}" pattern="HH:mm:ss dd/MM/yyyy"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="col-md-8">
              <div class="label">PDF</div>
              <div class="value text-muted">
                PDF được tạo tự động từ dữ liệu hiện tại (bấm nút “Xuất PDF”).
              </div>
            </div>

          </div>
        </div>
      </div>

      <hr class="my-4"/>

      <!-- TEXT BLOCKS -->
      <div class="row g-4">
        <div class="col-md-6">
          <h6 class="fw-bold">Description</h6>
          <div class="border rounded p-3 bg-light" style="min-height: 140px;">
            <c:out value="${pm.description}" default="-" />
          </div>
        </div>

        <div class="col-md-6">
          <h6 class="fw-bold">Specifications</h6>
          <div class="border rounded p-3 bg-light" style="min-height: 140px;">
            <c:out value="${pm.specifications}" default="-" />
          </div>
        </div>
      </div>

    </div>
  </div>

</div>
