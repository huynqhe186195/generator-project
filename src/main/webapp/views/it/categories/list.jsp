<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card { border-radius: 12px; border: none; }
  .table thead th {
    background: #f8f9fa;
    color: #495057;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.8rem;
  }
  .pagination .page-link { border-radius: 6px; margin: 0 2px; color: #4e73df; }
  .pagination .page-item.active .page-link { background-color: #4e73df; border-color: #4e73df; }
</style>

<!-- Giữ query khi chuyển trang -->
<c:set var="qs" value="&keyword=${fn:escapeXml(param.keyword)}" />
<c:if test="${param.msg == 'created'}">
  <div class="alert alert-success">Thêm danh mục thành công.</div>
</c:if>
<c:if test="${param.msg == 'updated'}">
  <div class="alert alert-success">Cập nhật danh mục thành công.</div>
</c:if>
<c:if test="${param.msg == 'not_found'}">
  <div class="alert alert-warning">Danh mục không tồn tại.</div>
</c:if>
<c:if test="${param.msg == 'invalid_id'}">
  <div class="alert alert-warning">ID không hợp lệ.</div>
</c:if>
<c:if test="${param.msg == 'deleted'}">
  <div class="alert alert-success">Xoá danh mục thành công.</div>
</c:if>

<c:if test="${param.msg == 'cannot_delete'}">
  <div class="alert alert-warning">
    Không thể xoá vì danh mục đang được dùng bởi <b>${param.used}</b> product model.
  </div>
</c:if>

<c:if test="${param.msg == 'delete_error'}">
  <div class="alert alert-danger">Không thể xoá danh mục. Vui lòng thử lại.</div>
</c:if>
<div class="container-fluid py-4">

  <!-- HEADER -->
  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Quản lý danh mục</h3>
      <div class="text-muted">Danh sách category trong hệ thống</div>
    </div>

    <a href="<c:url value='/it/categories/create'/>" class="btn btn-primary btn-sm px-3 shadow-sm">
      <i class="fas fa-plus-circle me-1"></i> Thêm danh mục
    </a>
  </div>

  <!-- FILTER -->
  <div class="card shadow-sm mb-4">
    <div class="card-body bg-light">
      <form action="${ctx}/it/categories/list" method="get" class="row g-2 align-items-end">
        <div class="col-md-6">
          <label class="form-label small fw-bold">Từ khóa</label>
          <input type="text" name="keyword"
                 value="${fn:escapeXml(param.keyword)}"
                 class="form-control form-control-sm"
                 placeholder="Nhập tên danh mục hoặc ID...">
        </div>

        <div class="col-md-2 d-grid">
          <button type="submit" class="btn btn-dark btn-sm">
            <i class="fas fa-filter me-1"></i> Lọc
          </button>
        </div>

        <div class="col-md-2 d-grid">
          <a class="btn btn-outline-secondary btn-sm" href="${ctx}/it/categories/list">
            <i class="fas fa-rotate-left me-1"></i> Reset
          </a>
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
            <th class="text-center" style="width: 70px;">#</th>
            <th style="width: 120px;">ID</th>
            <th>Tên danh mục</th>
            <th class="text-end pe-4" style="width: 220px;">Thao tác</th>
          </tr>
        </thead>

        <tbody>
          <c:forEach items="${categories}" var="c" varStatus="i">
            <tr>
              <td class="text-center text-muted">
                <c:choose>
                  <c:when test="${not empty currentPage and not empty pageSize}">
                    ${(currentPage - 1) * pageSize + i.index + 1}
                  </c:when>
                  <c:otherwise>
                    ${i.index + 1}
                  </c:otherwise>
                </c:choose>
              </td>

              <td class="text-muted">#${c.id}</td>

              <td>
                <div class="fw-bold text-primary">${c.name}</div>
                <small class="text-muted">Category ID: ${c.id}</small>
              </td>

              <td class="text-end pe-4">
                <a href="${ctx}/it/categories/edit?id=${c.id}" class="btn btn-sm btn-outline-warning border-0" title="Sửa">
                  <i class="fas fa-edit"></i>
                </a>

                <a href="${ctx}/it/categories/delete?id=${c.id}" class="btn btn-sm btn-outline-danger border-0"
                   title="Xóa" onclick="return confirm('Bạn chắc chắn muốn xoá danh mục này?');">
                  <i class="fas fa-trash"></i>
                </a>
              </td>
            </tr>
          </c:forEach>

          <c:if test="${empty categories}">
            <tr>
              <td colspan="4" class="text-center py-5 text-muted">
                Không tìm thấy dữ liệu.
              </td>
            </tr>
          </c:if>
        </tbody>

      </table>
    </div>

    <!-- PAGINATION (chỉ hiện khi controller set totalPages/currentPage/totalItems) -->
    <c:if test="${not empty totalPages and totalPages > 1}">
      <c:set var="window" value="2" />
      <c:set var="startPage" value="${currentPage - window}" />
      <c:set var="endPage" value="${currentPage + window}" />
      <c:if test="${startPage < 1}">
        <c:set var="startPage" value="1" />
      </c:if>
      <c:if test="${endPage > totalPages}">
        <c:set var="endPage" value="${totalPages}" />
      </c:if>

      <div class="card-footer bg-white border-top-0 py-3">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
          <div class="text-muted small">
            Trang ${currentPage} / ${totalPages}
            <c:if test="${not empty totalItems}"> • Tổng ${totalItems} danh mục</c:if>
          </div>

          <nav>
            <ul class="pagination pagination-sm mb-0">
              <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/categories/list?page=${currentPage - 1}${qs}">
                  <i class="fas fa-chevron-left"></i>
                </a>
              </li>

              <c:if test="${startPage > 1}">
                <li class="page-item">
                  <a class="page-link" href="${ctx}/it/categories/list?page=1${qs}">1</a>
                </li>
                <c:if test="${startPage > 2}">
                  <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
              </c:if>

              <c:forEach begin="${startPage}" end="${endPage}" var="pg">
                <li class="page-item ${currentPage == pg ? 'active' : ''}">
                  <a class="page-link" href="${ctx}/it/categories/list?page=${pg}${qs}">${pg}</a>
                </li>
              </c:forEach>

              <c:if test="${endPage < totalPages}">
                <c:if test="${endPage < totalPages - 1}">
                  <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
                <li class="page-item">
                  <a class="page-link" href="${ctx}/it/categories/list?page=${totalPages}${qs}">${totalPages}</a>
                </li>
              </c:if>

              <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/categories/list?page=${currentPage + 1}${qs}">
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