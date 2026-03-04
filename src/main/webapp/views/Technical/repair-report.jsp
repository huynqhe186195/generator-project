<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

                <p>
                  <strong>Trạng thái gửi STAFF:</strong>
                  <c:choose>
                    <c:when test="${staffQuoteStatus == 'WAITING_STAFF'}">
                      <span class="badge bg-warning">WAITING_STAFF</span>
                    </c:when>
                    <c:when test="${staffQuoteStatus == 'TASK_CREATED'}">
                      <span class="badge bg-success">APPROVED</span>
                    </c:when>
                    <c:when test="${staffQuoteStatus == 'REJECTED'}">
                      <span class="badge bg-danger">REJECTED</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary">CHƯA GỬI</span>
                    </c:otherwise>
                  </c:choose>
                </p>

                <p>
                  <strong>Customer phản hồi:</strong>
                  <c:choose>
                    <c:when test="${customerQuoteStatus == 'WAITING_CUSTOMER'}">
                      <span class="badge bg-warning">WAITING CUSTOMER</span>
                    </c:when>
                    <c:when test="${customerQuoteStatus == 'APPROVED_BY_CUSTOMER'}">
                      <span class="badge bg-success">CUSTOMER APPROVED</span>
                    </c:when>
                    <c:when test="${customerQuoteStatus == 'REJECTED_BY_CUSTOMER'}">
                      <span class="badge bg-danger">CUSTOMER REJECTED</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary">CHƯA CÓ PHẢN HỒI</span>
                    </c:otherwise>
                  </c:choose>
                </p>
            </div>
        </div>

        <!-- ===== FORM LƯU + HOÀN THÀNH ===== -->
        <c:if test="${task.status == 'SCHEDULED'}">

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
                        <td>${m.costAtTime}</td>
                        <td class="text-center">
                            <c:if test="${task.status == 'SCHEDULED'}">
                                <form method="post" action="<c:url value='/technical/delete-material'/>" style="display:inline;">
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
        </c:if>

        <c:if test="${task.status == 'SCHEDULED' && task.assignmentStatus != 'PENDING_APPROVAL'}">
            <hr/>
            <h5 class="mt-3">💰 Báo giá sửa chữa</h5>

            <form method="post" action="<c:url value='/technical/send-quote'/>" class="row g-3">
                <input type="hidden" name="id" value="${task.id}"/>

                <div class="col-md-12 d-flex align-items-end">
                    <button class="btn btn-warning w-100"
                            onclick="return confirm('Gửi báo giá cho Manager duyệt?')">
                        📩 Gửi báo giá cho STAFF
                    </button>
                </div>
            </form>
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
