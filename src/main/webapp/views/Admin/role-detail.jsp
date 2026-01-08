<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Role Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<h2>Role Detail</h2>

<table>
    <tr>
        <th width="200">Field</th>
        <th>Value</th>
    </tr>
    <tr>
        <td>ID</td>
        <td>${role.id}</td>
    </tr>
    <tr>
        <td>Name</td>
        <td>${role.name}</td>
    </tr>
    <tr>
        <td>Status</td>
        <td>
            <span class="${role.active ? 'status-active' : 'status-inactive'}">
                ${role.active ? 'Active' : 'Inactive'}
            </span>
        </td>
    </tr>
</table>

<h3 style="margin-top: 20px;">Permissions</h3>
<ul style="margin-top: 10px;">
    <c:forEach items="${permissions}" var="p">
        <li>${p.code}</li>
    </c:forEach>
</ul>

<br>
<a href="role-list.jsp">← Back to Role List</a>

</body>
</html>
