<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Role List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<h2>Role Management</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Role Name</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <c:forEach items="${roles}" var="r">
        <tr>
            <td>${r.id}</td>
            <td>${r.name}</td>
            <td>
                <span class="${r.active ? 'status-active' : 'status-inactive'}">
                        ${r.active ? 'Active' : 'Inactive'}
                </span>
            </td>
            <td>
                <a href="role-detail?id=${r.id}">View</a>
                <a href="role-status?id=${r.id}">
                        ${r.active ? 'Deactivate' : 'Activate'}
                </a>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>
