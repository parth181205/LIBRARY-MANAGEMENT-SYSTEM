<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue &amp; Return Circulation Desk | Amity University Library</title>
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
                    <h1 class="page-title">Circulation Counter &bull; Issue &amp; Return</h1>
                    <p class="page-subtitle">Scan student barcodes, verify borrowing eligibility, and process loan returns</p>
                </div>
            </div>

            <c:if test="${param.success eq 'issued'}">
                <div class="alert alert-success">
                    &#10003; Book copy successfully issued to student! Loan ID #${param.loanId} recorded.
                </div>
            </c:if>

            <c:if test="${param.success.startsWith('returned')}">
                <div class="alert alert-success">
                    &#10003; Book copy checked in and marked AVAILABLE. Loan closed successfully!
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-error">
                    &#9888; Transaction Rejected: ${param.error}
                </div>
            </c:if>

            <!-- Dual Column Desk Interface -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(440px, 1fr)); gap: 28px; margin-bottom: 32px;">
                
                <!-- STEP 1: PATRON VERIFICATION -->
                <div class="content-card">
                    <div class="card-header" style="background-color: var(--navy-ultra-light);">
                        <h3 class="card-title" style="font-size: 1.15rem;">1. Student / Patron Verification</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/librarian/issue-return" method="GET" style="display: flex; gap: 10px; margin-bottom: 20px;">
                            <input type="text" name="studentQuery" class="form-control" placeholder="Scan or enter Enrollment ID / Email..." value="${param.studentQuery}" required autofocus>
                            <input type="hidden" name="bookQuery" value="${param.bookQuery}">
                            <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">Lookup</button>
                        </form>

                        <c:if test="${not empty studentError}">
                            <div class="alert alert-error" style="padding: 10px 14px; font-size: 0.88rem;">${studentError}</div>
                        </c:if>

                        <c:choose>
                            <c:when test="${not empty selectedStudent}">
                                <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 18px;">
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                                        <div>
                                            <h4 style="color: var(--primary-navy); font-size: 1.15rem;">${selectedStudent.fullName}</h4>
                                            <div style="font-size: 0.88rem; color: var(--secondary-text);">${selectedStudent.enrollmentNo} &bull; ${selectedStudent.course}</div>
                                        </div>
                                        <span class="status-badge ${selectedStudent.active ? 'status-available' : 'status-overdue'}">${selectedStudent.status}</span>
                                    </div>

                                    <div style="font-size: 0.85rem; color: var(--secondary-text); line-height: 1.6;">
                                        <div>Department: <strong>${selectedStudent.department}</strong></div>
                                        <div>Email: <strong>${selectedStudent.email}</strong></div>
                                        <div>Active Loans: <strong>${studentActiveLoans.size()} / 3</strong></div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 30px; text-align: center; color: var(--secondary-text); background: var(--main-bg); border-radius: var(--radius-md);">
                                    Enter an Enrollment ID (e.g. <code>A2305221001</code>) to load patron profile.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- STEP 2: BOOK / COPY VERIFICATION & DISPATCH -->
                <div class="content-card">
                    <div class="card-header" style="background-color: var(--navy-ultra-light);">
                        <h3 class="card-title" style="font-size: 1.15rem;">2. Book / Barcode Scan &amp; Action</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/librarian/issue-return" method="GET" style="display: flex; gap: 10px; margin-bottom: 20px;">
                            <input type="text" name="bookQuery" class="form-control" placeholder="Scan Copy Barcode (e.g. AM-1-001) or ISBN..." value="${param.bookQuery}" required>
                            <input type="hidden" name="studentQuery" value="${param.studentQuery}">
                            <button type="submit" class="btn btn-primary" style="flex-shrink: 0;">Scan</button>
                        </form>

                        <c:if test="${not empty bookError}">
                            <div class="alert alert-error" style="padding: 10px 14px; font-size: 0.88rem;">${bookError}</div>
                        </c:if>

                        <c:choose>
                            <%-- A SPECIFIC COPY SCANNED --%>
                            <c:when test="${not empty scannedCopy}">
                                <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 18px; margin-bottom: 20px;">
                                    <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                        <h4 style="color: var(--primary-navy);">${scannedBook.title}</h4>
                                        <span class="status-badge ${scannedCopy.available ? 'status-available' : 'status-issued'}">${scannedCopy.status}</span>
                                    </div>
                                    <div style="font-size: 0.88rem; color: var(--secondary-text);">
                                        Barcode: <code>${scannedCopy.barcode}</code> &bull; Location: <strong>${scannedCopy.rackLocation}</strong>
                                    </div>
                                </div>

                                <div style="display: flex; gap: 12px;">
                                    <c:if test="${scannedCopy.available}">
                                        <form action="${pageContext.request.contextPath}/librarian/issue-return" method="POST" style="flex: 1;">
                                            <input type="hidden" name="action" value="issue">
                                            <input type="hidden" name="copyId" value="${scannedCopy.id}">
                                            <input type="hidden" name="studentId" value="${selectedStudent.id}">
                                            <button type="submit" class="btn btn-primary" style="width: 100%;" ${empty selectedStudent || !selectedStudent.active ? 'disabled' : ''}>
                                                &#10003; Issue to ${empty selectedStudent ? 'Student (Select First)' : selectedStudent.fullName}
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${scannedCopy.status eq 'ISSUED' || scannedCopy.status eq 'OVERDUE' || !scannedCopy.available}">
                                        <button type="button" class="btn btn-gold" style="flex: 1;"
                                                onclick="postAction('${pageContext.request.contextPath}/librarian/issue-return', {action:'return', copyId:'${scannedCopy.id}'})">
                                            &#10558; Check-in &amp; Return Book (Calculate Overdue)
                                        </button>
                                    </c:if>
                                </div>
                            </c:when>

                            <%-- BOOK SCANNED BY ISBN --%>
                            <c:when test="${not empty scannedBook}">
                                <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 18px; margin-bottom: 16px;">
                                    <h4 style="color: var(--primary-navy);">${scannedBook.title}</h4>
                                    <p style="font-size: 0.85rem; color: var(--secondary-text);">ISBN: ${scannedBook.isbn} &bull; Available Copies: ${availableCopies.size()}</p>
                                </div>

                                <h5 style="margin-bottom: 8px; color: var(--primary-navy);">Select Available Copy to Issue:</h5>
                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                    <c:forEach var="c" items="${availableCopies}">
                                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; background: #FFFFFF; border: 1px solid var(--border-color); border-radius: 8px;">
                                            <div>
                                                <code>${c.barcode}</code> &bull; <strong>${c.rackLocation}</strong>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/librarian/issue-return" method="POST">
                                                <input type="hidden" name="action" value="issue">
                                                <input type="hidden" name="copyId" value="${c.id}">
                                                <input type="hidden" name="studentId" value="${selectedStudent.id}">
                                                <button type="submit" class="btn btn-primary btn-sm" ${empty selectedStudent || !selectedStudent.active ? 'disabled' : ''}>
                                                    Issue Copy
                                                </button>
                                            </form>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div style="padding: 30px; text-align: center; color: var(--secondary-text); background: var(--main-bg); border-radius: var(--radius-md);">
                                    Scan a physical copy barcode (e.g. <code>AM-1-001</code>) or book ISBN.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>

            <!-- Recent Circulation Desk Transaction Log -->
            <div class="content-card">
                <div class="card-header">
                    <h3 class="card-title">Recent Desk Circulation Transactions</h3>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Loan ID</th>
                                    <th>Patron Name</th>
                                    <th>Enrollment ID</th>
                                    <th>Book Title</th>
                                    <th>Barcode</th>
                                    <th>Issued On</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Quick Return</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${recentTransactions}">
                                    <tr>
                                        <td>#${t.id}</td>
                                        <td><strong>${t.userFullName}</strong></td>
                                        <td><code>${t.userEnrollmentNo}</code></td>
                                        <td>${t.bookTitle}</td>
                                        <td><code>${t.barcode}</code></td>
                                        <td><fmt:formatDate value="${t.issueDate}" pattern="dd MMM yyyy, HH:mm" /></td>
                                        <td>
                                            <span style="${t.currentlyOverdue ? 'color: var(--error); font-weight: 700;' : ''}">
                                                <fmt:formatDate value="${t.dueDate}" pattern="dd MMM yyyy" />
                                            </span>
                                        </td>
                                        <td>
                                            <span class="status-badge ${t.status eq 'RETURNED' ? 'status-available' : (t.currentlyOverdue ? 'status-overdue' : 'status-issued')}">
                                                ${t.status}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${t.status eq 'ACTIVE' || t.status eq 'OVERDUE'}">
                                                <button type="button" class="btn btn-secondary btn-sm"
                                                        onclick="postAction('${pageContext.request.contextPath}/librarian/issue-return', {action:'return', copyId:'${t.copyId}'})">
                                                    Check In
                                                </button>
                                            </c:if>
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
