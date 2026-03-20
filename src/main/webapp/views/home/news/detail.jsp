<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

      <c:set var="ctx" value="${pageContext.request.contextPath}" />
      <c:set var="user" value="${sessionScope.USERMODEL}" />

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${news.title} | Gen-CMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

        <style>
          :root {
            --primary: #4e73df;
            --secondary: #224abe;
            --ink: #0f172a;
            --muted: #64748b;
            --card: #ffffff;
            --bg: #f6f8ff;
            --ring: rgba(78, 115, 223, .22);
          }

          * {
            box-sizing: border-box;
          }

          body {
            font-family: 'Plus Jakarta Sans', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            overflow-x: hidden;
            background:
              radial-gradient(1200px 600px at 10% -10%, rgba(78, 115, 223, .20), transparent 55%),
              radial-gradient(900px 500px at 95% 0%, rgba(34, 74, 190, .18), transparent 60%),
              var(--bg);
            color: var(--ink);
          }

          /* Navbar */
          .navbar-landing {
            background: transparent;
            padding: 18px 0;
            transition: all .35s ease;
            z-index: 1050;
          }

          .navbar-scrolled {
            background: rgba(255, 255, 255, .88) !important;
            backdrop-filter: blur(12px);
            padding: 10px 0;
            border-bottom: 1px solid rgba(15, 23, 42, .06);
            box-shadow: 0 10px 30px rgba(15, 23, 42, .10);
          }

          .navbar-brand {
            font-weight: 900;
            font-size: 1.7rem;
            letter-spacing: .2px;
            color: #fff !important;
            transition: .3s;
          }

          .navbar-scrolled .navbar-brand {
            color: var(--primary) !important;
          }

          .nav-link {
            color: rgba(255, 255, 255, .92) !important;
            font-weight: 600;
            transition: .25s;
            position: relative;
          }

          .navbar-scrolled .nav-link {
            color: rgba(15, 23, 42, .78) !important;
          }

          .navbar-scrolled .nav-link:hover {
            color: var(--primary) !important;
          }

          .nav-link:hover {
            transform: translateY(-1px);
          }

          .nav-pill {
            border-radius: 999px;
            padding: .55rem .95rem !important;
          }

          .navbar-scrolled .nav-pill:hover {
            background: rgba(78, 115, 223, .08);
          }

          .user-dropdown-toggle {
            border-radius: 999px;
            padding: .55rem .95rem !important;
            background: rgba(255, 255, 255, .16);
            color: #fff !important;
            border: 1px solid rgba(255, 255, 255, .35);
          }

          .navbar-scrolled .user-dropdown-toggle {
            color: var(--primary) !important;
            border-color: rgba(78, 115, 223, .35);
            background: rgba(78, 115, 223, .06);
          }

          .btn-white {
            background: #fff;
            color: var(--primary);
            font-weight: 800;
            border-radius: 999px;
            padding: 13px 30px;
            border: none;
            transition: all .28s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 16px 35px rgba(0, 0, 0, .18);
          }

          .btn-white:hover {
            transform: translateY(-3px);
            box-shadow: 0 22px 45px rgba(0, 0, 0, .22);
            color: var(--secondary);
          }

          /* Hero */
          .news-hero {
            position: relative;
            padding: 150px 0 80px;
            background: linear-gradient(115deg, rgba(15, 23, 42, .78) 0%, rgba(37, 99, 235, .72) 55%, rgba(15, 23, 42, .78) 100%),
            url('${ctx}/template/images/slide1.jpg') center/cover no-repeat;
            color: #fff;
            overflow: hidden;
          }

          .news-hero::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
              radial-gradient(circle at 20% 20%, rgba(255, 255, 255, .08), transparent 28%),
              radial-gradient(circle at 80% 18%, rgba(255, 255, 255, .08), transparent 28%);
            pointer-events: none;
          }

          .news-hero-content {
            position: relative;
            z-index: 2;
          }

          .news-hero .badge-soft {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, .12);
            border: 1px solid rgba(255, 255, 255, .18);
            color: #fff;
            border-radius: 999px;
            padding: 10px 16px;
            font-size: .9rem;
            font-weight: 700;
            margin-bottom: 18px;
            backdrop-filter: blur(10px);
          }

          .news-hero-title {
            font-weight: 900;
            font-size: clamp(2.2rem, 4vw, 3.4rem);
            line-height: 1.08;
            letter-spacing: -1px;
            margin-bottom: 14px;
            text-shadow: 0 10px 30px rgba(0, 0, 0, .18);
            max-width: 900px;
          }

          .news-hero-desc {
            color: rgba(255, 255, 255, .90);
            max-width: 72ch;
            font-size: 1.02rem;
            margin-bottom: 0;
          }

          /* Section */
          .news-section {
            margin-top: -30px;
            position: relative;
            z-index: 3;
          }

          .section-card {
            background: rgba(255, 255, 255, .75);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, .55);
            border-radius: 28px;
            padding: 32px;
            box-shadow: 0 20px 60px rgba(15, 23, 42, .08);
          }

          /* Article */
          .article-card {
            border-radius: 24px;
            overflow: hidden;
            background: #fff;
            border: 1px solid rgba(15, 23, 42, .06);
            box-shadow: 0 12px 30px rgba(15, 23, 42, .06);
            height: 100%;
            position: relative;
          }

          .article-card::before {
            content: "";
            position: absolute;
            inset: -2px;
            background: radial-gradient(500px 120px at 20% 0%, rgba(78, 115, 223, .10), transparent 60%);
            pointer-events: none;
            opacity: .9;
          }

          .article-cover {
            width: 100%;
            max-height: 520px;
            object-fit: cover;
            display: block;
          }

          .article-body {
            padding: 26px 28px 30px;
            position: relative;
            z-index: 2;
          }

          .article-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(78, 115, 223, .10);
            color: var(--primary);
            border-radius: 999px;
            padding: 8px 14px;
            font-size: .85rem;
            font-weight: 800;
            margin-bottom: 16px;
          }

          .article-title {
            font-size: clamp(1.9rem, 3vw, 2.8rem);
            line-height: 1.2;
            font-weight: 900;
            margin-bottom: 16px;
            letter-spacing: -.8px;
            color: var(--ink);
          }

          .article-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            font-size: .92rem;
            color: #6b7280;
            margin-bottom: 20px;
            font-weight: 600;
          }

          .article-meta span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
          }

          .article-summary {
            font-size: 1rem;
            color: #475569;
            line-height: 1.8;
            background: #f8fbff;
            border-left: 4px solid var(--primary);
            border-radius: 16px;
            padding: 18px 20px;
            margin-bottom: 24px;
          }

          .article-content {
            font-size: 1.02rem;
            line-height: 1.95;
            color: #1e293b;
            word-break: break-word;
          }

          .article-content img {
            max-width: 100%;
            height: auto;
            border-radius: 18px;
            margin: 20px 0;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .08);
          }

          .article-content table {
            width: 100% !important;
            border-collapse: collapse;
            margin: 20px 0;
            overflow: hidden;
            border-radius: 14px;
          }

          .article-content table,
          .article-content th,
          .article-content td {
            border: 1px solid #e2e8f0;
            padding: 10px 12px;
          }

          .article-content h1,
          .article-content h2,
          .article-content h3,
          .article-content h4,
          .article-content h5,
          .article-content h6 {
            font-weight: 800;
            color: var(--ink);
            margin-top: 1.4rem;
            margin-bottom: .8rem;
          }

          .article-content p {
            margin-bottom: 1rem;
          }

          /* Sidebar */
          .sidebar-card {
            border-radius: 24px;
            overflow: hidden;
            background: #fff;
            border: 1px solid rgba(15, 23, 42, .06);
            box-shadow: 0 12px 30px rgba(15, 23, 42, .06);
            padding: 22px;
            position: sticky;
            top: 100px;
          }

          .sidebar-title {
            font-size: 1.15rem;
            font-weight: 900;
            margin-bottom: 16px;
            letter-spacing: -.3px;
          }

          .related-item {
            display: flex;
            gap: 14px;
            text-decoration: none;
            color: inherit;
            padding: 14px 0;
            border-bottom: 1px solid rgba(15, 23, 42, .08);
            transition: .25s ease;
          }

          .related-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
          }

          .related-item:hover {
            transform: translateX(4px);
          }

          .related-item:hover .related-title {
            color: var(--primary);
          }

          .related-thumb {
            width: 96px;
            height: 72px;
            object-fit: cover;
            border-radius: 14px;
            flex-shrink: 0;
          }

          .related-title {
            font-weight: 800;
            line-height: 1.45;
            margin-bottom: 6px;
            transition: .25s;
            color: var(--ink);
          }

          .related-meta {
            font-size: .82rem;
            color: var(--muted);
          }

          .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--primary);
            font-weight: 800;
            text-decoration: none;
            transition: .25s;
            margin-top: 24px;
          }

          .back-link:hover {
            color: var(--secondary);
            transform: translateX(-3px);
          }

          /* Footer */
          footer {
            background: #0b1224;
            color: rgba(255, 255, 255, .70);
            padding: 58px 0 26px;
            border-top: 1px solid rgba(255, 255, 255, .06);
            margin-top: 70px;
          }

          .footer-link {
            color: rgba(255, 255, 255, .75);
            text-decoration: none;
          }

          .footer-link:hover {
            color: #fff;
          }

          @media (max-width: 991.98px) {
            .navbar-brand {
              font-size: 1.4rem;
            }

            .news-hero {
              padding: 130px 0 60px;
            }

            .section-card {
              padding: 22px;
            }

            .article-body {
              padding: 22px;
            }

            .sidebar-card {
              position: static;
            }
          }

          @media (max-width: 767.98px) {
            .news-hero-title {
              font-size: 2rem;
            }

            .article-meta {
              gap: 10px;
            }

            .related-thumb {
              width: 84px;
              height: 64px;
            }
          }
        </style>
      </head>

      <body>

        <!-- Navbar -->
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
                  <a class="nav-link nav-pill px-3" href="<c:url value='/views/home/DetailCompany.jsp'/>">Sơ lược công
                    ty</a>
                </li>

                <li class="nav-item">
                  <a class="nav-link nav-pill px-3" href="<c:url value='/products'/>">Sản phẩm mẫu</a>
                </li>

                <c:choose>
                  <c:when test="${empty user}">
                  </c:when>
                  <c:otherwise>
                    <li class="nav-item">
                      <a class="nav-link nav-pill px-3" href="<c:url value='/product-list'/>">Hợp đồng</a>
                    </li>
                  </c:otherwise>
                </c:choose>

                <c:if test="${not empty user}">
                  <li class="nav-item">
                    <a class="nav-link nav-pill px-3" href="<c:url value='/views/home/Support.jsp'/>">Chăm sóc khách
                      hàng</a>
                  </li>
                </c:if>

                <li class="nav-item">
                  <a class="nav-link nav-pill px-3" href="<c:url value='/news'/>">Tin tức</a>
                </li>

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
                      <a class="nav-link dropdown-toggle user-dropdown-toggle" href="#" role="button"
                        data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-1"></i> ${user.fullName}
                      </a>
                      <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-3">
                        <li><a class="dropdown-item py-2" href="<c:url value='/account/user-profile'/>"><i
                              class="fas fa-id-card me-2"></i>Hồ sơ</a></li>
                        <li><a class="dropdown-item py-2" href="<c:url value='/account/change-password'/>"><i
                              class="fas fa-key me-2"></i>Đổi mật khẩu</a></li>
                        <li>
                          <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item py-2 text-danger fw-bold" href="<c:url value='/account/logout'/>"><i
                              class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                      </ul>
                    </li>
                  </c:otherwise>
                </c:choose>
              </ul>
            </div>
          </div>
        </nav>

        <!-- Hero -->
        <section class="news-hero">
          <div class="container news-hero-content">
            <div class="badge-soft">
              <i class="fas fa-newspaper"></i>
              <c:out value="${empty news.category ? 'Tin tức' : news.category}" />
            </div>

            <h1 class="news-hero-title">
              <c:out value="${news.title}" />
            </h1>

            <p class="news-hero-desc">
              <c:choose>
                <c:when test="${not empty news.summary}">
                  <c:out value="${news.summary}" />
                </c:when>
                <c:otherwise>
                  Theo dõi nội dung chi tiết và các thông tin liên quan từ Gen-CMS.
                </c:otherwise>
              </c:choose>
            </p>
          </div>
        </section>

        <!-- Detail -->
        <section class="news-section">
          <div class="container">
            <div class="section-card">
              <div class="row g-4">
                <div class="col-lg-8">
                  <article class="article-card">
                    <c:choose>
                      <c:when test="${not empty news.imageUrl and fn:startsWith(news.imageUrl, 'http')}">
                        <img src="${news.imageUrl}" class="article-cover" alt="${news.title}">
                      </c:when>
                      <c:when
                        test="${not empty news.imageUrl and (fn:startsWith(news.imageUrl, '/') or fn:startsWith(news.imageUrl, 'uploads/') or fn:startsWith(news.imageUrl, 'news-images/'))}">
                        <img src="${ctx}${fn:startsWith(news.imageUrl, '/') ? '' : '/'}${news.imageUrl}"
                          class="article-cover" alt="${news.title}">
                      </c:when>
                      <c:when test="${not empty news.imageUrl}">
                        <img src="${ctx}/uploads/news-images/${news.imageUrl}" class="article-cover"
                          alt="${news.title}">
                      </c:when>
                      <c:otherwise>
                        <img src="${ctx}/uploads/download.jpg" class="article-cover" alt="${news.title}">
                      </c:otherwise>
                    </c:choose>

                    <div class="article-body">
                      <div class="article-badge">
                        <i class="fas fa-newspaper"></i>
                        <c:out value="${empty news.category ? 'Tin tức' : news.category}" />
                      </div>

                      <h1 class="article-title">
                        <c:out value="${news.title}" />
                      </h1>

                      <div class="article-meta">
                        <span>
                          <i class="fas fa-user"></i>
                          <c:out value="${empty news.author ? 'Ban biên tập' : news.author}" />
                        </span>
                        <span>
                          <i class="fas fa-calendar-alt"></i>
                          <c:out value="${news.publishedAt != null ? news.publishedAt : news.createdAt}" />
                        </span>
                        <span>
                          <i class="fas fa-eye"></i>
                          ${news.views != null ? news.views : 0} lượt xem
                        </span>
                      </div>

                      <c:if test="${not empty news.summary}">
                        <div class="article-summary">
                          <strong>Mở đầu:</strong>
                          <c:out value="${news.summary}" />
                        </div>
                      </c:if>

                      <div class="article-content">
                        ${news.content}
                      </div>

                      <a href="${ctx}/news" class="back-link">
                        <i class="fas fa-arrow-left"></i> Quay lại trang tin tức
                      </a>
                    </div>
                  </article>
                </div>

                <div class="col-lg-4">
                  <aside class="sidebar-card">
                    <div class="sidebar-title">
                      <i class="fas fa-fire me-2 text-danger"></i>Tin liên quan
                    </div>

                    <c:choose>
                      <c:when test="${not empty relatedNews}">
                        <c:forEach items="${relatedNews}" var="r">
                          <a href="${ctx}/news/detail?id=${r.id}" class="related-item">
                            <c:choose>
                              <c:when test="${not empty r.imageUrl and fn:startsWith(r.imageUrl, 'http')}">
                                <img src="${r.imageUrl}" class="related-thumb" alt="${r.title}">
                              </c:when>
                              <c:when
                                test="${not empty r.imageUrl and (fn:startsWith(r.imageUrl, '/') or fn:startsWith(r.imageUrl, 'uploads/') or fn:startsWith(r.imageUrl, 'news-images/'))}">
                                <img src="${ctx}${fn:startsWith(r.imageUrl, '/') ? '' : '/'}${r.imageUrl}"
                                  class="related-thumb" alt="${r.title}">
                              </c:when>
                              <c:when test="${not empty r.imageUrl}">
                                <img src="${ctx}/uploads/news-images/${r.imageUrl}" class="related-thumb"
                                  alt="${r.title}">
                              </c:when>
                              <c:otherwise>
                                <img src="${ctx}/uploads/download.jpg" class="related-thumb" alt="Ảnh mặc định">
                              </c:otherwise>
                            </c:choose>

                            <div>
                              <div class="related-title">
                                <c:out value="${r.title}" />
                              </div>
                              <div class="related-meta">
                                <i class="fas fa-calendar-alt me-1"></i>
                                ${r.publishedAt != null ? r.publishedAt : r.createdAt}
                              </div>
                            </div>
                          </a>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <div class="text-muted">Chưa có bài liên quan.</div>
                      </c:otherwise>
                    </c:choose>
                  </aside>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Footer -->
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