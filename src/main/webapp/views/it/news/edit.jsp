<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .card {
    border-radius: 12px;
    border: none;
  }

  .form-label {
    font-weight: 600;
    color: #495057;
  }

  .form-control,
  .form-select,
  textarea {
    border-radius: 10px;
  }

  .preview-image {
    width: 220px;
    height: 140px;
    object-fit: cover;
    border-radius: 10px;
    border: 1px solid #dee2e6;
    background: #f8f9fa;
  }
</style>

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Chỉnh sửa bài viết</h3>
      <div class="text-muted small mt-1">Cập nhật thông tin bài viết</div>
    </div>

    <a href="${ctx}/it/news/list" class="btn btn-outline-secondary btn-sm px-3 shadow-sm">
      <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
    </a>
  </div>

  <c:if test="${not empty error}">
    <div class="alert alert-danger shadow-sm">
      <i class="fas fa-circle-exclamation me-1"></i> ${error}
    </div>
  </c:if>

  <div class="card shadow-sm">
    <div class="card-body p-4">
      <form action="${ctx}/it/news/edit" method="post" enctype="multipart/form-data" class="row g-3">

        <input type="hidden" name="id" value="${news.id}">
        <input type="hidden" name="oldImage" value="${fn:escapeXml(news.imageUrl)}">

        <div class="col-md-8">
          <label class="form-label">Tiêu đề bài viết <span class="text-danger">*</span></label>
          <input type="text" name="title" class="form-control"
                 value="${fn:escapeXml(news.title)}" placeholder="Nhập tiêu đề bài viết">
        </div>

        <div class="col-md-4">
          <label class="form-label">Slug</label>
          <input type="text" name="slug" class="form-control"
                 value="${fn:escapeXml(news.slug)}" placeholder="tu-dong-sinh-neu-bo-trong">
        </div>

        <div class="col-md-4">
          <label class="form-label">Tác giả</label>
          <input type="text" name="author" class="form-control"
                 value="${fn:escapeXml(news.author)}" placeholder="Ví dụ: Admin">
        </div>

        <div class="col-md-4">
          <label class="form-label">Danh mục</label>
          <input type="text" name="category" class="form-control"
                 value="${fn:escapeXml(news.category)}" placeholder="Ví dụ: Generator">
        </div>

        <div class="col-md-4">
          <label class="form-label">Nổi bật</label>
          <select name="isFeatured" class="form-select">
            <option value="0" ${news.isFeatured == 0 || empty news.isFeatured ? 'selected' : ''}>Không</option>
            <option value="1" ${news.isFeatured == 1 ? 'selected' : ''}>Có</option>
          </select>
        </div>

        <div class="col-md-6">
          <label class="form-label">Trạng thái</label>
          <select name="status" class="form-select">
            <option value="draft" ${news.status == 'draft' || empty news.status ? 'selected' : ''}>DRAFT</option>
            <option value="published" ${news.status == 'published' ? 'selected' : ''}>PUBLISHED</option>
            <option value="archived" ${news.status == 'archived' ? 'selected' : ''}>ARCHIVED</option>
          </select>
        </div>

        <div class="col-md-6">
          <label class="form-label">Ngày đăng</label>
          <input type="datetime-local" name="publishedAt" class="form-control"
                 value="${not empty news.publishedAt ? fn:substring(news.publishedAt, 0, 16) : ''}">
        </div>

        <div class="col-md-8">
          <label class="form-label">Ảnh đại diện mới</label>
          <input type="file"
                 name="imageFile"
                 id="imageFile"
                 class="form-control"
                 accept="image/*"
                 onchange="previewImage(event)">
          <div class="form-text">Nếu không chọn ảnh mới thì sẽ giữ ảnh cũ.</div>
        </div>

        <div class="col-md-4">
          <label class="form-label">Xem trước ảnh</label>
          <div>
            <c:choose>
              <c:when test="${not empty news.imageUrl and fn:startsWith(news.imageUrl, 'http')}">
                <img id="preview" src="${news.imageUrl}" class="preview-image" alt="preview">
              </c:when>
              <c:when test="${not empty news.imageUrl and (fn:startsWith(news.imageUrl, '/') or fn:startsWith(news.imageUrl, 'uploads/') or fn:startsWith(news.imageUrl, 'news-images/'))}">
                <img id="preview" src="${ctx}${fn:startsWith(news.imageUrl, '/') ? '' : '/'}${news.imageUrl}" class="preview-image" alt="preview">
              </c:when>
              <c:when test="${not empty news.imageUrl}">
                <img id="preview" src="${ctx}/uploads/news-images/${news.imageUrl}" class="preview-image" alt="preview">
              </c:when>
              <c:otherwise>
                <img id="preview" src="${ctx}/uploads/download.jpg" class="preview-image" alt="preview">
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="col-12">
          <label class="form-label">Mô tả ngắn</label>
          <textarea name="summary" rows="3" class="form-control"
                    placeholder="Nhập mô tả ngắn cho bài viết">${fn:escapeXml(news.summary)}</textarea>
        </div>

        <div class="col-12">
          <label class="form-label">SEO description</label>
          <textarea name="seoDescription" rows="3" class="form-control"
                    placeholder="Nhập mô tả SEO">${fn:escapeXml(news.seoDescription)}</textarea>
        </div>

        <div class="col-12">
          <label class="form-label">Nội dung bài viết <span class="text-danger">*</span></label>
          <textarea name="content" id="contentEditor" rows="10" class="form-control">${fn:escapeXml(news.content)}</textarea>
        </div>

        <div class="col-12 d-flex gap-2 pt-2">
          <button type="submit" class="btn btn-primary px-4">
            <i class="fas fa-save me-1"></i> Cập nhật bài viết
          </button>

          <a href="${ctx}/it/news/list" class="btn btn-outline-secondary px-4">
            Hủy
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  function previewImage(event) {
    const preview = document.getElementById('preview');
    const file = event.target.files[0];

    if (!file) {
      return;
    }

    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif'];

    if (!allowedTypes.includes(file.type)) {
      alert('Chỉ cho phép upload file ảnh: jpg, jpeg, png, webp, gif');
      event.target.value = '';
      return;
    }

    preview.src = URL.createObjectURL(file);
  }
</script>

<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<script>
  CKEDITOR.replace('contentEditor', {
    height: 400
  });
</script>