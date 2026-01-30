<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- <jsp:include page="/views/common/header.jsp" /> --%>

<title>Hồ sơ người dùng: ${user.fullName}</title>

<div class="container mt-4">
  <div class="mb-3">
    <a href="javascript:history.back()" class="btn btn-outline-secondary btn-sm">
      <i class="fas fa-arrow-left me-2"></i>Quay lại
    </a>
  </div>

  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card shadow-lg border-0 rounded-3">

        <div class="card-header bg-primary text-white text-center py-4"
             style="background: linear-gradient(45deg, #4e73df, #224abe);">
          <div class="avatar-circle bg-white text-primary d-inline-flex align-items-center justify-content-center rounded-circle shadow mb-3"
               style="width: 100px; height: 100px; font-size: 40px;">
            <i class="fas fa-user"></i>
          </div>
          <h3 class="mb-0 fw-bold">${user.fullName}</h3>
          <p class="mb-0 opacity-75">ID: #${user.id}</p>
        </div>

        <div class="card-body p-4">
          <h5 class="text-muted mb-4 text-uppercase border-bottom pb-2">
            <i class="fas fa-info-circle me-2"></i>Thông tin cơ bản
          </h5>

          <div class="row g-3">
            <div class="col-md-6">
              <label class="small text-muted fw-bold">Email</label>
              <div class="fs-5 text-dark">
                <i class="fas fa-envelope me-2 text-secondary"></i>
                ${user.email}
              </div>
            </div>

            <div class="col-md-6">
              <label class="small text-muted fw-bold">Số điện thoại</label>
              <div class="fs-5 text-dark">
                <i class="fas fa-phone me-2 text-secondary"></i>
                ${not empty user.phone ? user.phone : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}
              </div>
            </div>

            <div class="col-md-6 mt-4">
              <label class="small text-muted fw-bold">Vai trò hệ thống</label>
              <div>
                <c:choose>
                  <c:when test="${user.roleId == 1}">
                    <span class="badge bg-danger p-2"><i class="fas fa-user-shield me-1"></i> Quản trị viên (Admin)</span>
                  </c:when>
                  <c:when test="${user.roleId == 2}">
                    <span class="badge bg-primary p-2"><i class="fas fa-user-tie me-1"></i> Nhân viên (Staff)</span>
                  </c:when>
                  <c:when test="${user.roleId == 4}">
                    <span class="badge bg-warning text-dark p-2"><i class="fas fa-tools me-1"></i> Kỹ thuật viên</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-success p-2"><i class="fas fa-user me-1"></i> Khách hàng</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="col-md-6 mt-4">
              <label class="small text-muted fw-bold">Trạng thái tài khoản</label>
              <div>
                <c:choose>
                  <c:when test="${user.status == 1}">
                    <span class="text-success fw-bold"><i class="fas fa-check-circle me-1"></i> Đang hoạt động</span>
                  </c:when>
                  <c:otherwise>
                    <span class="text-danger fw-bold"><i class="fas fa-ban me-1"></i> Đã khóa / Ngừng hoạt động</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

        </div>

        <div class="card-footer bg-light text-end py-3">
          <c:if test="${sessionScope.USERMODEL.roleId == 1}">
            <a href="#" class="btn btn-warning">
              <i class="fas fa-edit me-1"></i> Chỉnh sửa thông tin
            </a>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</div>

<%-- <jsp:include page="/views/common/footer.jsp" /> --%>