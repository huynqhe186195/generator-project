<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .card-box { border: none; border-radius: 10px; transition: transform 0.3s ease-in-out; color: white; }
        .card-box:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.2) !important; }
        .icon-box { font-size: 3.5rem; opacity: 0.3; }
        a { text-decoration: none; }
    </style>
</head>
<body class="bg-light">

        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-list-alt"></i> Hợp đồng mới nhất</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Số HĐ</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${recentContracts}">
                                    <tr>
                                        <td>
                                            <a href="contracts?action=detail&id=${c.id}" class="text-decoration-none fw-bold">
                                                ${c.contractNumber}
                                            </a>
                                        </td>
                                        <td>${c.customerName}</td>
                                        <td>
                                            <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'ACTIVE'}">
                                                    <span class="badge bg-success">ACTIVE</span>
                                                </c:when>
                                                <c:when test="${c.status == 'EXPIRED'}">
                                                    <span class="badge bg-danger">EXPIRED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">${c.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer bg-white text-center py-3">
                        <a href="${pageContext.request.contextPath}/manager/contracts" class="text-primary fw-bold">Xem tất cả hợp đồng <i class="fa fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <h5 class="mb-0 fw-bold text-secondary"><i class="fa fa-sticky-note"></i> Ghi chú hệ thống</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${expiringCount > 0}">
                            <div class="alert alert-warning shadow-sm">
                                <i class="fa fa-exclamation-circle"></i> Có <strong>${expiringCount}</strong> hợp đồng sắp hết hạn trong tháng này. Vui lòng liên hệ khách hàng.
                            </div>
                        </c:if>

                        <div class="alert alert-info shadow-sm">
                            <i class="fa fa-info-circle"></i> Kiểm tra định kỳ máy phát tại <strong>Khu công nghiệp VSIP</strong> vào ngày mai.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>