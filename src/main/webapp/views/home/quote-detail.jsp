<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Báo giá #QUOTE-${quote.id} | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root{
            --primary:#4e73df;
            --secondary:#224abe;
            --ink:#101828;
            --muted:#667085;
            --bg:#f6f7fb;
        }

        html, body { height: 100%; }
        body{
            min-height: 100vh;
            display:flex;
            flex-direction:column;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: var(--bg);
            color: var(--ink);
            overflow-x:hidden;
        }

        /* NAVBAR */
        .navbar-landing{
            position: sticky;
            top: 0;
            z-index: 1050;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 14px 0;
            box-shadow: 0 10px 25px rgba(0,0,0,.08);
        }
        .navbar-brand{
            font-weight: 900;
            letter-spacing: .2px;
            font-size: 1.6rem;
            color:#fff !important;
        }
        .nav-link{
            color: rgba(255,255,255,.92) !important;
            font-weight: 600;
            transition: .2s;
        }
        .nav-link:hover{ opacity: .9; transform: translateY(-1px); }

        .btn-white{
            background:#fff;
            color: var(--primary);
            font-weight: 800;
            border-radius: 999px;
            padding: 10px 22px;
            border: none;
            transition: .2s;
            text-decoration:none;
            display:inline-block;
            box-shadow: 0 10px 20px rgba(0,0,0,.10);
        }
        .btn-white:hover{
            transform: translateY(-1px);
            box-shadow: 0 14px 26px rgba(0,0,0,.14);
            color: var(--secondary);
        }

        .user-dropdown-toggle{
            background: rgba(255,255,255,.16);
            color: #fff !important;
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 999px;
            padding: 8px 14px !important;
        }

        /* MAIN & CARDS */
        main{ flex:1; padding: 40px 0 60px; }

        .card-custom {
            border-radius: 16px;
            border: none;
            box-shadow: 0 8px 24px rgba(16,24,40,.06);
            overflow: hidden;
            background: #fff;
        }
        .card-header-soft {
            background: #f8fafc;
            border-bottom: 1px solid #eaecf0;
            padding: 16px 20px;
            font-weight: bold;
            color: var(--primary);
        }
        .total-box {
            background: #fffcf5;
            border: 1px dashed #f5c066;
            border-radius: 12px;
            padding: 20px;
        }

        /* TABLE */
        .table thead th{
            background: #f8fafc;
            font-weight: 900;
            font-size: .85rem;
            letter-spacing: .5px;
            text-transform: uppercase;
            color: #475467;
            border-bottom: 1px solid #eaecf0;
        }
        .table td{ border-color:#f1f3f6; }
        .table-hover tbody tr:hover{ background: #fafbff; }

        .btn-pill{
            border-radius: 999px;
            font-weight: 700;
        }

        /* FOOTER */
        footer{
            margin-top:auto;
            background:#111827;
            color:#9ca3af;
            padding: 26px 0;
        }
        footer a{ color:#fff; }
        footer a:hover{ opacity:.9; }
    </style>
</head>

<body>

<%-- HEADER CHUNG --%>
<nav class="navbar navbar-expand-lg navbar-landing" id="mainNav">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>">
            <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link px-3" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công ty</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-pill px-3" href="<c:url value='/news'/>">Tin tức</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-pill px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
                </li>

                <c:if test="${not empty user}">
                    <li class="nav-item">
                        <a class="nav-link px-3" href="<c:url value='/views/home/Support.jsp'/>">Chăm sóc khách hàng</a>
                    </li>
                </c:if>

                <c:choose>
                    <c:when test="${empty user}">
                        <li class="nav-item ms-lg-3">
                            <a href="<c:url value='/account/login'/>" class="btn btn-white">Đăng nhập</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown ms-lg-3">
                            <a class="nav-link dropdown-toggle user-dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i> ${user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-3">
                                <li>
                                    <a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>">
                                        <i class="fas fa-id-card me-2"></i>Hồ sơ
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="<c:url value='/account/hanldeChangePassword'/>">
                                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger fw-bold" href="<c:url value='/account/logout'/>">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<%-- MAIN CONTENT --%>
<main>
    <div class="container">

        <%-- Header Tiêu đề & Nút Quay lại --%>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-primary mb-1"><i class="fas fa-file-invoice-dollar me-2"></i>Chi tiết Báo giá</h3>
                <p class="text-muted mb-0">Mã tham chiếu: <span class="fw-bold text-dark font-monospace">#QUOTE-${quote.id}</span></p>
            </div>
            <a href="javascript:history.back()" class="btn btn-outline-secondary btn-pill px-4">
                <i class="fas fa-arrow-left me-2"></i>Quay lại lịch sử
            </a>
        </div>

        <div class="row g-4">
            <%-- CỘT TRÁI: BẢNG CHI TIẾT VẬT TƯ --%>
            <div class="col-lg-8">
                <div class="card-custom mb-4">
                    <div class="card-header-soft">
                        <i class="fas fa-tools me-2"></i>Hạng mục sửa chữa & Vật tư
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-4">Mô tả / Tên vật tư</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="pe-4 text-end">Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty quoteDetails}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5 text-muted">
                                            <i class="fas fa-box-open fa-2x mb-2 opacity-25"></i>
                                            <p class="mb-0">Không có chi tiết vật tư nào.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${quoteDetails}" var="detail">
                                        <tr>
                                            <td class="ps-4 fw-bold text-dark">${detail.description}</td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border px-3">${detail.quantity}</span>
                                            </td>
                                            <td class="text-end text-muted">
                                                <fmt:formatNumber value="${detail.unitPrice}" pattern="#,###" /> đ
                                            </td>
                                            <td class="pe-4 text-end fw-bold text-primary">
                                                <fmt:formatNumber value="${detail.totalPrice}" pattern="#,###" /> đ
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- CỘT PHẢI: THÔNG TIN TỔNG QUAN --%>
            <div class="col-lg-4">
                <div class="card-custom position-sticky" style="top: 90px;">
                    <div class="card-header-soft text-center">
                        <i class="fas fa-info-circle me-2"></i>Tổng quan báo giá
                    </div>
                    <div class="card-body p-4">

                        <div class="mb-3 d-flex justify-content-between align-items-center">
                            <span class="text-muted small fw-bold">Trạng thái:</span>
                            <c:choose>
                                <c:when test="${quote.status == 'APPROVED'}">
                                    <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2">Khách đã đồng ý</span>
                                </c:when>
                                <c:when test="${quote.status == 'REJECTED'}">
                                    <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-2">Khách đã từ chối</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3 py-2">${quote.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <hr class="text-muted opacity-25">

                        <div class="mb-3">
                            <p class="text-muted small mb-1"><i class="fas fa-check-double me-1"></i>Ngày duyệt/xác nhận:</p>
                            <p class="fw-bold text-dark mb-0">
                                <c:choose>
                                    <c:when test="${not empty quote.approvedAt}">
                                        <fmt:formatDate value="${quote.approvedAt}" pattern="dd/MM/yyyy HH:mm" timeZone="Asia/Ho_Chi_Minh" />
                                    </c:when>
                                    <c:otherwise><span class="fst-italic text-muted">Chưa duyệt</span></c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <hr class="my-4 border-secondary opacity-25">

                        <div class="total-box mb-2">
                            <div class="text-center text-uppercase fw-bold text-muted small mb-2">Tổng chi phí sửa chữa</div>
                            <h2 class="fw-bold text-danger text-center mb-0">
                                <fmt:formatNumber value="${quote.totalAmount}" pattern="#,###" /> VNĐ
                            </h2>
                        </div>

                    </div>
                </div>
            </div>
        </div>

    </div>
</main>

<%-- FOOTER CHUNG --%>
<footer>
    <div class="container">
        <div class="row gy-3 align-items-center">
            <div class="col-lg-6 text-center text-lg-start">
                <a href="#" class="text-decoration-none fw-bold fs-5">
                    <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
                </a>
                <div class="small mt-2">Giải pháp số hóa hệ thống năng lượng dự phòng.</div>
            </div>
            <div class="col-lg-6 text-center text-lg-end">
                <div class="small">&copy; 2024 Gen-CMS Corporation. Bảo lưu mọi quyền.</div>
                <div class="mt-2">
                    <a href="#" class="me-3"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-linkedin"></i></a>
                    <a href="#"><i class="fas fa-envelope"></i></a>
                </div>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>