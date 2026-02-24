<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="mb-0 text-primary"><i class="fa fa-inbox"></i> Yêu cầu NEW_PRODUCT từ Manager</h3>
    <a href="${pageContext.request.contextPath}/it/home" class="btn btn-outline-secondary btn-sm">Về dashboard</a>
</div>
<div class="alert alert-info py-2">Duyệt request = IT xác nhận tiếp nhận và tải file Excel về để import ở màn Quản lý Product Model.</div>

<c:if test="${param.msg == 'success'}">
    <div class="alert alert-success">Xử lý yêu cầu thành công.</div>
</c:if>
<c:if test="${param.msg == 'error'}">
    <div class="alert alert-danger">Có lỗi xảy ra khi xử lý yêu cầu.</div>
</c:if>

<div class="card shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Manager</th>
                    <th>Nội dung</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th class="text-end">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${requests}">
                    <tr>
                        <td>#${r.id}</td>
                        <td>${r.senderId}</td>
                        <td>
                            <code>${fn:escapeXml(r.requestData)}</code>
                        </td>
                        <td><span class="badge bg-warning text-dark">${r.status}</span></td>
                        <td>${r.createdAt}</td>
                        <td class="text-end">
                            <a href="${pageContext.request.contextPath}/it/requests?action=download&id=${r.id}"
                               class="btn btn-primary btn-sm">
                                <i class="fa fa-download"></i> Tải Excel
                            </a>

                            <form action="${pageContext.request.contextPath}/it/requests" method="post" class="d-inline ms-1">
                                <input type="hidden" name="action" value="approve"/>
                                <input type="hidden" name="requestId" value="${r.id}"/>
                                <button type="submit" class="btn btn-success btn-sm"
                                        onclick="return confirm('Duyệt yêu cầu #${r.id}?');">
                                    <i class="fa fa-check"></i> Duyệt
                                </button>
                            </form>

                            <form action="${pageContext.request.contextPath}/it/requests" method="post" class="d-inline ms-1">
                                <input type="hidden" name="action" value="reject"/>
                                <input type="hidden" name="requestId" value="${r.id}"/>
                                <input type="hidden" name="responseMessage" value="IT từ chối tạo sản phẩm mới"/>
                                <button type="submit" class="btn btn-danger btn-sm"
                                        onclick="return confirm('Từ chối yêu cầu #${r.id}?');">
                                    <i class="fa fa-times"></i> Từ chối
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty requests}">
                    <tr>
                        <td colspan="6" class="text-center text-muted py-4">Không có yêu cầu NEW_PRODUCT đang chờ.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
