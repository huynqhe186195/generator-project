<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h4 class="mb-4">🛠 Báo cáo sửa chữa & vật tư</h4>

<div class="card shadow-sm">
  <div class="card-body">

    <c:if test="${param.msg == 'quote_sent'}">
      <div class="alert alert-success">
        Đã gửi báo giá cho STAFF.
      </div>
    </c:if>

    <c:if test="${param.msg == 'after_saved'}">
      <div class="alert alert-success">
        Đã lưu ảnh sau sửa chữa.
      </div>
    </c:if>

    <c:if test="${param.msg == 'completed'}">
      <div class="alert alert-success">
        Đã hoàn thành sửa chữa.
      </div>
    </c:if>

    <c:if test="${param.error == 'nomaterial'}">
      <div class="alert alert-danger">
        Phải có ít nhất 1 vật tư trước khi gửi báo giá hoặc hoàn thành sửa chữa.
      </div>
    </c:if>

    <c:if test="${param.error == 'customer_not_approved'}">
      <div class="alert alert-danger">
        Khách hàng chưa duyệt báo giá, chưa thể hoàn thành sửa chữa.
      </div>
    </c:if>

    <c:if test="${param.error == 'noafterimage'}">
      <div class="alert alert-danger">
        Vui lòng upload ít nhất 1 ảnh sau sửa chữa trước khi hoàn thành.
      </div>
    </c:if>

    <c:if test="${param.error == 'noreport'}">
      <div class="alert alert-danger">
        Vui lòng lưu báo cáo hiện trường trước khi hoàn thành sửa chữa.
      </div>
    </c:if>

    <!-- THÔNG TIN TASK -->
    <div class="row mb-3">
      <div class="col-md-6">
        <p><strong>Serial:</strong> ${task.productSerialNumber}</p>
        <p><strong>Tên máy:</strong> ${task.productName}</p>
      </div>

      <div class="col-md-6">
        <p><strong>Ngày sửa:</strong> ${task.maintenanceDate}</p>
        <p><strong>Loại:</strong> ${task.type}</p>

        <p>
          <strong>Trạng thái:</strong>
          <span class="badge
            ${task.status == 'COMPLETED' ? 'bg-success' :
              task.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning'}">
            ${task.status}
          </span>
        </p>

       <c:if test="${task.status != 'COMPLETED'}">
           <p>
             <strong>Trạng thái báo giá:</strong>
             <c:choose>
               <c:when test="${quoteStatus == 'WAITING_STAFF'}">
                 <span class="badge bg-warning">WAITING STAFF</span>
               </c:when>
               <c:when test="${quoteStatus == 'WAITING_MANAGER'}">
                 <span class="badge bg-info">WAITING MANAGER</span>
               </c:when>
               <c:when test="${quoteStatus == 'WAITING_CUSTOMER'}">
                 <span class="badge bg-primary">WAITING CUSTOMER</span>
               </c:when>
               <c:when test="${quoteStatus == 'APPROVED'}">
                 <span class="badge bg-success">APPROVED BY MANAGER</span>
               </c:when>
               <c:when test="${quoteStatus == 'APPROVED_BY_CUSTOMER'}">
                 <span class="badge bg-success">CUSTOMER APPROVED</span>
               </c:when>
               <c:when test="${quoteStatus == 'REJECTED'}">
                 <span class="badge bg-danger">REJECTED</span>
               </c:when>
               <c:when test="${quoteStatus == 'REJECTED_BY_CUSTOMER'}">
                 <span class="badge bg-danger">CUSTOMER REJECTED</span>
               </c:when>
               <c:otherwise>
                 <span class="badge bg-secondary">CHƯA GỬI</span>
               </c:otherwise>
             </c:choose>
           </p>
       </c:if>
      </div>
    </div>

    <hr/>

    <div class="mb-3">
      <a href="<c:url value='/technical/task-detail?id=${task.id}'/>"
         class="btn btn-outline-secondary btn-sm">
        ← Xem báo cáo hiện trường
      </a>
    </div>

    <!-- VẬT TƯ -->
    <c:if test="${not empty materials}">
      <h5 class="mt-4">🔧 Vật tư đã sử dụng</h5>

      <table class="table table-bordered">
        <thead>
          <tr>
            <th>Vật tư</th>
            <th>Số lượng</th>
            <th>Chi phí</th>
            <th>Thao tác</th>
          </tr>
        </thead>

        <tbody>
          <c:forEach var="m" items="${materials}">
            <tr>
              <td>
                ${m.sparePartName}
                <c:if test="${not empty m.partCode}">
                  (${m.partCode})
                </c:if>
              </td>

              <td>
                ${m.quantityUsed}
                <c:if test="${not empty m.unit}">
                  ${m.unit}
                </c:if>
              </td>

              <td>
                <fmt:formatNumber value="${m.costAtTime}" type="number"/> đ
              </td>

              <td class="text-center">
                <c:if test="${task.status == 'SCHEDULED' && quoteStatus != 'APPROVED_BY_CUSTOMER'}">
                  <form method="post"
                        action="<c:url value='/technical/delete-material'/>"
                        style="display:inline;">
                    <input type="hidden" name="maintenanceId" value="${task.id}"/>
                    <input type="hidden" name="sparePartId" value="${m.sparePartId}"/>

                    <button type="submit"
                            class="btn btn-sm btn-danger"
                            onclick="return confirm('Xóa vật tư này? Sẽ hoàn kho lại.')">
                      🗑 Xóa
                    </button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

    <!-- TÍNH TỔNG -->
    <c:set var="partsTotal" value="0" />
    <c:if test="${not empty materials}">
      <c:forEach var="m" items="${materials}">
        <c:set var="partsTotal" value="${partsTotal + m.costAtTime}" />
      </c:forEach>
    </c:if>

    <!-- TỔNG HỢP CHI PHÍ -->
    <div class="mt-4">
      <h5 class="fw-bold">💵 Tổng hợp chi phí</h5>

      <div class="d-flex justify-content-end mt-2">
        <div style="min-width: 340px;">
          <div class="d-flex justify-content-between border-bottom py-2">
            <span>Tổng vật tư:</span>
            <strong><fmt:formatNumber value="${partsTotal}" type="number"/> đ</strong>
          </div>

          <div class="d-flex justify-content-between border-bottom py-2">
            <span>Chi phí công:</span>
            <strong><fmt:formatNumber value="${task.laborCost}" type="number"/> đ</strong>
          </div>

          <div class="d-flex justify-content-between py-2 fs-5">
            <span><strong>Tổng báo giá:</strong></span>
            <strong class="text-danger">
              <fmt:formatNumber value="${partsTotal + task.laborCost}" type="number"/> đ
            </strong>
          </div>
        </div>
      </div>
    </div>

    <hr/>

    <!-- BÁO GIÁ -->
    <c:if test="${task.status == 'SCHEDULED' && quoteStatus != 'APPROVED_BY_CUSTOMER'}">
      <h5 class="mt-3">💰 Báo giá sửa chữa</h5>

      <form method="post"
            action="<c:url value='/technical/send-quote'/>"
            class="row g-3">

        <input type="hidden" name="id" value="${task.id}"/>

        <div class="col-md-4">
          <label class="form-label fw-bold">Chi phí công</label>
        <input type="number"
              step="0.01"
             min="0"
             name="laborCost"
              id="laborCostInput"
              class="form-control"
              value="${not empty param.laborCost ? param.laborCost : task.laborCost}" />
        </div>

        <div class="col-md-8 d-flex align-items-end">
          <button class="btn btn-warning w-100"
                  onclick="return confirm('Gửi báo giá cho STAFF?')">
            📩 Gửi báo giá cho STAFF
          </button>
        </div>
      </form>
    </c:if>

    <hr/>

    <!-- THÊM VẬT TƯ -->
    <c:if test="${task.status == 'SCHEDULED' && quoteStatus != 'APPROVED_BY_CUSTOMER'}">
      <form method="post"
            action="<c:url value='/technical/add-material'/>"
            class="row g-3">

        <input type="hidden" name="maintenanceId" value="${task.id}"/>
        <input type="hidden" name="laborCost" id="materialLaborCost"
                   value="${not empty param.laborCost ? param.laborCost : task.laborCost}"/>

        <div class="col-md-6">
          <label class="form-label fw-bold">Vật tư</label>
          <select name="sparePartId" class="form-select" required>
            <option value="">-- Chọn vật tư --</option>
            <c:forEach items="${parts}" var="p">
              <option value="${p.id}">
                ${p.name} (Tồn: ${p.quantityInStock})
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-3">
          <label class="form-label fw-bold">Số lượng</label>
          <input type="number"
                 name="quantityUsed"
                 class="form-control"
                 min="1"
                 required/>
        </div>

        <div class="col-md-3 d-flex align-items-end">
          <button class="btn btn-primary w-100">
            ➕ Thêm vật tư
          </button>
        </div>
      </form>
    </c:if>

    <hr/>

    <!-- ẢNH AFTER -->
    <c:if test="${not empty afterImages}">
      <h5 class="mt-4">📷 Ảnh sau sửa chữa</h5>

      <div class="row">
        <c:forEach items="${afterImages}" var="img">
          <div class="col-md-3 mb-3">
            <img src="<c:url value='/${img.imagePath}'/>"
                 class="img-fluid rounded border"
                 style="height:180px;object-fit:cover; width:100%;">
          </div>
        </c:forEach>
      </div>
    </c:if>

    <hr/>

    <!-- LƯU ẢNH AFTER + COMPLETE -->
    <c:if test="${task.status == 'SCHEDULED'  && quoteStatus == 'APPROVED_BY_CUSTOMER'}">

      <h5 class="mt-4">📷 Cập nhật ảnh sau sửa chữa</h5>

      <form method="post"
            action="<c:url value='/technical/save-after-images'/>"
            enctype="multipart/form-data"
            class="mt-3">

        <input type="hidden" name="id" value="${task.id}" />

        <div class="mb-3">
          <label class="form-label fw-bold">Ảnh sau sửa chữa (AFTER)</label>
          <input type="file"
                 name="afterImages"
                 class="form-control"
                 multiple
                 accept="image/*" />
          <div class="form-text">
            Có thể lưu ảnh trước, sau đó mới bấm hoàn thành sửa chữa.
          </div>
        </div>

        <button type="submit"
                class="btn btn-primary w-100">
          💾 Lưu ảnh sau sửa chữa
        </button>
      </form>

      <form method="post"
            action="<c:url value='/technical/task-complete'/>"
            class="mt-3">

        <input type="hidden" name="id" value="${task.id}" />

        <button type="submit"
                class="btn btn-success w-100"
                onclick="return confirm('Đã đủ ảnh sau sửa chữa. Xác nhận hoàn thành?')">
          ✅ Hoàn thành sửa chữa
        </button>
      </form>

    </c:if>

    <a href="<c:url value='/technical/my-tasks'/>"
       class="btn btn-secondary mt-3">
      ← Quay lại
    </a>

  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const laborCostInput = document.getElementById("laborCostInput");
    const materialLaborCost = document.getElementById("materialLaborCost");

    if (laborCostInput && materialLaborCost) {
        materialLaborCost.value = laborCostInput.value || "";

        laborCostInput.addEventListener("input", function () {
            materialLaborCost.value = laborCostInput.value || "";
        });
    }
});
</script>