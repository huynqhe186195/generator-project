<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<sitemesh:title>IT Dashboard</sitemesh:title>

<div class="container-fluid">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <div>
      <div class="text-muted small">IT Dashboard</div>
      <div class="text-muted">Trang tổng quan quản trị hệ thống</div>
    </div>
    <div class="text-muted small">
      <i class="fa fa-circle-info me-1"></i>
      Role: <strong>IT</strong>
    </div>
  </div>

  <div class="row g-3 mb-3">
    <!-- Máy / Products -->
    <div class="col-md-3">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <div class="text-muted small">Máy</div>
              <div class="fs-4 fw-bold">${requestScope.totalProducts}</div>
            </div>
            <i class="fa fa-laptop fs-2 text-secondary"></i>
          </div>
          <a class="btn btn-sm btn-outline-primary mt-3"
             href="${pageContext.request.contextPath}/it/products">
            Quản lý máy
          </a>
        </div>
      </div>
    </div>

    <!-- ✅ Danh mục / Categories -->
    <div class="col-md-3">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <div class="text-muted small">Danh mục</div>
              <div class="fs-4 fw-bold">${requestScope.totalCategories}</div>
            </div>
            <i class="fa fa-tags fs-2 text-secondary"></i>
          </div>
          <a class="btn btn-sm btn-outline-primary mt-3"
             href="${pageContext.request.contextPath}/it/categories">
            Quản lý danh mục
          </a>
        </div>
      </div>
    </div>

    <!-- ✅ Thương hiệu / Brands (thay cho Người dùng) -->
    <div class="col-md-3">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <div class="text-muted small">Thương hiệu</div>
              <div class="fs-4 fw-bold">${requestScope.totalBrands}</div>
            </div>
            <i class="fa fa-copyright fs-2 text-secondary"></i>
          </div>
          <a class="btn btn-sm btn-outline-primary mt-3"
             href="${pageContext.request.contextPath}/it/brands">
            Quản lý brand
          </a>
        </div>
      </div>
    </div>

    <!-- Cấu hình -->
    <div class="col-md-3">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <div class="text-muted small">Cấu hình</div>
              <div class="fs-6 fw-semibold">System Settings</div>
            </div>
            <i class="fa fa-gear fs-2 text-secondary"></i>
          </div>
          <a class="btn btn-sm btn-outline-primary mt-3"
             href="${pageContext.request.contextPath}/it/settings">
            Mở cấu hình
          </a>
        </div>
      </div>
    </div>

    <div class="col-md-3">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <div class="text-muted small">Yêu cầu NEW_PRODUCT</div>
              <div class="fs-6 fw-semibold">Từ Manager gửi IT</div>
            </div>
            <i class="fa fa-paper-plane fs-2 text-secondary"></i>
          </div>
          <a class="btn btn-sm btn-outline-primary mt-3"
             href="${pageContext.request.contextPath}/it/requests">
            Xử lý yêu cầu
          </a>
        </div>
      </div>
    </div>
  </div>

  <!-- ✅ Bỏ hẳn phần Thông báo / Công việc gần đây -->
</div>
