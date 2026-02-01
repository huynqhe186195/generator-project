<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Thêm Product</title>

<div class="container-fluid">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="text-secondary">Thêm Product</h3>
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

        <div class="col-md-4">
          <label class="form-label">Serial number</label>
          <input class="form-control" name="serialNumber" value="${param.serialNumber}" />
        </div>

        <div class="col-md-8">
          <label class="form-label">Tên sản phẩm *</label>
          <input class="form-control" name="name" value="${param.name}" required />
        </div>

        <div class="col-md-4">
          <label class="form-label">Model</label>
          <input class="form-control" name="model" value="${param.model}" />
        </div>

        <div class="col-md-4">
          <label class="form-label">Origin</label>
          <input class="form-control" name="origin" value="${param.origin}" />
        </div>

        <div class="col-md-4">
          <label class="form-label">Manufacture year</label>
          <input type="number" class="form-control" name="manufactureYear" value="${param.manufactureYear}" />
        </div>

        <div class="col-md-6">
          <label class="form-label">Brand *</label>
          <select class="form-select" name="brandId" required>
            <option value="">-- Chọn brand --</option>
            <c:forEach items="${brands}" var="b">
              <option value="${b.id}" <c:if test="${param.brandId == b.id}">selected</c:if>>${b.name}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-6">
          <label class="form-label">Category *</label>
          <select class="form-select" name="categoryId" required>
            <option value="">-- Chọn category --</option>
            <c:forEach items="${categories}" var="c">
              <option value="${c.id}" <c:if test="${param.categoryId == c.id}">selected</c:if>>${c.name}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-3">
          <label class="form-label">Power prime (kVA)</label>
          <input type="number" step="0.01" class="form-control" name="powerPrime" value="${param.powerPrime}" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Power standby (kVA)</label>
          <input type="number" step="0.01" class="form-control" name="powerStandby" value="${param.powerStandby}" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Voltage</label>
          <input class="form-control" name="voltage" value="${param.voltage}" placeholder="220V/380V" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Fuel tank capacity</label>
          <input type="number" step="0.01" class="form-control" name="fuelTankCapacity" value="${param.fuelTankCapacity}" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Fuel type *</label>
          <select class="form-select" name="fuelType" required>
            <option value="">-- Chọn fuel --</option>
            <c:forEach items="${fuelTypes}" var="f">
              <option value="${f}" <c:if test="${param.fuelType == f}">selected</c:if>>${f}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-6">
          <label class="form-label">Current location</label>
          <input class="form-control" name="currentLocation" value="${param.currentLocation}" />
        </div>

        <div class="col-md-3">
          <label class="form-label">Status *</label>
          <select class="form-select" name="status" required>
            <option value="">-- Chọn status --</option>
            <c:forEach items="${statuses}" var="s">
              <option value="${s}" <c:if test="${param.status == s}">selected</c:if>>${s}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-3">
          <label class="form-label">Total running hours</label>
          <input type="number" step="0.1" class="form-control" name="totalRunningHours" value="${param.totalRunningHours}" />
        </div>

        <!-- ✅ Upload image từ ổ cứng -->
        <div class="col-md-6">
          <label class="form-label">Image</label>
          <input type="file" class="form-control" name="imageFile" accept="image/*" />
          <small class="text-muted">Chọn ảnh từ máy (jpg/png).</small>
        </div>

        <!-- ✅ Dropdown Customer -->
        <div class="col-md-6">
          <label class="form-label">Customer (gán chủ sở hữu)</label>
          <select class="form-select" name="customerId">
            <option value="">-- Không gán chủ sở hữu --</option>
            <c:forEach items="${customers}" var="u">
              <option value="${u.id}" <c:if test="${param.customerId == u.id}">selected</c:if>>
                  ${u.fullName}
              </option>
            </c:forEach>
          </select>
          <small class="text-muted">Nếu không chọn thì không gán user sở hữu.</small>
        </div>

        <div class="col-12 d-flex gap-2 justify-content-end">
          <a class="btn btn-outline-secondary" href="<c:url value='/admin/product/product-list'/>">Hủy</a>
          <button class="btn btn-primary" type="submit">Lưu</button>
        </div>

      </form>
    </div>
  </div>

</div>
