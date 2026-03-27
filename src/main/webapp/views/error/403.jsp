<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .error403-page {
        min-height: calc(100vh - 140px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 24px 16px;
    }

    .error403-card {
        width: 100%;
        max-width: 760px;
        border: 0;
        border-radius: 24px;
        overflow: hidden;
        box-shadow: 0 24px 48px rgba(15, 23, 42, 0.12);
        background: #ffffff;
    }

    .error403-banner {
        background: linear-gradient(135deg, #ef4444, #f97316);
        color: #fff;
        padding: 20px 28px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
    }

    .error403-banner h1 {
        margin: 0;
        font-size: 1.2rem;
        font-weight: 700;
    }

    .error403-code {
        font-size: 4.2rem;
        font-weight: 900;
        line-height: 1;
        color: #dc2626;
        letter-spacing: 1px;
    }

    .error403-body {
        padding: 34px 28px 30px;
        text-align: center;
    }

    .error403-icon {
        width: 88px;
        height: 88px;
        border-radius: 50%;
        margin: 0 auto 18px;
        background: #fff7ed;
        color: #f59e0b;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
    }

    .error403-title {
        font-size: 1.85rem;
        font-weight: 800;
        color: #1f2937;
        margin-bottom: 10px;
    }

    .error403-copy {
        font-size: 1.05rem;
        color: #64748b;
        max-width: 560px;
        margin: 0 auto 20px;
    }

    .error403-hint {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        color: #334155;
        border-radius: 14px;
        padding: 12px 14px;
        margin: 0 auto 22px;
        max-width: 560px;
        font-size: 0.95rem;
    }
</style>

<div class="error403-page">
    <div class="error403-card">
        <div class="error403-banner">
            <h1><i class="fa-solid fa-shield-halved me-2"></i>Truy cập bị từ chối</h1>
            <div class="error403-code">403</div>
        </div>
        <div class="error403-body">
            <div class="error403-icon">
                <i class="fa-solid fa-user-lock"></i>
            </div>
            <div class="error403-title">Bạn không có quyền truy cập trang này</div>
            <p class="error403-copy">
                Tài nguyên bạn đang mở yêu cầu quyền cao hơn hoặc thuộc một vai trò khác trong hệ thống.
            </p>
            <div class="error403-hint">
                Nếu bạn cho rằng đây là nhầm lẫn, vui lòng liên hệ quản trị viên để kiểm tra lại quyền truy cập tài khoản.
            </div>
            <div class="d-flex justify-content-center flex-wrap gap-2">
                <button onclick="history.back()" class="btn btn-outline-secondary px-4">
                    <i class="fa-solid fa-arrow-left me-2"></i>Quay lại
                </button>
                <a href="<c:url value='/'/>" class="btn btn-primary px-4">
                    <i class="fa-solid fa-house me-2"></i>Về trang chủ
                </a>
            </div>
        </div>
    </div>
</div>
