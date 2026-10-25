<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User &amp; Role Management | Amity University</title>
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
                    <h1 class="page-title">User &amp; Patron Directory</h1>
                    <p class="page-subtitle">Manage student, librarian, and administrator accounts and enforce access statuses</p>
                </div>
            </div>

            <c:if test="${param.updated eq '1'}">
                <div class="alert alert-success">
                    &#10003; User status updated successfully.
                </div>
            </c:if>

            <!-- Search Bar -->
            <div class="content-card" style="padding: 18px 24px; margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/admin/users" method="GET" style="display: flex; gap: 12px; max-width: 600px;">
                    <input type="text" name="search" class="form-control" placeholder="Search by name, enrollment ID, or email..." value="${searchQuery}">
                    <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">Search</button>
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Clear</a>
                    </c:if>
                </form>
            </div>

            <!-- Users Table -->
            <div class="content-card">
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Enrollment / Employee ID</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Department</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${userList}">
                                    <tr>
                                        <td>#${u.id}</td>
                                        <td><strong>${u.fullName}</strong></td>
                                        <td><code>${u.enrollmentNo}</code></td>
                                        <td>${u.email}</td>
                                        <td>
                                            <span class="status-badge ${u.admin ? 'status-overdue' : (u.librarian ? 'status-pending' : 'status-active')}">
                                                ${u.roleName}
                                            </span>
                                        </td>
                                        <td>${not empty u.department ? u.department : 'Central Staff'}</td>
                                        <td>
                                            <span class="status-badge ${u.active ? 'status-available' : 'status-overdue'}">
                                                ${u.status}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${!u.admin}">
                                                <c:choose>
                                                    <c:when test="${u.active}">
                                                        <button type="button" class="btn btn-secondary btn-sm" style="color: var(--error);"
                                                                onclick="postAction('${pageContext.request.contextPath}/admin/users', {action:'toggle_user_status', userId:'${u.id}', status:'SUSPENDED'})">
                                                            Suspend
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-primary btn-sm"
                                                                onclick="postAction('${pageContext.request.contextPath}/admin/users', {action:'toggle_user_status', userId:'${u.id}', status:'ACTIVE'})">
                                                            Activate
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination" style="padding: 20px;">
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <a href="${pageContext.request.contextPath}/admin/users?page=${p}&search=${searchQuery}" 
                                   class="page-item ${p == currentPage ? 'active' : ''}">${p}</a>
                            </c:forEach>
                        </div>
                    </c:if>
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
