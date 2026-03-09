<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card {
    border-radius: 12px;
    border: none;
  }

  .table thead th {
    background: #f8f9fa;
    color: #495057;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.8rem;
  }

  .thumb-img {
    width: 56px;
    height: 56px;
    object-fit: cover;
    border-radius: 10px;
  }

  .status-published {
    color: #28a745;
    font-weight: 600;
  }

  .status-draft {
    color: #f6c23e;
    font-weight: 600;
  }

  .status-archived {
    color: #dc3545;
    font-weight: 600;
  }

  .pagination .page-link {
    border-radius: 6px;
    margin: 0 2px;
    color: #4e73df;
  }

  .pagination .page-item.active .page-link {
    background-color: #4e73df;
    border-color: #4e73df;
  }
</style>
<c:if test="${param.msg == 'add_success'}">
  <div class="alert alert-success">
    <i class="fas fa-circle-check me-1"></i> Thêm bài viết thành công.
  </div>
</c:if>
<c:if test="${param.msg == 'update_success'}">
  <div class="alert alert-success">
    <i class="fas fa-circle-check me-1"></i> Cập nhật bài viết thành công.
  </div>
</c:if>
<c:if test="${param.msg == 'delete_success'}">
  <div class="alert alert-success">
    <i class="fas fa-circle-check me-1"></i> Xóa bài viết thành công.
  </div>
</c:if>

<c:if test="${param.msg == 'not_found'}">
  <div class="alert alert-warning">
    <i class="fas fa-triangle-exclamation me-1"></i> Bài viết không tồn tại hoặc đã bị xóa.
  </div>
</c:if>

<c:if test="${param.msg == 'invalid_id'}">
  <div class="alert alert-danger">
    <i class="fas fa-circle-exclamation me-1"></i> ID bài viết không hợp lệ.
  </div>
