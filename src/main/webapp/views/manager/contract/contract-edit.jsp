<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <head>
            <title>Chỉnh sửa Hợp đồng</title>
        </head>

        <body>
            <div class="container mt-4">
                <div class="card shadow-sm border-warning">

                    <div class="card-header bg-warning text-dark">
                        <h4 class="mb-0">
                            <i class="fa fa-edit"></i> CẬP NHẬT HỢP ĐỒNG
                        </h4>
                    </div>

                    <div class="card-body">
                        <form action="contracts" method="post">

                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${contract.id}">

                            <h6 class="text-muted border-bottom pb-2 mb-3"><i class="fa fa-file-contract"></i> Thông tin
                                chung</h6>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Số Hợp Đồng (*)</label>
                                    <input type="text" name="contractNumber" class="form-control" required
                                        value="${contract.contractNumber}">
                                </div>
                            </div>

                            <h6 class="text-muted border-bottom pb-2 mb-3 mt-4"><i class="fa fa-server"></i> Máy phát
                                điện & Chủ sở hữu</h6>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Khách hàng (*)</label>
                                    <select name="customerId" class="form-select" required>
                                        <c:forEach var="u" items="${customers}">
                                            <option value="${u.id}" ${contract.customerId==u.id ? 'selected' : '' }>
                                                ${u.fullName} (${u.email})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 d-flex align-items-end">
                                    <div class="alert alert-light border w-100 mb-0">
                                        Nếu hợp đồng có nhiều serial, bạn có thể sửa nhiều máy trong cùng 1 lần lưu.
                                    </div>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty contractProducts}">
                                    <div class="table-responsive mb-3">
                                        <table class="table table-bordered align-middle">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width: 16%">Serial</th>
                                                    <th style="width: 30%">Tên máy phát điện (*)</th>
                                                    <th style="width: 14%">Năm sản xuất</th>
                                                    <th>Vị trí lắp đặt</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="cp" items="${contractProducts}">
                                                    <tr>
                                                        <td>
                                                            <input type="hidden" name="serialNumbers"
                                                                value="${cp.serialNumber}">
                                                            <span class="fw-bold text-primary">${cp.serialNumber}</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" class="form-control"
                                                                name="inputModelNames" list="modelSuggestions"
                                                                value="${cp.modelName}" required autocomplete="off">
                                                        </td>
                                                        <td>
                                                            <input type="number" name="manufactureYears"
                                                                class="form-control" min="1990" max="2100"
                                                                value="${cp.manufactureYear}">
                                                        </td>
                                                        <td>
                                                            <input type="text" name="currentLocations"
                                                                class="form-control" value="${cp.currentLocation}">
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Tên máy phát điện (*)</label>
                                            <input type="text" class="form-control" name="inputModelName"
                                                list="modelSuggestions" value="${contract.productModelName}" required
                                                autocomplete="off">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Số Serial (*)</label>
                                            <input type="text" name="serialNumber" class="form-control" required
                                                value="${contract.productSerial}">
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Năm sản xuất</label>
                                            <input type="number" name="manufactureYear" class="form-control" min="1990"
                                                max="2100" value="${contract.productManufactureYear}">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Vị trí lắp đặt</label>
                                            <input type="text" name="currentLocation" class="form-control" value="">
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <datalist id="modelSuggestions">
                                <c:forEach items="${models}" var="m">
                                    <option value="${m.name}"></option>
                                </c:forEach>
                            </datalist>

                            <h6 class="text-muted border-bottom pb-2 mb-3 mt-4"><i class="fa fa-calendar-alt"></i> Thời
                                gian hiệu lực</h6>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Ngày bắt đầu</label>
                                    <input type="date" name="startDate" class="form-control" required
                                        value="${contract.startDate}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Ngày kết thúc</label>
                                    <input type="date" name="endDate" class="form-control" required
                                        value="${contract.endDate}">
                                </div>
                            </div>

                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger mt-3">
                                    <i class="fa fa-exclamation-triangle"></i> ${errorMessage}
                                </div>
                            </c:if>

                            <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                                <a href="contracts" class="btn btn-secondary me-2">
                                    <i class="fa fa-arrow-left"></i> Quay lại
                                </a>
                                <button type="submit" class="btn btn-warning px-4 text-dark fw-bold">
                                    <i class="fa fa-save"></i> Lưu thay đổi
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>


        </body>

        </html>