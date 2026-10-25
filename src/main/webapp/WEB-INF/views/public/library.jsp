<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "library");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Central Library | Amity University Noida</title>
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
        <h1 class="public-hero-title">The Central Library</h1>
        <p class="public-hero-subtitle">
            An intellectual powerhouse spanning 58,000 sq. ft. across four fully air-conditioned floors, providing cutting-edge knowledge resources, collaborative research zones, and world-class digital repositories.
        </p>

        <div class="public-hero-stats">
            <div class="hero-stat-card">
                <div class="hero-stat-value">58,000</div>
                <div class="hero-stat-label">Square Feet Floor Area</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">2,500+</div>
                <div class="hero-stat-label">Air-Conditioned Seats</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">450+</div>
                <div class="hero-stat-label">Digital Access Terminals</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">100%</div>
                <div class="hero-stat-label">Wi-Fi & RFID Automated</div>
            </div>
        </div>
    </div>
</section>

<main class="public-main-content">

    <!-- Floor Directory Section -->
    <div class="section-header" id="directory">
        <span class="section-tag">Campus Architecture</span>
        <h2 class="section-title">Floor-by-Floor Directory</h2>
        <p class="section-desc">Find stacks, digital laboratories, quiet study zones, and helpdesks across all 4 levels.</p>
    </div>

    <div class="floor-directory-grid">
        <!-- Ground Floor -->
        <div class="floor-card">
            <span class="floor-badge">Ground Level</span>
            <h3 class="floor-name">Circulation & Reception</h3>
            <ul class="floor-features-list">
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Main Issue, Return & Renewal Counters</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Self-Service RFID Kiosks & Drop Boxes</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>New Arrivals Display Gallery</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>General Reference & Newspaper Reading Lounge</span>
                </li>
            </ul>
        </div>

        <!-- First Floor -->
        <div class="floor-card">
            <span class="floor-badge">First Level</span>
            <h3 class="floor-name">Engineering & Technology</h3>
            <ul class="floor-features-list">
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Computer Science, AI & Data Science Stacks</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Electronics, Mechanical & Civil Engineering</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>IEEE & ACM Digital Corner Terminals</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Student Group Discussion Pods (Rooms 101-108)</span>
                </li>
            </ul>
        </div>

        <!-- Second Floor -->
        <div class="floor-card">
            <span class="floor-badge">Second Level</span>
            <h3 class="floor-name">Management, Law & Arts</h3>
            <ul class="floor-features-list">
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Business Administration & Finance Stacks</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Constitutional, Corporate & Cyber Law Stacks</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Peer-Reviewed National & Global Periodicals</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Moot Court Preparation & Reference Alcove</span>
                </li>
            </ul>
        </div>

        <!-- Third Floor -->
        <div class="floor-card">
            <span class="floor-badge">Third Level</span>
            <h3 class="floor-name">Quiet Research & Digital Media</h3>
            <ul class="floor-features-list">
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Strict Silence PhD Scholar Carrels</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Institutional Theses & Dissertation Repository</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Rare Books & Manuscript Preservation Section</span>
                </li>
                <li>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Digital Seminar & Web-Conferencing Hall (120 Seats)</span>
                </li>
            </ul>
        </div>
    </div>

    <!-- Borrowing Privileges Matrix Table -->
    <div class="section-header" id="privileges">
        <span class="section-tag">Circulation Rules</span>
        <h2 class="section-title">Borrowing Privileges & Quotas</h2>
        <p class="section-desc">Entitlements, borrowing duration, renewal allowances, and overdue rates by patron category.</p>
    </div>

    <div class="privileges-table-card">
        <table class="privileges-table">
            <thead>
                <tr>
                    <th>Patron Category</th>
                    <th>Max Book Limit</th>
                    <th>Loan Period</th>
                    <th>Allowed Renewals</th>
                    <th>Overdue Fine Rate</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Undergraduate Students (UG)</strong></td>
                    <td><span class="sub-badge">3 Books</span></td>
                    <td>14 Days</td>
                    <td>2 Times (Online)</td>
                    <td>₹2.00 / day / volume</td>
                </tr>
                <tr>
                    <td><strong>Postgraduate Students (PG)</strong></td>
                    <td><span class="sub-badge">5 Books</span></td>
                    <td>21 Days</td>
                    <td>2 Times (Online)</td>
                    <td>₹2.00 / day / volume</td>
                </tr>
                <tr>
                    <td><strong>PhD Scholars & Research Fellows</strong></td>
                    <td><span class="sub-badge">8 Books</span></td>
                    <td>30 Days</td>
                    <td>3 Times (Online)</td>
                    <td>₹2.00 / day / volume</td>
                </tr>
                <tr>
                    <td><strong>Faculty Members & Scientists</strong></td>
                    <td><span class="sub-badge">10 Books</span></td>
                    <td>90 Days (Semester)</td>
                    <td>Unlimited</td>
                    <td>Exempt</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- General Code of Conduct -->
    <div class="section-header">
        <span class="section-tag">Guidelines</span>
        <h2 class="section-title">Library Code of Conduct</h2>
    </div>

    <div style="background: #FFFFFF; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 32px; margin-bottom: 56px;">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 24px;">
            <div>
                <h4 style="color: var(--primary-navy); margin-bottom: 8px;">1. ID Badge Mandatory</h4>
                <p style="color: var(--secondary-text); font-size: 0.9rem; line-height: 1.5;">All students and staff must tap their valid Amity Smart ID card at the turnstiles upon entering and exiting the library.</p>
            </div>
            <div>
                <h4 style="color: var(--primary-navy); margin-bottom: 8px;">2. Strict Noise Discipline</h4>
                <p style="color: var(--secondary-text); font-size: 0.9rem; line-height: 1.5;">Cell phones must remain on silent mode. Group discussions are restricted to dedicated pods on the 1st floor.</p>
            </div>
            <div>
                <h4 style="color: var(--primary-navy); margin-bottom: 8px;">3. Book Care & Protection</h4>
                <p style="color: var(--secondary-text); font-size: 0.9rem; line-height: 1.5;">Marking, underlining, or folding book pages is strictly prohibited. Borrowers are liable for damaged volumes.</p>
            </div>
            <div>
                <h4 style="color: var(--primary-navy); margin-bottom: 8px;">4. Personal Belongings</h4>
                <p style="color: var(--secondary-text); font-size: 0.9rem; line-height: 1.5;">Bags, umbrellas, and food items must be deposited in the secure locker counter at the Ground Floor entrance.</p>
            </div>
        </div>
    </div>

    <!-- Staff & Contact Directory -->
    <div class="section-header">
        <span class="section-tag">Leadership & Team</span>
        <h2 class="section-title">Key Library Contacts</h2>
        <p class="section-desc">Reach out to our librarians and systems team for research inquiries and assistance.</p>
    </div>

    <div class="staff-grid">
        <div class="staff-card">
            <div class="staff-avatar">RK</div>
            <h4 class="staff-name">Dr. R. K. Sharma</h4>
            <div class="staff-role">University Chief Librarian</div>
            <a href="mailto:rksharma@amity.edu" class="staff-contact">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                <span>rksharma@amity.edu</span>
            </a>
        </div>

        <div class="staff-card">
            <div class="staff-avatar">AS</div>
            <h4 class="staff-name">Ms. Ananya Sengupta</h4>
            <div class="staff-role">Head of Circulation & Services</div>
            <a href="mailto:asengupta@amity.edu" class="staff-contact">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                <span>asengupta@amity.edu</span>
            </a>
        </div>

        <div class="staff-card">
            <div class="staff-avatar">VS</div>
            <h4 class="staff-name">Er. Vikram Singh</h4>
            <div class="staff-role">Library IT & Systems Administrator</div>
            <a href="mailto:vsingh@amity.edu" class="staff-contact">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                <span>vsingh@amity.edu</span>
            </a>
        </div>

        <div class="staff-card">
            <div class="staff-avatar">PM</div>
            <h4 class="staff-name">Pooja Mishra</h4>
            <div class="staff-role">E-Resources & Journal Coordinator</div>
            <a href="mailto:eresources@amity.edu" class="staff-contact">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                <span>eresources@amity.edu</span>
            </a>
        </div>
    </div>

</main>

<jsp:include page="footer.jsp" />

</body>
</html>
