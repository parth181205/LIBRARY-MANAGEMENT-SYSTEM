<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Books &amp; Borrowing History | Amity University Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        .tabs-header {
            display: flex;
            gap: 8px;
            border-bottom: 2px solid var(--border-color);
            margin-bottom: 24px;
        }
        .tab-btn {
            padding: 12px 20px;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--secondary-text);
            border: none;
            background: transparent;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            transition: var(--transition);
        }
        .tab-btn.active {
            color: var(--primary-navy);
            border-bottom-color: var(--primary-navy);
            font-weight: 700;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
</head>
<body>

<div class="app-container">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="app-main">
        <jsp:include page="../common/topbar.jsp" />

        <div class="page-content">
            <div class="page-header">
                <div>
                    <h1 class="page-title">My Library Records</h1>
                    <p class="page-subtitle">Track your currently issued books, renewals, and borrowing history</p>
                </div>
            </div>

            <c:if test="${param.success eq 'renewal_requested'}">
                <div class="alert alert-success">
                    &#10003; Renewal request submitted! A librarian will review your request.
                </div>
            </c:if>

            <c:if test="${param.error eq 'renewal_ineligible'}">
                <div class="alert alert-error">
                    &#9888; Ineligible for renewal: Loan may be overdue, reached maximum renewals (2), or has an active hold.
                </div>
            </c:if>

            <!-- Tabs Header -->
            <div class="tabs-header">
                <button type="button" class="tab-btn ${param.tab ne 'history' && param.tab ne 'renewals' ? 'active' : ''}" onclick="switchTab('issued', this)">
                    Currently Issued (${activeLoans.size()})
                </button>
                <button type="button" class="tab-btn ${param.tab eq 'renewals' ? 'active' : ''}" onclick="switchTab('renewals', this)">
                    Renewal Requests (${renewalRequests.size()})
                </button>
                <button type="button" class="tab-btn ${param.tab eq 'history' ? 'active' : ''}" onclick="switchTab('history', this)">
                    Borrowing History (${history.size()})
                </button>
            </div>

            <!-- Tab 1: Currently Issued -->
            <div id="tab-issued" class="tab-content ${param.tab ne 'history' && param.tab ne 'renewals' ? 'active' : ''}">
                <div class="content-card">
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty activeLoans}">
                                <div class="table-responsive">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Cover</th>
                                                <th>Title &amp; ISBN</th>
                                                <th>Barcode</th>
                                                <th>Issued On</th>
                                                <th>Due Date</th>
                                                <th>Status</th>
                                                <th>Renewals</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="loan" items="${activeLoans}">
                                                <tr style="${loan.currentlyOverdue ? 'background: #FEF2F2;' : ''}">
                                                    <td style="width: 60px;">
                                                        <img src="${pageContext.request.contextPath}/${loan.bookCover}" 
                                                             alt="${loan.bookTitle}" 
                                                             style="width: 44px; height: 60px; object-fit: cover; border-radius: 4px;"
                                                             onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=100&q=80';">
                                                    </td>
                                                    <td>
                                                        <strong style="color: var(--primary-navy);">${loan.bookTitle}</strong>
                                                        <div style="font-size: 0.8rem; color: var(--secondary-text);">ISBN: ${loan.isbn}</div>
                                                    </td>
                                                    <td><code>${loan.barcode}</code></td>
                                                    <td><fmt:formatDate value="${loan.issueDate}" pattern="dd MMM yyyy" /></td>
                                                    <td>
                                                        <span style="${loan.currentlyOverdue ? 'color: var(--error); font-weight: 700;' : 'font-weight: 600;'}">
                                                            <fmt:formatDate value="${loan.dueDate}" pattern="dd MMM yyyy" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${loan.currentlyOverdue}">
                                                                <span class="status-badge status-overdue">Overdue (${loan.daysOverdue} d)</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-available">Active</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><strong>${loan.renewedCount}</strong> / 2</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${!loan.currentlyOverdue && loan.renewedCount < 2}">
                                                                <button type="button" class="btn btn-secondary btn-sm"
                                                                        onclick="postAction('${pageContext.request.contextPath}/student/my-books', {action:'request_renewal', loanId:'${loan.id}'})">
                                                                    Renew (+14d)
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                                    Renew (+14d)
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 50px; text-align: center; color: var(--secondary-text);">
                                    <div style="font-size: 2.5rem; margin-bottom: 12px;">&#128214;</div>
                                    <h4>No Active Loans</h4>
                                    <p>You have not checked out any books currently.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Tab 2: Renewal Requests -->
            <div id="tab-renewals" class="tab-content ${param.tab eq 'renewals' ? 'active' : ''}">
                <div class="content-card">
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty renewalRequests}">
                                <div class="table-responsive">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Book Title</th>
                                                <th>Barcode</th>
                                                <th>Request Date</th>
                                                <th>Status</th>
                                                <th>Librarian Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="req" items="${renewalRequests}">
                                                <tr>
                                                    <td><strong>${req.bookTitle}</strong></td>
                                                    <td><code>${req.barcode}</code></td>
                                                    <td><fmt:formatDate value="${req.requestDate}" pattern="dd MMM yyyy, HH:mm" /></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${req.status eq 'APPROVED'}">
                                                                <span class="status-badge status-available">Approved</span>
                                                            </c:when>
                                                            <c:when test="${req.status eq 'REJECTED'}">
                                                                <span class="status-badge status-overdue">Declined</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-pending">Pending Review</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${not empty req.librarianNotes ? req.librarianNotes : 'Awaiting circulation desk decision'}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 50px; text-align: center; color: var(--secondary-text);">
                                    <div style="font-size: 2.5rem; margin-bottom: 12px;">&#128337;</div>
                                    <h4>No Renewal Requests</h4>
                                    <p>You have not submitted any loan extension requests.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Tab 3: Borrowing History -->
            <div id="tab-history" class="tab-content ${param.tab eq 'history' ? 'active' : ''}">
                <div class="content-card">
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty history}">
                                <div class="table-responsive">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Book Title</th>
                                                <th>Barcode</th>
                                                <th>Issued Date</th>
                                                <th>Due Date</th>
                                                <th>Return Date</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="h" items="${history}">
                                                <tr>
                                                    <td><strong>${h.bookTitle}</strong></td>
                                                    <td><code>${h.barcode}</code></td>
                                                    <td><fmt:formatDate value="${h.issueDate}" pattern="dd MMM yyyy" /></td>
                                                    <td><fmt:formatDate value="${h.dueDate}" pattern="dd MMM yyyy" /></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty h.returnDate}">
                                                                <fmt:formatDate value="${h.returnDate}" pattern="dd MMM yyyy" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: var(--secondary-text);">Not returned</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${h.status eq 'RETURNED'}">
                                                                <span class="status-badge status-available">Returned</span>
                                                            </c:when>
                                                            <c:when test="${h.currentlyOverdue}">
                                                                <span class="status-badge status-overdue">Overdue</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-issued">Active</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 50px; text-align: center; color: var(--secondary-text);">
                                    <div style="font-size: 2.5rem; margin-bottom: 12px;">&#128218;</div>
                                    <h4>No Prior History Found</h4>
                                    <p>Your returned books will appear here over time.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <jsp:include page="../common/footer.jsp" />
    </main>
</div>

<script>
function switchTab(tabName, btn) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('tab-' + tabName).classList.add('active');
}

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
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
