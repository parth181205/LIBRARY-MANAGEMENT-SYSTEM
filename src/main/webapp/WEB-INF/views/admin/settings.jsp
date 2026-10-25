<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Institutional Library Rules | Amity University</title>
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
                    <h1 class="page-title">Library Rules &amp; Institutional Policy Settings</h1>
                    <p class="page-subtitle">Configure loan limits, loan durations, overdue fine calculations, and hold expiries</p>
                </div>
            </div>

            <c:if test="${param.success eq '1'}">
                <div class="alert alert-success">
                    &#10003; Library policies successfully saved and applied system-wide!
                </div>
            </c:if>

            <div class="content-card" style="max-width: 750px; padding: 36px;">
                <form action="${pageContext.request.contextPath}/admin/settings" method="POST">
                    <input type="hidden" name="action" value="update_settings">

                    <div class="form-group">
                        <label class="form-label">Maximum Simultaneous Books per Student</label>
                        <input type="number" name="max_books_student" class="form-control" value="${settings.max_books_student}" min="1" max="10" required>
                        <small style="color: var(--secondary-text); font-size: 0.8rem;">Maximum number of active loan checkouts allowed per student account.</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Standard Loan Duration (Days)</label>
                        <input type="number" name="loan_duration_days" class="form-control" value="${settings.loan_duration_days}" min="1" max="60" required>
                        <small style="color: var(--secondary-text); font-size: 0.8rem;">Number of days before a borrowed item becomes overdue.</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Overdue Fine Rate per Day (₹)</label>
                        <input type="number" step="0.50" name="fine_rate_per_day" class="form-control" value="${settings.fine_rate_per_day}" min="0.00" max="100.00" required>
                        <small style="color: var(--secondary-text); font-size: 0.8rem;">Daily penalty accrued per overdue title after the due date.</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Maximum Allowed Self-Renewals</label>
                        <input type="number" name="max_renewals_allowed" class="form-control" value="${settings.max_renewals_allowed}" min="0" max="5" required>
                        <small style="color: var(--secondary-text); font-size: 0.8rem;">Maximum times a patron can request to renew an existing loan.</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Reservation Hold Shelf Expiry (Days)</label>
                        <input type="number" name="reservation_expiry_days" class="form-control" value="${settings.reservation_expiry_days}" min="1" max="14" required>
                        <small style="color: var(--secondary-text); font-size: 0.8rem;">Days a reserved book is held at circulation desk before advancing to next in queue.</small>
                    </div>

                    <div style="margin-top: 28px;">
                        <button type="submit" class="btn btn-primary" onclick="return confirm('Apply updated rules to library management system?');">
                            Save Policy Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
