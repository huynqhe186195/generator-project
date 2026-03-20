<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="user" value="${sessionScope.USERMODEL}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tin tức | Gen-CMS</title>

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
      --ring: rgba(78,115,223,.22);
    }

    *{
      box-sizing: border-box;
    }

    body{
      font-family:'Plus Jakarta Sans', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      overflow-x:hidden;
      background:
        radial-gradient(1200px 600px at 10% -10%, rgba(78,115,223,.20), transparent 55%),
        radial-gradient(900px 500px at 95% 0%, rgba(34,74,190,.18), transparent 60%),
        var(--bg);
      color: var(--ink);
    }

    .navbar-landing{
      background: transparent;
      padding: 18px 0;
      transition: all .35s ease;
      z-index: 1050;
    }

    .navbar-scrolled{
      background: rgba(255,255,255,.88) !important;
      backdrop-filter: blur(12px);
      padding: 10px 0;
      border-bottom: 1px solid rgba(15,23,42,.06);
      box-shadow: 0 10px 30px rgba(15,23,42,.10);
    }

    .navbar-brand{
      font-weight: 900;
      font-size: 1.7rem;
      letter-spacing: .2px;
      color: #fff !important;
      transition: .3s;
    }

    .navbar-scrolled .navbar-brand{
      color: var(--primary) !important;
    }

    .nav-link{
      color: rgba(255,255,255,.92) !important;
      font-weight: 600;
      transition: .25s;
      position: relative;
    }

    .navbar-scrolled .nav-link{
      color: rgba(15,23,42,.78) !important;
    }

    .navbar-scrolled .nav-link:hover{
      color: var(--primary) !important;
    }

    .nav-link:hover{
      transform: translateY(-1px);
    }

    .nav-pill{
      border-radius: 999px;
      padding: .55rem .95rem !important;
    }

    .navbar-scrolled .nav-pill:hover{
      background: rgba(78,115,223,.08);
    }

    .user-dropdown-toggle{
      border-radius: 999px;
      padding: .55rem .95rem !important;
      background: rgba(255,255,255,.16);
      color:#fff !important;
      border: 1px solid rgba(255,255,255,.35);
    }

    .navbar-scrolled .user-dropdown-toggle{
      color: var(--primary) !important;
      border-color: rgba(78,115,223,.35);
      background: rgba(78,115,223,.06);
    }

    .btn-white{
      background: #fff;
      color: var(--primary);
      font-weight: 800;
      border-radius: 999px;
      padding: 13px 30px;
      border: none;
      transition: all .28s ease;
      text-decoration:none;
      display:inline-flex;
      align-items:center;
      gap:10px;
      box-shadow: 0 16px 35px rgba(0,0,0,.18);
    }

    .btn-white:hover{
      transform: translateY(-3px);
      box-shadow: 0 22px 45px rgba(0,0,0,.22);
      color: var(--secondary);
    }

    .news-hero{
      position: relative;
      padding: 150px 0 80px;
      background:
        linear-gradient(115deg, rgba(15,23,42,.78) 0%, rgba(37,99,235,.72) 55%, rgba(15,23,42,.78) 100%),
        url('${ctx}/template/images/slide1.jpg') center/cover no-repeat;
      color: #fff;
      overflow: hidden;
    }

    .news-hero::before{
      content:"";
      position:absolute;
      inset:0;
      background:
        radial-gradient(circle at 20% 20%, rgba(255,255,255,.08), transparent 28%),
        radial-gradient(circle at 80% 18%, rgba(255,255,255,.08), transparent 28%);
      pointer-events:none;
    }

    .news-hero-content{
      position: relative;
      z-index: 2;
    }

    .news-hero .badge-soft{
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: rgba(255,255,255,.12);
      border: 1px solid rgba(255,255,255,.18);
      color: #fff;
      border-radius: 999px;
      padding: 10px 16px;
      font-size: .9rem;
      font-weight: 700;
      margin-bottom: 18px;
      backdrop-filter: blur(10px);
    }

    .news-hero-title{
      font-weight: 900;
      font-size: clamp(2.2rem, 4vw, 3.8rem);
      line-height: 1.08;
      letter-spacing: -1px;
      margin-bottom: 14px;
      text-shadow: 0 10px 30px rgba(0,0,0,.18);
    }

    .news-hero-desc{
      color: rgba(255,255,255,.90);
      max-width: 62ch;
      font-size: 1.02rem;
      margin-bottom: 0;
    }

    .news-section{
      margin-top: -30px;
      position: relative;
      z-index: 3;
    }

    .section-card{
      background: rgba(255,255,255,.75);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,.55);
      border-radius: 28px;
      padding: 32px;
      box-shadow: 0 20px 60px rgba(15,23,42,.08);
    }

    .section-title{
      font-weight: 900;
      letter-spacing: -.4px;
      margin-bottom: 8px;
    }

    .section-sub{
      color: var(--muted);
      margin-bottom: 0;
    }

    .filter-box{
      background: #fff;
      border: 1px solid rgba(15,23,42,.06);
      border-radius: 20px;
      padding: 18px;
      box-shadow: 0 10px 24px rgba(15,23,42,.05);
      margin-bottom: 24px;
    }

    .filter-input,
    .filter-select{
      border-radius: 14px;
      min-height: 46px;
      border: 1px solid rgba(15,23,42,.12);
      box-shadow: none !important;
    }

    .filter-input:focus,
    .filter-select:focus{
      border-color: var(--primary);
      box-shadow: 0 0 0 .25rem rgba(78,115,223,.12) !important;
    }

    .filter-btn{
      min-height: 46px;
      border-radius: 14px;
      font-weight: 800;
    }

    .news-card{
      border-radius: 22px;
      overflow: hidden;
      background: #fff;
      border: 1px solid rgba(15,23,42,.06);
      transition: .32s ease;
      height: 100%;
      box-shadow: 0 12px 30px rgba(15,23,42,.06);
      position: relative;
    }

    .news-card::before{
      content:"";
      position:absolute;
      inset:-2px;
      background: radial-gradient(500px 120px at 20% 0%, rgba(78,115,223,.10), transparent 60%);
      pointer-events:none;
      opacity:.9;
    }

    .news-card:hover{
      transform: translateY(-8px);
      box-shadow: 0 20px 50px rgba(15,23,42,.12);
      border-color: rgba(78,115,223,.18);
    }

    .news-thumb-wrap{
      position: relative;
      overflow: hidden;
    }

    .news-thumb{
      width:100%;
      height:240px;
      object-fit:cover;
      transition: transform .45s ease;
      display:block;
    }

    .news-card:hover .news-thumb{
      transform: scale(1.05);
    }

    .news-content{
      padding: 20px 20px 22px;
      position: relative;
      z-index: 2;
    }

    .news-meta{
      display:flex;
      flex-wrap:wrap;
      gap:14px;
      font-size:.86rem;
      color:#6b7280;
      margin-bottom:12px;
      font-weight:600;
    }

    .news-meta span{
      display:inline-flex;
      align-items:center;
      gap:6px;
    }

    .news-title{
      font-weight:800;
      font-size:1.08rem;
      line-height:1.45;
      margin-bottom:12px;
    }

    .news-title a{
      color: var(--ink);
      text-decoration:none;
      transition:.25s;
    }

    .news-title a:hover{
      color: var(--primary);
    }

    .news-summary{
      font-size:.95rem;
      color:#64748b;
      line-height:1.7;
      margin-bottom:16px;
      min-height: 72px;
    }

    .news-readmore{
      display:inline-flex;
      align-items:center;
      gap:8px;
      color: var(--primary);
      font-weight:800;
      text-decoration:none;
      transition:.25s;
    }

    .news-readmore:hover{
      color: var(--secondary);
      transform: translateX(4px);
    }

    .pagination .page-link{
      border: none;
      margin: 0 4px;
      border-radius: 12px !important;
      color: var(--primary);
      font-weight: 700;
      min-width: 42px;
      height: 42px;
      display:flex;
      align-items:center;
      justify-content:center;
      box-shadow: 0 8px 20px rgba(15,23,42,.06);
    }

    .pagination .page-item.active .page-link{
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      color: #fff;
      box-shadow: 0 12px 25px rgba(78,115,223,.28);
    }

    .pagination .page-link:hover{
      background: rgba(78,115,223,.08);
      color: var(--secondary);
    }

    footer{
      background: #0b1224;
      color: rgba(255,255,255,.70);
      padding: 58px 0 26px;
      border-top: 1px solid rgba(255,255,255,.06);
      margin-top: 70px;
    }

    .footer-link{
      color: rgba(255,255,255,.75);
      text-decoration: none;
    }

    .footer-link:hover{
      color: #fff;
    }

    @media (max-width: 991.98px){
      .navbar-brand{
        font-size: 1.4rem;
      }

      .news-hero{
        padding: 130px 0 60px;
      }

      .section-card{
        padding: 22px;
      }

      .news-thumb{
        height: 210px;
      }

      .news-summary{
        min-height: auto;
      }
    }

    @media (max-width: 767.98px){
      .news-hero-title{
        font-size: 2rem;
      }

      .news-meta{
        gap:10px;
      }
    }
  </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-landing fixed-top" id="mainNav">
  <div class="container">
    <a class="navbar-brand" href="<c:url value='/'/>">
      <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
    </a>

    <button class="navbar-toggler bg-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-center gap-lg-1">
        <li class="nav-item">
          <a class="nav-link nav-pill px-3" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công ty</a>
        </li>

        <li class="nav-item">
          <a class="nav-link nav-pill px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
        </li>

        <c:choose>
          <c:when test="${empty user}">
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link nav-pill px-3" href="<c:url value='/product-list'/>">Sản phẩm</a>
            </li>
          </c:otherwise>
        </c:choose>

        <c:if test="${not empty user}">
          <li class="nav-item">
            <a class="nav-link nav-pill px-3" href="<c:url value='/views/home/Support.jsp'/>">Chăm sóc khách hàng</a>
          </li>
        </c:if>

        <c:choose>
          <c:when test="${empty user}">
            <li class="nav-item ms-lg-3">
              <a href="<c:url value='/account/login'/>" class="btn btn-white px-4">
                <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
              </a>
            </li>
          </c:when>

          <c:otherwise>
            <li class="nav-item dropdown ms-lg-3">
              <a class="nav-link dropdown-toggle user-dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                <i class="fas fa-user-circle me-1"></i> ${user.fullName}
              </a>
              <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-3">
                <li><a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>"><i class="fas fa-id-card me-2"></i>Hồ sơ</a></li>
                <li><a class="dropdown-item py-2" href="<c:url value='/account/change-password'/>"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item py-2 text-danger fw-bold" href="<c:url value='/account/logout'/>"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
              </ul>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<section class="news-hero">
  <div class="container news-hero-content">
    <div class="badge-soft">
      <i class="fas fa-newspaper"></i> Trang tin tức
    </div>
    <h1 class="news-hero-title">Cập nhật tin tức mới nhất từ Gen-CMS</h1>
    <p class="news-hero-desc">
      Theo dõi các bài viết, thông báo, hoạt động nổi bật và những thông tin mới nhất liên quan đến hệ thống quản trị máy phát điện.
    </p>
  </div>
