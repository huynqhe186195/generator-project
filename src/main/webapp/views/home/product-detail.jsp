<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pm.name} | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root{
            --primary:#4e73df;
            --secondary:#224abe;
            --ink:#0f172a;
            --muted:#64748b;
            --card:#ffffff;
            --bg:#f6f8ff;
            --line:rgba(15,23,42,.08);
            --soft:rgba(78,115,223,.08);
        }

        *{
            box-sizing: border-box;
        }

        body{
            font-family:'Plus Jakarta Sans', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            background:
                radial-gradient(1100px 500px at 10% -10%, rgba(78,115,223,.16), transparent 55%),
                radial-gradient(900px 450px at 100% 0%, rgba(34,74,190,.12), transparent 55%),
                var(--bg);
            color: var(--ink);
            overflow-x: hidden;
        }

        .navbar-landing{
            background: rgba(255,255,255,.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(15,23,42,.06);
            box-shadow: 0 8px 30px rgba(15,23,42,.06);
            padding: 12px 0;
        }

        .navbar-brand{
            font-weight: 900;
            font-size: 1.5rem;
            color: var(--primary) !important;
        }

        .nav-link{
            color: rgba(15,23,42,.78) !important;
            font-weight: 600;
        }

        .nav-link:hover{
            color: var(--primary) !important;
        }

        .nav-pill{
            border-radius: 999px;
            padding: .55rem .95rem !important;
        }

        .nav-pill:hover{
            background: rgba(78,115,223,.08);
        }

        .btn-white{
            background: #fff;
            color: var(--primary);
            font-weight: 800;
            border-radius: 999px;
            padding: 11px 22px;
            border: none;
            transition: .25s;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            gap:10px;
            box-shadow: 0 12px 28px rgba(15,23,42,.10);
        }

        .btn-white:hover{
            transform: translateY(-2px);
            color: var(--secondary);
        }

        .page-wrap{
            padding: 120px 0 60px;
        }

        .crumb{
            color: var(--muted);
            font-size: .95rem;
            margin-bottom: 16px;
        }

        .crumb a{
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
        }

        .detail-card{
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 28px;
            box-shadow: 0 18px 46px rgba(15,23,42,.06);
            overflow: hidden;
        }

        .gallery-wrap{
            padding: 24px;
        }

        .main-image{
            width: 100%;
            height: 460px;
            border-radius: 22px;
            object-fit: cover;
            background: linear-gradient(180deg, #eef3ff, #f8fbff);
            border: 1px solid rgba(15,23,42,.06);
        }

        .thumb-list{
            margin-top: 14px;
        }

        .thumb-item{
            width: 100%;
            height: 95px;
            object-fit: cover;
            border-radius: 16px;
            border: 2px solid transparent;
            cursor: pointer;
            transition: .2s ease;
            background: #f8fafc;
        }

        .thumb-item:hover,
        .thumb-item.active{
            border-color: var(--primary);
            transform: translateY(-2px);
        }

        .info-wrap{
            padding: 28px 28px 28px 10px;
        }

        .badge-soft{
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            background: var(--soft);
            color: var(--primary);
            font-weight: 800;
            font-size: .84rem;
            margin-bottom: 14px;
        }

        .product-title{
            font-size: clamp(1.8rem, 3vw, 2.6rem);
            font-weight: 900;
            line-height: 1.2;
            margin-bottom: 14px;
        }

        .meta-grid{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 22px;
        }

        .meta-box{
            background: #f8fafc;
            border: 1px solid rgba(15,23,42,.06);
            border-radius: 18px;
            padding: 14px 16px;
        }

        .meta-label{
            color: var(--muted);
            font-size: .86rem;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .meta-value{
            font-weight: 800;
            color: var(--ink);
        }

        .desc-box{
            background: #fff;
            border: 1px solid rgba(15,23,42,.08);
            border-radius: 20px;
            padding: 18px;
            margin-bottom: 16px;
        }

        .section-label{
            font-size: .95rem;
            font-weight: 800;
            margin-bottom: 10px;
            color: var(--primary);
        }

        .desc-text{
            color: #334155;
            line-height: 1.75;
            margin-bottom: 0;
            white-space: pre-line;
        }

        .action-row{
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 22px;
        }

        .btn-primary-custom{
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            border: none;
            border-radius: 999px;
            padding: 12px 20px;
            font-weight: 800;
            box-shadow: 0 12px 28px rgba(78,115,223,.22);
            text-decoration: none;
        }

        .btn-primary-custom:hover{
            color: #fff;
            transform: translateY(-1px);
        }

        .btn-outline-custom{
            border-radius: 999px;
            padding: 12px 18px;
            font-weight: 800;
            text-decoration: none;
        }

        .spec-box{
            margin-top: 24px;
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 14px 36px rgba(15,23,42,.05);
        }

        .spec-content{
            color: #334155;
            line-height: 1.8;
            white-space: pre-line;
        }

        footer{
            margin-top: 70px;
            background: #0b1224;
            color: rgba(255,255,255,.72);
            padding: 42px 0 20px;
        }

        .footer-link{
            color: rgba(255,255,255,.78);
            text-decoration: none;
        }

        .footer-link:hover{
            color: #fff;
        }

        @media (max-width: 991.98px){
            .page-wrap{
                padding-top: 105px;
            }

            .main-image{
                height: 320px;
            }

            .info-wrap{
                padding: 0 24px 24px 24px;
            }

            .meta-grid{
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-landing fixed-top">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>">
            <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav ms-auto align-items-center gap-lg-1">
                <li class="nav-item">
                    <a class="nav-link nav-pill" href="<c:url value='/'/>">Trang chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-pill" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
                </li>

                <c:choose>
                    <c:when test="${empty user}">
                        <li class="nav-item ms-lg-3">
                            <a href="<c:url value='/account/login'/>" class="btn btn-white">
                                <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item ms-lg-3">
                            <a href="<c:url value='/account/user-profile'/>" class="btn btn-white">
                                <i class="fas fa-user-circle"></i> ${user.fullName}
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<section class="page-wrap">
    <div class="container">
        <div class="crumb">
            <a href="${ctx}/">Trang chủ</a>
            <span class="mx-2">/</span>
            <a href="${ctx}/products">Sản phẩm mẫu</a>
            <span class="mx-2">/</span>
            <span>${pm.name}</span>
        </div>

        <div class="detail-card">
            <div class="row g-0">
                <div class="col-lg-6">
                    <div class="gallery-wrap">
                        <img id="mainPreview"
                             src="${mainImage}"
                             alt="${pm.name}"
                             class="main-image"
                             onerror="this.src='${ctx}/template/images/img.png'">

                        <c:if test="${not empty imageUrls}">
                            <div class="row g-2 thumb-list">
                                <c:forEach var="img" items="${imageUrls}" varStatus="loop">
                                    <div class="col-3">
                                        <img src="${img}"
                                             class="thumb-item ${loop.first ? 'active' : ''}"
                                             alt="${pm.name}"
                                             onclick="changeMainImage(this)"
                                             onerror="this.src='${ctx}/template/images/img.png'">
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="info-wrap">
                        <div class="badge-soft">
                            <i class="fas fa-bolt"></i>
                            <span>${pm.status}</span>
                        </div>

                        <h1 class="product-title">${pm.name}</h1>

                        <div class="meta-grid">
                            <div class="meta-box">
                                <div class="meta-label">Thương hiệu</div>
                                <div class="meta-value">
                                    <c:choose>
                                        <c:when test="${not empty brandName}">${brandName}</c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="meta-box">
                                <div class="meta-label">Danh mục</div>
                                <div class="meta-value">
                                    <c:choose>
                                        <c:when test="${not empty categoryName}">${categoryName}</c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="meta-box">
                                <div class="meta-label">Xuất xứ</div>
                                <div class="meta-value">
                                    <c:choose>
                                        <c:when test="${not empty pm.origin}">${pm.origin}</c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="meta-box">
                                <div class="meta-label">Nhiên liệu</div>
                                <div class="meta-value">
                                    <c:choose>
                                        <c:when test="${not empty pm.fuelType}">${pm.fuelType}</c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="meta-box">
                                <div class="meta-label">Công suất</div>
                                <div class="meta-value">
                                    <c:choose>
                                        <c:when test="${pm.power != null}">${pm.power} kVA</c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="meta-box">
                                <div class="meta-label">Mã slug</div>
                                <div class="meta-value">
                                    <c:choose>
                                        <c:when test="${not empty pm.slug}">${pm.slug}</c:when>
                                        <c:otherwise>Không có</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="desc-box">
                            <div class="section-label">Mô tả sản phẩm</div>
                            <p class="desc-text">
                                <c:choose>
                                    <c:when test="${not empty pm.description}">
                                        ${pm.description}
                                    </c:when>
                                    <c:otherwise>
                                        Sản phẩm hiện đang được trưng bày để khách hàng và người dùng tham khảo thông tin cơ bản.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="action-row">
                            <a href="${ctx}/products" class="btn btn-outline-primary btn-outline-custom">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                            </a>

                            <c:if test="${not empty pm.manualUrl}">

                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="spec-box">
            <div class="section-label">Thông số kỹ thuật</div>
            <div class="spec-content">
                <c:choose>
                    <c:when test="${not empty pm.specifications}">
                        ${pm.specifications}
                    </c:when>
                    <c:otherwise>
                        Thông số kỹ thuật đang được cập nhật.
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="container">
        <div class="row gy-3 align-items-center">
            <div class="col-lg-6 text-center text-lg-start">
                <a href="<c:url value='/'/>" class="text-white text-decoration-none fw-bold fs-4">
                    <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
                </a>
                <p class="mt-2 mb-0">Giải pháp số hóa hệ thống năng lượng dự phòng hàng đầu.</p>
            </div>

            <div class="col-lg-6 text-center text-lg-end">
                <p class="small mb-2">&copy; 2024 Gen-CMS Corporation. Bảo lưu mọi quyền.</p>
                <div class="d-inline-flex gap-3">
                    <a href="#" class="footer-link"><i class="fab fa-facebook fs-5"></i></a>
                    <a href="#" class="footer-link"><i class="fab fa-linkedin fs-5"></i></a>
                    <a href="#" class="footer-link"><i class="fas fa-envelope fs-5"></i></a>
                </div>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function changeMainImage(el){
        const main = document.getElementById('mainPreview');
        main.src = el.src;

        document.querySelectorAll('.thumb-item').forEach(item => {
            item.classList.remove('active');
        });

        el.classList.add('active');
    }
</script>
<jsp:include page="/views/customer/common/ai-chat-widget.jsp" />

</body>
</html>