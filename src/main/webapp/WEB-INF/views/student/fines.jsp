<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fines &amp; Payments | Amity University Library</title>
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
                    <h1 class="page-title">Fines &amp; Payment Transactions</h1>
                    <p class="page-subtitle">Track overdue penalties, clearance receipts, and settle dues online</p>
                </div>
            </div>

            <c:if test="${param.paid eq '1'}">
                <div class="alert alert-success">
                    &#10003; Simulated payment completed successfully! Fine cleared and receipt generated.
                </div>
            </c:if>

            <!-- Outstanding Dues Summary Card -->
            <div class="stat-card" style="margin-bottom: 28px; background: linear-gradient(135deg, #FFFBEB 0%, #FEF3C7 100%); border-color: #FDE68A;">
                <div class="stat-icon-wrapper" style="background: #F59E0B; color: #FFFFFF;">&#8377;</div>
                <div style="flex: 1;">
                    <div class="stat-label" style="color: #92400E;">Total Outstanding Library Dues</div>
                    <div class="stat-value" style="color: #78350F;">₹${totalPending}</div>
                </div>
                <div>
                    <c:if test="${totalPending > 0}">
                        <span class="status-badge status-overdue">Dues Pending</span>
                    </c:if>
                    <c:if test="${totalPending == 0}">
                        <span class="status-badge status-available">All Dues Cleared</span>
                    </c:if>
                </div>
            </div>

            <!-- Fines Table -->
            <div class="content-card">
                <div class="card-header">
                    <h3 class="card-title">Pending &amp; Assessed Overdue Fines</h3>
                </div>
                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty fines}">
                            <div class="table-responsive">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Book Title</th>
                                            <th>Barcode</th>
                                            <th>Date Incurred</th>
                                            <th>Amount</th>
                                            <th>Reason</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="f" items="${fines}">
                                            <tr>
                                                <td><strong>${f.bookTitle}</strong></td>
                                                <td><code>${f.barcode}</code></td>
                                                <td><fmt:formatDate value="${f.createdAt}" pattern="dd MMM yyyy" /></td>
                                                <td><strong style="color: var(--primary-navy); font-size: 1.05rem;">₹${f.amount}</strong></td>
                                                <td>${f.reason}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${f.status eq 'PAID'}">
                                                            <span class="status-badge status-available">Settled</span>
                                                        </c:when>
                                                        <c:when test="${f.status eq 'WAIVED'}">
                                                            <span class="status-badge status-active">Waived</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-overdue">Unpaid</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${f.pending}">
                                                        <!-- Trigger Simulated Online Payment Form -->
                                                        <form action="${pageContext.request.contextPath}/student/fines" method="POST" style="display:inline;">
                                                            <input type="hidden" name="action" value="pay_simulated">
                                                            <input type="hidden" name="fineId" value="${f.id}">
                                                            <input type="hidden" name="amount" value="${f.amount}">
                                                            <input type="hidden" name="method" value="ONLINE_SIMULATED">
                                                            <button type="submit" class="btn btn-gold btn-sm">
                                                                Pay Online (Simulated)
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 40px; text-align: center; color: var(--secondary-text);">
                                <div style="font-size: 2.5rem; margin-bottom: 12px;">&#10003;</div>
                                <h4>No Fines on Record</h4>
                                <p>You have maintained a spotless record with no late fees!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Payment Receipts History -->
            <div class="content-card" style="margin-top: 32px;">
                <div class="card-header">
                    <h3 class="card-title">Cleared Payment Receipts</h3>
                </div>
                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty payments}">
                            <div class="table-responsive">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Transaction Ref</th>
                                            <th>Amount Paid</th>
                                            <th>Payment Method</th>
                                            <th>Payment Date</th>
                                            <th>Receipt</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${payments}">
                                            <tr>
                                                <td><code>${p.transactionRef}</code></td>
                                                <td><strong>₹${p.amountPaid}</strong></td>
                                                <td><span class="status-badge status-active">${p.paymentMethod}</span></td>
                                                <td><fmt:formatDate value="${p.paymentDate}" pattern="dd MMM yyyy, HH:mm" /></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/receipt?id=${p.id}" class="btn btn-secondary btn-sm" target="_blank">
                                                        View Receipt
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 30px; text-align: center; color: var(--secondary-text);">
                                <p>No payment receipts recorded.</p>
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
</body>
</html>
