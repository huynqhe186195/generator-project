<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h4 class="mb-3">🛠 Chi tiết công việc</h4>

<!-- Thông tin công việc -->
<div class="card mb-3">
  <div class="card-body">
    <p><b>Mã máy:</b> ${task.productId}</p>
    <p><b>Loại bảo trì:</b> ${task.type}</p>
    <p><b>Ngày bảo trì:</b> ${task.maintenanceDate}</p>

    <p><b>Trạng thái:</b>
      <span class="badge
                ${task.status == 'SCHEDULED' ? 'bg-warning' :
                  task.status == 'COMPLETED' ? 'bg-success' :
                  'bg-secondary'}">
        ${task.status}
      </span>
    </p>

    <p><b>Mô tả ban đầu:</b> ${task.description}</p>
  </div>
</div>

<hr>

<!-- Chỉ cho báo cáo khi CHƯA hoàn thành -->
<c:if test="${task.status == 'SCHEDULED'}">
  <h5 class="mb-3">📝 Báo cáo hiện trường</h5>

  <form action="<c:url value='/technical/task-report'/>"
        method="post"
        enctype="multipart/form-data">

    + <input type="hidden" name="id" value="${task.id}" />

    <!-- Ghi chú lỗi -->
    <div class="mb-3">
      <label class="form-label">Mô tả lỗi / tình trạng máy</label>
       <textarea class="form-control"
                  name="description"
                rows="3"
                placeholder="Mô tả chi tiết tình trạng thực tế..."></textarea>
    </div>

    <!-- Ảnh hiện trường -->
    <div class="mb-3">
      <label class="form-label">Ảnh hiện trường</label>
      <input type="file"
             class="form-control"
             name="images"
             multiple />
    </div>

    <!-- Đề xuất linh kiện -->
    <div class="mb-3">
      <label class="form-label">Đề xuất thay linh kiện</label>
      <textarea class="form-control"
                name="sparePartSuggestion"
                rows="2"
                placeholder="Ví dụ: thay bugi, lọc nhớt..."></textarea>
    </div>

    <button type="submit" class="btn btn-primary">
      💾 Lưu báo cáo
    </button>

    <a class="btn btn-outline-secondary ms-2"
       href="<c:url value='/technical/materials'/>">
      📦 Kho vật tư
    </a>
  </form>
</c:if>

<!-- Khi đã hoàn thành hoặc hủy -->
<c:if test="${task.status != 'SCHEDULED'}">
  <div class="alert alert-info">
    Công việc đã <b>${task.status}</b>.
    Bạn chỉ có thể xem lại thông tin, không chỉnh sửa.
  </div>
</c:if>
