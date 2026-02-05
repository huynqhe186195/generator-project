<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<c:set var="currentUser" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><s:title default="IT Dashboard" /> - GenCMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body { min-height: 100vh; display: flex; flex-direction: column; }
        .wrapper { display: flex; width: 100%; align-items: stretch; flex: 1; }

        #sidebar {
            min-width: 250px; max-width: 250px;
            background: #2c3e50; color: #fff; transition: all 0.3s;
        }
        #sidebar .sidebar-header { padding: 20px; background: #1a252f; }
        #sidebar ul.components { padding: 20px 0; border-bottom: 1px solid #47748b; }
        #sidebar ul li a {
            padding: 15px; font-size: 1.05em;
            display: block; color: #fff; text-decoration: none;
        }
        #sidebar ul li a:hover, #sidebar ul li.active > a {
            background: #34495e; border-left: 4px solid #3498db;
        }

        #content { width: 100%; padding: 20px; background-color: #f8f9fa; }
    </style>

    <s:head />
</head>

<body>

<!-- NAVBAR TOP -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/it/product-model/product-model-list">
        GenCMS - IT
    </a>

    <div class="ms-auto d-flex align-items-center text-white">
        <span class="me-3">
            Xin chào, <strong>${currentUser.fullName}</strong>
        </span>
        <a href="${pageContext.request.contextPath}/account/logout" class="btn btn-outline-light btn-sm">
            Đăng xuất
        </a>
    </div>
</nav>

<div class="wrapper">

    <!-- SIDEBAR -->
    <nav id="sidebar">
        <div class="sidebar-header">
            <h3><i class="fa fa-screwdriver-wrench"></i> IT</h3>
        </div>

        <ul class="list-unstyled components">

            <!-- Product Model -->
            <c:if test="${currentUser.roleId == 6 || currentUser.roleId == 1
                         || currentUser.hasPermission('PRODUCT_MODEL_VIEW')
                         || currentUser.hasPermission('PRODUCT_MODEL_MANAGE')}">
                <li class="${pageContext.request.requestURI.contains('/it/product-model') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/it/product-model/product-model-list">
                        <i class="fa fa-cubes me-2"></i> Product Model
                    </a>
                </li>
            </c:if>

            <!-- CMS -->
            <c:if test="${currentUser.roleId == 6 || currentUser.hasPermission('CMS_MANAGE')}">
                <li class="${pageContext.request.requestURI.contains('/it/cms') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/it/cms/post-list">
                        <i class="fa fa-newspaper me-2"></i> CMS
                    </a>
                </li>
            </c:if>

            <!-- Banner -->
            <c:if test="${currentUser.roleId == 6 || currentUser.hasPermission('BANNER_MANAGE')}">
                <li class="${pageContext.request.requestURI.contains('/it/banner') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/it/banner/banner-list">
                        <i class="fa fa-image me-2"></i> Banner
                    </a>
                </li>
            </c:if>

            <!-- Profile -->
            <li class="${pageContext.request.requestURI.contains('/it/it-profile') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/it/it-profile">
                    <i class="fa fa-id-card me-2"></i> Hồ sơ cá nhân
                </a>
            </li>

        </ul>
    </nav>

    <!-- CONTENT -->
    <div id="content">
        <s:body />
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
