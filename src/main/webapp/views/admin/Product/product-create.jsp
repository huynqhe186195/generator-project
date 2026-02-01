<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Thêm sản phẩm</title>

<div class="container-fluid">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="text-secondary">Thêm sản phẩm</h3>
    <a class="btn btn-outline-secondary" href="<c:url value='/admin/product/product-list'/>">Quay lại</a>
  </div>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <div class="card shadow border-0">
    <div class="card-body">

      <form method="post"
            action="<c:url value='/admin/product/create'/>"
            class="row g-3"
            enctype="multipart/form-data">

        <!-- ================= -->
        <!-- I. THÔNG TIN CƠ BẢN -->
        <!-- ================= -->
        <div class="col-12">
          <h6 class="text-primary fw-bold">I. Thông tin cơ bản</h6>
          <hr class="mt-1 mb-3"/>
        </div>

        <div class="col-md-4">
          <label class="form-label">Số serial</label>
          <input class="form-control" name="serialNumber" value="${param.serialNumber}" />
        </div>

        <div class="col-md-8">
          <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
          <input class="form-control" name="name" value="${param.name}" required />
        </div>

        <div class="col-md-4">
          <label class="form-label">Model</label>
          <input class="form-control" name="model" value="${param.model}" />
        </div>

        <div class="col-md-4">
          <label class="form-label">Xuất xứ</label>
          <input class="form-control" name="origin" value="${param.origin}" />
        </div>

        <div class="col-md-4">
          <label class="form-label">Năm sản xuất</label>
          <input type="number" class="form-control" name="manufactureYear" value="${param.manufactureYear}" />
        </div>

        <!-- ================= -->
        <!-- II. PHÂN LOẠI -->
        <!-- ================= -->
        <div class="col-12 mt-3">
          <h6 class="text-primary fw-bold">II. Phân loại & trạng thái</h6>
          <hr class="mt-1 mb-3"/>
        </div>

        <div class="col-md-6">
          <label class="form-label d-flex justify-content-between align-items-center">
            <span>Hãng (Brand) <span class="text-danger">*</span></span>
            <button type="button"
                    class="btn btn-sm btn-outline-primary"
                    data-bs-toggle="modal"
                    data-bs-target="#brandModal">
              + Thêm hãng
            </button>
          </label>

          <select class="form-select" name="brandId" id="brandSelect" required>
            <option value="">-- Chọn hãng --</option>
            <c:forEach items="${brands}" var="b">
              <option value="${b.id}" <c:if test="${param.brandId == b.id}">selected</c:if>>
                  ${b.name}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-6">
          <label class="form-label">Danh mục <span class="text-danger">*</span></label>
          <select class="form-select" name="categoryId" required>
            <option value="">-- Chọn danh mục --</option>
            <c:forEach items="${categories}" var="c">
              <option value="${c.id}" <c:if test="${param.categoryId == c.id}">selected</c:if>>
                  ${c.name}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-4">
          <label class="form-label">Loại nhiên liệu  <span class="text-danger">*</span></label>
          <select class="form-select" name="fuelType" required>
            <option value="">-- Chọn nhiên liệu --</option>
            <c:forEach items="${fuelTypes}" var="f">
              <option value="${f}" <c:if test="${param.fuelType == f}">selected</c:if>>
                  ${f}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-4">
          <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
          <select class="form-select" name="status" required>
            <option value="">-- Chọn trạng thái --</option>
            <c:forEach items="${statuses}" var="s">
              <option value="${s}" <c:if test="${param.status == s}">selected</c:if>>
                  ${s}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-4">
          <label class="form-label">Vị trí hiện tại</label>
          <input class="form-control" name="currentLocation" value="${param.currentLocation}" />
        </div>

        <!-- ================= -->
        <!-- III. THÔNG SỐ KỸ THUẬT -->
        <!-- ================= -->
        <div class="col-12 mt-3">
          <h6 class="text-primary fw-bold">III. Thông số kỹ thuật</h6>
          <hr class="mt-1 mb-3"/>
        </div>

        <div class="col-md-3">
          <label class="form-label">Công suất Prime (kVA)</label>
          <input type="number" step="0.01" class="form-control" name="powerPrime" value="${param.powerPrime}" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Công suất Standby (kVA)</label>
          <input type="number" step="0.01" class="form-control" name="powerStandby" value="${param.powerStandby}" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Điện áp</label>
          <input class="form-control" name="voltage" placeholder="220V / 380V" value="${param.voltage}" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Dung tích bình nhiên liệu</label>
          <input type="number" step="0.01" class="form-control" name="fuelTankCapacity" value="${param.fuelTankCapacity}" />
        </div>

        <!-- ================= -->
        <!-- IV. VẬN HÀNH -->
        <!-- ================= -->
        <div class="col-12 mt-3">
          <h6 class="text-primary fw-bold">IV. Vận hành</h6>
          <hr class="mt-1 mb-3"/>
        </div>

        <div class="col-md-4">
          <label class="form-label">Tổng giờ đã vận hành</label>
          <input type="number" step="0.1" class="form-control" name="totalRunningHours" value="${param.totalRunningHours}" />
        </div>

        <!-- ================= -->
        <!-- V. KHÁC -->
        <!-- ================= -->
        <div class="col-12 mt-3">
          <h6 class="text-primary fw-bold">V. Thông tin khác</h6>
          <hr class="mt-1 mb-3"/>
        </div>

        <div class="col-md-6">
          <label class="form-label">Hình ảnh</label>
          <input type="file" class="form-control" name="imageFile" accept="image/*" />
        </div>

        <div class="col-md-6">
          <label class="form-label">Khách hàng sở hữu</label>
          <select class="form-select" name="customerId">
            <option value="">-- Không gán --</option>
            <c:forEach items="${customers}" var="u">
              <option value="${u.id}" <c:if test="${param.customerId == u.id}">selected</c:if>>
                  ${u.fullName}
              </option>
            </c:forEach>
          </select>
        </div>

        <!-- ACTION -->
        <div class="col-12 d-flex justify-content-end gap-2 mt-4">
          <a class="btn btn-outline-secondary" href="<c:url value='/admin/product/product-list'/>">Hủy</a>
          <button class="btn btn-primary" type="submit">Lưu sản phẩm</button>
        </div>

      </form>
    </div>
  </div>

