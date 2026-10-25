<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fine Collections &amp; Waivers | Amity Central Library</title>
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
                    <h1 class="page-title">Fines, Counter Collections &amp; Waivers</h1>
                    <p class="page-subtitle">Settle overdue penalties, record cash/card counter payments, and process authorized waivers</p>
                </div>
            </div>

            <c:if test="${param.recorded eq '1'}">
                <div class="alert alert-success">
                    &#10003; Payment successfully recorded at circulation desk! Receipt issued.
                </div>
            </c:if>

            <c:if test="${param.waived eq '1'}">
                <div class="alert alert-success">
                    &#10003; Fine waiver processed and recorded in security audit logs.
                </div>
            </c:if>

            <!-- Pending Fines Section -->
            <div class="content-card">
                <div class="card-header">
                    <h3 class="card-title">Assessed Overdue Fines</h3>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Student Name</th>
                                    <th>Enrollment ID</th>
                                    <th>Book &amp; Barcode</th>
                                    <th>Amount</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Counter Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="f" items="${fines}">
                                    <tr>
                                        <td>#${f.id}</td>
                                        <td><strong>${f.userFullName}</strong></td>
                                        <td><code>${f.userEnrollmentNo}</code></td>
                                        <td>
                                            <div>${f.bookTitle}</div>
                                            <code>${f.barcode}</code>
                                        </td>
                                        <td><strong style="color: var(--primary-navy); font-size: 1.05rem;">₹${f.amount}</strong></td>
                                        <td>${f.reason}</td>
                                        <td>
                                            <span class="status-badge ${f.status eq 'PAID' ? 'status-available' : (f.status eq 'WAIVED' ? 'status-active' : 'status-overdue')}">
                                                ${f.status}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${f.pending}">
                                                <div style="display: flex; gap: 6px;">
                                                    <!-- Record Payment Form -->
                                                    <form action="${pageContext.request.contextPath}/librarian/fines" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="record_payment">
                                                        <input type="hidden" name="fineId" value="${f.id}">
                                                        <input type="hidden" name="studentId" value="${f.userId}">
                                                        <input type="hidden" name="amount" value="${f.amount}">
                                                        <input type="hidden" name="method" value="CASH">
                                                        <input type="hidden" name="notes" value="Paid at central library circulation desk">
                                                        <button type="submit" class="btn btn-primary btn-sm">
                                                            Record Cash
                                                        </button>
                                                    </form>

                                                    <!-- Waive Fine Form -->
                                                    <form action="${pageContext.request.contextPath}/librarian/fines" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="waive">
                                                        <input type="hidden" name="fineId" value="${f.id}">
                                                        <input type="hidden" name="reason" value="Authorized academic waiver by librarian">
                                                        <button type="submit" class="btn btn-secondary btn-sm" style="color: var(--error);">
                                                            Waive
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Collected Payments Table -->
            <div class="content-card" style="margin-top: 32px;">
                <div class="card-header">
                    <h3 class="card-title">Completed Payment Transactions &amp; Receipts</h3>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Transaction Ref</th>
                                    <th>Student</th>
                                    <th>Amount</th>
                                    <th>Method</th>
                                    <th>Recorded By</th>
                                    <th>Date</th>
                                    <th>Receipt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${payments}">
                                    <tr>
                                        <td><code>${p.transactionRef}</code></td>
                                        <td>
                                            <strong>${p.userFullName}</strong>
                                            <div style="font-size: 0.8rem; color: var(--secondary-text);">${p.userEnrollmentNo}</div>
                                        </td>
                                        <td><strong>₹${p.amountPaid}</strong></td>
                                        <td><span class="status-badge status-active">${p.paymentMethod}</span></td>
                                        <td>${not empty p.recordedByName ? p.recordedByName : 'Online Simulated Gateway'}</td>
                                        <td><fmt:formatDate value="${p.paymentDate}" pattern="dd MMM yyyy, HH:mm" /></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/receipt?id=${p.id}" class="btn btn-secondary btn-sm" target="_blank">
                                                Receipt
                                            </a>
                                        </td>
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
