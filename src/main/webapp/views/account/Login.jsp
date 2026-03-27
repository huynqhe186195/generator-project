<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Sign In | Gen-CMS</title>

    <link rel="stylesheet" href="<c:url value='/template/account/fonts/material-icon/css/material-design-iconic-font.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/template/account/css/login-style.css'/>">

    <style>
        /* =========================================
           CĂN GIỮA TUYỆT ĐỐI VÀ LÀM ĐẸP GIAO DIỆN
        ========================================= */

        /* 1. Ép body chiếm 100% màn hình và dùng Flexbox để căn giữa Form */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
            display: flex;
            align-items: center;      /* Căn giữa theo chiều dọc */
            justify-content: center;  /* Căn giữa theo chiều ngang */
        }

        /* 2. Gỡ bỏ lớp padding mặc định gây lệch của file CSS gốc */
        .main {
            padding: 0 !important;
            margin: 0 !important;
            width: 100%;
            display: flex;
            justify-content: center;
        }

        .sign-in {
            margin: 0 !important;
            padding: 0 !important;
        }

        /* 3. Làm mềm khối hộp đăng nhập: Bo góc to hơn, đổ bóng mờ (Soft Shadow) */
        .container {
            border-radius: 24px !important;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08) !important;
            background: #ffffff;
            border: 1px solid rgba(0,0,0,0.02);
            margin: auto !important;
        }

        /* 4. Nút Đăng nhập: Hiệu ứng hover nhấc lên, bóng xanh */
        .form-submit {
            background: #4e73df !important; /* Xanh của hệ thống */
            border-radius: 8px !important;
            transition: all 0.3s ease !important;
        }
        .form-submit:hover {
            background: #224abe !important;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(78, 115, 223, 0.3) !important;
        }

        /* 5. Link Quên mật khẩu */
        .signup-image-link {
            color: #4e73df !important;
            transition: all 0.3s ease;
        }
        .signup-image-link:hover {
            color: #224abe !important;
            text-decoration: underline !important;
        }

        /* 6. Khung thông báo Lỗi/Thành công đẹp mắt */
        .alert-box {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 600;
            text-align: center;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* 7. NÚT QUAY LẠI GÓC TRÊN BÊN TRÁI MÀN HÌNH */
        .back-home-btn {
            position: fixed; /* Fixed để luôn ghim ở góc màn hình */
            top: 30px;
            left: 40px;
            display: inline-flex;
            align-items: center;
            color: #555;
            text-decoration: none;
            font-size: 15px;
            font-weight: bold;
            transition: all 0.3s ease;
            z-index: 1000;
        }
        .back-home-btn i {
            font-size: 20px;
            margin-right: 8px;
            transition: transform 0.3s ease;
        }
        .back-home-btn:hover {
            color: #4e73df;
        }
        .back-home-btn:hover i {
            transform: translateX(-5px);
        }
    </style>
</head>

<body>

<%-- NÚT QUAY LẠI TRANG CHỦ --%>
<a href="<c:url value='/'/>" class="back-home-btn">
    <i class="zmdi zmdi-arrow-left"></i> Quay lại Trang chủ
</a>

<div class="main">
    <section class="sign-in">
        <div class="container">
            <div class="signin-content">

                <div class="signin-image text-center">
                    <figure>
                        <img src="<c:url value='/template/images/signin-image.jpg'/>" alt="sign in image">
                    </figure>
                </div>

                <div class="signin-form">
                    <h2 class="form-title">Sign In</h2>

                    <%-- 1. Hiển thị thông báo gửi từ Servlet qua biến request (setAttribute) --%>
                    <c:if test="${not empty message}">
                        <div class="alert-box ${alert == 'success' ? 'alert-success' : 'alert-danger'}">
                                ${message}
                        </div>
                    </c:if>

                    <%-- 2. Hiển thị thông báo gửi từ URL Parameter (?message=...) --%>
                    <c:if test="${not empty param.message}">
                        <%-- Đặt mặc định là màu xanh (success), trừ khi message có chứa chữ 'invalid' hoặc 'error' --%>
                        <c:set var="alertType" value="${(param.message == 'token_invalid' || param.message == 'error') ? 'alert-danger' : 'alert-success'}" />

                        <div class="alert-box ${alertType}">
                            <c:choose>
                                <c:when test="${param.message == 'reset_success'}">Cập nhật mật khẩu thành công! Vui lòng đăng nhập lại.</c:when>
                                <c:when test="${param.message == 'token_invalid'}">Link khôi phục đã hết hạn hoặc không hợp lệ!</c:when>
                                <c:when test="${param.message == 'logout'}">Bạn đã đăng xuất thành công.</c:when>
                                <%-- Bổ sung otherwise để bắt trọn mọi tin nhắn khác, tránh hiện hộp rỗng --%>
                                <c:otherwise>${param.message}</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <form method="POST" action="<c:url value='/hanldeLogin'/>" class="register-form" id="login-form">
                        <div class="form-group">
                            <label for="username"><i class="zmdi zmdi-account material-icons-name"></i></label>
                            <input type="text" name="username" id="username" placeholder="Your Username" required/>
                        </div>

                        <div class="form-group">
                            <label for="password"><i class="zmdi zmdi-lock"></i></label>
                            <input type="password" name="password" id="password" placeholder="Password" required/>
                        </div>

                        <div class="form-group d-flex justify-content-between align-items-center">

                            <a href="<c:url value='/account/forgot-password'/>" class="signup-image-link" style="margin-top: 0;">Forgot password?</a>
                        </div>

                        <div class="form-group form-button">
                            <input type="submit" name="signin" id="signin" class="form-submit" value="Log in"/>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </section>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="<c:url value='/template/account/js/main.js'/>"></script>
</body>
</html>