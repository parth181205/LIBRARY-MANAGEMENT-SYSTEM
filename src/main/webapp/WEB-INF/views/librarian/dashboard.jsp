<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Librarian Dashboard | Amity Central Library</title>
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
                    <h1 class="page-title">Circulation &amp; Library Operations</h1>
                    <p class="page-subtitle">Real-time catalog inventory, loans, overdue monitoring, and patron requests</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/librarian/issue-return" class="btn btn-primary">
                        <span>Issue / Return Desk</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/librarian/books/add" class="btn btn-gold">
                        <span>+ Add Book Title</span>
                    </a>
                </div>
            </div>

            <!-- 8 Live Database-Backed Statistics Cards -->
            <div class="stat-cards-grid" style="grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));">
                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-blue">&#128218;</div>
                    <div>
                        <div class="stat-label">Total Titles</div>
                        <div class="stat-value">${stats.totalTitles}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-gold">&#128214;</div>
                    <div>
                        <div class="stat-label">Total Copies</div>
                        <div class="stat-value">${stats.totalCopies}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-green">&#9989;</div>
                    <div>
                        <div class="stat-label">Available Copies</div>
                        <div class="stat-value">${stats.availableCopies}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-blue">&#128228;</div>
                    <div>
                        <div class="stat-label">Active Loans</div>
                        <div class="stat-value">${stats.activeLoans}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-red">&#9888;</div>
                    <div>
                        <div class="stat-label">Overdue Loans</div>
                        <div class="stat-value">${stats.overdueLoans}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-gold">&#128278;</div>
                    <div>
                        <div class="stat-label">Active Reservations</div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${not empty stats.activeReservationsCount}">
                                    ${stats.activeReservationsCount}
                                </c:when>
                                <c:when test="${stats.activeReservations['class'].simpleName eq 'Integer'}">
                                    ${stats.activeReservations}
                                </c:when>
                                <c:when test="${not empty stats.activeReservations}">
                                    ${stats.activeReservations.size()}
                                </c:when>
                                <c:otherwise>
                                    0
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-red">&#8377;</div>
                    <div>
                        <div class="stat-label">Pending Fines</div>
                        <div class="stat-value">₹${stats.outstandingFines}</div>
                    </div>
                </div>
            </div>

            <!-- Pending Renewal Requests Requiring Decision -->
            <c:if test="${not empty pendingRenewals}">
                <div class="content-card" style="border-left: 4px solid var(--gold-accent);">
                    <div class="card-header" style="background-color: var(--gold-light);">
                        <h3 class="card-title" style="color: #92400E;">
                            Pending Loan Renewal Requests (${pendingRenewals.size()})
                        </h3>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Student</th>
                                        <th>Book Title</th>
                                        <th>Barcode</th>
                                        <th>Current Due Date</th>
                                        <th>Requested On</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="req" items="${pendingRenewals}">
                                        <tr>
                                            <td>
                                                <strong>${req.userFullName}</strong>
                                                <div style="font-size: 0.8rem; color: var(--secondary-text);">${req.userEnrollmentNo}</div>
                                            </td>
                                            <td><strong>${req.bookTitle}</strong></td>
                                            <td><code>${req.barcode}</code></td>
                                            <td><fmt:formatDate value="${req.dueDate}" pattern="dd MMM yyyy" /></td>
                                            <td><fmt:formatDate value="${req.requestDate}" pattern="dd MMM, HH:mm" /></td>
                                            <td>
                                                <div style="display: flex; gap: 8px;">
                                                    <form action="${pageContext.request.contextPath}/librarian/renewals/decision" method="POST" style="display:inline;">
                                                        <input type="hidden" name="requestId" value="${req.id}">
                                                        <input type="hidden" name="decision" value="approve">
                                                        <input type="hidden" name="librarianNotes" value="Approved at circulation desk (+14 days)">
                                                        <button type="submit" class="btn btn-primary btn-sm">&#10003; Approve (+14d)</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/librarian/renewals/decision" method="POST" style="display:inline;">
                                                        <input type="hidden" name="requestId" value="${req.id}">
                                                        <input type="hidden" name="decision" value="reject">
                                                        <input type="hidden" name="librarianNotes" value="High reservation hold demand on this title.">
                                                        <button type="submit" class="btn btn-danger btn-sm">&#10005; Decline</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(480px, 1fr)); gap: 28px;">
                <!-- Overdue Loans Table -->
                <div class="content-card">
                    <div class="card-header">
                        <h3 class="card-title">Urgent: Overdue Loans</h3>
                        <a href="${pageContext.request.contextPath}/librarian/issue-return" class="btn btn-secondary btn-sm">Process Returns</a>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty overdueLoans}">
                                <div class="table-responsive">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Student</th>
                                                <th>Book &amp; Barcode</th>
                                                <th>Due Date</th>
                                                <th>Days Late</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="loan" items="${overdueLoans}">
                                                <tr>
                                                    <td>
                                                        <strong>${loan.userFullName}</strong>
                                                        <div style="font-size: 0.8rem; color: var(--secondary-text);">${loan.userEnrollmentNo}</div>
                                                    </td>
                                                    <td>
                                                        <div style="font-weight: 600;">${loan.bookTitle}</div>
                                                        <code>${loan.barcode}</code>
                                                    </td>
                                                    <td style="color: var(--error); font-weight: 700;">
                                                        <fmt:formatDate value="${loan.dueDate}" pattern="dd MMM yyyy" />
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-overdue">${loan.daysOverdue} Days Late</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 30px; text-align: center; color: var(--secondary-text);">
                                    <p>&#10003; No overdue loans currently!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Recent Loan Activity -->
                <div class="content-card">
                    <div class="card-header">
                        <h3 class="card-title">Recent Loan Activity</h3>
                        <a href="${pageContext.request.contextPath}/librarian/issue-return" class="btn btn-secondary btn-sm">Full History</a>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Student</th>
                                        <th>Title</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="loan" items="${recentLoans}">
                                        <tr>
                                            <td>
                                                <strong>${loan.userFullName}</strong>
                                                <div style="font-size: 0.8rem; color: var(--secondary-text);">${loan.userEnrollmentNo}</div>
                                            </td>
                                            <td>${loan.bookTitle}</td>
                                            <td><fmt:formatDate value="${loan.issueDate}" pattern="dd MMM, HH:mm" /></td>
                                            <td>
                                                <span class="status-badge ${loan.status eq 'RETURNED' ? 'status-available' : (loan.currentlyOverdue ? 'status-overdue' : 'status-issued')}">
                                                    ${loan.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <jsp:include page="../common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
