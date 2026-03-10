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


<form method="post"
      action="<c:url value='${not empty editPart ? "/technical/spare-part-update" : "/technical/spare-part-create"}'/>"
      class="card card-body mb-3">

  <input type="hidden" name="id" value="${editPart.id}"/>

  <div class="row g-2">
    <div class="col-md-3">
      <input class="form-control" name="name" placeholder="Tên vật tư" value="${editPart.name}" required/>
    </div>
    <div class="col-md-2">
      <input class="form-control" name="partCode" placeholder="Mã" value="${editPart.partCode}" required/>
    </div>
    <div class="col-md-1">
      <input class="form-control" name="unit" placeholder="Đơn vị" value="${editPart.unit}" required/>
    </div>
    <div class="col-md-2">
      <input type="number" class="form-control" name="quantityInStock" placeholder="Tồn kho" value="${editPart.quantityInStock}" required/>
    </div>
    <div class="col-md-1">
      <input type="number" class="form-control" name="minStockAlert" placeholder="Cảnh báo" value="${editPart.minStockAlert}" required/>
    </div>
    <div class="col-md-2">
      <input type="number" step="0.01" class="form-control" name="price" placeholder="Giá" value="${editPart.price}" required/>
    </div>
    <div class="col-md-1 d-grid">
      <button class="btn btn-success">${not empty editPart ? "Lưu" : "Thêm"}</button>
    </div>
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
        <th>Thao tác </th>
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
            <td class="text-nowrap">
              <a class="btn btn-sm btn-outline-primary"
                 href="<c:url value='/technical/spare-part-update?editId=${p.id}'/>">Sửa</a>

              <form method="post" action="<c:url value='/technical/spare-part-delete'/>"
                    style="display:inline">
                <input type="hidden" name="id" value="${p.id}"/>
                <button class="btn btn-sm btn-outline-danger"
                        onclick="return confirm('Xóa vật tư này?')">Xóa</button>
              </form>
            </td>
        </tr>
    </c:forEach>

    </tbody>
</table>


<c:if test="${totalPages > 1}">
<nav>
    <ul class="pagination justify-content-center">

        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
            <a class="page-link"
               href="?page=${currentPage - 1}&keyword=${keyword}">
                «
            </a>
        </li>

        <c:forEach begin="1" end="${totalPages}" var="i">
            <li class="page-item ${i == currentPage ? 'active' : ''}">
                <a class="page-link"
                   href="?page=${i}&keyword=${keyword}">
                    ${i}
                </a>
            </li>
        </c:forEach>

        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
            <a class="page-link"
               href="?page=${currentPage + 1}&keyword=${keyword}">
                »
            </a>
        </li>

    </ul>
</nav>
</c:if>
