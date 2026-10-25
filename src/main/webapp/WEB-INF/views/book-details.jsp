<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} | Amity Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<div class="app-container">
    <jsp:include page="common/sidebar.jsp" />

    <main class="app-main">
        <jsp:include page="common/topbar.jsp" />

        <div class="page-content">
            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-secondary btn-sm">
                    &larr; Return to Catalogue
                </a>
            </div>

            <c:if test="${param.reserved eq 'success'}">
                <div class="alert alert-success">
                    &#10003; Book reservation confirmed! You will receive a notification when a copy is ready at the circulation counter.
                </div>
            </c:if>

            <c:if test="${param.added eq '1'}">
                <div class="alert alert-success">
                    &#10003; Book record and barcodes generated successfully in library inventory!
                </div>
            </c:if>

            <div class="content-card" style="padding: 36px;">
                <div style="display: flex; gap: 36px; flex-wrap: wrap;">
                    <!-- Book Cover -->
                    <div style="width: 260px; height: 380px; flex-shrink: 0; border-radius: var(--radius-lg); overflow: hidden; box-shadow: var(--shadow-lg);">
                        <img src="${pageContext.request.contextPath}/${book.coverImage}" 
                             alt="${book.title}" 
                             style="width: 100%; height: 100%; object-fit: cover;"
                             onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=400&q=80';">
                    </div>

                    <!-- Book Metadata -->
                    <div style="flex: 1; min-width: 300px;">
                        <span class="status-badge status-active" style="margin-bottom: 8px;">${book.categoryName}</span>
                        <h1 style="font-size: 2.2rem; color: var(--primary-navy); margin-bottom: 8px;">${book.title}</h1>
                        <p style="font-size: 1.15rem; color: var(--secondary-text); margin-bottom: 20px;">
                            By <strong>${book.authorsDisplay}</strong>
                        </p>

                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; background: var(--main-bg); padding: 20px; border-radius: var(--radius-md); margin-bottom: 24px; border: 1px solid var(--border-color);">
                            <div>
                                <span style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">ISBN</span>
                                <div style="font-weight: 700; color: var(--primary-navy);"><code>${book.isbn}</code></div>
                            </div>
                            <div>
                                <span style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">Publisher</span>
                                <div style="font-weight: 600;">${not empty book.publisherName ? book.publisherName : 'Amity Academic Press'}</div>
                            </div>
                            <div>
                                <span style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">Edition / Year</span>
                                <div style="font-weight: 600;">${not empty book.edition ? book.edition : 'Standard Edition'} (${book.publicationYear})</div>
                            </div>
                            <div>
                                <span style="font-size: 0.8rem; color: var(--secondary-text); text-transform: uppercase;">Inventory Availability</span>
                                <div>
                                    <c:choose>
                                        <c:when test="${book.available}">
                                            <span class="status-badge status-available">${book.availableCopies} of ${book.totalCopies} Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-issued">All ${book.totalCopies} Copies Checked Out</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div style="margin-bottom: 28px;">
                            <h3 style="font-size: 1.1rem; color: var(--primary-navy); margin-bottom: 8px;">Abstract &amp; Synopsis</h3>
                            <p style="color: var(--main-text); line-height: 1.7; font-size: 0.95rem;">
                                ${not empty book.description ? book.description : 'Comprehensive academic reference covering foundational concepts, real-world case studies, and modern methodologies.'}
                            </p>
                        </div>

                        <!-- Actions Bar -->
                        <div style="display: flex; gap: 14px; flex-wrap: wrap;">
                            <c:choose>
                                <c:when test="${sessionScope.CURRENT_USER.librarian || sessionScope.CURRENT_USER.admin}">
                                    <a href="${pageContext.request.contextPath}/librarian/issue-return?bookQuery=${book.isbn}" class="btn btn-primary">
                                        Open in Issue Desk
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/book" method="POST">
                                        <input type="hidden" name="action" value="reserve">
                                        <input type="hidden" name="bookId" value="${book.id}">
                                        <button type="submit" class="btn btn-gold" ${hasActiveReservation ? 'disabled' : ''}>
                                            ${hasActiveReservation ? 'Already Reserved' : 'Reserve Book'}
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                            <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-secondary">Catalogue</a>
                        </div>
                    </div>
                </div>

                <!-- Physical Copies Inventory Table -->
                <div style="margin-top: 40px; border-top: 1px solid var(--border-color); padding-top: 30px;">
                    <h3 style="font-size: 1.3rem; color: var(--primary-navy); margin-bottom: 16px;">
                        Physical Copies &amp; Shelf Locations
                    </h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Copy Barcode</th>
                                    <th>Rack / Shelf Location</th>
                                    <th>Status</th>
                                    <th>Condition Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="copy" items="${copies}">
                                    <tr>
                                        <td><code>${copy.barcode}</code></td>
                                        <td><strong>${copy.rackLocation}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${copy.status eq 'AVAILABLE'}">
                                                    <span class="status-badge status-available">Available on Shelf</span>
                                                </c:when>
                                                <c:when test="${copy.status eq 'ISSUED'}">
                                                    <span class="status-badge status-issued">Issued to Patron</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-overdue">${copy.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${copy.conditionNote}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
