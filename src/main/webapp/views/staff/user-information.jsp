<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <title>Hồ sơ người dùng: ${user.fullName}</title>

      <div class="container mt-4">
        <div class="mb-3">
          <a href="javascript:history.back()" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
          </a>
        </div>

        <div class="row justify-content-center">
          <div class="col-md-9">
            <div class="card shadow-lg border-0 rounded-3">

              <div class="card-header bg-primary text-white text-center py-4"
                style="background: linear-gradient(45deg, #4e73df, #224abe);">
                <div
                  class="avatar-circle bg-white text-primary d-inline-flex align-items-center justify-content-center rounded-circle shadow mb-3"
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
                    <div class="fs-5 text-dark"><i class="fas fa-envelope me-2 text-secondary"></i>${user.email}</div>
                  </div>
                  <div class="col-md-6">
                    <label class="small text-muted fw-bold">Số điện thoại</label>
                    <div class="fs-5 text-dark">
                      <i class="fas fa-phone me-2 text-secondary"></i>
                      ${not empty user.phone ? user.phone : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}
                    </div>
                  </div>
                  <div class="col-md-6 mt-4">
                    <label class="small text-muted fw-bold">Vai trò</label>
                    <div>
                      <c:choose>
                        <c:when test="${user.roleId == 5}"><span class="badge bg-success">Khách hàng</span></c:when>
                        <c:otherwise><span class="badge bg-info text-dark">Nhân viên</span></c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                  <div class="col-md-6 mt-4">
                    <label class="small text-muted fw-bold">Trạng thái</label>
                    <div>${user.status == 1 ? '<span class="text-success fw-bold">Hoạt động</span>' : '<span
                        class="text-danger">Đã khóa</span>'}</div>
                  </div>
                </div>
              </div>

              <div class="card-body p-4 border-top bg-light">
                <div class="d-flex justify-content-between align-items-center mb-3">
                  <h5 class="text-muted text-uppercase mb-0">
                    <i class="fas fa-file-contract me-2"></i>Danh sách Hợp đồng
                  </h5>
                  <span class="badge bg-secondary">${listContracts.size()} Hợp đồng</span>
                </div>

                <c:choose>
                  <c:when test="${not empty listContracts}">
                    <div class="table-responsive bg-white rounded shadow-sm">
                      <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-secondary small">
                          <tr>
                            <th class="py-3 ps-3">Mã Hợp Đồng</th>

                            <th>Sản phẩm / Máy</th>
                            <th>Thời hạn</th>
                            <th>Trạng thái</th>

                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach items="${listContracts}" var="contract">
                            <tr>
                              <td class="ps-3 fw-bold text-primary">
                                <i class="fas fa-hashtag me-1 text-muted small"></i>${contract.contractNumber}
                              </td>

                              <td>
                                <div class="fw-bold text-dark">${contract.productName}</div>
                                <small class="text-muted">ID: ${contract.productId}</small>
                              </td>
                              <td>
                                <div class="small">
                                  <div class="text-success"><i class="fas fa-calendar-check me-1"></i>Start:
                                    <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy" />
                                  </div>
                                  <div class="text-danger"><i class="fas fa-calendar-times me-1"></i>End:
                                    <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy" />
                                  </div>
                                </div>
                              </td>
                              <td>
                                <c:choose>
                                  <c:when test="${contract.status == 'ACTIVE'}">
                                    <span
                                      class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill">Đang
                                      hiệu lực</span>
                                  </c:when>
                                  <c:when test="${contract.status == 'EXPIRED'}">
                                    <span
                                      class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill">Hết
                                      hạn</span>
                                  </c:when>
                                  <c:when test="${contract.status == 'TERMINATED'}">
                                    <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill">Đã
                                      hủy</span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="badge bg-light text-dark border">${contract.status}</span>
                                  </c:otherwise>
                                </c:choose>
                              </td>

                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div class="text-center py-5 border border-dashed rounded bg-white">
                      <i class="fas fa-folder-open fa-3x text-gray-300 mb-3" style="color: #ccc;"></i>
                      <h6 class="text-muted">Khách hàng này chưa có hợp đồng nào.</h6>
                    </div>
                  </c:otherwise>
                </c:choose>
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