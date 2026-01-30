<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="dec" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><dec:title default="Technical Dashboard"/></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .sidebar {
            width: 230px;
            min-height: 100vh;
            background: #212529;
        }
        .sidebar a {
            color: #ddd;
            text-decoration: none;
        }
        .sidebar a:hover {
            background: #343a40;
        }
    </style>

    <dec:head/>
</head>
<body>

<div class="d-flex">
    <div class="sidebar p-3">
        <h5 class="text-warning text-center mb-4">
            <i class="fas fa-tools"></i> TECHNICAL
        </h5>

        <!-- Công việc của tôi -->
        <a class="d-block p-2 rounded mb-2"
           href="${pageContext.request.contextPath}/technical/my-tasks">
            <i class="fas fa-list me-2"></i> My Tasks
        </a>

        <!-- Kho vật tư -->
        <a class="d-block p-2 rounded mb-2"
           href="${pageContext.request.contextPath}/technical/materials">
            <i class="fas fa-warehouse me-2"></i> Kho vật tư
        </a>

        <!-- Hồ sơ cá nhân -->
        <a class="d-block p-2 rounded mb-2"
           href="${pageContext.request.contextPath}/technical/profile">
            <i class="fas fa-user me-2"></i> Hồ sơ cá nhân
        </a>

        <hr class="text-secondary">

        <!-- Đăng xuất -->
        <a class="d-block p-2 rounded text-danger"
           href="${pageContext.request.contextPath}/account/logout">
            <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
        </a>
    </div>



    <div class="flex-grow-1 p-4">
        <dec:body/>
    </div>
</div>

</body>
</html>
