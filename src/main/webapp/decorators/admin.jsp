<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="dec" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><dec:title default="Admin Dashboard" /></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="<c:url value='/template/admin/css/admin-style.css'/>">

    <dec:head />
</head>
<body>

<div class="d-flex" id="wrapper">
    <div class="border-end bg-dark text-white" id="sidebar-wrapper" style="width: 250px; min-height: 100vh;">
        <div class="sidebar-heading text-center py-4 fs-4 fw-bold text-warning border-bottom border-secondary">
            <i class="fas fa-bolt"></i> GEN-CMS
        </div>
        <div class="list-group list-group-flush">
            <a href="<c:url value='/admin/dashboard'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-tachometer-alt me-2"></i> Home
            </a>
            <a href="<c:url value='/admin/user-list'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                 <i class="fas fa-tachometer-alt me-2"></i> User List
            </a>
            <a href="<c:url value='/admin/generator-list'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-server me-2"></i> Generator List
            </a>
             <a href="<c:url value='/admin/admin-profile'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-user me-2"></i> My Profile
            </a>
            <a href="<c:url value='/admin/role-list'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-user me-2"></i> Role list
            </a>
        </div>
    </div>

    <div id="page-content-wrapper" style="width: 100%;">
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-4">
            <button class="btn btn-outline-secondary" id="sidebarToggle"><i class="fas fa-bars"></i></button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle fw-bold" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            Admin Huy
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="<c:url value='/profile'/>">Hồ sơ</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="#">Đăng xuất</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>

        <div class="container-fluid px-4 py-4">
            <dec:body />
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>