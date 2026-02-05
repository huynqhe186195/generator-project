<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card { border-radius: 12px; border: none; }
  .table thead th { background: #f8f9fa; color: #495057; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; }
  .thumb-img { width: 42px; height: 42px; object-fit: cover; border-radius: 10px; }
  .status-active { color: #28a745; font-weight: 500; }
  .status-locked { color: #dc3545; font-weight: 500; }
  .status-coming { color: #f6c23e; font-weight: 600; }
  .pagination .page-link { border-radius: 6px; margin: 0 2px; color: #4e73df; }
  .pagination .page-item.active .page-link { background-color: #4e73df; border-color: #4e73df; }
</style>

<c:set var="qs"
       value="&keyword=${fn:escapeXml(param.keyword)}
              &brandId=${fn:escapeXml(param.brandId)}
              &categoryId=${fn:escapeXml(param.categoryId)}
              &fuelType=${fn:escapeXml(param.fuelType)}
              &power=${fn:escapeXml(param.power)}
              &status=${fn:escapeXml(param.status)}" />

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-dark">Quản lý Product Model</h3>

    <!-- ✅ ADD -->
    <a href="${ctx}/it/products/add" class="btn btn-primary px-4 shadow-sm">
      <i class="fas fa-plus-circle me-2"></i> Thêm mẫu
    </a>
  </div>

  <!-- FILTER -->
  <div class="card shadow-sm mb-4">
    <div class="card-body bg-light border-radius-12">
      <form action="${ctx}/it/products" method="get" class="row g-2 align-items-end">

        <div class="col-md-3">
          <label class="form-label small fw-bold">Tên</label>
          <input type="text" name="keyword"
                 value="${fn:escapeXml(param.keyword)}"
                 class="form-control form-control-sm"
                 placeholder="Tên, slug...">
        </div>

        <div class="col-md-2">
          <label class="form-label small fw-bold">Hãng</label>
          <select class="form-select form-select-sm" name="brandId">
            <option value="">-- Tất cả --</option>
            <c:forEach items="${brands}" var="b">
              <option value="${b.id}" ${param.brandId == (b.id.toString()) ? 'selected' : ''}>
                  ${b.name}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-2">
          <label class="form-label small fw-bold">Danh mục</label>
          <select class="form-select form-select-sm" name="categoryId">
            <option value="">-- Tất cả --</option>
            <c:forEach items="${categories}" var="cat">
              <option value="${cat.id}" ${param.categoryId == (cat.id.toString()) ? 'selected' : ''}>
                  ${cat.name}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-1">
          <label class="form-label small fw-bold">Fuel</label>
          <select class="form-select form-select-sm" name="fuelType">
            <option value="">--</option>
            <option value="DIESEL" ${param.fuelType == 'DIESEL' ? 'selected' : ''}>DIESEL</option>
            <option value="GASOLINE" ${param.fuelType == 'GASOLINE' ? 'selected' : ''}>GAS</option>
            <option value="OTHER" ${param.fuelType == 'OTHER' ? 'selected' : ''}>OTHER</option>
          </select>
        </div>

        <div class="col-md-1">
          <label class="form-label small fw-bold">Power ≥</label>
          <input type="number" step="0.01" name="power"
                 value="${fn:escapeXml(param.power)}"
                 class="form-control form-control-sm"
                 placeholder="150">
        </div>

        <div class="col-md-2">
          <label class="form-label small fw-bold">Trạng thái</label>
          <select class="form-select form-select-sm" name="status">
            <option value="">-- Tất cả --</option>
            <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
            <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
            <option value="COMING_SOON" ${param.status == 'COMING_SOON' ? 'selected' : ''}>COMING</option>
          </select>
        </div>

        <div class="col-md-1 d-grid">
          <button type="submit" class="btn btn-dark btn-sm">
            <i class="fas fa-filter me-1"></i>Lọc
          </button>
        </div>

      </form>
    </div>
  </div>

  <!-- TABLE -->
  <div class="card shadow-sm">
    <div class="table-responsive">
      <table class="table table-hover align-middle mb-0">
        <thead>
        <tr>
          <th class="text-center" style="width: 60px;">#</th>
          <th>Mẫu sản phẩm</th>
          <th>Brand</th>
          <th>Fuel</th>
          <th class="text-center">Power</th>
          <th class="text-center">Status</th>
          <th class="text-end pe-4">Thao tác</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${listModels}" var="pm" varStatus="i">
          <tr>
            <td class="text-center text-muted">${i.index + 1}</td>

            <td>
              <div class="d-flex align-items-center">
                <c:choose>
                  <c:when test="${not empty pm.imageUrl and fn:startsWith(pm.imageUrl, 'http')}">
                    <img src="${pm.imageUrl}" class="thumb-img me-3 shadow-sm border" alt="thumb">
                  </c:when>
                  <c:when test="${not empty pm.imageUrl}">
                    <img src="${ctx}/${pm.imageUrl}" class="thumb-img me-3 shadow-sm border" alt="thumb">
                  </c:when>
                  <c:otherwise>
                    <img src="https://via.placeholder.com/42x42?text=IMG" class="thumb-img me-3 shadow-sm border" alt="thumb">
                  </c:otherwise>
                </c:choose>

                <div>
                  <div class="fw-bold text-primary">${pm.name}</div>
                  <small class="text-muted">Slug: ${pm.slug} | ID: #${pm.id}</small>
                </div>
              </div>
            </td>

            <td>
              <c:forEach items="${brands}" var="b">
                <c:if test="${b.id == pm.brandId}">
                  <span class="badge bg-light text-dark border">${b.name}</span>
                </c:if>
              </c:forEach>
            </td>

            <td><span class="badge bg-light text-dark border">${pm.fuelType}</span></td>

            <td class="text-center"><span class="badge bg-light text-dark border">${pm.power}</span></td>

            <td class="text-center">
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
            </td>

            <td class="text-end pe-4">
              <!-- ✅ DETAIL -->
              <a href="${ctx}/it/products/detail?id=${pm.id}" class="btn btn-sm btn-outline-info border-0" title="Xem">
                <i class="fas fa-eye"></i>
              </a>
              <!-- ✅ EDIT -->
              <a href="${ctx}/it/products/edit?id=${pm.id}" class="btn btn-sm btn-outline-warning border-0" title="Sửa">
                <i class="fas fa-edit"></i>
              </a>
              <!-- ✅ DELETE -->
              <a href="${ctx}/it/products/delete?id=${pm.id}"
                 class="btn btn-sm btn-outline-danger border-0"
                 title="Xóa"
                 onclick="return confirm('Bạn chắc chắn muốn xóa mẫu này?');">
                <i class="fas fa-trash"></i>
              </a>
            </td>

          </tr>
        </c:forEach>

        <c:if test="${empty listModels}">
          <tr>
            <td colspan="7" class="text-center py-5 text-muted">Không tìm thấy dữ liệu.</td>
          </tr>
        </c:if>

        </tbody>
      </table>
    </div>

    <!-- PAGINATION -->
    <c:if test="${totalPages > 1}">
      <div class="card-footer bg-white border-top-0 py-3">
        <div class="d-flex justify-content-between align-items-center">
          <div class="text-muted small">Trang ${currentPage} / ${totalPages}</div>

          <nav>
            <ul class="pagination pagination-sm mb-0">
              <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/products?page=${currentPage - 1}${qs}">
                  <i class="fas fa-chevron-left"></i>
                </a>
              </li>

              <c:forEach begin="1" end="${totalPages}" var="pg">
                <li class="page-item ${currentPage == pg ? 'active' : ''}">
                  <a class="page-link" href="${ctx}/it/products?page=${pg}${qs}">${pg}</a>
                </li>
              </c:forEach>

              <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/products?page=${currentPage + 1}${qs}">
                  <i class="fas fa-chevron-right"></i>
                </a>
              </li>
            </ul>
          </nav>
        </div>
      </div>
    </c:if>

  </div>
</div>
