<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Queue Manager | Amity University Library</title>
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
                    <h1 class="page-title">Patron Reservation Queue Manager</h1>
                    <p class="page-subtitle">Track book holds, allocate returned copies, and dispatch pickup alerts</p>
                </div>
            </div>

            <c:if test="${param.updated eq '1'}">
                <div class="alert alert-success">
                    &#10003; Reservation status successfully updated!
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
                                            <th>ID</th>
                                            <th>Student</th>
                                            <th>Book Title &amp; ISBN</th>
                                            <th>Queue Pos</th>
                                            <th>Reserved On</th>
                                            <th>Hold Expiry</th>
                                            <th>Status</th>
                                            <th>Update Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${reservations}">
                                            <tr>
                                                <td>#${r.id}</td>
                                                <td>
                                                    <strong>${r.userFullName}</strong>
                                                    <div style="font-size: 0.8rem; color: var(--secondary-text);">${r.userEnrollmentNo}</div>
                                                </td>
                                                <td>
                                                    <strong>${r.bookTitle}</strong>
                                                    <div style="font-size: 0.8rem; color: var(--secondary-text);">ISBN: ${r.isbn}</div>
                                                </td>
                                                <td><strong>#${r.queuePosition}</strong></td>
                                                <td><fmt:formatDate value="${r.reservationDate}" pattern="dd MMM yyyy" /></td>
                                                <td><fmt:formatDate value="${r.expiryDate}" pattern="dd MMM yyyy" /></td>
                                                <td>
                                                    <span class="status-badge ${r.status eq 'READY_FOR_PICKUP' ? 'status-available' : (r.status eq 'FULFILLED' ? 'status-active' : 'status-pending')}">
                                                        ${r.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 6px;">
                                                        <select id="res_status_${r.id}" class="form-control" style="padding: 4px 8px; font-size: 0.82rem; height: 32px; width: auto;">
                                                            <option value="READY_FOR_PICKUP" ${r.status eq 'READY_FOR_PICKUP' ? 'selected' : ''}>Ready for Pickup</option>
                                                            <option value="CONFIRMED" ${r.status eq 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                                            <option value="FULFILLED" ${r.status eq 'FULFILLED' ? 'selected' : ''}>Fulfilled</option>
                                                            <option value="CANCELLED" ${r.status eq 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                                        </select>
                                                        <button type="button" class="btn btn-primary btn-sm" style="padding: 4px 10px; height: 32px;"
                                                                onclick="postAction('${pageContext.request.contextPath}/librarian/reservations', {action:'update_status', reservationId:'${r.id}', status: document.getElementById('res_status_${r.id}').value})">Update</button>
                                                    </div>
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
                                <p>All patron book holds are currently fulfilled or expired.</p>
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
