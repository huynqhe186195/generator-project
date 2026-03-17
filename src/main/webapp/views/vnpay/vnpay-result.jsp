<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Kết quả thanh toán | Gen-CMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">

<div class="card shadow-lg border-0 rounded-4 p-5 text-center" style="max-width: 500px;">
    <c:choose>
        <c:when test="${status == 'success'}">
            <i class="fas fa-check-circle text-success mb-4" style="font-size: 80px;"></i>
            <h3 class="fw-bold text-dark mb-3">Thanh toán thành công!</h3>
            <p class="text-muted mb-4">${message}</p>
            <div class="bg-light rounded-3 p-3 mb-4 text-start small">
                <div class="mb-2"><strong>Mã giao dịch VNPay:</strong> ${transactionNo}</div>
                <div><strong>Thời gian:</strong> <%= new java.util.Date() %></div>
            </div>
        </c:when>

        <c:otherwise>
            <i class="fas fa-times-circle text-danger mb-4" style="font-size: 80px;"></i>
            <h3 class="fw-bold text-dark mb-3">Giao dịch thất bại</h3>
            <p class="text-muted mb-4">${message}</p>
        </c:otherwise>
    </c:choose>

    <a href="<c:url value='/'/>" class="btn btn-primary rounded-pill px-4 py-2 fw-bold w-100">
        Trở về trang chủ
    </a>
</div>

</body>
</html>