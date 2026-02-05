<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.opensymphony.com/sitemesh/decorator" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><s:title default="Manager Dashboard" /> - GenCMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body { min-height: 100vh; display: flex; flex-direction: column; }
        .wrapper { display: flex; width: 100%; align-items: stretch; flex: 1; }
        #sidebar { min-width: 250px; max-width: 250px; background: #2c3e50; color: #fff; transition: all 0.3s; }
        #sidebar .sidebar-header { padding: 20px; background: #1a252f; }
        #sidebar ul.components { padding: 20px 0; border-bottom: 1px solid #47748b; }
        #sidebar ul li a { padding: 15px; font-size: 1.1em; display: block; color: #fff; text-decoration: none; }
        #sidebar ul li a:hover, #sidebar ul li.active > a { background: #34495e; border-left: 4px solid #3498db; }
        #content { width: 100%; padding: 20px; background-color: #f8f9fa; }
    </style>

    <s:head />
</head>
<body>

<<<<<<< HEAD
<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
    <a class="navbar-brand" href="#">GenCMS - Manager</a>
    <div class="ms-auto d-flex align-items-center text-white">
        <span class="me-3">Xin chào, <strong>${sessionScope.USERMODEL.fullName}</strong></span>
        <a href="${pageContext.request.contextPath}/account/logout" class="btn btn-outline-light btn-sm">Đăng xuất</a>
    </div>
</nav>

<div class="wrapper">
    <nav id="sidebar">
        <div class="sidebar-header">
            <h3><i class="fa fa-cogs"></i> Quản lý</h3>
=======
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
        <a class="navbar-brand" href="#">GenCMS - Manager</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3">Xin chào, <strong>${sessionScope.USERMODEL.fullName}</strong></span>
            <a href="${pageContext.request.contextPath}/account/logout" class="btn btn-outline-light btn-sm">Đăng xuất</a>
>>>>>>> main
        </div>

        <ul class="list-unstyled components">
            <li class="${pageContext.request.requestURI.endsWith('/manager/home.jsp') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/manager/home">
                    <i class="fa fa-tachometer-alt me-2"></i> Tổng quan
                </a>
            </li>

            <li class="${pageContext.request.requestURI.contains('contract') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/manager/contracts">
                    <i class="fa fa-file-contract me-2"></i> Hợp đồng
                </a>
            </li>

            <li class="${pageContext.request.requestURI.contains('/manager/requests') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/manager/requests">
                    <i class="fa fa-paper-plane me-2"></i> Gửi Yêu cầu (Admin)
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/manager/assets">
                    <i class="fa fa-server me-2"></i> Tài sản Khách hàng
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/manager/reports">
                    <i class="fa fa-chart-line me-2"></i> Báo cáo
                </a>
            </li>
        </ul>
    </nav>

<<<<<<< HEAD
    <div id="content">
        <s:body />
=======
    <div class="wrapper">
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3><i class="fa fa-cogs"></i> Quản lý</h3>
            </div>

            <ul class="list-unstyled components">
                <li class="${pageContext.request.requestURI.endsWith('/manager/home.jsp') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/manager/home">
                        <i class="fa fa-tachometer-alt me-2"></i> Tổng quan
                    </a>
                </li>

                <li class="${pageContext.request.requestURI.contains('contract') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/manager/contracts">
                        <i class="fa fa-file-contract me-2"></i> Hợp đồng
                    </a>
                </li>

                <li class="${pageContext.request.requestURI.contains('/manager/requests') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/manager/requests">
                        <i class="fa fa-paper-plane me-2"></i> Gửi Yêu cầu (Admin)
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/manager/assets">
                        <i class="fa fa-server me-2"></i> Tài sản Khách hàng
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/manager/reports">
                        <i class="fa fa-chart-line me-2"></i> Báo cáo
                    </a>
                </li>
            </ul>
        </nav>

        <div id="content">
            <s:body />
        </div>
>>>>>>> main
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>