<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>
    <title>Quản lý Yêu cầu</title>
    <style>
        .table td, .table th { vertical-align: middle; }
        .summary-cell { max-width: 520px; }
        .summary-text{
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            word-break: break-word;
            white-space: normal;
        }
        pre.json-pretty{
            white-space: pre-wrap;
            word-break: break-word;
            margin: 0;
        }
        code.mini-json{
            font-size: 12px;
            color: #6c757d;
        }
    </style>
</head>

<body>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="text-primary mb-0">
        <i class="fa fa-paper-plane"></i> Yêu cầu hệ thống
    </h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createRequestModal">
        <i class="fa fa-plus-circle"></i> Tạo yêu cầu mới
    </button>
</div>

<c:if test="${empty box}">
    <c:set var="box" value="sent"/>
</c:if>

<div class="d-flex gap-2 mb-4">
    <a class="btn btn-sm ${box == 'sent' ? 'btn-primary' : 'btn-outline-primary'}"
       href="${pageContext.request.contextPath}/manager/requests?box=sent">
        <i class="fa fa-paper-plane"></i> Đã gửi
    </a>
    <a class="btn btn-sm ${box == 'inbox' ? 'btn-primary' : 'btn-outline-primary'}"
       href="${pageContext.request.contextPath}/manager/requests?box=inbox">
        <i class="fa fa-inbox"></i> Inbox
    </a>
</div>

<c:if test="${param.msg == 'success'}">
    <div class="alert alert-success">Thao tác thành công!</div>
</c:if>
<c:if test="${param.msg == 'duplicate'}">
    <div class="alert alert-warning">Yêu cầu này đang chờ xử lý rồi!</div>
</c:if>
<c:if test="${param.msg == 'error'}">
    <div class="alert alert-danger">Có lỗi xảy ra, vui lòng thử lại.</div>
</c:if>

<div class="card shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th style="width: 90px;">ID</th>

                    <c:if test="${box == 'inbox'}">
                        <th style="width: 180px;">Người gửi</th>
                    </c:if>

                    <c:if test="${box == 'sent'}">
                        <th style="width: 140px;">Gửi tới</th>
                    </c:if>

                    <th style="width: 170px;">Loại yêu cầu</th>
                    <th>Nội dung</th>
                    <th style="width: 170px;">Ngày gửi</th>
                    <th style="width: 170px;">Trạng thái</th>

                    <c:if test="${box == 'sent'}">
                        <th style="width: 240px;">Phản hồi</th>
                    </c:if>

                    <c:if test="${box == 'inbox'}">
                        <th style="width: 190px;" class="text-end">Hành động</th>
                    </c:if>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="r" items="${requests}">
                    <tr>
                        <td>#${r.id}</td>

                        <c:if test="${box == 'inbox'}">
                            <td>
                                <div class="fw-semibold">
                                    <c:choose>
                                        <c:when test="${not empty senderNames && not empty senderNames[r.senderId]}">
                                            <c:out value="${senderNames[r.senderId]}"/>
                                        </c:when>
                                        <c:otherwise>
                                            User #<c:out value="${r.senderId}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="text-muted small">ID: <c:out value="${r.senderId}"/></div>
                            </td>
                        </c:if>

                        <c:if test="${box == 'sent'}">
                            <td>
                                <span class="badge bg-dark"><c:out value="${r.receiverRole}"/></span>
                            </td>
                        </c:if>

                        <td>
                            <c:choose>
                                <c:when test="${r.requestType == 'CREATE_USER'}">
                                    <span class="badge bg-info text-dark">CREATE_USER</span>
                                </c:when>
                                <c:when test="${r.requestType == 'INCIDENT_REPORT'}">
                                    <span class="badge bg-warning text-dark">INCIDENT_REPORT</span>
                                </c:when>
                                <c:when test="${r.requestType == 'NEW_PRODUCT'}">
                                    <span class="badge bg-primary">NEW_PRODUCT</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary"><c:out value="${r.requestType}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="summary-cell">
                            <div class="summary-text" id="summary-${r.id}"></div>

                            <code class="mini-json d-none" id="json-${r.id}">
                                ${fn:escapeXml(r.requestData)}
                            </code>

                            <div class="mt-2">
                                <button type="button"
                                        class="btn btn-sm btn-outline-primary"
                                        data-bs-toggle="modal"
                                        data-bs-target="#jsonDetailModal"
                                        data-reqid="${r.id}"
                                        data-reqtype="${r.requestType}">
                                    <i class="fa fa-eye"></i> Xem chi tiết
                                </button>
                            </div>
                        </td>

                        <td><c:out value="${r.createdAt}"/></td>

                        <td>
                            <c:choose>
                                <c:when test="${r.status == 'PENDING' || r.status == 'WAITING_MANAGER'}">
                                    <span class="badge bg-warning text-dark"><c:out value="${r.status}"/></span>
                                </c:when>
                                <c:when test="${r.status == 'APPROVED'}">
                                    <span class="badge bg-success">APPROVED</span>
                                </c:when>
                                <c:when test="${r.status == 'REJECTED'}">
                                    <span class="badge bg-danger">REJECTED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary"><c:out value="${r.status}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <c:if test="${box == 'sent'}">
                            <td class="text-danger fw-semibold">
                                <c:out value="${r.responseMessage}"/>
                            </td>
                        </c:if>

                        <c:if test="${box == 'inbox'}">
                            <td class="text-end">
                                <c:choose>
                                    <c:when test="${r.status == 'PENDING' || r.status == 'WAITING_MANAGER'}">
                                        <form class="d-inline"
                                              action="${pageContext.request.contextPath}/manager/requests"
                                              method="post">
                                            <input type="hidden" name="action" value="approve"/>
                                            <input type="hidden" name="id" value="${r.id}"/>
                                            <button type="submit" class="btn btn-sm btn-success"
                                                    onclick="return confirm('Duyệt request #${r.id}?');">
                                                <i class="fa fa-check"></i> Duyệt
                                            </button>
                                        </form>

                                        <button type="button"
                                                class="btn btn-sm btn-danger"
                                                data-bs-toggle="modal"
                                                data-bs-target="#rejectModal"
                                                data-id="${r.id}">
                                            <i class="fa fa-times"></i> Từ chối
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">Đã xử lý</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </c:if>

                    </tr>
                </c:forEach>

                <c:if test="${empty requests}">
                    <tr>
                        <td colspan="${box == 'sent' ? 7 : 8}" class="text-center text-muted py-4">
                            <c:choose>
                                <c:when test="${box == 'inbox'}">Bạn chưa nhận yêu cầu nào.</c:when>
                                <c:otherwise>Bạn chưa gửi yêu cầu nào.</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: JSON Detail -->
