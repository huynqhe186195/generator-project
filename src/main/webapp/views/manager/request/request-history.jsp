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
        .request-detail-wrap {
            border: 1px solid #e6ebf2;
            border-radius: 12px;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            overflow: hidden;
        }
        .request-detail-head {
            padding: 14px 16px;
            border-bottom: 1px solid #e6ebf2;
            background: #f2f7ff;
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }
        .request-detail-body {
            padding: 16px;
        }
        .detail-section-title {
            font-size: 13px;
            font-weight: 700;
            color: #2b3a55;
            letter-spacing: .02em;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
            margin-bottom: 14px;
        }
        .detail-item {
            border: 1px solid #e9edf3;
            border-radius: 10px;
            background: #fff;
            padding: 10px 12px;
            min-height: 68px;
        }
        .detail-label {
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 5px;
            font-weight: 600;
        }
        .detail-value {
            font-size: 15px;
            font-weight: 600;
            color: #1f2d3d;
            line-height: 1.4;
            word-break: break-word;
        }
        .detail-value.is-muted {
            color: #7f8a96;
            font-weight: 500;
            font-style: italic;
        }
        .detail-note {
            border: 1px dashed #bfd5ff;
            border-radius: 10px;
            background: #f8fbff;
            padding: 10px 12px;
            color: #30466e;
            line-height: 1.5;
            margin-top: 4px;
            white-space: pre-wrap;
            word-break: break-word;
        }
        .request-detail-wrap.is-animated {
            animation: detailFadeIn .28s ease-out both;
        }
        @keyframes detailFadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .tech-assign-form {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }
        .tech-assign-select {
            min-width: 240px;
            border: 1px solid #bcd1ff;
            box-shadow: 0 2px 8px rgba(39, 92, 203, 0.08);
            transition: all .2s ease;
        }
        .tech-assign-select:hover,
        .tech-assign-select:focus {
            border-color: #7aa8ff;
            box-shadow: 0 0 0 .2rem rgba(43, 122, 255, 0.15);
        }
        .tech-assign-btn {
            border-radius: 999px;
            padding: 4px 14px;
            transition: transform .15s ease, box-shadow .2s ease;
        }
        .tech-assign-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.25);
        }
        pre.json-pretty{
            white-space: pre-wrap;
            word-break: break-word;
            margin: 0;
        }
        @media (max-width: 768px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }
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
<c:if test="${param.msg == 'technician_updated'}">
    <div class="alert alert-success">Cập nhật kỹ thuật viên thành công!</div>
</c:if>
<c:if test="${param.msg == 'duplicate'}">
    <div class="alert alert-warning">Yêu cầu này đang chờ xử lý rồi!</div>
</c:if>
<c:if test="${param.msg == 'error'}">
    <div class="alert alert-danger">Có lỗi xảy ra, vui lòng thử lại.</div>
