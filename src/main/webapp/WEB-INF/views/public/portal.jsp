<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "portal");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic & Library Portal | Amity University Noida</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/public-pages.css">
</head>
<body class="public-page">

<jsp:include page="header.jsp" />

<!-- Hero Section -->
<section class="public-hero">
    <div class="public-hero-inner">
        <div class="public-hero-badge">
            <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
            Amity University Noida
        </div>
        <h1 class="public-hero-title">Academic & Library Portal</h1>
        <p class="public-hero-subtitle">
            Your single gateway to discover 50,000+ print volumes, thousands of peer-reviewed digital journals, research repositories, online renewals, and campus circulation counters.
        </p>

        <div class="public-hero-stats">
            <div class="hero-stat-card">
                <div class="hero-stat-value">50,000+</div>
                <div class="hero-stat-label">Printed Books & Volumes</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">12,000+</div>
                <div class="hero-stat-label">Subscribed E-Journals</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">2,500+</div>
                <div class="hero-stat-label">Reading Hall Capacity</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">24 / 7</div>
                <div class="hero-stat-label">Exam Period Access</div>
            </div>
        </div>
    </div>
</section>

<!-- Main Portal Services -->
<main class="public-main-content">

    <div class="section-header">
        <span class="section-tag">Library Services</span>
        <h2 class="section-title">Essential Academic Tools</h2>
        <p class="section-desc">Access cataloguing, borrower accounts, e-resources, and study rooms quickly.</p>
    </div>

    <div class="portal-services-grid">
        <!-- Service 1: OPAC Catalogue -->
        <div class="portal-service-card">
            <div class="portal-service-icon">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
            </div>
            <h3 class="portal-service-title">OPAC Catalogue</h3>
            <p class="portal-service-desc">Search the full book catalogue by title, author, ISBN, or subject. View exact shelf racks and live copy availability.</p>
            <a href="${pageContext.request.contextPath}/catalogue" class="portal-service-action">
                Browse Catalogue &rarr;
            </a>
        </div>

        <!-- Service 2: Patron Dashboard -->
        <div class="portal-service-card">
            <div class="portal-service-icon">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            </div>
            <h3 class="portal-service-title">My Patron Account</h3>
            <p class="portal-service-desc">Check active borrowings, submit 1-click loan renewals, track reserved books, and view your fine payment history.</p>
            <a href="${pageContext.request.contextPath}/login" class="portal-service-action">
                Patron Login &rarr;
            </a>
        </div>

        <!-- Service 3: E-Resources & Research -->
        <div class="portal-service-card" id="eresources">
            <div class="portal-service-icon">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
            </div>
            <h3 class="portal-service-title">Digital Library & VPN</h3>
            <p class="portal-service-desc">Remote and campus access to IEEE Xplore, ScienceDirect, SpringerLink, JSTOR, Scopus, and ACM Digital Library.</p>
            <a href="${pageContext.request.contextPath}/library#privileges" class="portal-service-action">
                Access Guidelines &rarr;
            </a>
        </div>

        <!-- Service 4: Book Reservations -->
        <div class="portal-service-card">
            <div class="portal-service-icon">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
            </div>
            <h3 class="portal-service-title">Circulation & Holds</h3>
            <p class="portal-service-desc">Place holds on currently checked-out volumes. Get automated email notifications as soon as books arrive at the desk.</p>
            <a href="${pageContext.request.contextPath}/catalogue" class="portal-service-action">
                Place Book Hold &rarr;
            </a>
        </div>

        <!-- Service 5: Study Spaces -->
        <div class="portal-service-card">
            <div class="portal-service-icon">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 21h18"></path><path d="M5 21V7l7-4 7 4v14"></path><path d="M9 10v6"></path><path d="M15 10v6"></path></svg>
            </div>
            <h3 class="portal-service-title">Study Rooms & Pods</h3>
            <p class="portal-service-desc">Air-conditioned collaborative discussion rooms, quiet PhD carrels, and individual study cubicles with power sockets.</p>
            <a href="${pageContext.request.contextPath}/library#directory" class="portal-service-action">
                View Floor Directory &rarr;
            </a>
        </div>

        <!-- Service 6: Ask a Librarian -->
        <div class="portal-service-card">
            <div class="portal-service-icon">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
            </div>
            <h3 class="portal-service-title">Helpdesk & FAQs</h3>
            <p class="portal-service-desc">Find answers to borrowing quotas, overdue rates, book lost replacement procedures, and library clearance certificates.</p>
            <a href="${pageContext.request.contextPath}/faq" class="portal-service-action">
                Open Helpdesk &rarr;
            </a>
        </div>
    </div>

    <!-- Live Hours & Notice Board -->
    <div class="portal-two-col">
        <!-- Timings Card -->
        <div class="portal-timings-card">
            <div class="section-header" style="margin-bottom: 20px;">
                <span class="section-tag">Operating Schedule</span>
                <h3 style="font-size: 1.4rem; color: var(--primary-navy);">Today's Library Hours</h3>
            </div>
            <div class="timing-row">
                <div>
                    <div class="timing-facility">Central Library Stack & Racks</div>
                    <div class="timing-hours">All 4 Floors</div>
                </div>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span class="timing-hours">08:00 AM – 11:00 PM</span>
                    <span class="timing-status-badge open">Open</span>
                </div>
            </div>
            <div class="timing-row">
                <div>
                    <div class="timing-facility">Circulation & Issue Desk</div>
                    <div class="timing-hours">Ground Floor Foyer</div>
                </div>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span class="timing-hours">09:00 AM – 06:00 PM</span>
                    <span class="timing-status-badge open">Open</span>
                </div>
            </div>
            <div class="timing-row">
                <div>
                    <div class="timing-facility">24/7 Air-Conditioned Reading Hall</div>
                    <div class="timing-hours">North Wing Annex</div>
                </div>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span class="timing-hours">24 Hours (ID Required)</span>
                    <span class="timing-status-badge round-the-clock">24/7</span>
                </div>
            </div>
            <div class="timing-row">
                <div>
                    <div class="timing-facility">Digital Library & Multimedia Lab</div>
                    <div class="timing-hours">Floor 3, Tech Hub</div>
                </div>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span class="timing-hours">08:30 AM – 09:00 PM</span>
                    <span class="timing-status-badge open">Open</span>
                </div>
            </div>
        </div>

        <!-- Bulletin / Notices -->
        <div class="portal-bulletin-card">
            <div class="section-header" style="margin-bottom: 20px;">
                <span class="section-tag">Library Bulletins</span>
                <h3 style="font-size: 1.4rem; color: var(--primary-navy);">Notices & Updates</h3>
            </div>
            <div class="notice-item">
                <div class="notice-date-badge">
                    <div class="notice-day">05</div>
                    <div class="notice-month">Nov</div>
                </div>
                <div class="notice-content">
                    <h4>IEEE Xplore & Research Citation Workshop</h4>
                    <p>Hands-on session for B.Tech & M.Tech researchers on literature discovery and citation management in the Multimedia Lab.</p>
                </div>
            </div>
            <div class="notice-item">
                <div class="notice-date-badge">
                    <div class="notice-day">12</div>
                    <div class="notice-month">Nov</div>
                </div>
                <div class="notice-content">
                    <h4>Annual National Book Fair 2026</h4>
                    <p>Over 40 leading academic publishers offering 20% discount on textbooks and reference material at the Library Foyer.</p>
                </div>
            </div>
            <div class="notice-item">
                <div class="notice-date-badge">
                    <div class="notice-day">01</div>
                    <div class="notice-month">Nov</div>
                </div>
                <div class="notice-content">
                    <h4>Remote VPN Access Certificate Renewal</h4>
                    <p>Please update your campus digital proxy certificate before the semester deadline to maintain uninterrupted home access.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Subscribed Databases -->
    <div class="subscriptions-bar">
        <span class="subscriptions-label">Subscribed Academic Databases:</span>
        <div class="subscriptions-logos">
            <span class="sub-badge">IEEE Xplore</span>
            <span class="sub-badge">ScienceDirect</span>
            <span class="sub-badge">SpringerLink</span>
            <span class="sub-badge">ACM Digital Library</span>
            <span class="sub-badge">Scopus</span>
            <span class="sub-badge">JSTOR</span>
            <span class="sub-badge">ProQuest</span>
            <span class="sub-badge">Delnet</span>
        </div>
    </div>

    <!-- Featured Arrivals -->
    <c:if test="${not empty featuredBooks}">
        <div class="section-header">
            <span class="section-tag">New Additions</span>
            <h2 class="section-title">Featured Books in Collection</h2>
            <p class="section-desc">Recently catalogued textbooks, references, and bestsellers ready for checkout.</p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 24px; margin-bottom: 48px;">
            <c:forEach var="book" items="${featuredBooks}">
                <div style="background: #FFFFFF; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 20px; display: flex; gap: 16px; box-shadow: var(--shadow-sm); transition: var(--transition);">
                    <div style="width: 70px; height: 100px; background: linear-gradient(135deg, var(--primary-navy), var(--navy-light)); border-radius: 6px; display: flex; align-items: center; justify-content: center; color: var(--gold-accent); flex-shrink: 0;">
                        <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                    </div>
                    <div style="display: flex; flex-direction: column; justify-content: space-between; overflow: hidden;">
                        <div>
                            <span style="font-size: 0.72rem; font-weight: 700; color: var(--primary-navy); text-transform: uppercase;">${book.categoryName}</span>
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--main-text); margin: 3px 0 2px 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${book.title}">${book.title}</h4>
                            <p style="font-size: 0.82rem; color: var(--secondary-text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${book.authorsDisplay}</p>
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
                            <span style="font-size: 0.75rem; color: var(--success); font-weight: 600;">${book.availableCopies} Copies Available</span>
                            <a href="${pageContext.request.contextPath}/book-details?id=${book.id}" style="font-size: 0.82rem; font-weight: 600; color: var(--primary-navy); text-decoration: none;">View Details &rarr;</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

</main>

<jsp:include page="footer.jsp" />

</body>
</html>
