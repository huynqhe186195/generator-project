<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:if test="${param.msg == 'delete_success'}">
  <div class="alert alert-success">Xóa brand thành công.</div>
</c:if>
<c:if test="${param.msg == 'brand_in_use'}">
  <div class="alert alert-warning">Không thể xóa vì brand đang được sử dụng bởi Product.</div>
</c:if>
<c:if test="${param.msg == 'delete_failed'}">
  <div class="alert alert-danger">Xóa brand thất bại.</div>
</c:if>
<style>
  .card { border-radius: 12px; border: none; }
  .table thead th { background: #f8f9fa; color: #495057; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; }
  .thumb-img { width: 42px; height: 42px; object-fit: contain; border-radius: 10px; background: #fff; }
  .pagination .page-link { border-radius: 6px; margin: 0 2px; color: #4e73df; }
  .pagination .page-item.active .page-link { background-color: #4e73df; border-color: #4e73df; }
</style>

<!-- giữ query khi paginate -->
<c:set var="qs" value="&q=${fn:escapeXml(param.q)}&sort=${fn:escapeXml(param.sort)}&size=${fn:escapeXml(param.size)}" />

<div class="container-fluid py-4">

  <!-- Header -->
  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <h3 class="fw-bold text-dark mb-0">Quản lý Brand</h3>

    <!-- bạn đang add brand bằng POST /it/brands/add (từ màn add product) nên tạm để link này -->
    <a href="${ctx}/it/brands/create" class="btn btn-primary btn-sm px-3 shadow-sm">
      <i class="fas fa-plus-circle me-1"></i> Thêm brand
    </a>
  </div>

  <!-- FILTER (khớp controller: q, sort, size) -->
  <div class="card shadow-sm mb-4">
    <div class="card-body bg-light border-radius-12">
      <form action="${ctx}/it/brands" method="get" class="row g-2 align-items-end">

        <div class="col-md-4">
          <label class="form-label small fw-bold">Từ khóa</label>
          <input type="text" name="q"
                 value="${fn:escapeXml(param.q)}"
                 class="form-control form-control-sm"
                 placeholder="Tên, slug...">
        </div>

        <div class="col-md-3">
          <label class="form-label small fw-bold">Sắp xếp</label>
          <select class="form-select form-select-sm" name="sort">
            <option value="" ${empty param.sort ? 'selected' : ''}>Name A→Z</option>
            <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>Name Z→A</option>
            <option value="id_desc" ${param.sort == 'id_desc' ? 'selected' : ''}>Newest (ID desc)</option>
            <option value="id_asc" ${param.sort == 'id_asc' ? 'selected' : ''}>Oldest (ID asc)</option>
          </select>
        </div>

        <div class="col-md-2">
          <label class="form-label small fw-bold">Page size</label>
          <select class="form-select form-select-sm" name="size">
            <option value="10" ${(empty param.size || param.size == '10') ? 'selected' : ''}>10 / page</option>
            <option value="20" ${param.size == '20' ? 'selected' : ''}>20 / page</option>
            <option value="50" ${param.size == '50' ? 'selected' : ''}>50 / page</option>
          </select>
        </div>

        <div class="col-md-1 d-grid">
          <button type="submit" class="btn btn-dark btn-sm">
            <i class="fas fa-filter me-1"></i>Lọc
          </button>
        </div>

        <div class="col-md-2 d-grid">
          <a class="btn btn-outline-secondary btn-sm" href="${ctx}/it/brands">Reset</a>
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
          <th>Brand</th>
          <th>Slug</th>
          <th class="text-center" style="width: 90px;">Logo</th>
          <th class="text-end pe-4" style="width: 140px;">Thao tác</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${brands}" var="b" varStatus="i">
          <tr>
            <td class="text-center text-muted">
              ${((page - 1) * size) + i.index + 1}
            </td>

            <td>
              <div class="fw-bold text-primary">${fn:escapeXml(b.name)}</div>
              <small class="text-muted">ID: #${b.id}</small>
            </td>

            <td>
              <span class="badge bg-light text-dark border">${fn:escapeXml(b.slug)}</span>
            </td>

            <td class="text-center">
              <c:choose>
                <c:when test="${not empty b.logoUrl and fn:startsWith(b.logoUrl, 'http')}">
                  <img src="${fn:escapeXml(b.logoUrl)}" class="thumb-img shadow-sm border" alt="logo">
                </c:when>
                <c:when test="${not empty b.logoUrl}">
                  <img src="${ctx}/${fn:escapeXml(b.logoUrl)}" class="thumb-img shadow-sm border" alt="logo">
                </c:when>
                <c:otherwise>
                  <img src="https://via.placeholder.com/42x42?text=LOGO" class="thumb-img shadow-sm border" alt="logo">
                </c:otherwise>
              </c:choose>
            </td>

            <td class="text-end pe-4">
            <a href="${ctx}/it/brands/detail?id=${b.id}" class="btn btn-sm btn-outline-info border-0" title="Xem">
              <i class="fas fa-eye"></i>
            </a>
              <a href="${ctx}/it/brands/edit?id=${b.id}" class="btn btn-sm btn-outline-warning border-0" title="Sửa">
                <i class="fas fa-edit"></i>
              </a>
              <a href="${ctx}/it/brands/delete?id=${b.id}"
                 class="btn btn-sm btn-outline-danger border-0"
                 title="Xóa"
                 onclick="return confirm('Bạn chắc chắn muốn xóa brand này?');">
                <i class="fas fa-trash"></i>
              </a>
            </td>
          </tr>
        </c:forEach>

        <c:if test="${empty brands}">
          <tr>
            <td colspan="5" class="text-center py-5 text-muted">Không tìm thấy dữ liệu.</td>
          </tr>
        </c:if>

        </tbody>
      </table>
    </div>

    <c:if test="${totalPages > 1}">
      <c:set var="window" value="2"/>
      <c:set var="startPage" value="${page - window}"/>
      <c:set var="endPage" value="${page + window}"/>
      <c:if test="${startPage < 1}">
        <c:set var="startPage" value="1"/>
      </c:if>
      <c:if test="${endPage > totalPages}">
        <c:set var="endPage" value="${totalPages}"/>
      </c:if>

      <div class="card-footer bg-white border-top-0 py-3">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
          <div class="text-muted small">Trang ${page} / ${totalPages} • Tổng ${total} brand</div>

          <nav>
            <ul class="pagination pagination-sm mb-0">

              <li class="page-item ${page == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/brands?page=${page - 1}${qs}">
                  <i class="fas fa-chevron-left"></i>
                </a>
              </li>

              <c:if test="${startPage > 1}">
                <li class="page-item"><a class="page-link" href="${ctx}/it/brands?page=1${qs}">1</a></li>
                <c:if test="${startPage > 2}">
                  <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
              </c:if>

              <c:forEach begin="${startPage}" end="${endPage}" var="pg">
                <li class="page-item ${page == pg ? 'active' : ''}">
                  <a class="page-link" href="${ctx}/it/brands?page=${pg}${qs}">${pg}</a>
                </li>
              </c:forEach>

              <c:if test="${endPage < totalPages}">
                <c:if test="${endPage < totalPages - 1}">
                  <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
                <li class="page-item">
                  <a class="page-link" href="${ctx}/it/brands?page=${totalPages}${qs}">${totalPages}</a>
                </li>
              </c:if>

              <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/brands?page=${page + 1}${qs}">
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