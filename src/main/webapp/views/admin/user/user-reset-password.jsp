<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="currentUser" value="${sessionScope.USERMODEL}" />

<title>Password Reset Requests</title>

<div class="container-fluid px-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">Password Reset Requests</h3>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-${sessionScope.alertType != null ? sessionScope.alertType : 'info'} alert-dismissible fade show" role="alert">
                ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <%-- Xóa message sau khi hiển thị để không hiện lại khi F5 --%>
            <c:remove var="message" scope="session"/>
            <c:remove var="alertType" scope="session"/>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">

            <table class="table table-hover table-bordered mb-0 text-center align-middle">
                <thead class="table-secondary">
                <tr>
                    <th style="width:5%">#</th>
                    <th style="width:25%">Email Account</th>
                    <th style="width:25%">Full Name</th>
                    <th style="width:20%">Requested Time</th>
                    <th style="width:25%">Action</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${list}" var="req" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>

                        <td class="fw-semibold text-start ps-4">
                            <i class="fa-solid fa-envelope text-muted me-2"></i> ${req.email}
                        </td>

                        <td class="text-start">${req.fullName}</td>

                        <td>
                                <span class="badge bg-light text-dark border">
                                    <i class="fa-regular fa-clock"></i>
                                    <fmt:formatDate value="${req.requestedTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                        </td>

                        <td>
                            <form action="<c:url value='/admin/approve-reset'/>" method="post" style="display:inline;">
                                <input type="hidden" name="token" value="${req.token}">
                                <input type="hidden" name="email" value="${req.email}">

                                <button type="submit" name="action" value="approve"
                                        class="btn btn-success btn-sm me-1"
                                        onclick="return confirm('Duyệt yêu cầu này?');"
                                        title="Duyệt & Gửi Link">
                                    <i class="fa-solid fa-check"></i> Duyệt
                                </button>

                                <button type="submit" name="action" value="reject"
                                        class="btn btn-danger btn-sm"
                                        onclick="return confirm('Bạn chắc chắn muốn TỪ CHỐI yêu cầu này?');"
                                        title="Từ chối yêu cầu">
                                    <i class="fa-solid fa-xmark"></i> Từ chối
                                </button>
                            </form>

                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty list}">
                    <tr>
                        <td colspan="5" class="text-muted py-5">
                            <i class="fa-solid fa-inbox fa-3x mb-3"></i><br>
                            Không có yêu cầu đặt lại mật khẩu nào đang chờ xử lý.
                        </td>
                    </tr>
                </c:if>
                </tbody>

            </table>
        </div>
    </div>
</div>