</c:if>
<c:if test="${param.msg == 'invalid_file'}">
    <div class="alert alert-warning">Vui lòng tải đúng file Excel (.xlsx/.xls) cho yêu cầu import.</div>
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
                                <c:when test="${r.requestType == 'NEW_USER'}">
                                    <span class="badge bg-primary">NEW_USER</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary"><c:out value="${r.requestType}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="summary-cell">
                            <code class="mini-json d-none" id="json-${r.id}">
                                ${fn:escapeXml(r.requestData)}
                            </code>

                            <div class="mt-2">
                                <button type="button"
                                        class="btn btn-sm btn-outline-primary"
                                        data-bs-toggle="modal"
                                        data-bs-target="#jsonDetailModal"
                                        data-reqid="${r.id}"
                                        data-reqtype="${r.requestType}"
                                        data-reqstatus="${r.status}"
                                        data-box="${box}">
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
                                        <form class="d-inline-flex align-items-center gap-2"
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
                <div id="detailContent"></div>
                <pre class="json-pretty border rounded p-3 bg-light d-none" id="detailJson"></pre>
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
              <option value="NEW_PRODUCT">NEW_PRODUCT - Yêu cầu thêm sản phẩm mới</option>
              <option value="NEW_USER">NEW_USER - Yêu cầu import users từ Excel</option>
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

          <!-- GROUP: NEW_PRODUCT -->
          <div class="req-group d-none" data-type="NEW_PRODUCT">
            <div class="mb-3">
              <label class="form-label">File Excel thông tin sản phẩm <span class="text-danger">*</span></label>
              <input type="file" name="productExcelFile" class="form-control" accept=".xlsx,.xls,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" required>
              <div class="form-text">Mẫu cột theo thứ tự: name, brandName, categoryName, origin, fuelType, power, description, specifications, manualUrl, imageUrl, status. Cột imageUrl có thể chứa nhiều link, ngăn cách bằng dấu ; hoặc xuống dòng.</div>
            </div>
          </div>

          <!-- GROUP: NEW_USER -->
          <div class="req-group d-none" data-type="NEW_USER">
            <div class="mb-3">
              <label class="form-label">File Excel thông tin users <span class="text-danger">*</span></label>
              <input type="file" name="userExcelFile" class="form-control" accept=".xlsx,.xls,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" required>
              <div class="form-text">Mẫu cột theo thứ tự: email, fullName, phone, roleId (optional), status (optional).</div>
            </div>
          </div>
          <div class="alert alert-info small mb-0">
            <i class="fa fa-info-circle"></i>
            Với <b>NEW_PRODUCT</b>, hệ thống tự gửi cho <b>IT</b>. Với <b>NEW_USER</b>, hệ thống tự gửi cho <b>ADMIN</b> để import users.
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
      } else if (type === "NEW_USER") {
        receiverRoleEl.value = "ADMIN";
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

<script id="technicianDisplayMapData" type="application/json"><c:out value="${technicianDisplayJson}" escapeXml="false"/></script>
<script id="productDisplayMapData" type="application/json"><c:out value="${productDisplayJson}" escapeXml="false"/></script>
<div id="technicianOptionsTemplate" class="d-none">
    <c:forEach items="${listTechnicians}" var="tech">
        <option value="${tech.id}">${fn:escapeXml(tech.fullName)} - ${fn:escapeXml(tech.email)}</option>
    </c:forEach>
</div>

<script>
(function () {
    function safeParseJson(text) {
        try { return JSON.parse(text); } catch (e) { return null; }
    }

    const technicianDisplayMap = safeParseJson((document.getElementById("technicianDisplayMapData")?.textContent || "").trim()) || {};
    const productDisplayMap = safeParseJson((document.getElementById("productDisplayMapData")?.textContent || "").trim()) || {};

    function escapeHtml(input) {
        return String(input || "")
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;")
            .replaceAll("'", "&#039;");
    }

    function valueOrDash(value) {
        if (value === null || value === undefined || value === "") return "-";
        return value;
    }

    function normalizeTechnicianIdValue(rawValue) {
        if (rawValue === null || rawValue === undefined || rawValue === "") {
            return "";
        }
        const numeric = Number(rawValue);
        if (Number.isFinite(numeric)) {
            return String(Math.trunc(numeric));
        }
        return String(rawValue).trim();
    }

    function resolveTechnicianDisplay(technicianId) {
        const key = String(valueOrDash(technicianId));
        if (key === "-") return "-";
        return productOrFallback(technicianDisplayMap[key], key + " - Chưa có tên");
    }

    function resolveProductDisplay(productId) {
        const key = String(valueOrDash(productId));
        if (key === "-") return "-";
        return productOrFallback(productDisplayMap[key], "Sản phẩm #" + key + " - N/A");
    }

    function productOrFallback(value, fallback) {
        if (value === null || value === undefined || value === "") return fallback;
        return value;
    }

    function renderField(label, value) {
        const val = valueOrDash(value);
        const mutedClass = val === "-" ? "is-muted" : "";
        return '<div class="detail-item">'
            + '<div class="detail-label">' + escapeHtml(label) + '</div>'
            + '<div class="detail-value ' + mutedClass + '">' + escapeHtml(val) + '</div>'
            + '</div>';
    }

    function renderSection(title, fields) {
        const fieldHtml = fields.map(f => renderField(f.label, f.value)).join("");
        return '<div class="mb-3">'
            + '<div class="detail-section-title">' + escapeHtml(title) + '</div>'
            + '<div class="detail-grid">' + fieldHtml + '</div>'
            + '</div>';
    }

    function toNumber(value) {
        if (value === null || value === undefined || value === "") return null;
        const n = Number(value);
        return Number.isFinite(n) ? n : null;
    }

    function formatCurrency(value) {
        const n = toNumber(value);
        if (n === null) return valueOrDash(value);
        return n.toLocaleString("vi-VN") + " VNĐ";
    }

    function normalizeMaterials(rawMaterials) {
        if (!rawMaterials) return [];
        if (Array.isArray(rawMaterials)) return rawMaterials;
        if (typeof rawMaterials === "string") {
            const parsed = safeParseJson(rawMaterials);
            return Array.isArray(parsed) ? parsed : [];
        }
        return [];
    }

    function renderMaterialsSection(rawMaterials) {
        const materials = normalizeMaterials(rawMaterials);
        if (!materials.length) {
            return '<div class="mb-3">'
                + '<div class="detail-section-title">Vật tư / Linh kiện</div>'
                + '<div class="detail-note">-</div>'
                + '</div>';
        }

        const rows = materials.map(function (mat, index) {
            return '<tr>'
                + '<td>' + (index + 1) + '</td>'
                + '<td>' + escapeHtml(valueOrDash(mat.partName || mat.sparePartName || ("ID #" + valueOrDash(mat.sparePartId)))) + '</td>'
                + '<td>' + escapeHtml(valueOrDash(mat.quantityUsed)) + '</td>'
                + '<td>' + escapeHtml(formatCurrency(mat.unitPrice)) + '</td>'
                + '<td>' + escapeHtml(formatCurrency(mat.costAtTime)) + '</td>'
                + '</tr>';
        }).join("");

        return '<div class="mb-3">'
            + '<div class="detail-section-title">Vật tư / Linh kiện</div>'
            + '<div class="table-responsive">'
            + '<table class="table table-sm table-bordered align-middle mb-0">'
            + '<thead class="table-light"><tr><th>#</th><th>Tên linh kiện</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr></thead>'
            + '<tbody>' + rows + '</tbody>'
            + '</table>'
            + '</div>'
            + '</div>';
    }

    function renderStructuredDetail(reqType, obj, requestId) {
        const common = renderSection("Thông tin chung", [
            { label: "Mã request", value: "#" + requestId },
            { label: "Loại yêu cầu", value: reqType || "REQUEST" }
        ]);

        if (reqType === "INCIDENT_REPORT") {
            return '<div class="request-detail-wrap is-animated">'
                + '<div class="request-detail-head">'
                + '<span class="badge bg-warning text-dark">Sự cố / Incident</span>'
                + '<span class="text-muted small">Chi tiết sự cố đã gửi từ manager</span>'
                + '</div>'
                + '<div class="request-detail-body">'
                + common
                + renderSection("Nội dung sự cố", [
                    { label: "Tiêu đề", value: obj.title },
                    { label: "Loại sự cố", value: obj.issueType || obj.maintenanceType },
                    { label: "Mức ưu tiên", value: obj.priority },
                    { label: "Ngày mong muốn", value: obj.preferredDate },
                    { label: "Sản phẩm", value: resolveProductDisplay(obj.productId) },
                    { label: "Kỹ thuật viên", value: resolveTechnicianDisplay(obj.technicianId) }
                ])
                + renderSection("Người báo cáo", [
                    { label: "Họ tên", value: obj.reporterName },
                    { label: "Số điện thoại", value: obj.reporterPhone },
                    { label: "Email", value: obj.reporterEmail }
                ])
                + '<div class="detail-section-title">Mô tả chi tiết</div>'
                + '<div class="detail-note">' + escapeHtml(valueOrDash(obj.description)) + '</div>'
                + '<div class="detail-section-title mt-3">Ghi chú nội bộ</div>'
                + '<div class="detail-note">' + escapeHtml(valueOrDash(obj.staffNote)) + '</div>'
                + '</div>'
                + '</div>';
        }

        if (reqType === "CREATE_USER") {
            return '<div class="request-detail-wrap is-animated">'
                + '<div class="request-detail-head">'
                + '<span class="badge bg-info text-dark">Tạo tài khoản</span>'
                + '</div>'
                + '<div class="request-detail-body">'
                + common
                + renderSection("Thông tin user", [
                    { label: "Họ tên", value: obj.fullName },
                    { label: "Email", value: obj.email },
                    { label: "Số điện thoại", value: obj.phone || obj.phoneNumber },
                    { label: "Vai trò", value: obj.role || obj.roleId }
                ])
                + '</div>'
                + '</div>';
        }

        if (reqType === "NEW_PRODUCT" || reqType === "NEW_USER") {
            return '<div class="request-detail-wrap is-animated">'
                + '<div class="request-detail-head">'
                + '<span class="badge bg-primary">Import từ Excel</span>'
                + '</div>'
                + '<div class="request-detail-body">'
                + common
                + renderSection("File đính kèm", [
                    { label: "Tên file", value: obj.excelFileName },
                    { label: "Kích thước", value: obj.fileSize }
                ])
                + '</div>'
                + '</div>';
        }

        if (reqType === "REPAIR_QUOTE") {
            return '<div class="request-detail-wrap is-animated">'
                + '<div class="request-detail-head">'
                + '<span class="badge bg-success">Báo giá sửa chữa</span>'
                + '</div>'
                + '<div class="request-detail-body">'
                + common
                + renderSection("Dữ liệu", [
                    { label: "maintenanceId", value: obj.maintenanceId },
                    { label: "technicianId", value: obj.technicianId },
                    { label: "actualDescription", value: obj.actualDescription },
                    { label: "partsTotal", value: formatCurrency(obj.partsTotal) },
                    { label: "grandTotal", value: formatCurrency(obj.grandTotal) }
                ])
                + renderMaterialsSection(obj.materials)
                + '</div>'
                + '</div>';
        }

        const genericFields = Object.keys(obj).slice(0, 12).map(function (k) {
            return { label: k, value: typeof obj[k] === "object" ? JSON.stringify(obj[k]) : obj[k] };
        });

        return '<div class="request-detail-wrap is-animated">'
            + '<div class="request-detail-head">'
            + '<span class="badge bg-secondary">REQUEST</span>'
            + '</div>'
            + '<div class="request-detail-body">'
            + common
            + renderSection("Dữ liệu", genericFields)
            + '</div>'
            + '</div>';
    }

    function buildTechnicianField(obj, requestId, reqStatus, box) {
        const normalizedStatus = (reqStatus || "").toUpperCase();
        const isEditable = (box || "").toLowerCase() === "inbox"
            && (normalizedStatus === "PENDING" || normalizedStatus === "WAITING_MANAGER");
        if (!isEditable) {
            return renderField("Kỹ thuật viên", resolveTechnicianDisplay(obj.technicianId));
        }

        const optionsTemplate = document.getElementById("technicianOptionsTemplate");
        const optionsHtml = optionsTemplate ? optionsTemplate.innerHTML : '';
        const selectedTechnician = normalizeTechnicianIdValue(obj.technicianId);
        const suggestedLabel = selectedTechnician
            ? '-- Chọn kỹ thuật viên đã gợi ý (' + resolveTechnicianDisplay(selectedTechnician) + ') --'
            : '-- Chọn kỹ thuật viên đã gợi ý --';
        const suggestedOption = '<option value="' + escapeHtml(selectedTechnician) + '">' + escapeHtml(suggestedLabel) + '</option>';

        return ''
            + '<div class="detail-item">'
            + '  <div class="detail-label">Kỹ thuật viên</div>'
            + '  <form method="post" action="${pageContext.request.contextPath}/manager/requests" class="tech-assign-form">'
            + '    <input type="hidden" name="action" value="assign_technician" />'
            + '    <input type="hidden" name="id" value="' + escapeHtml(requestId) + '" />'
            + '    <select class="form-select form-select-sm tech-assign-select" name="technicianId">'
            +        suggestedOption
            +        optionsHtml
            + '    </select>'
            + '    <button type="submit" class="btn btn-sm btn-outline-primary tech-assign-btn">Lưu</button>'
            + '  </form>'
            + '  <div class="small text-muted mt-1">Đã chọn: ' + escapeHtml(resolveTechnicianDisplay(selectedTechnician)) + '</div>'
            + '</div>';
    }

    const detailModal = document.getElementById("jsonDetailModal");
    if (detailModal) {
        detailModal.addEventListener("show.bs.modal", function (event) {
            const button = event.relatedTarget;
            const id = button.getAttribute("data-reqid");
            const type = button.getAttribute("data-reqtype");
            const raw = (document.getElementById("json-" + id)?.textContent || "").trim();
            const obj = safeParseJson(raw);
            const detailContentEl = document.getElementById("detailContent");
            const detailJsonEl = document.getElementById("detailJson");
            const status = button.getAttribute("data-reqstatus") || "";
            const box = button.getAttribute("data-box") || "";

            document.getElementById("detailId").textContent = id;
            document.getElementById("detailTypeBadge").textContent = type || "REQUEST";

            if (obj) {
                if (type === "INCIDENT_REPORT") {
                    const common = renderSection("Thông tin chung", [
                        { label: "Mã request", value: "#" + id },
                        { label: "Loại yêu cầu", value: type || "REQUEST" }
                    ]);
                    const incidentSection = '<div class="mb-3">'
                        + '<div class="detail-section-title">Nội dung sự cố</div>'
                        + '<div class="detail-grid">'
                        + renderField("Tiêu đề", obj.title)
                        + renderField("Loại sự cố", obj.issueType || obj.maintenanceType)
                        + renderField("Mức ưu tiên", obj.priority)
                        + renderField("Ngày mong muốn", obj.preferredDate)
                        + renderField("Sản phẩm", resolveProductDisplay(obj.productId))
                        + buildTechnicianField(obj, id, status, box)
                        + '</div>'
                        + '</div>';

                    detailContentEl.innerHTML = '<div class="request-detail-wrap is-animated">'
                        + '<div class="request-detail-head">'
                        + '<span class="badge bg-warning text-dark">Sự cố / Incident</span>'
                        + '<span class="text-muted small">Chi tiết sự cố đã gửi từ manager</span>'
                        + '</div>'
                        + '<div class="request-detail-body">'
                        + common
                        + incidentSection
                        + renderSection("Người báo cáo", [
                            { label: "Họ tên", value: obj.reporterName },
                            { label: "Số điện thoại", value: obj.reporterPhone },
                            { label: "Email", value: obj.reporterEmail }
                        ])
                        + '<div class="detail-section-title">Mô tả chi tiết</div>'
                        + '<div class="detail-note">' + escapeHtml(valueOrDash(obj.description)) + '</div>'
                        + '<div class="detail-section-title mt-3">Ghi chú nội bộ</div>'
                        + '<div class="detail-note">' + escapeHtml(valueOrDash(obj.staffNote)) + '</div>'
                        + '</div>'
                        + '</div>';

                    const selectEl = detailContentEl.querySelector('select[name="technicianId"]');
                    const normalizedTechnicianId = normalizeTechnicianIdValue(obj.technicianId);
                    if (selectEl && normalizedTechnicianId) {
                        selectEl.value = normalizedTechnicianId;
                    }
                } else {
                    detailContentEl.innerHTML = renderStructuredDetail(type, obj, id);
                }
                detailJsonEl.classList.add("d-none");
            } else {
                detailContentEl.innerHTML = "";
                detailJsonEl.classList.remove("d-none");
                detailJsonEl.textContent = raw;
            }
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