</c:if>
<c:set var="qs"
  value="&keyword=${fn:escapeXml(param.keyword)}&category=${fn:escapeXml(param.category)}&status=${fn:escapeXml(param.status)}" />

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <h3 class="fw-bold text-dark mb-0">Quản lý bài viết</h3>

    <div class="d-flex align-items-center gap-2 flex-wrap">
      <a href="${ctx}/it/news/create" class="btn btn-primary btn-sm px-3 shadow-sm">
        <i class="fas fa-plus-circle me-1"></i> Thêm bài viết
      </a>
    </div>
  </div>

  <div class="card shadow-sm mb-4">
    <div class="card-body bg-light border-radius-12">
      <form action="${ctx}/it/news/list" method="get" class="row g-2 align-items-end">

        <div class="col-md-5">
          <label class="form-label small fw-bold">Từ khóa</label>
          <input type="text" name="keyword" value="${fn:escapeXml(param.keyword)}"
                 class="form-control form-control-sm"
                 placeholder="Tìm theo tiêu đề, tác giả...">
        </div>

        <div class="col-md-3">
          <label class="form-label small fw-bold">Danh mục</label>
          <input type="text" name="category" value="${fn:escapeXml(param.category)}"
                 class="form-control form-control-sm"
                 placeholder="Ví dụ: Generator">
        </div>

        <div class="col-md-2">
          <label class="form-label small fw-bold">Trạng thái</label>
          <select class="form-select form-select-sm" name="status">
            <option value="">-- Tất cả --</option>
            <option value="draft" ${param.status == 'draft' ? 'selected' : ''}>DRAFT</option>
            <option value="published" ${param.status == 'published' ? 'selected' : ''}>PUBLISHED</option>
            <option value="archived" ${param.status == 'archived' ? 'selected' : ''}>ARCHIVED</option>
          </select>
        </div>

        <div class="col-md-2 d-flex gap-2">
          <button type="submit" class="btn btn-dark btn-sm w-100">
            <i class="fas fa-filter me-1"></i>Lọc
          </button>

          <a href="${ctx}/it/news/list" class="btn btn-outline-secondary btn-sm w-100">
            <i class="fas fa-rotate-left me-1"></i>Đặt lại
          </a>
        </div>
      </form>
    </div>
  </div>

  <div class="card shadow-sm">
    <div class="table-responsive">
      <table class="table table-hover align-middle mb-0">
        <thead>
          <tr>
            <th class="text-center" style="width: 60px;">#</th>
            <th>Bài viết</th>
            <th>Tác giả</th>
            <th>Danh mục</th>
            <th class="text-center">Views</th>
            <th class="text-center">Trạng thái</th>
            <th>Ngày đăng</th>
            <th class="text-end pe-4">Thao tác</th>
          </tr>
        </thead>

        <tbody>
          <c:forEach items="${newsList}" var="n" varStatus="i">
            <tr>
              <td class="text-center text-muted">${(currentPage - 1) * pageSize + i.index + 1}</td>

              <td>
                <div class="d-flex align-items-center">
                  <c:choose>
                    <c:when test="${not empty n.imageUrl and fn:startsWith(n.imageUrl, 'http')}">
                      <img src="${n.imageUrl}" class="thumb-img me-3 shadow-sm border" alt="thumb"
                           onerror="this.onerror=null;this.src='${ctx}/uploads/download.jpg';">
                    </c:when>
                    <c:when test="${not empty n.imageUrl and (fn:startsWith(n.imageUrl, '/') or fn:startsWith(n.imageUrl, 'uploads/') or fn:startsWith(n.imageUrl, 'news-images/'))}">
                      <img src="${ctx}${fn:startsWith(n.imageUrl, '/') ? '' : '/'}${n.imageUrl}"
                           class="thumb-img me-3 shadow-sm border" alt="thumb"
                           onerror="this.onerror=null;this.src='${ctx}/uploads/download.jpg';">
                    </c:when>
                    <c:when test="${not empty n.imageUrl and (fn:endsWith(n.imageUrl, '.jpg') or fn:endsWith(n.imageUrl, '.jpeg') or fn:endsWith(n.imageUrl, '.png') or fn:endsWith(n.imageUrl, '.webp') or fn:endsWith(n.imageUrl, '.gif'))}">
                      <img src="${ctx}/uploads/news-images/${n.imageUrl}"
                           class="thumb-img me-3 shadow-sm border" alt="thumb"
                           onerror="this.onerror=null;this.src='${ctx}/uploads/download.jpg';">
                    </c:when>
                    <c:otherwise>
                      <img src="${ctx}/uploads/download.jpg" class="thumb-img me-3 shadow-sm border" alt="thumb">
                    </c:otherwise>
                  </c:choose>

                  <div>
                    <div class="fw-bold text-primary">${n.title}</div>
                    <small class="text-muted">
                      ID: #${n.id}
                      <c:if test="${not empty n.summary}">
                        | ${fn:length(n.summary) > 80 ? fn:substring(n.summary, 0, 80) : n.summary}
                        <c:if test="${fn:length(n.summary) > 80}">...</c:if>
                      </c:if>
                    </small>
                  </div>
                </div>
              </td>

              <td>
                <span class="badge bg-light text-dark border">
                  <c:out value="${empty n.author ? 'Admin' : n.author}" />
                </span>
              </td>

              <td>
                <span class="badge bg-light text-dark border">
                  <c:out value="${empty n.category ? 'Chưa phân loại' : n.category}" />
                </span>
              </td>

              <td class="text-center">
                <span class="badge bg-light text-dark border">${n.views}</span>
              </td>

              <td class="text-center">
                <c:choose>
                  <c:when test="${n.status == 'published'}">
                    <span class="status-published">
                      <i class="fas fa-check-circle me-1"></i>PUBLISHED
                    </span>
                  </c:when>
                  <c:when test="${n.status == 'draft'}">
                    <span class="status-draft">
                      <i class="fas fa-pen-to-square me-1"></i>DRAFT
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="status-archived">
                      <i class="fas fa-box-archive me-1"></i>ARCHIVED
                    </span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td>
                <small class="text-muted">
                  <c:out value="${n.publishedAt != null ? n.publishedAt : n.createdAt}" />
                </small>
              </td>

              <td class="text-end pe-4">
                <a href="${ctx}/it/news/detail?id=${n.id}" class="btn btn-sm btn-outline-info border-0" title="Xem">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="${ctx}/it/news/edit?id=${n.id}" class="btn btn-sm btn-outline-warning border-0" title="Sửa">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="${ctx}/it/news/delete?id=${n.id}" class="btn btn-sm btn-outline-danger border-0"
                   title="Xóa"
                   onclick="return confirm('Bạn chắc chắn muốn xóa bài viết này?');">
                  <i class="fas fa-trash"></i>
                </a>
              </td>
            </tr>
          </c:forEach>

          <c:if test="${empty newsList}">
            <tr>
              <td colspan="8" class="text-center py-5 text-muted">Không tìm thấy bài viết nào.</td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>

    <c:if test="${totalPages > 1}">
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
          <div class="text-muted small">Trang ${currentPage} / ${totalPages} • Tổng ${totalItems} bài viết</div>

          <nav>
            <ul class="pagination pagination-sm mb-0">
              <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/news/list?page=${currentPage - 1}${qs}">
                  <i class="fas fa-chevron-left"></i>
                </a>
              </li>

              <c:if test="${startPage > 1}">
                <li class="page-item">
                  <a class="page-link" href="${ctx}/it/news/list?page=1${qs}">1</a>
                </li>
                <c:if test="${startPage > 2}">
                  <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
              </c:if>

              <c:forEach begin="${startPage}" end="${endPage}" var="pg">
                <li class="page-item ${currentPage == pg ? 'active' : ''}">
                  <a class="page-link" href="${ctx}/it/news/list?page=${pg}${qs}">${pg}</a>
                </li>
              </c:forEach>

              <c:if test="${endPage < totalPages}">
                <c:if test="${endPage < totalPages - 1}">
                  <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
                <li class="page-item">
                  <a class="page-link" href="${ctx}/it/news/list?page=${totalPages}${qs}">${totalPages}</a>
                </li>
              </c:if>

              <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${ctx}/it/news/list?page=${currentPage + 1}${qs}">
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