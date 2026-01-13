<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="dec" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<c:set var="currentUser" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><dec:title default="Admin Dashboard" /></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/template/admin/css/admin-style.css'/>">

    <style>
        #wrapper { overflow-x: hidden; transition: all 0.3s; }
        #sidebar-wrapper { min-height: 100vh; margin-left: -15rem; transition: margin 0.25s ease-out; }
        #sidebar-wrapper .sidebar-heading { padding: 0.875rem 1.25rem; font-size: 1.2rem; }
        #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
        #page-content-wrapper { width: 100%; transition: all 0.3s; }

        /* Khi màn hình to (Desktop) thì hiện sidebar mặc định */
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
    <div class="border-end bg-dark text-white" id="sidebar-wrapper" style="width: 250px;">
        <div class="sidebar-heading text-center py-4 fs-4 fw-bold text-warning border-bottom border-secondary">
            <i class="fas fa-bolt"></i> GEN-CMS
        </div>

        <div class="list-group list-group-flush">


            <c:if test="${currentUser.roleId == 2}">
                <a href="<c:url value='/admin/dashboard'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                    <i class="fas fa-tachometer-alt me-2" style="width: 20px;"></i> Dashboard
                </a>
            </c:if>

            <c:if test="${currentUser.roleId == 1 || currentUser.hasPermission('USER_VIEW')}">
                <a href="<c:url value='/admin/user-list'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                     <i class="fas fa-users me-2" style="width: 20px;"></i> Quản lý User
                </a>
            </c:if>

            <c:if test="${currentUser.roleId == 1 || currentUser.hasPermission('ROLE_VIEW')}">
                <a href="<c:url value='/admin/role-list'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                    <i class="fas fa-user-shield me-2" style="width: 20px;"></i> Phân quyền (Role)
                </a>
            </c:if>

            <c:if test="${currentUser.roleId == 2}">
                <a href="<c:url value='/admin/generator-list'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                    <i class="fas fa-server me-2" style="width: 20px;"></i> Máy phát điện
                </a>
            </c:if>

             <a href="<c:url value='/admin/admin-profile'/>" class="list-group-item list-group-item-action bg-transparent text-white p-3">
                <i class="fas fa-id-card me-2" style="width: 20px;"></i> Hồ sơ cá nhân
            </a>
        </div>
    </div>
    <div id="page-content-wrapper">

        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-4">
            <button class="btn btn-outline-secondary" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle fw-bold" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>
                            ${currentUser.fullName != null ? currentUser.fullName : 'Admin'}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item text-danger" href="<c:url value='/logout'/>">
                                    <i class="fas fa-sign-out-alt me-1"></i> Đăng xuất
                                </a>
                            </li>
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

<script>
    window.addEventListener('DOMContentLoaded', event => {
        // Lấy cái nút 3 gạch
        const sidebarToggle = document.body.querySelector('#sidebarToggle');

        // Nếu tìm thấy nút
        if (sidebarToggle) {
            // Gắn sự kiện click
            sidebarToggle.addEventListener('click', event => {
                event.preventDefault();
                // Thêm/Bỏ class 'toggled' vào id="wrapper"
                document.body.querySelector('#wrapper').classList.toggle('toggled');
            });
        }
    });
</script>

</body>
</html>