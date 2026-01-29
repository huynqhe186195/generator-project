<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Report Task</title>

<div class="container-fluid px-4">

    <h3 class="text-secondary mb-3">
        <i class="fa-solid fa-pen-to-square"></i> Report Maintenance
    </h3>

    <form method="post" action="<c:url value='/technical/task-report'/>">

        <input type="hidden" name="id" value="${task.id}">

        <div class="mb-3">
            <label>Description / Notes</label>
            <textarea name="description" class="form-control" rows="4">${task.description}</textarea>
        </div>

        <button type="submit" class="btn btn-primary">
            Save Report
        </button>

        <a href="<c:url value='/technical/task-detail?id=${task.id}'/>"
           class="btn btn-secondary">
            Cancel
        </a>

    </form>
</div>
