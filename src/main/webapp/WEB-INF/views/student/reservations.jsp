<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations | Amity University Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<div class="app-container">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="app-main">
        <jsp:include page="../common/topbar.jsp" />

        <div class="page-content">
            <div class="page-header">
                <div>
                    <h1 class="page-title">My Book Reservations</h1>
                    <p class="page-subtitle">Manage holds and track pickup availability for popular titles</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-primary btn-sm">Find More Books</a>
                </div>
            </div>

            <c:if test="${param.cancelled eq '1'}">
                <div class="alert alert-success">
                    &#10003; Reservation cancelled successfully.
                </div>
            </c:if>

            <div class="content-card">
                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty reservations}">
                            <div class="table-responsive">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Book Title</th>
                                            <th>ISBN</th>
                                            <th>Reserved On</th>
                                            <th>Expiry Date</th>
                                            <th>Queue Position</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="res" items="${reservations}">
                                            <tr>
                                                <td>
                                                    <strong>${res.bookTitle}</strong>
                                                </td>
                                                <td><code>${res.isbn}</code></td>
                                                <td><fmt:formatDate value="${res.reservationDate}" pattern="dd MMM yyyy" /></td>
                                                <td><fmt:formatDate value="${res.expiryDate}" pattern="dd MMM yyyy" /></td>
                                                <td>
                                                    <span style="font-weight: 700; color: var(--primary-navy);">#${res.queuePosition}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${res.status eq 'READY_FOR_PICKUP'}">
                                                            <span class="status-badge status-available">Ready at Counter</span>
                                                        </c:when>
                                                        <c:when test="${res.status eq 'PENDING' || res.status eq 'CONFIRMED'}">
                                                            <span class="status-badge status-pending">In Queue</span>
                                                        </c:when>
                                                        <c:when test="${res.status eq 'FULFILLED'}">
                                                            <span class="status-badge status-active">Fulfilled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-overdue">${res.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${res.active}">
                                                        <button type="button" class="btn btn-secondary btn-sm" style="color: var(--error);"
                                                                onclick="postAction('${pageContext.request.contextPath}/student/reservations', {action:'cancel', reservationId:'${res.id}'})">
                                                            Cancel
                                                        </button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 50px; text-align: center; color: var(--secondary-text);">
                                <div style="font-size: 2.5rem; margin-bottom: 12px;">&#128278;</div>
                                <h4>No Active Reservations</h4>
                                <p>You have not placed holds on any books currently.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script>
function postAction(url, params) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = url;
    form.style.display = 'none';
    for (var key in params) {
        if (params.hasOwnProperty(key)) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = params[key];
            form.appendChild(input);
        }
    }
    document.body.appendChild(form);
    form.submit();
}
</script>
</body>
</html>
