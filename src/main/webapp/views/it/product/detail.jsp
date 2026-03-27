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

  .thumb-sm {
    width: 52px;
    height: 52px;
    object-fit: cover;
    border-radius: 10px;
    cursor: pointer;
  }
</style>

<div class="container-fluid py-4">

  <!-- HEADER -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <div>
      <h3 class="fw-bold mb-1">${pm.name}</h3>
      <div class="text-muted small">
        Mã: #${pm.id} | Đường dẫn tĩnh: ${pm.slug}
      </div>
    </div>

    <div class="d-flex gap-2">
      <a href="${ctx}/it/products" class="btn btn-outline-secondary btn-sm">
        <i class="fas fa-arrow-left me-1"></i> Quay lại
      </a>

      <a href="${ctx}/it/products/edit?id=${pm.id}" class="btn btn-warning btn-sm">
        <i class="fas fa-edit me-1"></i> Sửa
      </a>

      <a href="${ctx}/it/products/pdf?id=${pm.id}" class="btn btn-outline-primary btn-sm" target="_blank">
        <i class="fas fa-file-pdf me-1"></i> Xuất PDF
      </a>

      <a href="${ctx}/it/products/delete?id=${pm.id}"
         class="btn btn-danger btn-sm"
         onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không? Hành động này không thể hoàn tác!');">
        <i class="fas fa-trash me-1"></i> Xóa
      </a>
    </div>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">

      <!-- THÔNG TIN CƠ BẢN -->
      <div class="row g-4">

        <!-- ẢNH SẢN PHẨM -->
        <div class="col-md-3 text-center">

          <c:set var="mainImg" value="" />
          <c:if test="${not empty imageUrls}">
            <c:set var="mainImg" value="${imageUrls[0]}" />
          </c:if>

          <c:choose>
            <c:when test="${not empty mainImg}">
              <img id="mainPreview"
                   src="${fn:startsWith(mainImg,'http') ? mainImg : ctx.concat('/').concat(mainImg)}"
                   class="thumb-lg shadow-sm border" alt="Ảnh sản phẩm">
            </c:when>

            <c:when test="${not empty pm.imageUrl}">
              <img id="mainPreview"
                   src="${fn:startsWith(pm.imageUrl,'http') ? pm.imageUrl : ctx.concat('/').concat(pm.imageUrl)}"
                   class="thumb-lg shadow-sm border" alt="Ảnh sản phẩm">
            </c:when>

            <c:otherwise>
              <img id="mainPreview"
                   src="https://via.placeholder.com/140x140?text=IMG"
                   class="thumb-lg shadow-sm border" alt="Ảnh sản phẩm">
            </c:otherwise>
          </c:choose>

          <c:if test="${not empty imageUrls}">
            <div class="d-flex flex-wrap justify-content-center gap-2 mt-3">
              <c:forEach items="${imageUrls}" var="img" varStatus="st">
                <img class="thumb-sm border shadow-sm"
                     src="${fn:startsWith(img,'http') ? img : ctx.concat('/').concat(img)}"
                     onclick="document.getElementById('mainPreview').src=this.src"
                     alt="Ảnh nhỏ ${st.index}">
              </c:forEach>
            </div>
          </c:if>

        </div>

        <!-- THÔNG TIN CHÍNH -->
        <div class="col-md-9">
          <div class="row g-3">

            <div class="col-md-4">
              <div class="label">Hãng</div>
              <div class="value">${brandName}</div>
            </div>

            <div class="col-md-4">
              <div class="label">Danh mục</div>
              <div class="value">${categoryName}</div>
            </div>

            <div class="col-md-4">
              <div class="label">Xuất xứ</div>
              <div class="value"><c:out value="${pm.origin}" default="-" /></div>
            </div>

            <div class="col-md-4">
              <div class="label">Loại nhiên liệu</div>
              <div class="value">
                <c:choose>
                  <c:when test="${pm.fuelType == 'DIESEL'}">Dầu diesel</c:when>
                  <c:when test="${pm.fuelType == 'GASOLINE'}">Xăng</c:when>
                  <c:when test="${pm.fuelType == 'OTHER'}">Khác</c:when>
                  <c:otherwise><c:out value="${pm.fuelType}" default="-" /></c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="col-md-4">
              <div class="label">Công suất</div>
              <div class="value">
                <c:choose>
                  <c:when test="${not empty pm.power}">${pm.power}</c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="col-md-4">
              <div class="label">Trạng thái</div>
              <div class="value">
                <c:choose>
                  <c:when test="${pm.status == 'ACTIVE'}">
                    <span class="status-active"><i class="fas fa-check-circle me-1"></i>Đang hoạt động</span>
                  </c:when>
                  <c:when test="${pm.status == 'COMING_SOON'}">
                    <span class="status-coming"><i class="fas fa-clock me-1"></i>Sắp ra mắt</span>
                  </c:when>
                  <c:otherwise>
                    <span class="status-locked"><i class="fas fa-ban me-1"></i>Ngừng hoạt động</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="col-md-4">
              <div class="label">Ngày tạo</div>
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
              <div class="label">Tệp PDF</div>
              <div class="value text-muted">
                Tệp PDF được tạo tự động từ dữ liệu hiện tại (bấm nút “Xuất PDF”).
              </div>
            </div>

          </div>
        </div>

      </div>

      <hr class="my-4"/>

      <!-- NỘI DUNG MÔ TẢ -->
      <div class="row g-4">
        <div class="col-md-6">
          <h6 class="fw-bold">Mô tả</h6>
          <div class="border rounded p-3 bg-light" style="min-height: 140px;">
            <c:out value="${pm.description}" default="-" />
          </div>
        </div>

        <div class="col-md-6">
          <h6 class="fw-bold">Thông số kỹ thuật</h6>
          <div class="border rounded p-3 bg-light" style="min-height: 140px;">
            <c:out value="${pm.specifications}" default="-" />
          </div>
        </div>
      </div>

    </div>
  </div>

</div>