<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <title>Quản lý Product Model Ownership</title>
    <style>
        .ownership-shell { background: linear-gradient(180deg, #f8faff 0%, #ffffff 65%); border-radius: 18px; }
        .ownership-card { border: 1px solid #e8eefc; border-radius: 14px; transition: all .2s ease; background: #fff; }
        .ownership-card:hover { transform: translateY(-2px); box-shadow: 0 12px 28px rgba(34,74,169,.08); border-color: #cfe0ff; }
        .ownership-card.active { border-color: #5b8cff; box-shadow: 0 8px 24px rgba(51,112,255,.15); background: linear-gradient(180deg,#f4f8ff 0%, #ffffff 100%); }
        .metric-pill { font-size: 12px; border-radius: 999px; padding: .24rem .55rem; font-weight: 600; }
        .section-title { letter-spacing: .2px; }
        .serial-link { font-weight: 700; text-decoration: none; }
        .serial-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container-fluid mt-4">
    <div class="ownership-shell p-3 p-lg-4 border shadow-sm">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3 mb-3">
            <div>
                <h3 class="text-primary fw-bold mb-1 section-title"><i class="fa fa-layer-group"></i> Product Model Ownership</h3>
                <p class="text-muted mb-0">Quản lý model theo người sở hữu, click model để xem danh sách serial chi tiết.</p>
            </div>
            <div class="d-flex gap-2">
                <span class="badge text-bg-light border px-3 py-2">Tổng models: ${ownershipTotalItems}</span>
                <span class="badge text-bg-primary px-3 py-2">Trang ${ownershipCurrentPage}/${ownershipTotalPages}</span>
            </div>
        </div>

        <form action="assets" method="get" class="card border-0 shadow-sm mb-3">
            <div class="card-body py-2 px-3 d-flex flex-column flex-lg-row gap-2 align-items-lg-center">
                <input type="hidden" name="action" value="list"/>
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="fa fa-search text-muted"></i></span>
                    <input type="text" name="keyword" class="form-control" placeholder="Lọc theo model, serial, khách hàng, email, vị trí..." value="${currentKeyword}"/>
                </div>
                <select name="ownerFilter" class="form-select" style="max-width: 240px;">
                    <option value="all" ${ownerFilter == 'all' ? 'selected' : ''}>Tất cả Product Models</option>
                    <option value="has_owner" ${ownerFilter == 'has_owner' ? 'selected' : ''}>Có khách hàng sở hữu</option>
                    <option value="no_owner" ${ownerFilter == 'no_owner' ? 'selected' : ''}>Chưa có khách hàng sở hữu</option>
                </select>
                <button class="btn btn-primary" type="submit"><i class="fa fa-filter"></i> Lọc</button>
                <a class="btn btn-outline-secondary" href="assets?action=list"><i class="fa fa-undo"></i> Reset</a>
            </div>
        </form>

        <div class="row g-3">
            <div class="col-12 col-xl-5">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white border-0 py-3">
                        <h6 class="mb-0 fw-bold"><i class="fa fa-list"></i> Danh sách Product Models</h6>
                    </div>
                    <div class="card-body pt-1">
                        <c:choose>
                            <c:when test="${empty productModelOwnerships}">
                                <div class="text-center text-muted py-5">Không có dữ liệu Product Model Ownership.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="vstack gap-2">
                                    <c:forEach var="ownership" items="${productModelOwnerships}">
                                        <a class="ownership-card p-3 text-decoration-none ${selectedModelId == ownership.modelId ? 'active' : ''}"
                                           href="assets?action=list&keyword=${currentKeyword}&ownerFilter=${ownerFilter}&ownershipPage=${ownershipCurrentPage}&selectedModelId=${ownership.modelId}">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div class="text-dark fw-semibold">${ownership.modelName}</div>
                                                <i class="fa fa-chevron-right text-muted"></i>
                                            </div>
                                            <div class="mt-2 d-flex gap-2">
                                                <span class="badge text-bg-info metric-pill">${ownership.ownerCount} khách hàng</span>
                                                <span class="badge text-bg-secondary metric-pill">${ownership.totalAssets} tài sản</span>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-footer bg-white border-0 pt-0 pb-3">
                        <c:if test="${ownershipTotalPages > 1}">
                            <nav>
                                <ul class="pagination pagination-sm mb-0 justify-content-end">
                                    <li class="page-item ${ownershipCurrentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="assets?action=list&keyword=${currentKeyword}&ownerFilter=${ownerFilter}&ownershipPage=${ownershipCurrentPage - 1}&selectedModelId=${selectedModelId}"><i class="fa fa-chevron-left"></i></a>
                                    </li>

                                    <c:if test="${ownershipPageStart > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="assets?action=list&keyword=${currentKeyword}&ownerFilter=${ownerFilter}&ownershipPage=1&selectedModelId=${selectedModelId}">1</a>
                                        </li>
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>

                                    <c:forEach begin="${ownershipPageStart}" end="${ownershipPageEnd}" var="i">
                                        <li class="page-item ${ownershipCurrentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="assets?action=list&keyword=${currentKeyword}&ownerFilter=${ownerFilter}&ownershipPage=${i}&selectedModelId=${selectedModelId}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${ownershipPageEnd < ownershipTotalPages}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                        <li class="page-item">
                                            <a class="page-link" href="assets?action=list&keyword=${currentKeyword}&ownerFilter=${ownerFilter}&ownershipPage=${ownershipTotalPages}&selectedModelId=${selectedModelId}">${ownershipTotalPages}</a>
                                        </li>
                                    </c:if>

                                    <li class="page-item ${ownershipCurrentPage == ownershipTotalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="assets?action=list&keyword=${currentKeyword}&ownerFilter=${ownerFilter}&ownershipPage=${ownershipCurrentPage + 1}&selectedModelId=${selectedModelId}"><i class="fa fa-chevron-right"></i></a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="col-12 col-xl-7">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white border-0 py-3">
                        <h6 class="mb-0 fw-bold"><i class="fa fa-microchip"></i> Chi tiết tài sản theo Product Model</h6>
                    </div>
                    <div class="card-body pt-1">
                        <c:choose>
                            <c:when test="${selectedOwnership == null}">
                                <div class="d-flex align-items-center justify-content-center text-muted" style="min-height: 280px;">
                                    <div class="text-center">
                                        <i class="fa fa-hand-pointer fa-2x text-primary mb-2"></i>
                                        <p class="mb-1">Chọn một Product Model bên trái để xem serial và người sở hữu.</p>
                                        <small>Click vào serial để mở chi tiết tài sản.</small>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div>
                                        <h5 class="mb-1 fw-bold text-dark">${selectedOwnership.modelName}</h5>
                                        <small class="text-muted">${selectedOwnership.ownerCount} khách hàng • ${selectedOwnership.totalAssets} tài sản</small>
                                    </div>
                                </div>
                                <div class="table-responsive border rounded-3">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                        <tr>
                                            <th class="ps-3">Serial Number</th>
                                            <th>Khách hàng</th>
                                            <th>Email</th>
                                            <th>Vị trí</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:if test="${empty selectedOwnership.assets}">
                                            <tr>
                                                <td colspan="4" class="text-center py-4 text-muted">Model này hiện chưa có tài sản.</td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="asset" items="${selectedOwnership.assets}">
                                            <tr>
                                                <td class="ps-3 font-monospace">
                                                    <a class="serial-link" href="assets?action=detail&id=${asset.productId}">${asset.serialNumber}</a>
                                                </td>
                                                <td class="fw-semibold text-primary">${asset.customerName}</td>
                                                <td>${asset.customerEmail}</td>
                                                <td>${asset.location}</td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