</div>

<!-- ================= -->
<!-- MODAL THÊM HÃNG -->
<!-- ================= -->
<div class="modal fade" id="brandModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Thêm hãng (Brand)</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <div id="brandErr" class="alert alert-danger d-none"></div>

        <div class="mb-3">
          <label class="form-label">Tên hãng <span class="text-danger">*</span></label>
          <input class="form-control" id="brandName"/>
        </div>

        <div class="mb-3">
          <label class="form-label">Slug</label>
          <input class="form-control" id="brandSlug"/>
        </div>
      </div>

      <div class="modal-footer">
        <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
        <button class="btn btn-primary" id="btnSaveBrand" type="button">Lưu hãng</button>
      </div>
    </div>
  </div>
</div>

<script>
  (function () {
    const btn = document.getElementById("btnSaveBrand");
    const err = document.getElementById("brandErr");

    function showErr(m){ err.textContent = m; err.classList.remove("d-none"); }
    function hideErr(){ err.classList.add("d-none"); }

    btn.onclick = async function () {
      hideErr();
      const name = brandName.value.trim();
      const slug = brandSlug.value.trim();

      if (!name) return showErr("Tên hãng không được để trống");

      const fd = new FormData();
      fd.append("name", name);
      fd.append("slug", slug);

      const res = await fetch("<c:url value='/admin/brand/create-ajax'/>", {
        method: "POST",
        body: fd
      });

      const data = await res.json();
      if (!data.success) return showErr(data.message || "Không thể thêm hãng");

      const opt = document.createElement("option");
      opt.value = data.id;
      opt.textContent = data.name;
      opt.selected = true;
      brandSelect.appendChild(opt);

      bootstrap.Modal.getInstance(brandModal).hide();
      brandName.value = brandSlug.value = "";
    };
  })();
</script>
