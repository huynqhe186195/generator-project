<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Generator CMS</title>

    <link rel="stylesheet" href="<c:url value='/template/account/fonts/material-icon/css/material-design-iconic-font.min.css'/>">
    <link rel="stylesheet" href="<c:url value='/template/account/css/login-style.css'/>">
</head>
<body>

<div class="main">
    <section class="sign-in">
        <div class="container">
            <div class="signin-content no-image">

                <div class="signin-form">
                    <h2 class="form-title text-center">Mật khẩu mới</h2>

                    <c:if test="${not empty message}">
                        <div class="text-center" style="color: red; margin-bottom: 15px; font-size: 14px; font-weight: bold;">
                                ${message}
                        </div>
                    </c:if>

                    <form method="POST" action="<c:url value='/account/reset-password'/>" class="register-form" id="reset-form">
                        <input type="hidden" name="token" value="${token}">

                        <div class="form-group">
                            <label for="password"><i class="zmdi zmdi-lock"></i></label>
                            <input type="password" name="password" id="password" placeholder="Mật khẩu mới" required/>
                        </div>

                        <div class="form-group">
                            <label for="re-password"><i class="zmdi zmdi-lock-outline"></i></label>
                            <input type="password" name="re_password" id="re-password" placeholder="Nhập lại mật khẩu" required/>
                        </div>

                        <div class="form-group form-button text-center">
                            <input type="submit" name="reset" id="reset" class="form-submit" value="Cập nhật mật khẩu"/>
                        </div>
                    </form>

                    <a href="<c:url value='/login'/>" class="back-link">
                        <i class="zmdi zmdi-arrow-left"></i> Quay lại Đăng nhập
                    </a>
                </div>
            </div>
        </div>
    </section>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Kiểm tra khớp mật khẩu bằng JS
    $('#reset-form').submit(function(e) {
        var pass = $('#password').val();
        var rePass = $('#re-password').val();
        if (pass !== rePass) {
            e.preventDefault();
            alert("Mật khẩu nhập lại không khớp!");
        }
    });
</script>
</body>
</html>