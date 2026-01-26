<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quản lý máy phát điện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-img { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; }
        .status-ready { color: #28a745; font-weight: bold; }
        .status-broken { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">DANH SÁCH MÁY PHÁT ĐIỆN</h5>

        </div>
        <div class="card-body">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th>Hình ảnh</th>
                    <th>Tên & Model</th>
                    <th>Số Serial</th>
                    <th>Công suất</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${products}" var="p">
                    <tr>
                        <td>
                            <img src="${p.imageUrl != null ? p.imageUrl : 'https://via.placeholder.com/60'}" class="product-img border">
                        </td>
                        <td>
                            <div><strong>${p.name}</strong></div>
                            <small class="text-muted">${p.model}</small>
                        </td>
                        <td><code>${p.serialNumber}</code></td>
                        <td>${p.powerPrime} kVA</td>
                        <td>
                                <span class="badge ${p.status == 'READY' ? 'bg-success' : 'bg-warning'}">
                                        ${p.status}
                                </span>
                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>