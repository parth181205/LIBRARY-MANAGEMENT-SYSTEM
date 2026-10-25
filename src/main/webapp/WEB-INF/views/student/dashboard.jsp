<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | Amity University Noida Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<div class="app-container">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="app-main">
        <jsp:include page="../common/topbar.jsp" />

        <div class="page-content">
            <!-- Personalized Welcome Header -->
            <div class="page-header">
                <div>
                    <h1 class="page-title">Welcome, ${sessionScope.CURRENT_USER.fullName}</h1>
                    <p class="page-subtitle">Explore. Learn. Grow with Amity University Library.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-primary">
                        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <span>Explore Catalogue</span>
                    </a>
                </div>
            </div>

            <!-- Dashboard Top: Stats + Quick Links -->
            <div class="dashboard-top-grid">
                <!-- 4 Stat Cards -->
                <div class="dashboard-stats-section">
                    <div class="stat-cards-grid stat-cards-2x2">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-icon-blue">
                                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                            </div>
                            <div>
                                <div class="stat-label">Issued Books</div>
                                <div class="stat-value">${stats.issuedCount}</div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-icon-gold">
                                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                            </div>
                            <div>
                                <div class="stat-label">Reserved Books</div>
                                <div class="stat-value">${stats.reservedCount}</div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-icon-green">
                                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 10 3 12 0v-5"></path></svg>
                            </div>
                            <div>
                                <div class="stat-label">Total Borrowed</div>
                                <div class="stat-value">${stats.totalBorrowed}</div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-icon-red">
                                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="20" height="14" x="2" y="5" rx="2"></rect><line x1="2" x2="22" y1="10" y2="10"></line></svg>
                            </div>
                            <div>
                                <div class="stat-label">Pending Fines</div>
                                <div class="stat-value">&#8377;${stats.pendingFines}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Links Panel -->
                <div class="quick-links-card">
                    <h3 class="quick-links-title">Quick Links</h3>
                    <a href="${pageContext.request.contextPath}/catalogue" class="quick-link-item">
                        <div class="quick-link-icon">
                            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        </div>
                        <span>Browse New Arrivals</span>
                        <svg class="quick-link-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/catalogue?type=ejournal" class="quick-link-item">
                        <div class="quick-link-icon">
                            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
                        </div>
                        <span>E-Journals & Databases</span>
                        <svg class="quick-link-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/student/reservations" class="quick-link-item">
                        <div class="quick-link-icon">
                            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                        </div>
                        <span>Reserve a Book</span>
                        <svg class="quick-link-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/student/my-books" class="quick-link-item">
                        <div class="quick-link-icon">
                            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"></path></svg>
                        </div>
                        <span>Renew Issued Book</span>
                        <svg class="quick-link-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                    <a href="#" class="quick-link-item">
                        <div class="quick-link-icon">
                            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                        </div>
                        <span>Library Rules & Guidelines</span>
                        <svg class="quick-link-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                </div>
            </div>

            <!-- Campus Image Hero Banner Panel -->
            <div class="campus-hero-banner">
                <div class="hero-text-content">
                    <span class="hero-badge">Central Library &amp; Academic Repository</span>
                    <h2 class="hero-title">A World of Knowledge at Your Fingertips</h2>
                    <p class="hero-desc">
                        Explore thousands of books, research papers, e-journals and more.
                    </p>
                </div>
                <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-gold">Search Library Catalog</a>
                </div>
            </div>

            <!-- Currently Issued / Upcoming Due Dates Table -->
            <div class="content-card">
                <div class="card-header">
                    <h3 class="card-title">Currently Issued Books &amp; Upcoming Due Dates</h3>
                    <a href="${pageContext.request.contextPath}/student/my-books" class="btn btn-secondary btn-sm">Manage All</a>
                </div>
                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty activeLoans}">
                            <div class="table-responsive">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Book Title</th>
                                            <th>Barcode</th>
                                            <th>Issue Date</th>
                                            <th>Due Date</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="loan" items="${activeLoans}">
                                            <tr>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--primary-navy);">${loan.bookTitle}</div>
                                                </td>
                                                <td><code>${loan.barcode}</code></td>
                                                <td><fmt:formatDate value="${loan.issueDate}" pattern="dd MMM yyyy" /></td>
                                                <td>
                                                    <span style="${loan.currentlyOverdue ? 'color: var(--error); font-weight: 700;' : ''}">
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
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/student/my-books" method="POST" style="display: inline;">
                                                        <input type="hidden" name="action" value="request_renewal">
                                                        <input type="hidden" name="loanId" value="${loan.id}">
                                                        <button type="submit" class="btn btn-gold btn-sm" ${loan.currentlyOverdue || loan.renewedCount >= 2 ? 'disabled' : ''}>
                                                            Renew
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 40px; text-align: center; color: var(--secondary-text);">
                                <div style="font-size: 2.5rem; margin-bottom: 12px;">&#128214;</div>
                                <h4 style="color: var(--primary-navy); margin-bottom: 6px;">No Books Currently Issued</h4>
                                <p style="font-size: 0.92rem;">You do not have any active loans. Visit the catalogue to find reading materials.</p>
                                <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-primary btn-sm" style="margin-top: 16px;">Browse Catalogue</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Recently Added Books Shelf -->
            <div style="margin-top: 36px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <div>
                        <h3 style="font-size: 1.4rem; color: var(--primary-navy);">Recently Added to Collection</h3>
                        <p style="font-size: 0.88rem; color: var(--secondary-text);">Fresh arrivals and newly indexed titles</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-secondary btn-sm">View Full Catalogue &rarr;</a>
                </div>

                <div class="books-grid">
                    <c:forEach var="book" items="${recentBooks}">
                        <div class="book-card">
                            <div class="book-cover-wrap">
                                <img src="${pageContext.request.contextPath}/${book.coverImage}" 
                                     alt="${book.title}" 
                                     class="book-cover-img"
                                     onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=400&q=80';">
                            </div>
                            <div class="book-card-body">
                                <span class="book-category-tag">${book.categoryName}</span>
                                <h4 class="book-title" title="${book.title}">${book.title}</h4>
                                <div class="book-author">${book.authorsDisplay}</div>
                                <div class="book-meta-footer">
                                    <c:choose>
                                        <c:when test="${book.available}">
                                            <span class="status-badge status-available">Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-issued">Issued</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/book?id=${book.id}" class="btn btn-primary btn-sm">View Details</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
