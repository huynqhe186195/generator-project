<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="dec" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<c:set var="currentUser" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><dec:title default="IT Dashboard" /> - GEN-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- dùng chung css admin để giống admin -->
    <link rel="stylesheet" href="<c:url value='/template/admin/css/admin-style.css'/>">

    <style>
        #wrapper { overflow-x: hidden; transition: all 0.3s; }
        #sidebar-wrapper { min-height: 100vh; margin-left: -15rem; transition: margin 0.25s ease-out; }
        #sidebar-wrapper .sidebar-heading { padding: 0.875rem 1.25rem; font-size: 1.2rem; }
        #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
        #page-content-wrapper { width: 100%; transition: all 0.3s; }

        @media (min-width: 768px) {
            #sidebar-wrapper { margin-left: 0; }
            #page-content-wrapper { min-width: 0; width: 100%; }
            #wrapper.toggled #sidebar-wrapper { margin-left: -15rem; }
        }
    </style>

    <dec:head />
</head>
<body>

<div class="d-flex" id="wrapper">

    <!-- Sidebar -->
    <div class="border-end bg-dark text-white" id="sidebar-wrapper" style="width: 250px;">
        <div class="sidebar-heading text-center py-4 fs-4 fw-bold text-warning border-bottom border-secondary">
            <i class="fas fa-screwdriver-wrench"></i> IT Console
        </div>

        <div class="list-group list-group-flush">
            <!-- Tạm thời chỉ quản lý sản phẩm -->
            <a href="<c:url value='/it/products'/>"
               class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-box-open me-2" style="width: 20px;"></i> Quản lý sản phẩm
            </a>
        </div>
    </div>

    <!-- Page content -->
    <div id="page-content-wrapper">

        <!-- Topbar -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-4">
            <button class="btn btn-outline-secondary" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>

            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle fw-bold" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>
                            ${currentUser.fullName != null ? currentUser.fullName : 'IT'}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item text-danger" href="<c:url value='/account/logout'/>">
                                    <i class="fas fa-sign-out-alt me-1"></i> Đăng xuất
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Body -->
        <div class="container-fluid px-4 py-4">
            <dec:body />
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.addEventListener('DOMContentLoaded', () => {
        const sidebarToggle = document.body.querySelector('#sidebarToggle');
        if (sidebarToggle) {
            sidebarToggle.addEventListener('click', (event) => {
                event.preventDefault();
                document.body.querySelector('#wrapper').classList.toggle('toggled');
            });
        }
    });
</script>

</body>
</html>
