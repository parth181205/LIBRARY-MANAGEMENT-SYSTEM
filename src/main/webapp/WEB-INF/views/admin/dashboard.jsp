<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Dashboard | Amity Central Library</title>
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
                    <h1 class="page-title">System Administration &amp; Governance</h1>
                    <p class="page-subtitle">Security audit monitoring, user permissions, and institutional library policies</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">Manage Users</a>
                    <a href="${pageContext.request.contextPath}/admin/settings" class="btn btn-gold">Configure Rules</a>
                </div>
            </div>

            <!-- Stats Grid -->
            <div class="stat-cards-grid">
                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-blue">&#128218;</div>
                    <div>
                        <div class="stat-label">Total Titles</div>
                        <div class="stat-value">${stats.totalTitles}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-green">&#128214;</div>
                    <div>
                        <div class="stat-label">Physical Copies</div>
                        <div class="stat-value">${stats.totalCopies}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper stat-icon-gold">&#128228;</div>
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
            </div>

            <!-- Active Policy Settings Overview -->
            <div class="content-card" style="margin-bottom: 28px;">
                <div class="card-header">
                    <h3 class="card-title">Current Institutional Borrowing Policies</h3>
                    <a href="${pageContext.request.contextPath}/admin/settings" class="btn btn-secondary btn-sm">Edit Policies</a>
                </div>
                <div class="card-body">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                        <div style="padding: 14px; background: #F8FAFC; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
                            <div style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">Max Books / Student</div>
                            <div style="font-size: 1.4rem; font-weight: 700; color: var(--primary-navy);">${settings.max_books_student} books</div>
                        </div>
                        <div style="padding: 14px; background: #F8FAFC; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
                            <div style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">Standard Loan Duration</div>
                            <div style="font-size: 1.4rem; font-weight: 700; color: var(--primary-navy);">${settings.loan_duration_days} days</div>
                        </div>
                        <div style="padding: 14px; background: #F8FAFC; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
                            <div style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">Overdue Fine Rate</div>
                            <div style="font-size: 1.4rem; font-weight: 700; color: var(--primary-navy);">₹${settings.fine_rate_per_day} / day</div>
                        </div>
                        <div style="padding: 14px; background: #F8FAFC; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
                            <div style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">Max Allowed Renewals</div>
                            <div style="font-size: 1.4rem; font-weight: 700; color: var(--primary-navy);">${settings.max_renewals_allowed} times</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Security & Compliance Audit Log Feed -->
            <div class="content-card">
                <div class="card-header">
                    <h3 class="card-title">Security &amp; Operational Audit Trail</h3>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>Actor</th>
                                    <th>Action</th>
                                    <th>Event Details</th>
                                    <th>IP Address</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${auditLogs}">
                                    <tr>
                                        <td><fmt:formatDate value="${log.createdAt}" pattern="dd MMM yyyy, HH:mm:ss" /></td>
                                        <td><strong>${log.userFullName}</strong></td>
                                        <td><span class="status-badge status-active">${log.action}</span></td>
                                        <td>${log.details}</td>
                                        <td><code>${log.ipAddress}</code></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
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
