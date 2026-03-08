<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .news-detail-card {
    border: none;
    border-radius: 16px;
    overflow: hidden;
  }

  .news-cover {
    width: 100%;
    max-height: 420px;
    object-fit: cover;
    border-radius: 14px;
  }

  .news-title {
    font-size: 2rem;
    font-weight: 700;
    color: #212529;
    line-height: 1.4;
  }

  .news-meta {
    display: flex;
    flex-wrap: wrap;
    gap: 10px 20px;
    color: #6c757d;
    font-size: 0.95rem;
  }

  .news-summary {
    font-size: 1.05rem;
    color: #495057;
    background: #f8f9fa;
    border-left: 4px solid #0d6efd;
    padding: 14px 16px;
    border-radius: 10px;
  }

  .news-content {
    font-size: 1.05rem;
    line-height: 1.9;
    color: #212529;
    word-break: break-word;
  }

  .news-content img {
    max-width: 100%;
    height: auto;
    border-radius: 12px;
    margin: 18px 0;
  }

  .news-content table {
    width: 100% !important;
    border-collapse: collapse;
    margin: 16px 0;
  }

  .news-content table,
  .news-content th,
  .news-content td {
    border: 1px solid #dee2e6;
    padding: 8px;
  }

  .badge-soft {
    background: #f8f9fa;
    color: #343a40;
    border: 1px solid #dee2e6;
    border-radius: 999px;
    padding: 6px 12px;
    font-size: 0.85rem;
  }

  .detail-actions a {
    min-width: 120px;
  }
</style>

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Chi tiết bài viết</h3>
      <div class="text-muted small mt-1">Thông tin đầy đủ của bài viết</div>
    </div>

    <div class="d-flex gap-2 flex-wrap detail-actions">
      <a href="${ctx}/it/news/list" class="btn btn-outline-secondary btn-sm px-3 shadow-sm">
        <i class="fas fa-arrow-left me-1"></i> Quay lại
      </a>
      <a href="${ctx}/it/news/edit?id=${news.id}" class="btn btn-warning btn-sm px-3 shadow-sm text-white">
        <i class="fas fa-pen me-1"></i> Chỉnh sửa
      </a>
    </div>
  </div>

  <c:if test="${empty news}">
    <div class="alert alert-danger">Không tìm thấy bài viết.</div>
  </c:if>

  <c:if test="${not empty news}">
    <div class="card shadow-sm news-detail-card">
      <div class="card-body p-4 p-md-5">

        <div class="mb-3 d-flex flex-wrap gap-2">
          <span class="badge-soft">ID: #${news.id}</span>
          <span class="badge-soft">
            Danh mục:
            <c:out value="${empty news.category ? 'Chưa phân loại' : news.category}" />
          </span>
          <span class="badge-soft">
            Trạng thái:
            <c:out value="${empty news.status ? 'draft' : news.status}" />
          </span>
          <c:if test="${news.isFeatured == 1}">
            <span class="badge bg-warning text-dark">Nổi bật</span>
          </c:if>
        </div>

        <div class="news-title mb-3">
          <c:out value="${news.title}" />
        </div>

        <div class="news-meta mb-4">
          <div>
            <i class="fas fa-user me-1"></i>
            <strong>Tác giả:</strong>
            <c:out value="${empty news.author ? 'Admin' : news.author}" />
          </div>

          <div>
            <i class="fas fa-eye me-1"></i>
            <strong>Lượt xem:</strong>
            ${news.views != null ? news.views : 0}
          </div>

          <div>
            <i class="fas fa-calendar-alt me-1"></i>
            <strong>Ngày đăng:</strong>
            <c:out value="${news.publishedAt != null ? news.publishedAt : news.createdAt}" />
          </div>

          <c:if test="${not empty news.slug}">
            <div>
              <i class="fas fa-link me-1"></i>
              <strong>Slug:</strong>
              <c:out value="${news.slug}" />
            </div>
          </c:if>
        </div>

        <c:if test="${not empty news.imageUrl}">
          <div class="mb-4">
            <c:choose>
              <c:when test="${fn:startsWith(news.imageUrl, 'http')}">
                <img src="${news.imageUrl}" class="news-cover shadow-sm" alt="cover"
                     onerror="this.onerror=null;this.src='${ctx}/uploads/download.jpg';">
              </c:when>

              <c:when test="${fn:startsWith(news.imageUrl, '/') or fn:startsWith(news.imageUrl, 'uploads/') or fn:startsWith(news.imageUrl, 'news-images/')}">
                <img src="${ctx}${fn:startsWith(news.imageUrl, '/') ? '' : '/'}${news.imageUrl}"
                     class="news-cover shadow-sm" alt="cover"
                     onerror="this.onerror=null;this.src='${ctx}/uploads/download.jpg';">
              </c:when>

              <c:otherwise>
                <img src="${ctx}/uploads/news-images/${news.imageUrl}"
                     class="news-cover shadow-sm" alt="cover"
                     onerror="this.onerror=null;this.src='${ctx}/uploads/download.jpg';">
              </c:otherwise>
            </c:choose>
          </div>
        </c:if>

        <c:if test="${not empty news.summary}">
          <div class="news-summary mb-4">
            <strong>Tóm tắt:</strong>
            <c:out value="${news.summary}" />
          </div>
        </c:if>

        <c:if test="${not empty news.seoDescription}">
          <div class="mb-4 text-muted">
            <strong>SEO description:</strong>
            <c:out value="${news.seoDescription}" />
          </div>
        </c:if>

        <hr class="my-4">

        <div class="news-content">
          ${news.content}
        </div>

      </div>
    </div>
  </c:if>

</div>