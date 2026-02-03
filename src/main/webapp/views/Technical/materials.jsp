<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h4 class="mb-4">📦 Kho vật tư</h4>

<form method="get"
      action="<c:url value='/technical/materials'/>"
      class="row g-2 mb-3">

    <div class="col-md-4">
        <input type="text"
               name="keyword"
               class="form-control"
               placeholder="Tìm theo tên hoặc mã vật tư"
               value="${param.keyword}">
    </div>

    <div class="col-md-2">
        <button class="btn btn-primary w-100">
            Tìm
        </button>
    </div>
</form>

<table class="table table-bordered bg-white">
    <thead class="table-light">
    <tr>
        <th>#</th>
        <th>Tên vật tư</th>
        <th>Mã</th>
        <th>Đơn vị</th>
        <th>Tồn kho</th>
        <th>Cảnh báo</th>
        <th>Giá</th>
    </tr>
    </thead>
    <tbody>

    <c:if test="${empty parts}">
        <tr>
            <td colspan="7" class="text-center text-muted">
                Không có vật tư
            </td>
        </tr>
    </c:if>

    <c:forEach items="${parts}" var="p" varStatus="i">
        <tr class="${p.quantityInStock <= p.minStockAlert ? 'table-warning' : ''}">
            <td>${i.count}</td>
            <td>${p.name}</td>
            <td>${p.partCode}</td>
            <td>${p.unit}</td>
            <td>${p.quantityInStock}</td>
            <td>${p.minStockAlert}</td>
            <td>
                <c:if test="${p.price != 0}">
                    ${p.price}
                </c:if>
            </td>
        </tr>
    </c:forEach>

    </tbody>
</table>