</section>

<section class="news-section">
  <div class="container">
    <div class="section-card">
      <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-2">
        <div>
          <h2 class="section-title">Tin tức mới nhất</h2>
          <p class="section-sub">Khám phá các bài viết và thông báo mới được cập nhật</p>
        </div>
      </div>

      <div class="filter-box">
        <form method="get" action="${ctx}/news" class="row g-3 align-items-end">
          <div class="col-lg-6">
            <label class="form-label fw-bold mb-2">Từ khóa</label>
            <input
              type="text"
              name="keyword"
              class="form-control filter-input"
              placeholder="Tìm theo tiêu đề bài viết hoặc tên tác giả..."
              value="${param.keyword}">
          </div>

          <div class="col-lg-4">
            <label class="form-label fw-bold mb-2">Danh mục</label>
            <select name="category" class="form-select filter-select">
              <option value="">Tất cả danh mục</option>
              <c:forEach items="${categoryList}" var="c">
                <option value="${c}" ${param.category == c ? 'selected' : ''}>
                  ${c}
                </option>
              </c:forEach>
            </select>
          </div>

          <div class="col-lg-2 d-grid">
            <button type="submit" class="btn btn-primary filter-btn">
              <i class="fas fa-search me-1"></i> Tìm kiếm
            </button>
          </div>
        </form>
      </div>

      <div class="row g-4">
        <c:forEach items="${newsList}" var="n">
          <div class="col-md-6 col-lg-4">
            <div class="news-card">
              <div class="news-thumb-wrap">
                <c:choose>
                  <c:when test="${not empty n.imageUrl}">
                    <img src="${ctx}/uploads/news-images/${n.imageUrl}" class="news-thumb" alt="${n.title}">
                  </c:when>
                  <c:otherwise>
                    <img src="${ctx}/uploads/download.jpg" class="news-thumb" alt="Ảnh mặc định">
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="news-content">
                <div class="news-meta">
                  <span>
                    <i class="fas fa-calendar-alt"></i>
                    Ngày đăng:
                    <fmt:formatDate value="${n.publishedAt != null ? n.publishedAt : n.createdAt}" pattern="dd/MM/yyyy"/>
                  </span>

                  <span>
                    <i class="fas fa-eye"></i>
                    ${n.views} lượt xem
                  </span>
                </div>

                <div class="news-title">
                  <a href="${ctx}/news/detail?id=${n.id}">
                    ${n.title}
                  </a>
                </div>

                <p class="news-summary">
                  <c:choose>
                    <c:when test="${not empty n.summary}">
                      ${n.summary}
                    </c:when>
                    <c:otherwise>
                      ${n.title}
                    </c:otherwise>
                  </c:choose>
                </p>

                <a href="${ctx}/news/detail?id=${n.id}" class="news-readmore">
                  Xem chi tiết <i class="fas fa-arrow-right"></i>
                </a>
              </div>
            </div>
          </div>
        </c:forEach>

        <c:if test="${empty newsList}">
          <div class="col-12">
            <div class="alert alert-light border text-center py-4 rounded-4">
              <i class="fas fa-search me-2 text-primary"></i>
              Không tìm thấy bài viết phù hợp.
            </div>
          </div>
        </c:if>
      </div>

      <c:if test="${totalPages > 1}">
        <nav class="mt-5">
          <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPages}" var="pg">
              <c:url var="pageUrl" value="/news">
                <c:param name="page" value="${pg}" />
                <c:param name="keyword" value="${param.keyword}" />
                <c:param name="category" value="${param.category}" />
              </c:url>

              <li class="page-item ${currentPage == pg ? 'active' : ''}">
                <a class="page-link" href="${pageUrl}">${pg}</a>
              </li>
            </c:forEach>
          </ul>
        </nav>
      </c:if>
    </div>
  </div>
</section>

<footer>
  <div class="container">
    <div class="row gy-4 align-items-center">
      <div class="col-lg-6 text-center text-lg-start">
        <a href="<c:url value='/'/>" class="text-white text-decoration-none fw-bold fs-4">
          <i class="fas fa-bolt me-2 text-warning"></i>Gen-CMS
        </a>
        <p class="mt-2 mb-0">Giải pháp số hóa hệ thống năng lượng dự phòng hàng đầu.</p>
      </div>

      <div class="col-lg-6 text-center text-lg-end">
        <p class="small mb-2">&copy; 2026 Gen-CMS Corporation. Bảo lưu mọi quyền.</p>
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
  const mainNav = document.getElementById('mainNav');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) mainNav.classList.add('navbar-scrolled');
    else mainNav.classList.remove('navbar-scrolled');
  });
</script>

<jsp:include page="/views/customer/ai-chat-widget.jsp" />
</body>
</html>