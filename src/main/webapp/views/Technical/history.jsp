<%@ page contentType="text/html; charset=UTF-8"%>
           <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
           <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

           <h4 class="mb-4">📜 Lịch sử sửa chữa</h4>

           <form method="get" action="<c:url value='/technical/history'/>" class="row g-2 mb-3">
               <div class="col-md-3">
                   <input class="form-control" name="serial" placeholder="Serial..."
                          value="${param.serial}"/>
               </div>

               <div class="col-md-3">
                   <input class="form-control" name="customer" placeholder="Khách hàng (tên/sđt)..."
                          value="${param.customer}"/>
               </div>

               <div class="col-md-2">
                   <input type="date" class="form-control" name="dateFrom" value="${param.dateFrom}"/>
               </div>

               <div class="col-md-2">
                   <input type="date" class="form-control" name="dateTo" value="${param.dateTo}"/>
               </div>

               <div class="col-md-2">
                   <button class="btn btn-primary w-100">Lọc</button>
               </div>
               <div class="col-md-2">
                   <a href="<c:url value='/technical/history'/>"
                      class="btn btn-secondary w-100">Reset</a>
               </div>
           </form>

           <table class="table table-bordered bg-white">
               <thead class="table-light">
               <tr>
                   <th>Serial</th>
                   <th>Tên máy</th>
                   <th>Khách hàng</th>
                   <th>Ngày</th>
                   <th>Loại</th>
                   <th>Tổng chi phí</th>
                   <th>Chi tiết</th>
               </tr>
               </thead>

               <tbody>
               <c:if test="${empty tasks}">
                   <tr>
                       <td colspan="7" class="text-center text-muted">Không có dữ liệu</td>
                   </tr>
               </c:if>

               <c:forEach items="${tasks}" var="t">
                   <tr>
                       <td>${t.productSerialNumber}</td>
                       <td>${t.productName}</td>
                       <td>
                           <c:choose>
                               <c:when test="${not empty t.customerName}">
                                   ${t.customerName}
                                   <c:if test="${not empty t.customerPhone}"> - ${t.customerPhone}</c:if>
                               </c:when>
                               <c:otherwise>
                                   -
                               </c:otherwise>
                           </c:choose>
                       </td>
                       <td>
                           <fmt:formatDate value="${t.maintenanceDate}" pattern="dd/MM/yyyy"/>
                       </td>
                       <td>${t.type}</td>
                       <td>
                           <fmt:formatNumber value="${t.totalCost != null ? t.totalCost : 0}" type="number"/> đ
                       </td>
                       <td>
                           <a class="btn btn-sm btn-primary"
                              href="<c:url value='/technical/task-detail?id=${t.id}'/>">
                               Xem
                           </a>
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
                              href="?page=${currentPage - 1}&serial=${param.serial}&customer=${param.customer}&dateFrom=${param.dateFrom}&dateTo=${param.dateTo}">
                               «
                           </a>
                       </li>

                       <c:forEach begin="1" end="${totalPages}" var="i">
                           <li class="page-item ${i == currentPage ? 'active' : ''}">
                               <a class="page-link"
                                  href="?page=${i}&serial=${param.serial}&customer=${param.customer}&dateFrom=${param.dateFrom}&dateTo=${param.dateTo}">
                                       ${i}
                               </a>
                           </li>
                       </c:forEach>

                       <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                           <a class="page-link"
                              href="?page=${currentPage + 1}&serial=${param.serial}&customer=${param.customer}&dateFrom=${param.dateFrom}&dateTo=${param.dateTo}">
                               »
                           </a>
                       </li>
                   </ul>
               </nav>
           </c:if>