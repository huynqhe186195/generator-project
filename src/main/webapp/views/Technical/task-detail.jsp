<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h4 class="mb-4">📝 Báo cáo hiện trường</h4>

<div class="card shadow-sm">
  <div class="card-body">

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

    <form method="post" action="<c:url value='/technical/task-report'/>">
      <input type="hidden" name="id" value="${task.id}"/>

      <!-- MÔ TẢ BAN ĐẦU -->
      <div class="mb-3">
        <label class="form-label fw-bold">Mô tả ban đầu</label>
        <textarea rows="4"
                  class="form-control"
                  readonly>${task.description}</textarea>
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

      <!-- VẬT TƯ ĐÃ SỬ DỤNG -->
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
                  <td>
                    <fmt:formatNumber value="${m.costAtTime}" type="number"/> đ
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
          <c:set var="partsTotal" value="0" />
          <c:forEach var="m" items="${materials}">
              <c:set var="partsTotal" value="${partsTotal + m.costAtTime}" />
          </c:forEach>

          <div class="d-flex justify-content-end mt-2">
              <div class="fw-bold">
                  Tổng giá vật tư:
                  <fmt:formatNumber value="${partsTotal}" type="number"/> đ
              </div>
          </div>
        </div>
      </c:if>


      <div class="d-flex justify-content-between">
        <a href="<c:url value='/technical/my-tasks'/>"
           class="btn btn-secondary">
          ← Quay lại
        </a>

        <!-- CHỈ SCHEDULED MỚI CÓ HÀNH ĐỘNG -->
        <c:if test="${task.status == 'SCHEDULED'}">
          <div>
            <!-- ✅ REPAIR cũng được lưu báo cáo -->
            <button type="submit" class="btn btn-primary">💾 Lưu báo cáo</button>

            <!-- ✅ Hoàn thành bằng POST (không dùng link GET nữa) -->
            <button type="submit"
                    class="btn btn-success ms-2"
                    formaction="<c:url value='/technical/task-complete'/>"
                    onclick="return confirm('Xác nhận hoàn thành công việc?')">
              ✅ Hoàn thành
            </button>
          </div>
        </c:if>
      </div>

    </form>
  </div>
</div>
