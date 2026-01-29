<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h4 class="mb-3">📋 Chi tiết công việc</h4>

<p><b>Mã máy:</b> ${task.productId}</p>
<p><b>Loại bảo trì:</b> ${task.type}</p>
<p><b>Trạng thái:</b>
  <span class="badge
        ${task.status == 'SCHEDULED' ? 'bg-warning' :
          task.status == 'COMPLETED' ? 'bg-success' : 'bg-secondary'}">
    ${task.status}
  </span>
</p>

<p><b>Mô tả:</b> ${task.description}</p>

<hr>

<c:if test="${task.status == 'SCHEDULED'}">
  <a class="btn btn-warning"
     href="<c:url value='/technical/task-start?id=${task.id}'/>">
    ▶️ Bắt đầu
  </a>
</c:if>

<a class="btn btn-secondary"
   href="<c:url value='/technical/task-report?id=${task.id}'/>">
  📝 Báo cáo
</a>

<c:if test="${task.status != 'COMPLETED'}">
  <a class="btn btn-success"
     href="<c:url value='/technical/task-complete?id=${task.id}'/>">
    ✅ Hoàn thành
  </a>
</c:if>
