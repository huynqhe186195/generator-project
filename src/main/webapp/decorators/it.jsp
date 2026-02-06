<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="dec" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<c:set var="currentUser" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><dec:title default="IT Home" /> - GEN-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/template/admin/css/admin-style.css'/>">

    <style>
        #wrapper { overflow-x: hidden; transition: all 0.3s; }
        #sidebar-wrapper { min-height: 100vh; margin-left: -15rem; transition: margin 0.25s ease-out; }
        #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
        #page-content-wrapper { width: 100%; transition: all 0.3s; }

        @media (min-width: 768px) {
            #sidebar-wrapper { margin-left: 0; }
            #page-content-wrapper { min-width: 0; width: 100%; }
            #wrapper.toggled #sidebar-wrapper { margin-left: -15rem; }
        }

        /* nice hover */
        #sidebar-wrapper .list-group-item:hover { background: rgba(255,255,255,0.08) !important; }
    </style>

    <dec:head />
</head>
<body>

<div class="d-flex" id="wrapper">

    <!-- Sidebar -->
    <div class="border-end bg-dark text-white" id="sidebar-wrapper" style="width: 250px;">

        <!-- IT Console quay về IT HOME -->
        <a href="<c:url value='/it/home'/>"
           class="text-center py-4 fs-4 fw-bold text-warning border-bottom border-secondary d-block text-decoration-none">
            <i class="fas fa-screwdriver-wrench"></i> IT Console
        </a>

        <div class="list-group list-group-flush">

            <!-- Home -->
            <a href="<c:url value='/it/home'/>"
               class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-house me-2" style="width: 20px;"></i> Trang chủ
            </a>

            <!-- Products -->
            <a href="<c:url value='/it/products'/>"
               class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-box-open me-2" style="width: 20px;"></i> Quản lý máy
            </a>

            <!-- ✅ Brands -->
            <a href="<c:url value='/it/brands'/>"
               class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-copyright me-2" style="width: 20px;"></i> Quản lý brand
            </a>

            <!-- ✅ Quản lý danh mục (category) -->
            <a href="<c:url value='/it/categories'/>"
               class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-tags me-2" style="width: 20px;"></i> Quản lý danh mục
            </a>

        </div>
    </div>

    <!-- Page content -->
    <div id="page-content-wrapper">

        <!-- Topbar -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-4">
            <button class="btn btn-outline-secondary" id="sidebarToggle" type="button">
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
        const sidebarToggle = document.querySelector('#sidebarToggle');
        if (sidebarToggle) {
            sidebarToggle.addEventListener('click', (e) => {
                e.preventDefault();
                document.querySelector('#wrapper').classList.toggle('toggled');
            });
        }
    });
</script>

</body>
</html>
