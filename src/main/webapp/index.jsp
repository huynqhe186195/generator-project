<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. Lấy thông tin User từ Session --%>
<c:set var="user" value="${sessionScope.USERMODEL}" />

<c:choose>
    <%-- TRƯỜNG HỢP 1: Chưa đăng nhập (Session rỗng) --%>
    <%-- => Chuyển hướng về trang chủ Landing Page --%>
    <c:when test="${empty user}">
        <c:redirect url="/home"/>
    </c:when>

    <%-- TRƯỜNG HỢP 2: Đã đăng nhập --%>
    <c:otherwise>
        <%-- Kiểm tra xem user này có đường dẫn riêng không (VD: /admin, /manager) --%>
        <c:choose>
            <c:when test="${not empty user.roleUrl}">
                <%-- Có đường dẫn riêng -> Chuyển đúng tuyến --%>
                <c:redirect url="${user.roleUrl}"/>
            </c:when>

            <c:otherwise>
                <%-- Nếu trong DB quên set url -> Về tạm home --%>
                <c:redirect url="/home"/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>