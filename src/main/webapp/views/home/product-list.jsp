<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Máy phát điện | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

    <style>
        :root { --primary: #4e73df; --secondary: #224abe; }

        html, body { height: 100%; }

        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fc;
            padding-top: 78px;
        }

        main { flex: 1; }

        .navbar-landing {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 15px 0;
            box-shadow: 0 4px 15px rgba(0,0,0,.1);
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 1.5rem;
            color: #fff !important;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary), #36b9cc);
            padding: 80px 0 100px;
            color: white;
            border-bottom-left-radius: 50px;
            border-bottom-right-radius: 50px;
            margin-bottom: -60px;
        }

        .main-card {
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,.1);
            background: white;
            overflow: hidden;
        }

        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,.15);
            background: #f1f1f1; /* fallback */
        }

        .table thead th {
            background-color: #f8f9fc;
            font-weight: 700;
            font-size: .85rem;
            text-transform: uppercase;
            color: #5a5c69;
        }

        footer {
            background: #1a1a1a;
            color: #888;
            padding: 40px 0;
            margin-top: auto;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-landing fixed-top">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>">
            <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
        </a>
    </div>
</nav>

<header class="page-header text-center">
    <div class="container" data-aos="fade-down">
        <h1 class="fw-bold mb-3">Quản lý Máy phát điện</h1>
        <p class="opacity-75 fs-5">Danh sách thiết bị & báo lỗi nhanh</p>
    </div>
</header>

<main>
    <div class="container mb-5" data-aos="fade-up">
        <div class="main-card p-4">

            <!-- HEADER + FILTER -->
            <div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-3">
                <div>
                    <h5 class="fw-bold text-primary m-0">
                        <i class="fas fa-list me-2"></i>Danh sách thiết bị
                    </h5>
                    <div class="text-muted small mt-1">
                        Lọc theo Brand / Công suất / Fuel type hoặc tìm theo tên máy
                    </div>
                </div>

                <!-- FILTER FORM -->
                <form class="row g-2 align-items-center" method="get" action="<c:url value='/product-list'/>">

                    <!-- Keyword -->
                    <div class="col-auto">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text"
                                   name="keyword"
                                   class="form-control bg-light border-0"
                                   placeholder="Tìm theo tên máy..."
                                   value="${keyword != null ? keyword : ''}">
                        </div>
                    </div>

                    <!-- Brand -->
                    <div class="col-auto">
                        <select class="form-select" name="brandId">
                            <option value="">-- Brand --</option>
                            <c:forEach items="${brands}" var="b">
                                <option value="${b.id}" ${brandId != null && brandId == b.id ? 'selected' : ''}>
                                        ${b.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Fuel type -->
                    <div class="col-auto">
                        <select class="form-select" name="fuelType">
                            <option value="">-- Fuel --</option>
                            <option value="DIESEL" ${fuelType == 'DIESEL' ? 'selected' : ''}>Diesel</option>
                            <option value="GASOLINE" ${fuelType == 'GASOLINE' ? 'selected' : ''}>Gasoline</option>
                        </select>
                    </div>

                    <!-- Min Power -->
                    <div class="col-auto">
                        <input type="number" step="0.1" class="form-control" name="minPower"
                               placeholder="Min kVA"
                               value="${minPower != null ? minPower : ''}">
                    </div>

                    <!-- Max Power -->
                    <div class="col-auto">
                        <input type="number" step="0.1" class="form-control" name="maxPower"
                               placeholder="Max kVA"
                               value="${maxPower != null ? maxPower : ''}">
                    </div>

                    <!-- Buttons -->
                    <div class="col-auto d-flex gap-2">
                        <button type="submit" class="btn btn-primary rounded-pill px-3">
                            <i class="fas fa-filter me-1"></i>Lọc
                        </button>
                        <a class="btn btn-outline-secondary rounded-pill px-3" href="<c:url value='/product-list'/>">
                            Xóa lọc
                        </a>
                    </div>

                </form>
            </div>

            <!-- TABLE -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th class="ps-3">Hình ảnh</th>
                        <th>Thông tin máy</th>
                        <th>Công suất</th>
                        <th>Fuel type</th>
                        <th class="text-end pe-3">Báo lỗi</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach items="${products}" var="p">
                        <tr>
                            <!-- Image (URL/local/default) -->
                            <td class="ps-3">
                                <c:choose>
                                    <c:when test="${not empty p.imageUrl and p.imageUrl.startsWith('http')}">
                                        <img src="${p.imageUrl}" class="product-img" alt="Generator">
                                    </c:when>

                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="<c:url value='/${p.imageUrl}'/>" class="product-img" alt="Generator">
                                    </c:when>

                                    <c:otherwise>
                                        <img src="<c:url value='/assets/img/default-generator.png'/>" class="product-img" alt="No image">
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- NAME + BRAND + MODEL -->
                            <td>
                                <div class="fw-bold text-dark">${p.name}</div>
                                <div class="text-muted small">
                                    <span class="fw-semibold">${p.brand.name}</span>
                                    &nbsp;•&nbsp;
                                    <span>${p.model}</span>
                                </div>
                            </td>

                            <!-- Power -->
                            <td>
                                <strong>${p.powerPrime}</strong>
                                <span class="text-muted small">kVA</span>
                            </td>

                            <!-- Fuel type -->
                            <td>
                                <c:choose>
                                    <c:when test="${p.fuelType == 'DIESEL'}">
                                        <span class="badge bg-warning text-dark">Diesel</span>
                                    </c:when>
                                    <c:when test="${p.fuelType == 'GASOLINE'}">
                                        <span class="badge bg-info text-dark">Gasoline</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${p.fuelType}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Report -->
                            <td class="text-end pe-3">
                                <form action="<c:url value='/product/report-error'/>" method="post">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="btn btn-sm btn-danger rounded-pill px-3">
                                        <i class="fas fa-triangle-exclamation me-1"></i>
                                        Báo lỗi
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">
                                <i class="fas fa-box-open fa-3x mb-3 opacity-50"></i>
                                <p class="mb-1">Không có máy phù hợp bộ lọc.</p>
                                <small>Hãy thử bỏ bớt điều kiện lọc hoặc nhấn “Xóa lọc”.</small>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</main>

<footer>
    <div class="container text-center">
        <p class="small mb-0">
            &copy; 2024 Gen-CMS Corporation. Hệ thống quản lý năng lượng.
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    AOS.init({ duration: 800, once: true });
</script>

</body>
</html>