<div class="modal fade" id="jsonDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa fa-code"></i> Chi tiết request</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-2">
                    <span class="badge bg-dark" id="detailTypeBadge"></span>
                    <span class="text-muted ms-2">#<span id="detailId"></span></span>
                </div>
                <pre class="json-pretty border rounded p-3 bg-light" id="detailJson"></pre>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Reject -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/manager/requests" method="post" enctype="multipart/form-data">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="fa fa-times-circle"></i> Từ chối request</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="reject"/>
                    <input type="hidden" name="id" id="rejectId"/>

                    <label class="form-label">Lý do từ chối</label>
                    <textarea class="form-control" name="responseMessage" rows="3"
                              placeholder="Nhập lý do để bên gửi biết..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger"
                            onclick="return confirm('Xác nhận từ chối request này?');">
                        Từ chối
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Create Request -->
<div class="modal fade" id="createRequestModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/manager/requests" method="post" enctype="multipart/form-data">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Tạo yêu cầu mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>

        <div class="modal-body">
          <input type="hidden" name="action" value="create_request">

          <!-- ROLE NHẬN -->
          <div class="mb-3">
            <label class="form-label">Gửi tới role <span class="text-danger">*</span></label>
            <select name="receiverRole" class="form-select" required>
              <option value="ADMIN">ADMIN</option>
              <option value="MANAGER">MANAGER</option>
              <option value="STAFF">STAFF</option>
              <option value="TECHNICIAN">TECHNICIAN</option>
              <option value="IT">IT</option>
              <option value="CUSTOMER">CUSTOMER</option>
            </select>
          </div>

          <!-- REQUEST TYPE -->
          <div class="mb-3">
            <label class="form-label">Loại yêu cầu <span class="text-danger">*</span></label>
            <select name="requestType" id="requestType" class="form-select" required>
              <option value="CREATE_USER">CREATE_USER - Tạo tài khoản</option>
              <option value="INCIDENT_REPORT">INCIDENT_REPORT - Báo sự cố</option>
              <option value="CUSTOMER_REMINDER">CUSTOMER_REMINDER - Nhắc khách hàng</option>
              <option value="NEW_PRODUCT">NEW_PRODUCT - Yêu cầu thêm sản phẩm mới</option>
            </select>
            <div class="form-text">Form sẽ thay đổi theo loại yêu cầu.</div>
          </div>

          <!-- GROUP: CREATE_USER -->
          <div class="req-group" data-type="CREATE_USER">
            <div class="mb-3">
              <label class="form-label">Email <span class="text-danger">*</span></label>
              <input type="email" name="email" class="form-control" placeholder="customer@example.com">
            </div>

            <div class="mb-3">
              <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
              <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A">
            </div>

            <div class="mb-3">
              <label class="form-label">Số điện thoại</label>
              <input type="text" name="phone" class="form-control" placeholder="0912...">
            </div>
          </div>

          <!-- GROUP: INCIDENT_REPORT -->
          <div class="req-group d-none" data-type="INCIDENT_REPORT">
            <div class="mb-3">
              <label class="form-label">Product ID <span class="text-danger">*</span></label>
              <input type="number" name="productId" class="form-control" placeholder="3">
            </div>

            <div class="mb-3">
              <label class="form-label">Loại sự cố</label>
              <select name="issueType" class="form-select">
                <option value="BROKEN">BROKEN</option>
                <option value="WARNING">WARNING</option>
                <option value="MAINTENANCE">MAINTENANCE</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
              <input type="text" name="title" class="form-control" placeholder="Máy hư...">
            </div>

            <div class="mb-3">
              <label class="form-label">Mô tả</label>
              <textarea name="description" class="form-control" rows="3"></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label">Priority</label>
              <select name="priority" class="form-select">
                <option value="LOW">LOW</option>
                <option value="MEDIUM">MEDIUM</option>
                <option value="HIGH">HIGH</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Ngày mong muốn</label>
              <input type="date" name="preferredDate" class="form-control">
            </div>
          </div>

          <!-- GROUP: CUSTOMER_REMINDER -->
          <div class="req-group d-none" data-type="CUSTOMER_REMINDER">
            <div class="mb-3">
              <label class="form-label">Customer ID <span class="text-danger">*</span></label>
              <input type="number" name="customerId" class="form-control" placeholder="39">
            </div>

            <div class="mb-3">
              <label class="form-label">Nội dung nhắc <span class="text-danger">*</span></label>
              <textarea name="content" class="form-control" rows="3" placeholder="Nhắc khách hàng..."></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label">Hạn xử lý</label>
              <input type="date" name="dueDate" class="form-control">
            </div>
          </div>

          <!-- GROUP: NEW_PRODUCT -->
          <div class="req-group d-none" data-type="NEW_PRODUCT">
            <div class="mb-3">
              <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
              <input type="text" name="name" class="form-control" placeholder="VD: Cummins C250D5">
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">Brand <span class="text-danger">*</span></label>
                <select name="brandName" class="form-select">
                  <option value="">-- Chọn brand --</option>
                  <c:forEach var="b" items="${brands}">
                    <option value="${b.name}"><c:out value="${b.name}"/></option>
                  </c:forEach>
                </select>
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label">Category <span class="text-danger">*</span></label>
                <select name="categoryName" class="form-select">
                  <option value="">-- Chọn category --</option>
                  <c:forEach var="c" items="${categories}">
                    <option value="${c.name}"><c:out value="${c.name}"/></option>
                  </c:forEach>
                </select>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">Xuất xứ</label>
                <input type="text" name="origin" class="form-control" placeholder="Nhật Bản">
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label">Fuel Type <span class="text-danger">*</span></label>
                <select name="fuelType" class="form-select">
                  <option value="DIESEL">DIESEL</option>
                  <option value="GASOLINE">GASOLINE</option>
                  <option value="OTHER">OTHER</option>
                </select>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Công suất (kVA)</label>
              <input type="number" step="0.1" name="power" class="form-control" placeholder="250">
            </div>

            <div class="mb-3">
              <label class="form-label">Mô tả</label>
              <textarea name="description" class="form-control" rows="2" placeholder="Mô tả nhanh sản phẩm..."></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label">Thông số kỹ thuật</label>
              <textarea name="specifications" class="form-control" rows="2" placeholder="Thông số chính..."></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label">Trạng thái sản phẩm</label>
              <select name="productStatus" class="form-select">
                <option value="COMING_SOON">COMING_SOON</option>
                <option value="ACTIVE">ACTIVE</option>
                <option value="INACTIVE">INACTIVE</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Manual file (PDF)</label>
              <input type="file" name="manualFile" class="form-control" accept=".pdf,application/pdf">
            </div>

            <div class="mb-3">
              <label class="form-label">Image file</label>
              <input type="file" name="imageFile" class="form-control" accept="image/*,.png,.jpg,.jpeg,.webp">
            </div>
          </div>
          <div class="alert alert-info small mb-0">
            <i class="fa fa-info-circle"></i>
            Với <b>NEW_PRODUCT</b>, hệ thống sẽ tự gửi request xuống role <b>IT</b> để tạo sản phẩm mới.
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-primary">Gửi ngay</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
(function(){
  var receiverRoleEl = document.querySelector("select[name='receiverRole']");

  function toggleGroups() {
    var type = document.getElementById("requestType").value;

    document.querySelectorAll(".req-group").forEach(function(g){
      var match = g.getAttribute("data-type") === type;
      g.classList.toggle("d-none", !match);
      // optional: disable inputs of hidden groups to avoid sending junk
      g.querySelectorAll("input,select,textarea").forEach(function(el){
        el.disabled = !match;
      });
    });

    if (receiverRoleEl) {
      if (type === "NEW_PRODUCT") {
        receiverRoleEl.value = "IT";
        receiverRoleEl.setAttribute("disabled", "disabled");
      } else {
        receiverRoleEl.removeAttribute("disabled");
      }
    }
  }
  document.getElementById("requestType").addEventListener("change", toggleGroups);

  // Giữ receiverRole gửi lên server khi select đang disabled
  var formEl = document.querySelector("#createRequestModal form");
  if (formEl && receiverRoleEl) {
    formEl.addEventListener("submit", function(){
      if (receiverRoleEl.disabled) {
        receiverRoleEl.removeAttribute("disabled");
      }
    });
  }

  toggleGroups();
})();
</script>


