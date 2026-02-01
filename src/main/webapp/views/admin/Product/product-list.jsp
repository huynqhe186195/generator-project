<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<title>Danh sách Product</title>

<div class="container-fluid">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Quản lý Product</h3>

        <a class="btn btn-primary" href="<c:url value='/admin/product/create'/>">
            <i class="fas fa-plus-circle me-2"></i> Thêm mới
        </a>
    </div>

    <!-- FILTER -->
    <div class="card shadow mb-4 border-0">
        <div class="card-body bg-light rounded">
            <form action="<c:url value='/admin/product/product-list'/>" method="get" class="row g-3 align-items-end">

                <div class="col-12 col-md-4">
                    <label class="form-label">Tìm theo tên</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="q" class="form-control"
                               value="${param.q}" placeholder="Nhập tên product..." />
                    </div>
                </div>

                <div class="col-12 col-md-3">
                    <label class="form-label">Brand</label>
                    <select name="brandId" class="form-select">
                        <option value="">-- Tất cả --</option>
                        <c:forEach items="${brands}" var="b">
                            <option value="${b.id}" <c:if test="${param.brandId == b.id}">selected</c:if>>
                                    ${b.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-12 col-md-2">
                    <label class="form-label">Fuel</label>
                    <select name="fuel" class="form-select">
                        <option value="">-- Tất cả --</option>
                        <c:forEach items="${fuels}" var="f">
                            <option value="${f}" <c:if test="${param.fuel == f}">selected</c:if>>
                                    ${f}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-6 col-md-1">
                    <label class="form-label">Min kVA</label>
                    <input type="number" step="0.1" name="minKva" class="form-control"
                           value="${param.minKva}" />
                </div>

                <div class="col-6 col-md-1">
                    <label class="form-label">Max kVA</label>
                    <input type="number" step="0.1" name="maxKva" class="form-control"
                           value="${param.maxKva}" />
                </div>

                <div class="col-12 col-md-1 d-grid">
                    <button class="btn btn-secondary w-100" type="submit">
                        Lọc dữ liệu
                    </button>
                </div>

                <div class="col-12 col-md-1 d-grid">
                    <a class="btn btn-outline-secondary w-100" href="<c:url value='/admin/product/product-list'/>">
                        Reset
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- TABLE -->
    <div class="card shadow border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light text-secondary">
                    <tr>
                        <th class="py-3 ps-4" style="width:70px;">ID</th>
                        <th class="py-3">Tên</th>
                        <th class="py-3">Model</th>
                        <th class="py-3">Origin</th>
                        <th class="py-3">Brand</th>
                        <th class="py-3 text-end">Power Prime (kVA)</th>
                        <th class="py-3">Customer</th>

                        <!-- ✅ NEW: Status -->
                        <th class="py-3" style="width:140px;">Trạng thái</th>

                        <th class="py-3 text-end pe-4" style="width:140px;">Hành động</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${empty products}">
                            <tr>
                                <td colspan="9" class="text-center py-5 text-muted">
                                    <i class="fas fa-box-open fa-3x mb-3 text-gray-300"></i><br>
                                    Không có dữ liệu.
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach items="${products}" var="p">
                                <tr>
                                    <td class="ps-4">${p.id}</td>
                                    <td class="fw-bold">${p.name}</td>
                                    <td>${p.model}</td>

                                    <!-- ✅ FIX: Origin -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.origin}">${p.origin}</c:when>
                                            <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.brand}">${p.brand.name}</c:when>
                                            <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end"><c:out value="${p.powerPrime}" /></td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.customerName}">${p.customerName}</c:when>
                                            <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- ✅ NEW: Status pill giống ảnh -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'READY'}">
                                                <span class="badge rounded-pill bg-success">
                                                    <i class="fas fa-check-circle me-1"></i> Active
                                                </span>
                                            </c:when>
                                            <c:when test="${p.status == 'RUNNING'}">
                                                <span class="badge rounded-pill bg-primary">
                                                    <i class="fas fa-bolt me-1"></i> Running
                                                </span>
                                            </c:when>
                                            <c:when test="${p.status == 'MAINTENANCE'}">
                                                <span class="badge rounded-pill bg-warning text-dark">
                                                    <i class="fas fa-tools me-1"></i> Maintenance
                                                </span>
                                            </c:when>
                                            <c:when test="${p.status == 'BROKEN'}">
                                                <span class="badge rounded-pill bg-danger">
                                                    <i class="fas fa-times-circle me-1"></i> Broken
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge rounded-pill bg-secondary">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <div class="d-flex gap-1 justify-content-end">
                                            <!-- view (nếu bạn có detail) -->
                                            <a class="btn btn-sm btn-info text-white"
                                               href="<c:url value='/admin/product/detail?id=${p.id}'/>"
                                               title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                            </a>

                                            <a class="btn btn-sm btn-warning text-white"
                                               href="<c:url value='/admin/product-update?id=${p.id}'/>"
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>

                                            <a class="btn btn-sm btn-danger"
                                               href="<c:url value='/admin/product-delete?id=${p.id}'/>"
                                               onclick="return confirm('Xoá product #${p.id}?');"
                                               title="Xoá">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <div class="card-footer bg-white py-3">
            <c:if test="${not empty totalPages && totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-end mb-0">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:url var="pageUrl" value="/admin/product/product-list">
                                <c:param name="page" value="${i}" />
                                <c:if test="${not empty param.q}"><c:param name="q" value="${param.q}"/></c:if>
                                <c:if test="${not empty param.brandId}"><c:param name="brandId" value="${param.brandId}"/></c:if>
                                <c:if test="${not empty param.fuel}"><c:param name="fuel" value="${param.fuel}"/></c:if>
                                <c:if test="${not empty param.minKva}"><c:param name="minKva" value="${param.minKva}"/></c:if>
                                <c:if test="${not empty param.maxKva}"><c:param name="maxKva" value="${param.maxKva}"/></c:if>
                            </c:url>

                            <li class="page-item <c:if test='${page == i}'>active</c:if>">
                                <a class="page-link" href="${pageUrl}">${i}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

</div>
