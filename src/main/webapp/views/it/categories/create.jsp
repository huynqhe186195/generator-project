<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Thêm danh mục</h3>
      <div class="text-muted">Tạo category mới</div>
    </div>

    <a href="${ctx}/it/categories/list" class="btn btn-outline-secondary btn-sm">
      <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
    </a>
  </div>

  <div class="card shadow-sm" style="border-radius: 12px;">
    <div class="card-body">

      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <form action="${ctx}/it/categories/create" method="post" class="row g-3">
        <div class="col-md-6">
          <label class="form-label fw-bold">Tên danh mục</label>
          <input type="text"
                 name="name"
                 class="form-control"
                 placeholder="VD: Máy phát điện..."
                 value="${fn:escapeXml(name)}"
                 required>
        </div>

        <div class="col-12">
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save me-1"></i> Lưu
          </button>

          <a href="${ctx}/it/categories/list" class="btn btn-light ms-2">
            Huỷ
          </a>
        </div>
      </form>

    </div>
  </div>

</div>