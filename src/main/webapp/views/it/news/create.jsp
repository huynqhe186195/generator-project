<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  .news-content img {
    max-width: 100%;
    border-radius: 8px;
    margin: 20px 0;
  }

  .news-content p {
    font-size: 17px;
    line-height: 1.8;
    margin-bottom: 15px;
  }

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
    width: 180px;
    height: 120px;
    object-fit: cover;
    border-radius: 10px;
    border: 1px solid #dee2e6;
    background: #f8f9fa;
  }
</style>

<div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
      <h3 class="fw-bold text-dark mb-0">Thêm bài viết</h3>
      <div class="text-muted small mt-1">Tạo mới bài viết cho hệ thống tin tức</div>
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
      <form action="${ctx}/it/news/create" method="post" enctype="multipart/form-data" class="row g-3">

        <div class="col-md-8">
          <label class="form-label">Tiêu đề bài viết <span class="text-danger">*</span></label>
          <input type="text" name="title" class="form-control"
                 value="${fn:escapeXml(title)}" placeholder="Nhập tiêu đề bài viết">
        </div>

        <div class="col-md-4">
          <label class="form-label">Slug</label>
          <input type="text" name="slug" class="form-control"
                 value="${fn:escapeXml(slug)}" placeholder="tu-dong-sinh-neu-bo-trong">
        </div>

        <div class="col-md-4">
          <label class="form-label">Tác giả</label>
          <input type="text" name="author" class="form-control"
                 value="${fn:escapeXml(author)}" placeholder="Ví dụ: Admin">
        </div>

        <div class="col-md-4">
          <label class="form-label">Danh mục</label>
          <input type="text" name="category" class="form-control"
                 value="${fn:escapeXml(category)}" placeholder="Ví dụ: Generator">
        </div>

        <div class="col-md-4">
          <label class="form-label">Nổi bật</label>
          <select name="isFeatured" class="form-select">
            <option value="0" ${isFeatured == '0' || empty isFeatured ? 'selected' : ''}>Không</option>
            <option value="1" ${isFeatured == '1' ? 'selected' : ''}>Có</option>
          </select>
        </div>

        <div class="col-md-3">
          <label class="form-label">Trạng thái</label>
          <select name="status" class="form-select">
            <option value="draft" ${status == 'draft' || empty status ? 'selected' : ''}>DRAFT</option>
            <option value="published" ${status == 'published' ? 'selected' : ''}>PUBLISHED</option>
            <option value="archived" ${status == 'archived' ? 'selected' : ''}>ARCHIVED</option>
          </select>
        </div>

        <div class="col-md-8">
          <label class="form-label">Ảnh đại diện</label>
          <input type="file"
                 name="imageFile"
                 id="imageFile"
                 class="form-control"
                 accept="image/*"
                 onchange="previewImage(event)">
          <div class="form-text">Chọn file ảnh từ máy tính của bạn.</div>
        </div>

        <div class="col-md-4">
          <label class="form-label">Xem trước ảnh</label>
          <div>
            <img id="preview"
                 src="${ctx}/uploads/download.jpg"
                 class="preview-image"
                 alt="preview">
          </div>
        </div>

        <div class="col-12">
          <label class="form-label">Mô tả ngắn</label>
          <textarea name="summary" rows="3" class="form-control"
                    placeholder="Nhập mô tả ngắn cho bài viết">${fn:escapeXml(summary)}</textarea>
        </div>

        <div class="col-12">
          <label class="form-label">SEO description</label>
          <textarea name="seoDescription" rows="3" class="form-control"
                    placeholder="Nhập mô tả SEO">${fn:escapeXml(seoDescription)}</textarea>
        </div>

        <div class="col-12">
          <label class="form-label">Nội dung bài viết <span class="text-danger">*</span></label>
          <textarea name="content" id="contentEditor" rows="10" class="form-control">${fn:escapeXml(content)}</textarea>
        </div>

        <div class="col-12 d-flex gap-2 pt-2">
          <button type="submit" class="btn btn-primary px-4">
            <i class="fas fa-save me-1"></i> Lưu bài viết
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
      preview.src = '${ctx}/uploads/download.jpg';
      return;
    }

    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif'];

    if (!allowedTypes.includes(file.type)) {
      alert('Chỉ cho phép upload file ảnh: jpg, jpeg, png, webp, gif');
      event.target.value = '';
      preview.src = '${ctx}/uploads/download.jpg';
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