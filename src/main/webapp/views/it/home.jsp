<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<sitemesh:title>IT Dashboard</sitemesh:title>

<div class="container-fluid">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <div>
      <h4 class="mb-1">IT Dashboard</h4>
      <div class="text-muted">Trang tổng quan quản trị hệ thống</div>
    </div>
    <div class="text-muted small">
      <i class="fa fa-circle-info me-1"></i>
      Role: <strong>IT</strong>
    </div>
  </div>

  <div class="row g-3 mb-3">
    <div class="col-md-3">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <div class="text-muted small">Sản phẩm</div>
              <div class="fs-4 fw-bold">${requestScope.totalProducts}</div>
            </div>
            <i class="fa fa-box-open fs-2 text-secondary"></i>
          </div>
          <a class="btn btn-sm btn-outline-primary mt-3"
             href="${pageContext.request.contextPath}/it/products">
            Quản lý sản phẩm
          </a>
        </div>
      </div>
    </div>

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

    <div class="col-md-3">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <div class="text-muted small">Người dùng</div>
              <div class="fs-4 fw-bold">${requestScope.totalUsers}</div>
            </div>
            <i class="fa fa-users-gear fs-2 text-secondary"></i>
          </div>
          <a class="btn btn-sm btn-outline-primary mt-3"
             href="${pageContext.request.contextPath}/it/users">
            Quản lý người dùng
          </a>
        </div>
      </div>
    </div>

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
  </div>

  <div class="card shadow-sm">
    <div class="card-header bg-white">
      <strong>Thông báo / Công việc gần đây</strong>
    </div>
    <div class="card-body">
      <c:choose>
        <c:when test="${not empty requestScope.recentActivities}">
          <ul class="mb-0">
            <c:forEach items="${requestScope.recentActivities}" var="a">
              <li>
                <span class="text-muted small">${a.time}</span> - ${a.content}
              </li>
            </c:forEach>
          </ul>
        </c:when>
        <c:otherwise>
          <div class="text-muted">Chưa có dữ liệu hoạt động gần đây.</div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
