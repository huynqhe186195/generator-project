<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.opensymphony.com/sitemesh/decorator" %>

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
        #sidebar { min-width: 260px; max-width: 260px; background: #243447; color: #fff; transition: all 0.3s; }
        #sidebar .sidebar-header { padding: 20px; background: #1b2735; }
        #sidebar ul.components { padding: 16px 0; border-bottom: 1px solid #3b546b; }
        #sidebar ul li a { padding: 14px 18px; font-size: 1.05em; display: block; color: #fff; text-decoration: none; }
        #sidebar ul li a:hover, #sidebar ul li.active > a { background: #2f445a; border-left: 4px solid #0dcaf0; }
        #content { width: 100%; padding: 20px; background-color: #f8f9fa; }
        .badge-role { background: rgba(13,202,240,.2); color: #0dcaf0; border: 1px solid rgba(13,202,240,.35); }
    </style>

    <s:head />
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/it/home">GenCMS - IT</a>

    <div class="ms-auto d-flex align-items-center text-white">
        <span class="me-2 badge badge-role px-2 py-1 rounded">IT</span>
        <span class="me-3">
            Xin chào, <strong>${sessionScope.USERMODEL.fullName}</strong>
        </span>
        <a href="${pageContext.request.contextPath}/account/logout" class="btn btn-outline-light btn-sm">
            Đăng xuất
        </a>
    </div>
</nav>

<div class="wrapper">
    <nav id="sidebar">
        <div class="sidebar-header">
            <h3 class="m-0"><i class="fa fa-screwdriver-wrench"></i> IT Console</h3>
        </div>

        <ul class="list-unstyled components">
            <li class="${pageContext.request.requestURI.contains('/it/home') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/it/home">
                    <i class="fa fa-gauge-high me-2"></i> Tổng quan
                </a>
            </li>

            <li class="${pageContext.request.requestURI.contains('/it/products') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/it/products">
                    <i class="fa fa-box-open me-2"></i> Sản phẩm (CRUD)
                </a>
            </li>

            <li class="${pageContext.request.requestURI.contains('/it/categories') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/it/categories">
                    <i class="fa fa-tags me-2"></i> Danh mục
                </a>
            </li>

            <li class="${pageContext.request.requestURI.contains('/it/users') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/it/users">
                    <i class="fa fa-users-gear me-2"></i> Người dùng
                </a>
            </li>

            <li class="${pageContext.request.requestURI.contains('/it/settings') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/it/settings">
                    <i class="fa fa-gear me-2"></i> Cấu hình
                </a>
            </li>
        </ul>
    </nav>

    <div id="content">
        <s:body />
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>