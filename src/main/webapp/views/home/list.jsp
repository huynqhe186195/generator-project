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
    <title>Gen-CMS | Danh sách sản phẩm mẫu</title>

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

        .hero{
            padding: 130px 0 50px;
        }

        .hero-box{
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 60%, #162d6f 100%);
            border-radius: 30px;
            color: #fff;
            padding: 42px 36px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 24px 70px rgba(34,74,190,.20);
        }

        .hero-box::before{
            content:"";
            position:absolute;
            inset:0;
            background:
                radial-gradient(700px 220px at 15% 20%, rgba(255,255,255,.18), transparent 60%),
                radial-gradient(650px 220px at 85% 10%, rgba(255,255,255,.10), transparent 60%);
            pointer-events:none;
        }

        .hero-title{
            font-weight: 900;
            font-size: clamp(2rem, 4vw, 3rem);
            line-height: 1.15;
            position: relative;
            z-index: 1;
        }

        .hero-desc{
            max-width: 58ch;
            opacity: .94;
            margin-top: 12px;
            margin-bottom: 0;
            position: relative;
            z-index: 1;
        }

        .filter-wrap{
            margin-top: 28px;
            margin-bottom: 26px;
        }

        .filter-box{
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 14px 40px rgba(15,23,42,.06);
        }

        .filter-label{
            font-size: .92rem;
            font-weight: 700;
            color: var(--muted);
            margin-bottom: 8px;
        }

        .form-control,
        .form-select{
            min-height: 46px;
            border-radius: 14px;
            border-color: rgba(15,23,42,.10);
            box-shadow: none !important;
        }

        .form-control:focus,
        .form-select:focus{
            border-color: rgba(78,115,223,.45);
        }

        .btn-primary-custom{
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            border: none;
            border-radius: 999px;
            padding: 11px 20px;
            font-weight: 700;
            box-shadow: 0 12px 28px rgba(78,115,223,.22);
        }

        .btn-primary-custom:hover{
            color: #fff;
            transform: translateY(-1px);
        }

        .btn-outline-custom{
            border-radius: 999px;
            padding: 11px 18px;
            font-weight: 700;
        }

        .section-head{
            margin-bottom: 20px;
        }

        .section-title{
            font-weight: 900;
            letter-spacing: -.3px;
            margin-bottom: 6px;
        }

        .section-sub{
            color: var(--muted);
            margin-bottom: 0;
        }

        .product-card{
            height: 100%;
            border-radius: 24px;
            overflow: hidden;
            background: var(--card);
            border: 1px solid var(--line);
            box-shadow: 0 14px 38px rgba(15,23,42,.06);
            transition: .28s ease;
            position: relative;
        }

        .product-card:hover{
            transform: translateY(-8px);
            box-shadow: 0 20px 48px rgba(15,23,42,.10);
            border-color: rgba(78,115,223,.18);
        }

        .product-thumb{
            height: 235px;
            background: linear-gradient(180deg, #eef3ff, #f8fbff);
            position: relative;
            overflow: hidden;
        }

        .product-thumb img{
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .product-badge{
            position: absolute;
            top: 14px;
            left: 14px;
            z-index: 2;
            background: rgba(255,255,255,.92);
            color: var(--primary);
            border-radius: 999px;
            padding: 7px 12px;
            font-size: .78rem;
            font-weight: 800;
            box-shadow: 0 8px 20px rgba(0,0,0,.08);
        }

        .product-body{
            padding: 18px 18px 20px;
        }

        .product-name{
            font-size: 1.08rem;
            font-weight: 800;
            line-height: 1.4;
            min-height: 48px;
            margin-bottom: 12px;
        }

        .product-meta{
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 14px;
        }

        .meta-pill{
            background: #f1f5f9;
            color: #334155;
            border-radius: 999px;
            padding: 6px 10px;
            font-size: .8rem;
            font-weight: 700;
        }

        .product-desc{
            color: var(--muted);
            font-size: .94rem;
            line-height: 1.6;
            min-height: 72px;
            margin-bottom: 16px;
        }

        .product-footer{
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .power-text{
            font-weight: 900;
            color: var(--primary);
            font-size: 1.06rem;
            white-space: nowrap;
        }

        .btn-detail{
            border-radius: 999px;
            font-weight: 800;
            padding: 10px 16px;
        }

        .empty-box{
            background: #fff;
            border: 1px dashed #cbd5e1;
            border-radius: 24px;
            padding: 56px 22px;
            text-align: center;
            box-shadow: 0 12px 30px rgba(15,23,42,.04);
        }

        .empty-box i{
            color: var(--primary);
            opacity: .8;
        }

        .pagination{
            gap: 6px;
        }

        .page-link{
            border: none !important;
            border-radius: 12px !important;
            color: var(--primary);
            font-weight: 700;
            min-width: 42px;
            text-align: center;
            box-shadow: 0 6px 18px rgba(15,23,42,.05);
        }

        .page-item.active .page-link{
            background: var(--primary);
            color: #fff;
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
            .hero{
                padding-top: 110px;
            }

            .hero-box{
                padding: 30px 22px;
                border-radius: 24px;
            }

            .product-thumb{
                height: 210px;
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
                    <a class="nav-link nav-pill" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công ty</a>
                </li>
                <li class="nav-item">
                          <a class="nav-link nav-pill px-3" href="<c:url value='/news'/>">Tin tức</a>
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

<section class="hero">
    <div class="container">
        <div class="hero-box">
            <div class="row align-items-center g-4">
                <div class="col-lg-8">
                    <h1 class="hero-title">Khám phá các mẫu máy phát điện nổi bật</h1>
                    <p class="hero-desc">
                        Trang trưng bày sản phẩm dành cho khách tham quan và người dùng, giúp xem nhanh thông tin cơ bản,
                        công suất, nhiên liệu và chi tiết từng mẫu máy.
                    </p>
                </div>

                <div class="col-lg-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="bg-white bg-opacity-10 border border-light border-opacity-25 rounded-4 text-center py-3 px-2">
                                <div class="fw-bold fs-4">${totalItems}</div>
                                <div class="small text-white-50">Sản phẩm</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="bg-white bg-opacity-10 border border-light border-opacity-25 rounded-4 text-center py-3 px-2">
                                <div class="fw-bold fs-4">${totalPages}</div>
                                <div class="small text-white-50">Trang hiển thị</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="filter-wrap">
            <div class="filter-box">
                <form action="${ctx}/products" method="get">
                    <div class="row g-3">
                        <div class="col-lg-4">
                            <label class="filter-label">Từ khóa tìm kiếm</label>
                            <input type="text"
                                   name="keyword"
                                   class="form-control"
                                   placeholder="Tên máy, hãng, danh mục..."
                                   value="${param.keyword}">
                        </div>

                        <div class="col-md-6 col-lg-2">
                            <label class="filter-label">Thương hiệu</label>
                            <select name="brandId" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach var="b" items="${brands}">
                                    <option value="${b.id}" ${param.brandId == b.id.toString() ? 'selected' : ''}>
                                        ${b.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6 col-lg-2">
                            <label class="filter-label">Danh mục</label>
                            <select name="categoryId" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.id}" ${param.categoryId == c.id.toString() ? 'selected' : ''}>
                                        ${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6 col-lg-2">
                            <label class="filter-label">Nhiên liệu</label>
                            <select name="fuelType" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="Diesel" ${param.fuelType == 'Diesel' ? 'selected' : ''}>Diesel</option>
                                <option value="Gasoline" ${param.fuelType == 'Gasoline' ? 'selected' : ''}>Gasoline</option>
                                <option value="Gas" ${param.fuelType == 'Gas' ? 'selected' : ''}>Gas</option>
                            </select>
                        </div>

                        <div class="col-md-6 col-lg-2">
                            <label class="filter-label">Công suất từ</label>
                            <input type="number"
                                   min="0"
                                   name="powerMin"
                                   class="form-control"
                                   placeholder="VD: 100"
                                   value="${param.powerMin}">
                        </div>

                        <div class="col-md-6 col-lg-2">
                            <label class="filter-label">Đến</label>
                            <input type="number"
                                   min="0"
                                   name="powerMax"
                                   class="form-control"
                                   placeholder="VD: 500"
                                   value="${param.powerMax}">
                        </div>

                        <div class="col-12 d-flex flex-wrap gap-2 mt-2">
                            <button type="submit" class="btn btn-primary-custom">
                                <i class="fas fa-search me-2"></i>Lọc sản phẩm
                            </button>
                            <a href="${ctx}/products" class="btn btn-outline-secondary btn-outline-custom">
                                <i class="fas fa-rotate-left me-2"></i>Đặt lại
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="section-head d-flex flex-wrap justify-content-between align-items-center gap-2">
            <div>
                <h2 class="section-title">Danh sách mẫu sản phẩm</h2>
                <p class="section-sub">
                    Hiển thị <strong>${totalItems}</strong> sản phẩm phù hợp
                </p>
            </div>
            <div class="text-muted small">
                Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty listModels}">
                <div class="row g-4">
                    <c:forEach var="item" items="${listModels}">
                        <div class="col-sm-6 col-lg-4">
                            <div class="product-card">
                               <div class="product-thumb">
                                   <span class="product-badge">
                                       <c:choose>
                                           <c:when test="${not empty item.status}">
                                               ${item.status}
                                           </c:when>
                                           <c:otherwise>Mẫu trưng bày</c:otherwise>
                                       </c:choose>
                                   </span>

                                   <c:choose>
                                       <c:when test="${not empty item.imageUrl}">
                                           <img src="${item.imageUrl}"
                                                alt="${item.name}"
                                                loading="lazy"
                                                onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                           <div class="no-image" style="display:none;">
                                               <i class="fas fa-image"></i>
                                               <span>Không có ảnh</span>
                                           </div>
                                       </c:when>
                                       <c:otherwise>
                                           <div class="no-image">
                                               <i class="fas fa-image"></i>
                                               <span>Không có ảnh</span>
                                           </div>
                                       </c:otherwise>
                                   </c:choose>
                               </div>

                                <div class="product-body">
                                    <div class="product-name">${item.name}</div>

                                    <div class="product-meta">
                                        <c:if test="${not empty item.fuelType}">
                                            <span class="meta-pill">
                                                <i class="fas fa-gas-pump me-1"></i>${item.fuelType}
                                            </span>
                                        </c:if>

                                        <c:if test="${not empty item.origin}">
                                            <span class="meta-pill">
                                                <i class="fas fa-earth-asia me-1"></i>${item.origin}
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="product-desc">
                                        <c:choose>
                                            <c:when test="${not empty item.description}">
                                                ${fn:length(item.description) > 120 ? fn:substring(item.description, 0, 120).concat('...') : item.description}
                                            </c:when>
                                            <c:otherwise>
                                                Mẫu máy phát điện phù hợp cho nhu cầu vận hành, dự phòng và tham khảo thông số kỹ thuật cơ bản.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="product-footer">
                                        <div class="power-text">
                                            <c:choose>
                                                <c:when test="${item.power != null}">
                                                    ${item.power} kVA
                                                </c:when>
                                                <c:otherwise>
                                                    Đang cập nhật
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <a href="${ctx}/products/detail?id=${item.id}" class="btn btn-outline-primary btn-detail">
                                            Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav class="mt-5">
                        <ul class="pagination justify-content-center flex-wrap">

                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${ctx}/products?page=${currentPage - 1}&keyword=${param.keyword}&brandId=${param.brandId}&categoryId=${param.categoryId}&fuelType=${param.fuelType}&power=${param.power}">
                                    <i class="fas fa-angle-left"></i>
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${ctx}/products?page=${i}&keyword=${param.keyword}&brandId=${param.brandId}&categoryId=${param.categoryId}&fuelType=${param.fuelType}&power=${param.power}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${ctx}/products?page=${currentPage + 1}&keyword=${param.keyword}&brandId=${param.brandId}&categoryId=${param.categoryId}&fuelType=${param.fuelType}&power=${param.power}">
                                    <i class="fas fa-angle-right"></i>
                                </a>
                            </li>

                        </ul>
                    </nav>
                </c:if>
            </c:when>

            <c:otherwise>
                <div class="empty-box">
                    <i class="fas fa-box-open fa-3x mb-3"></i>
                    <h4 class="fw-bold mb-2">Chưa có sản phẩm phù hợp</h4>
                    <p class="text-muted mb-3">
                        Hiện chưa tìm thấy mẫu máy phát điện nào theo điều kiện bạn đã chọn.
                    </p>
                    <a href="${ctx}/products" class="btn btn-primary-custom">
                        Xem lại toàn bộ sản phẩm
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
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
<jsp:include page="/views/customer/common/ai-chat-widget.jsp" />

</body>
</html>