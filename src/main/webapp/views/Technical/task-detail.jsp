<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h4 class="mb-4">📝 Báo cáo hiện trường</h4>

<div class="card shadow-sm">
  <div class="card-body">

    <c:if test="${param.msg == 'saved'}">
      <div class="alert alert-success">
        Đã lưu báo cáo hiện trường.
      </div>
    </c:if>

    <c:if test="${param.error == 'noreport'}">
      <div class="alert alert-danger">
        Vui lòng nhập báo cáo hiện trường trước khi hoàn thành.
      </div>
    </c:if>

    <!-- THÔNG TIN CHUNG -->
    <div class="row mb-3">
      <div class="col-md-6">
        <p><strong>Serial:</strong> ${task.productSerialNumber}</p>
        <p><strong>Tên máy:</strong> ${task.productName}</p>
      </div>

      <div class="col-md-6">
        <p><strong>Ngày bảo trì:</strong> ${task.maintenanceDate}</p>
        <p><strong>Loại:</strong> ${task.type}</p>
        <p>
          <strong>Trạng thái:</strong>
          <span class="badge
            ${task.status == 'COMPLETED' ? 'bg-success' :
              task.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning'}">
            ${task.status}
          </span>
        </p>
      </div>
    </div>

    <form method="post"
          action="<c:url value='/technical/task-report'/>"
          enctype="multipart/form-data">

      <input type="hidden" name="id" value="${task.id}"/>

      <!-- MÔ TẢ BAN ĐẦU -->
      <div class="mb-3">
        <label class="form-label fw-bold">Mô tả ban đầu</label>
        <textarea rows="4" class="form-control" readonly>${task.description}</textarea>
      </div>

      <!-- BÁO CÁO HIỆN TRƯỜNG -->
      <div class="mb-3">
        <label class="form-label fw-bold">Báo cáo hiện trường</label>

        <c:choose>
          <c:when test="${task.status == 'SCHEDULED'}">
            <textarea name="actualDescription"
                      rows="5"
                      class="form-control"
                      required>${task.actualDescription}</textarea>
          </c:when>
          <c:otherwise>
            <textarea rows="5"
                      class="form-control"
                      readonly>${task.actualDescription}</textarea>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- UPLOAD ẢNH BEFORE -->
      <c:if test="${task.status == 'SCHEDULED'}">
        <div class="mb-3">
          <label class="form-label fw-bold">Ảnh hiện trường trước sửa (BEFORE)</label>
          <input type="file"
                 name="siteImages"
                 class="form-control"
                 accept="image/*"
                 multiple />
          <small class="text-muted">
            Chọn 1 hoặc nhiều ảnh hiện trạng trước khi sửa chữa.
          </small>
        </div>
      </c:if>

      <!-- HIỂN THỊ ẢNH BEFORE -->
      <c:if test="${not empty beforeImages}">
        <div class="mt-3">
          <h5 class="fw-bold">📷 Ảnh hiện trường trước sửa</h5>
          <div class="row">
            <c:forEach items="${beforeImages}" var="img">
              <c:if test="${img.imageType == 'BEFORE'}">
                <div class="col-md-3 mb-3">
                  <img src="<c:url value='/${img.imagePath}'/>"
                       class="img-fluid rounded border"
                       style="height:160px; object-fit:cover; width:100%;" />
                </div>
              </c:if>
            </c:forEach>
          </div>
        </div>
      </c:if>

      <!-- HIỂN THỊ ẢNH AFTER -->
      <c:if test="${not empty afterImages   }">
        <div class="mt-4">
          <h5 class="fw-bold">📷 Ảnh sau sửa chữa</h5>
          <div class="row">
            <c:forEach items="${afterImages}" var="img">
              <c:if test="${img.imageType == 'AFTER'}">
                <div class="col-md-3 mb-3">
                  <img src="<c:url value='/${img.imagePath}'/>"
                       class="img-fluid rounded border"
                       style="height:160px; object-fit:cover; width:100%;" />
                </div>
              </c:if>
            </c:forEach>
          </div>
        </div>
      </c:if>

      <!-- VẬT TƯ -->
      <c:if test="${not empty materials}">
        <div class="mt-4">
          <h5 class="fw-bold">🧰 Vật tư đã sử dụng</h5>

          <table class="table table-bordered mt-2">
            <thead class="table-light">
              <tr>
                <th>#</th>
                <th>Tên vật tư</th>
                <th>Số lượng</th>
                <th>Chi phí</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="m" items="${materials}" varStatus="st">
                <tr>
                  <td>${st.index + 1}</td>
                  <td>${m.sparePartName}</td>
                  <td>${m.quantityUsed}</td>
                  <td><fmt:formatNumber value="${m.costAtTime}" type="number"/> đ</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <c:set var="partsTotal" value="0" />
          <c:forEach var="m" items="${materials}">
            <c:set var="partsTotal" value="${partsTotal + m.costAtTime}" />
          </c:forEach>

          <div class="d-flex justify-content-end mt-2">
            <div style="min-width: 320px;">
              <div class="d-flex justify-content-between border-bottom py-1">
                <span>Tổng vật tư:</span>
                <strong><fmt:formatNumber value="${partsTotal}" type="number"/> đ</strong>
              </div>

              <div class="d-flex justify-content-between border-bottom py-1">
                <span>Chi phí công:</span>
                <strong><fmt:formatNumber value="${task.laborCost}" type="number"/> đ</strong>
              </div>

              <div class="d-flex justify-content-between py-2">
                <span><strong>Tổng chi phí:</strong></span>
                <strong class="text-danger">
                  <fmt:formatNumber value="${partsTotal + task.laborCost}" type="number"/> đ
                </strong>
              </div>
            </div>
          </div>
        </div>
      </c:if>

      <div class="d-flex justify-content-between mt-4">
        <a href="<c:url value='/technical/my-tasks'/>" class="btn btn-secondary">
          ← Quay lại
        </a>

        <c:if test="${task.status == 'SCHEDULED'}">
          <div>
            <button type="submit" class="btn btn-primary">
              💾 Lưu báo cáo
            </button>

            <c:if test="${task.type == 'REPAIR'}">
              <a href="<c:url value='/technical/repair-report?id=${task.id}'/>"
                 class="btn btn-warning ms-2">
                🔧 Sang màn sửa chữa
              </a>
            </c:if>

            <c:if test="${task.type != 'REPAIR'}">
              <button type="submit"
                      class="btn btn-success ms-2"
                      formaction="<c:url value='/technical/task-complete'/>"
                      onclick="return confirm('Xác nhận hoàn thành công việc?')">
                ✅ Hoàn thành
              </button>
            </c:if>
          </div>
        </c:if>
      </div>

    </form>
  </div>
</div>