<script>
(function () {
    function safeParseJson(text) {
        try { return JSON.parse(text); } catch (e) { return null; }
    }

    function buildSummary(reqType, obj, raw) {
        if (!obj) return raw;

        if (reqType === "CREATE_USER") {
            const fullName = obj.fullName || "-";
            const email = obj.email || "-";
            const phone = obj.phone || obj.phoneNumber || "-";
            return `Tạo user: ${fullName} | ${email} | ${phone}`;
        }

        if (reqType === "INCIDENT_REPORT") {
            const title = obj.title || "(không có tiêu đề)";
            const priority = obj.priority || "-";
            const issueType = obj.issueType || "-";
            const productId = obj.productId || "-";
            return `Sự cố: ${title} | Priority: ${priority} | Type: ${issueType} | ProductID: ${productId}`;
        }

        if (reqType === "NEW_PRODUCT") {
            const name = obj.name || "-";
            const brandName = obj.brandName || obj.brandId || "-";
            const categoryName = obj.categoryName || obj.categoryId || "-";
            const power = obj.power || "-";
            const fuelType = obj.fuelType || "-";
            return `New product: ${name} | Brand: ${brandName} | Category: ${categoryName} | Fuel: ${fuelType} | Power: ${power}`;
        }

        const keys = Object.keys(obj);
        return `Dữ liệu: ${keys.slice(0, 6).join(", ")}${keys.length > 6 ? "..." : ""}`;
    }

    document.querySelectorAll("code[id^='json-']").forEach(codeEl => {
        const id = codeEl.id.replace("json-", "");
        const raw = (codeEl.textContent || "").trim();
        const summaryEl = document.getElementById("summary-" + id);
        const btn = document.querySelector("button[data-reqid='" + id + "']");
        const reqType = btn ? (btn.getAttribute("data-reqtype") || "") : "";
        const obj = safeParseJson(raw);
        const summary = buildSummary(reqType, obj, raw);
        if (summaryEl) summaryEl.textContent = summary;
    });

    const detailModal = document.getElementById("jsonDetailModal");
    if (detailModal) {
        detailModal.addEventListener("show.bs.modal", function (event) {
            const button = event.relatedTarget;
            const id = button.getAttribute("data-reqid");
            const type = button.getAttribute("data-reqtype");
            const raw = (document.getElementById("json-" + id)?.textContent || "").trim();
            const obj = safeParseJson(raw);

            document.getElementById("detailId").textContent = id;
            document.getElementById("detailTypeBadge").textContent = type || "REQUEST";
            document.getElementById("detailJson").textContent = obj ? JSON.stringify(obj, null, 2) : raw;
        });
    }

    const rejectModal = document.getElementById("rejectModal");
    if (rejectModal) {
        rejectModal.addEventListener("show.bs.modal", function (event) {
            const button = event.relatedTarget;
            const id = button.getAttribute("data-id");
            document.getElementById("rejectId").value = id;
        });
    }
})();
</script>

</body>
