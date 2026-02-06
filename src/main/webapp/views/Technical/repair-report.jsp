<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h4 class="mb-4">🛠 Báo cáo sửa chữa & vật tư</h4>

<div class="card shadow-sm">
    <div class="card-body">

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
            </div>
        </div>

        <!-- ===== FORM LƯU + HOÀN THÀNH ===== -->
        <c:if test="${task.status == 'SCHEDULED'}">
            <form method="post" action="<c:url value='/technical/task-complete'/>">

                <input type="hidden" name="id" value="${task.id}"/>

                <div class="mb-3">
                    <label class="form-label fw-bold">Báo cáo hiện trường</label>
                    <textarea name="actualDescription"
                              class="form-control"
                              rows="4"
                              required>${task.actualDescription}</textarea>
                </div>

                <button class="btn btn-success"
                        onclick="return confirm('Xác nhận hoàn thành sửa chữa?')">
                    ✅ Lưu báo cáo & Hoàn thành
                </button>
            </form>
        </c:if>

        <c:if test="${task.status != 'SCHEDULED'}">
            <div class="mb-3">
                <label class="form-label fw-bold">Báo cáo hiện trường</label>
                <textarea class="form-control" rows="4" readonly>
                    ${task.actualDescription}
                </textarea>
            </div>
        </c:if>

        <hr/>

        <!-- ===== THÊM VẬT TƯ ===== -->
        <c:if test="${not empty materials}">
            <h5 class="mt-4">🔧 Vật tư đã sử dụng</h5>

            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>Spare Part ID</th>
                    <th>Số lượng</th>
                    <th>Chi phí</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="m" items="${materials}">
                    <tr>
                        <td>${m.sparePartId}</td>
                        <td>${m.quantityUsed}</td>
                        <td>${m.costAtTime}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>


        <c:if test="${task.status == 'SCHEDULED'}">
            <form method="post" action="<c:url value='/technical/add-material'/>"
                  class="row g-3">

                <input type="hidden" name="maintenanceId" value="${task.id}"/>

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
                    <!-- 🔥 QUAN TRỌNG: name PHẢI là quantityUsed -->
                    <input type="number"
                           name="quantityUsed"
                           class="form-control"
                           min="1"
                           required/>
                </div>

                <div class="col-md-3 d-flex align-items-end">
                    <button class="btn btn-primary w-100">➕ Thêm vật tư</button>
                </div>
            </form>
        </c:if>

        <hr/>

        <a href="<c:url value='/technical/my-tasks'/>"
           class="btn btn-secondary mt-3">← Quay lại</a>

    </div>
</div>
