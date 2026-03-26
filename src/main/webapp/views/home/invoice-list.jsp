<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tra cứu hợp đồng | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

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

        .hero-section{
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color:#fff;
            padding: 46px 0 88px;
            position:relative;
            overflow:hidden;
        }
        .hero-section .container{
            position:relative;
            z-index:1;
        }
        .hero-section:before{
            content:"";
            position:absolute;
            width:520px;height:520px;
            right:-220px; top:-220px;
            background: rgba(255,255,255,.12);
            border-radius: 50%;
        }
        .hero-section:after{
            content:"";
            position:absolute;
            width:420px;height:420px;
            left:-220px; bottom:-240px;
            background: rgba(255,255,255,.10);
            border-radius: 50%;
        }
        .hero-title{
            font-weight: 900;
            font-size: 2.5rem;
            line-height: 1.15;
            margin:0 0 10px;
        }
        .hero-desc{
            opacity:.92;
            margin:0;
            max-width: 760px;
            line-height: 1.7;
            padding-bottom: 28px;
        }

        main{ flex:1; padding: 18px 0 60px; }

        .main-card,
        .lookup-card{
            border-radius: 22px;
            background:#fff;
            box-shadow: 0 18px 40px rgba(16,24,40,.08);
            border: 1px solid rgba(16,24,40,.06);
        }

        .card-header-soft{
            padding: 18px 18px 12px;
            border-bottom: 1px solid rgba(16,24,40,.06);
            background: linear-gradient(180deg, rgba(78,115,223,.06), rgba(255,255,255,0));
        }

        .section-title{
            margin:0;
            font-weight: 900;
            color: var(--primary);
            display:flex;
            align-items:center;
            gap:10px;
        }
        .section-sub{
            margin:6px 0 0;
            color: var(--muted);
            font-size: .92rem;
        }

        .lookup-card{ padding: 24px; }
        .lookup-form{
            display:grid;
            grid-template-columns: minmax(0, 1fr) auto auto;
            gap: 12px;
            align-items:end;
        }
        .lookup-hint{
            background:#eef4ff;
            border:1px solid #dbe7ff;
            color:#224abe;
            border-radius:16px;
            padding:14px 16px;
            margin-top:16px;
        }
        .detail-grid{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            padding: 20px;
        }
        .detail-item{
            background:#f8fafc;
            border:1px solid #eaecf0;
            border-radius:18px;
            padding:16px;
        }
        .detail-item .label{
            color: var(--muted);
            font-size:.84rem;
            text-transform:uppercase;
            letter-spacing:.06em;
            margin-bottom:6px;
            font-weight:700;
        }
        .detail-item .value{
            font-weight:800;
            color:#0f172a;
            word-break:break-word;
        }

        .device-browser{
            display:grid;
            grid-template-columns: minmax(240px, 0.95fr) minmax(300px, 1.15fr) minmax(320px, 1.3fr);
            gap:20px;
        }
        .device-pane{
            background:#f8fafc;
            border:1px solid #e5e7eb;
            border-radius:20px;
            padding:18px;
            min-height: 100%;
        }
        .device-pane-head{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap:12px;
            margin-bottom:16px;
        }
        .device-pane-title{
            font-size:1rem;
            font-weight:900;
            color:#0f172a;
            margin:0;
        }
        .device-pane-sub{
            margin:4px 0 0;
            color:var(--muted);
            font-size:.85rem;
        }
        .device-count-badge{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            min-width:36px;
            height:36px;
            border-radius:999px;
            background:#e0e7ff;
            color:#3730a3;
            font-weight:900;
            padding:0 12px;
        }
        .device-model-list,
        .device-serial-list{
            display:grid;
            gap:12px;
        }
        .device-model-card,
        .device-serial-card{
            width:100%;
            border:1px solid #e5e7eb;
            border-radius:18px;
            background:#fff;
            padding:16px;
            text-align:left;
            transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease, background .18s ease;
            box-shadow: 0 10px 22px rgba(15,23,42,.05);
        }
        .device-model-card:hover,
        .device-serial-card:hover{
            transform: translateY(-2px);
            border-color: rgba(78,115,223,.28);
            box-shadow: 0 16px 28px rgba(15,23,42,.10);
        }
        .device-model-card.is-active,
        .device-serial-card.is-active{
            border-color: rgba(78,115,223,.45);
            background: linear-gradient(180deg, rgba(78,115,223,.10), rgba(255,255,255,.96));
            box-shadow: 0 20px 34px rgba(78,115,223,.14);
        }
        .device-model-card:focus-visible,
        .device-serial-card:focus-visible{
            outline: 3px solid rgba(78,115,223,.22);
            outline-offset: 3px;
        }
        .device-model-top,
        .device-serial-top{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap:12px;
        }
        .device-model-name,
        .device-serial-name{
            font-size:1rem;
            font-weight:900;
            color:#111827;
            margin:0;
        }
        .device-model-brand,
        .device-serial-meta,
        .device-empty-text{
            color:var(--muted);
            font-size:.88rem;
        }
        .device-qty-pill,
        .serial-pill{
            display:inline-flex;
            align-items:center;
            gap:8px;
            border-radius:999px;
            background:#eef2ff;
            color:#3730a3;
            padding:8px 14px;
            font-weight:800;
            font-size:.88rem;
        }
        .device-meta-list{
            display:grid;
            gap:10px;
            margin-top:14px;
        }
        .device-meta-row{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:16px;
            border-top:1px dashed #e5e7eb;
            padding-top:10px;
        }
        .device-meta-label{
            color:var(--muted);
            font-weight:700;
        }
        .device-meta-value{
            color:#0f172a;
            font-weight:800;
            text-align:right;
        }
        .device-detail-card{
            background:#fff;
            border:1px solid #e5e7eb;
            border-radius:18px;
            padding:20px;
            min-height:100%;
            box-shadow: 0 14px 30px rgba(15,23,42,.06);
        }
        .device-detail-hero{
            display:flex;
            flex-wrap:wrap;
            align-items:flex-start;
            justify-content:space-between;
            gap:14px;
            margin-bottom:18px;
        }
        .device-detail-title{
            font-size:1.2rem;
            font-weight:900;
            margin:0;
            color:#0f172a;
        }
        .device-detail-subtitle{
            margin:6px 0 0;
            color:var(--muted);
        }
        .device-detail-grid{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap:14px;
        }
        .device-detail-field{
            background:#f8fafc;
            border:1px solid #eaecf0;
            border-radius:16px;
            padding:14px;
        }
        .device-detail-field .label{
            color:var(--muted);
            font-size:.8rem;
            text-transform:uppercase;
            letter-spacing:.05em;
            margin-bottom:6px;
            font-weight:700;
        }
        .device-detail-field .value{
            color:#0f172a;
            font-weight:800;
            word-break:break-word;
        }
        .device-empty-state{
            display:grid;
            place-items:center;
            min-height:220px;
            text-align:center;
            color:var(--muted);
            border:1px dashed #d0d5dd;
            border-radius:18px;
            padding:24px;
            background:rgba(255,255,255,.75);
        }

        .btn-pill{
            border-radius: 999px;
            padding: 10px 16px;
            font-weight: 800;
        }

        .status-badge{
            border-radius:999px;
            padding:8px 12px;
            font-weight:800;
            display:inline-flex;
            align-items:center;
            gap:8px;
        }
        .detail-actions{
            display:flex;
            flex-wrap:wrap;
            gap:12px;
        }

        footer{
            margin-top:auto;
            background:#111827;
            color:#9ca3af;
            padding: 26px 0;
        }
        footer a{ color:#fff; }
        footer a:hover{ opacity:.9; }

        @media (max-width: 1200px){
            .device-browser{
                grid-template-columns: 1fr 1fr;
            }
            .device-pane.device-detail-pane{
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 992px){
            .lookup-form{ grid-template-columns: 1fr; }
            .hero-title{ font-size: 2rem; }
            .device-browser{ grid-template-columns: 1fr; }
            .device-pane.device-detail-pane{ grid-column: auto; }
        }
    </style>
</head>

<body>

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
                        <a class="nav-link px-3" href="<c:url value='/product-list'/>">Hợp đồng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link px-3" href="<c:url value='/invoice-list'/>">Hóa đơn</a>
                    </li>
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


<section class="hero-section">
    <div class="container" data-aos="fade-up">
        <h1 class="hero-title">Quản lý Hóa đơn</h1>
        <p class="hero-desc">
            Tra cứu lịch sử giao dịch, chi tiết các hóa đơn bảo trì và thực hiện thanh toán trực tuyến an toàn qua cổng VNPay.
        </p>
    </div>
</section>

<main class="container">
    <div class="lookup-card mb-4" data-aos="fade-up" data-aos-delay="100">
        <form action="<c:url value='/invoice-list'/>" method="get" class="lookup-form">
            <div>
                <label class="form-label fw-bold small text-uppercase">Tìm kiếm</label>
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" name="keyword" class="form-control border-start-0"
                           placeholder="Nhập mã hóa đơn..." value="${param.keyword}">
                </div>
            </div>
            <div>
                <label class="form-label fw-bold small text-uppercase">Trạng thái</label>
                <select name="status" class="form-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="UNPAID" ${param.status == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                    <option value="PAID" ${param.status == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-pill px-4">
                <i class="fas fa-filter me-2"></i>Lọc dữ liệu
            </button>
        </form>
    </div>

    <div class="main-card" data-aos="fade-up" data-aos-delay="200">
        <div class="card-header-soft d-flex justify-content-between align-items-center">
            <div>
                <h4 class="section-title"><i class="fas fa-file-invoice-dollar"></i> Danh sách hóa đơn</h4>
                <p class="section-sub">Hiển thị các hóa đơn mới nhất của bạn</p>
            </div>
            <span class="badge bg-primary-subtle text-primary rounded-pill px-3 py-2 fw-bold">
                Tổng số: ${fn:length(invoiceList)}
            </span>
        </div>

        <div class="table-responsive p-3">
            <table class="table table-hover align-middle border-light">
                <thead class="table-light">
                <tr>
                    <th class="ps-3">Mã hóa đơn</th>
                    <th>Ngày xuất</th>
                    <th>Hạn thanh toán</th>
                    <th class="text-end">Tổng tiền</th>
                    <th class="text-center">Trạng thái</th>
                    <th class="text-end pe-3">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty invoiceList}">
                        <c:forEach var="item" items="${invoiceList}">
                            <tr>
                                <td class="ps-3">
                                    <span class="fw-bold text-primary">${item.invoiceCode}</span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${item.issuedDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <fmt:formatDate value="${item.dueDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td class="text-end fw-bold">
                                    <fmt:formatNumber value="${item.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.paymentStatus == 'PAID'}">
                                                <span class="status-badge bg-success-subtle text-success">
                                                    <i class="fas fa-check-circle"></i> Đã thanh toán
                                                </span>
                                        </c:when>
                                        <c:when test="${item.paymentStatus == 'UNPAID'}">
                                                <span class="status-badge bg-warning-subtle text-warning-emphasis">
                                                    <i class="fas fa-clock"></i> Chờ thanh toán
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                                <span class="status-badge bg-secondary-subtle text-secondary">
                                                    <i class="fas fa-times-circle"></i> Đã hủy
                                                </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-3">
                                    <div class="detail-actions justify-content-end">
                                        <a href="<c:url value='/user/quote-detail?id=${item.quoteId}'/>"
                                           class="btn btn-outline-primary btn-sm btn-pill" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </a>


                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-5">
                                <div class="device-empty-state">
                                    <i class="fas fa-folder-open fa-3x mb-3 opacity-25"></i>
                                    <p class="mb-0 fw-bold">Không tìm thấy hóa đơn nào</p>
                                    <small>Vui lòng kiểm tra lại bộ lọc hoặc từ khóa tìm kiếm</small>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<footer>
    <div class="container text-center">
        <p class="mb-2 fw-bold text-white">GEN-CMS CORPORATION</p>
        <p class="small mb-0 opacity-75">
            &copy; 2026 Hệ thống quản lý bảo trì máy phát điện công nghiệp. All rights reserved.
        </p>
        <div class="mt-3">
            <a href="#" class="mx-2 small text-decoration-none">Điều khoản</a>
            <a href="#" class="mx-2 small text-decoration-none">Bảo mật</a>
            <a href="#" class="mx-2 small text-decoration-none">Liên hệ</a>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 800,
        once: true
    });
</script>

</body>
</html>