<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
            flex: 1;
        }

        #sidebar {
            min-width: 290px;
            max-width: 290px;
            background: #2c3e50;
            color: #fff;
            transition: all 0.3s;
            overflow-y: auto;
        }

        #sidebar ul.components {
            padding: 20px 0;
            border-bottom: 1px solid #47748b;
        }

        #sidebar ul li > a,
        #sidebar ul li > button {
            padding: 15px;
            font-size: 1.05em;
            display: block;
            color: #fff;
            text-decoration: none;
            width: 100%;
            text-align: left;
            border: 0;
            background: transparent;
            white-space: normal;
            line-height: 1.45;
        }

        #sidebar ul li > a:hover,
        #sidebar ul li > button:hover,
        #sidebar ul li.active > a,
        #sidebar ul li.active > button {
            background: #34495e;
            border-left: 4px solid #3498db;
        }

        .sidebar-parent-toggle {
            display: flex !important;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .sidebar-parent-toggle .caret-icon {
            transition: transform 0.18s ease;
            font-size: 0.9rem;
        }

        .sidebar-parent-toggle[aria-expanded="true"] .caret-icon {
            transform: rotate(180deg);
        }

        .sidebar-submenu {
            background: rgba(0, 0, 0, 0.14);
            padding: 6px 0 10px;
        }

        .sidebar-submenu a {
            display: block;
            width: 100%;
            padding: 10px 20px 10px 38px !important;
            font-size: 0.95rem !important;
            line-height: 1.45;
            color: #dbe7f3 !important;
            white-space: normal;
            word-break: break-word;
        }

        .sidebar-submenu a:hover,
        .sidebar-submenu a.active {
            background: #243342;
            border-left: 4px solid #60a5fa;
            color: #fff !important;
        }

        #content {
            width: 100%;
            padding: 20px;
            background-color: #f8f9fa;
        }
    </style>

    <s:head />
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
        <a class="navbar-brand" href="#">GenCMS - Manager</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3">Xin chào, <strong>${sessionScope.USERMODEL.fullName}</strong></span>
            <a href="${pageContext.request.contextPath}/account/logout" class="btn btn-outline-light btn-sm">Đăng xuất</a>
        </div>
    </nav>

    <div class="wrapper">
        <nav id="sidebar">
            <ul class="list-unstyled components">
                <li class="${pageContext.request.requestURI.endsWith('/manager/home.jsp') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/manager/home"><i class="fa fa-tachometer-alt me-2"></i> Tổng quan</a>
                </li>
                <li class="${pageContext.request.requestURI.contains('contract') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/manager/contracts"><i class="fa fa-file-contract me-2"></i> Hợp đồng</a>
                </li>
                <li class="${pageContext.request.requestURI.contains('/manager/requests') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/manager/requests"><i class="fa fa-paper-plane me-2"></i> Gửi Yêu cầu</a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/manager/assets"><i class="fa fa-server me-2"></i> Tài sản Khách hàng</a>
                </li>

                <li class="${pageContext.request.requestURI.contains('/manager/technician-capability') ? 'active' : ''}">
                    <button class="sidebar-parent-toggle" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarTechnicianList" aria-expanded="${pageContext.request.requestURI.contains('/manager/technician-capability') ? 'true' : 'false'}" aria-controls="sidebarTechnicianList">
                        <span><i class="fa fa-user-gear me-2"></i> Quản lý kỹ thuật viên</span>
                        <i class="fa fa-chevron-down caret-icon"></i>
                    </button>
                    <div id="sidebarTechnicianList" class="collapse ${pageContext.request.requestURI.contains('/manager/technician-capability') ? 'show' : ''}">
                        <div class="sidebar-submenu">
                            <a class="${empty param.section || param.section == 'technicians' ? 'active' : ''}" href="${pageContext.request.contextPath}/manager/technician-capability?section=technicians">
                                <i class="fa fa-list me-2"></i> Quản lý danh sách kỹ thuật viên
                            </a>
                            <a class="${param.section == 'catalog' ? 'active' : ''}" href="${pageContext.request.contextPath}/manager/technician-capability?section=catalog">
                                <i class="fa fa-book me-2"></i> Quản lý danh sách kỹ năng
                            </a>
                        </div>
                    </div>
                </li>

                <li class="${pageContext.request.requestURI.contains('system-report') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/manager/system-report"><i class="fa fa-chart-line me-2"></i> Báo cáo</a>
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
