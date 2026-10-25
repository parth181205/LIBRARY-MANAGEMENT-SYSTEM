<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "events");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Events & Workshops | Amity University Noida</title>
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
        <h1 class="public-hero-title">Library Events & Workshops</h1>
        <p class="public-hero-subtitle">
            Cultivating academic inquiry, scholarly research, digital literacy, and literature appreciation through campus exhibitions, publisher book fairs, and hands-on skill seminars.
        </p>

        <div class="public-hero-stats">
            <div class="hero-stat-card">
                <div class="hero-stat-value">18+</div>
                <div class="hero-stat-label">Annual Research Seminars</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">40+</div>
                <div class="hero-stat-label">Book Fair Publishers</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">3,500+</div>
                <div class="hero-stat-label">Student Participants</div>
            </div>
            <div class="hero-stat-card">
                <div class="hero-stat-value">100% Free</div>
                <div class="hero-stat-label">For Amity Students & Staff</div>
            </div>
        </div>
    </div>
</section>

<main class="public-main-content">

    <div class="section-header">
        <span class="section-tag">Calendar 2026</span>
        <h2 class="section-title">Upcoming Schedule of Events</h2>
        <p class="section-desc">Register online with your student ID or employee enrollment number for certificates and reserved seating.</p>
    </div>

    <!-- Filter Buttons -->
    <div class="events-filter-bar">
        <button type="button" class="event-filter-btn active" data-category="all">All Events</button>
        <button type="button" class="event-filter-btn" data-category="workshop">Workshops</button>
        <button type="button" class="event-filter-btn" data-category="exhibition">Book Fairs</button>
        <button type="button" class="event-filter-btn" data-category="seminar">Research Seminars</button>
        <button type="button" class="event-filter-btn" data-category="author">Author Talks</button>
    </div>

    <!-- Events Grid -->
    <div class="events-list-grid">

        <!-- Event 1: Workshop -->
        <div class="event-card" data-cat="workshop">
            <div class="event-card-header">
                <span class="event-badge">Hands-On Workshop</span>
                <div class="event-date-block">
                    <div class="event-date-day">05</div>
                    <div class="event-date-month">Nov 2026</div>
                </div>
            </div>
            <div class="event-card-body">
                <h3 class="event-title">Mastering IEEE Xplore, Scopus & Zotero Citation Management</h3>
                <p class="event-desc">
                    Comprehensive training for graduate scholars on structuring search queries, identifying high-impact quartile journals, export BibTeX citations, and avoiding predatory publishers.
                </p>
                <div class="event-meta-info">
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span>02:00 PM – 04:30 PM (IST)</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        <span>Multimedia Lab, 3rd Floor, Central Library</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        <span>Speaker: Dr. K. Ramanathan (IEEE Senior Member)</span>
                    </div>
                </div>
                <button type="button" class="btn-event-rsvp" onclick="openRsvpModal('Mastering IEEE Xplore, Scopus & Zotero Citation Management', '05 Nov 2026')">
                    <span>Reserve My Seat &rarr;</span>
                </button>
            </div>
        </div>

        <!-- Event 2: Book Fair -->
        <div class="event-card" data-cat="exhibition">
            <div class="event-card-header" style="background: linear-gradient(135deg, #1E3A8A 0%, #172554 100%);">
                <span class="event-badge">Campus Exhibition</span>
                <div class="event-date-block">
                    <div class="event-date-day">12-16</div>
                    <div class="event-date-month">Nov 2026</div>
                </div>
            </div>
            <div class="event-card-body">
                <h3 class="event-title">Annual Amity National Book Fair 2026</h3>
                <p class="event-desc">
                    Five days of literary celebration featuring over 40 global publishing houses (Oxford University Press, Pearson, McGraw Hill, Springer). All students receive a flat 20% discount on academic texts.
                </p>
                <div class="event-meta-info">
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span>09:30 AM – 06:30 PM Daily</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        <span>Central Library Ground Foyer & Central Lawn</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        <span>Open Entry for all Amity Students & Faculty</span>
                    </div>
                </div>
                <button type="button" class="btn-event-rsvp" onclick="openRsvpModal('Annual Amity National Book Fair 2026', '12-16 Nov 2026')">
                    <span>Get Event Pass &rarr;</span>
                </button>
            </div>
        </div>

        <!-- Event 3: Author Talk -->
        <div class="event-card" data-cat="author">
            <div class="event-card-header" style="background: linear-gradient(135deg, #047857 0%, #064E3B 100%);">
                <span class="event-badge">Distinguished Lecture</span>
                <div class="event-date-block">
                    <div class="event-date-day">20</div>
                    <div class="event-date-month">Nov 2026</div>
                </div>
            </div>
            <div class="event-card-body">
                <h3 class="event-title">Author Talk: "Ethics & Safety in Generative Artificial Intelligence"</h3>
                <p class="event-desc">
                    An insightful dialogue with bestselling author and AI policy advisor Prof. Arvind Subramanian on navigating algorithmic accountability, intellectual property, and research integrity.
                </p>
                <div class="event-meta-info">
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span>11:00 AM – 01:00 PM (IST)</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        <span>University Auditorium 2 (Sector 125)</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        <span>Followed by Q&A and Book Signing</span>
                    </div>
                </div>
                <button type="button" class="btn-event-rsvp" onclick="openRsvpModal('Author Talk: Ethics & Safety in Generative AI', '20 Nov 2026')">
                    <span>Reserve My Seat &rarr;</span>
                </button>
            </div>
        </div>

        <!-- Event 4: Seminar -->
        <div class="event-card" data-cat="seminar">
            <div class="event-card-header" style="background: linear-gradient(135deg, #7C3AED 0%, #4C1D95 100%);">
                <span class="event-badge">Research Seminar</span>
                <div class="event-date-block">
                    <div class="event-date-day">28</div>
                    <div class="event-date-month">Nov 2026</div>
                </div>
            </div>
            <div class="event-card-body">
                <h3 class="event-title">National Digital Library of India (NDLI) Club Awareness Drive</h3>
                <p class="event-desc">
                    Discover how to unlock 5 Crore+ open educational resources, audiobooks, institutional question repositories, and competitive exam preparation modules hosted on NDLI.
                </p>
                <div class="event-meta-info">
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span>03:00 PM – 04:30 PM (IST)</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        <span>Hybrid (Room 204 & Microsoft Teams Live)</span>
                    </div>
                    <div class="event-meta-item">
                        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        <span>E-Certificate for all attendees</span>
                    </div>
                </div>
                <button type="button" class="btn-event-rsvp" onclick="openRsvpModal('NDLI Club Awareness Drive', '28 Nov 2026')">
                    <span>Register Online &rarr;</span>
                </button>
            </div>
        </div>

    </div>

</main>

<!-- Interactive RSVP Modal -->
<div id="rsvpModal" style="display: none; position: fixed; inset: 0; background: rgba(6, 26, 50, 0.6); backdrop-filter: blur(6px); z-index: 9999; align-items: center; justify-content: center; padding: 20px;">
    <div style="background: #FFFFFF; border-radius: var(--radius-lg); max-width: 520px; width: 100%; padding: 32px; box-shadow: var(--shadow-xl); position: relative;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 style="font-size: 1.3rem; color: var(--primary-navy); margin: 0;">Event Registration</h3>
            <button type="button" onclick="closeRsvpModal()" style="background: none; border: none; font-size: 1.5rem; color: var(--muted-text); cursor: pointer;">&times;</button>
        </div>

        <div style="background: var(--navy-ultra-light); border-radius: var(--radius-md); padding: 14px; margin-bottom: 20px;">
            <div style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--primary-navy);" id="modalEventDate">Date</div>
            <div style="font-size: 1rem; font-weight: 700; color: var(--main-text); margin-top: 4px;" id="modalEventTitle">Event Title</div>
        </div>

        <form onsubmit="handleRsvpSubmit(event)">
            <div style="margin-bottom: 16px;">
                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--main-text); margin-bottom: 6px;">Full Name</label>
                <input type="text" id="rsvpName" required placeholder="e.g. Parth Sharma" style="width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: var(--radius-md); font-size: 0.92rem;">
            </div>

            <div style="margin-bottom: 16px;">
                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--main-text); margin-bottom: 6px;">Enrollment / Employee No.</label>
                <input type="text" id="rsvpId" required placeholder="e.g. A2305221001" style="width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: var(--radius-md); font-size: 0.92rem;">
            </div>

            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--main-text); margin-bottom: 6px;">Amity Email Address</label>
                <input type="email" id="rsvpEmail" required placeholder="student@amity.edu" style="width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: var(--radius-md); font-size: 0.92rem;">
            </div>

            <button type="submit" style="width: 100%; padding: 12px; background: var(--primary-navy); color: #FFFFFF; font-size: 0.95rem; font-weight: 700; border: none; border-radius: var(--radius-full); cursor: pointer; transition: var(--transition);">
                Confirm Registration &rarr;
            </button>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script>
    // Category Filtering
    document.querySelectorAll('.event-filter-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.event-filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            const category = btn.getAttribute('data-category');

            document.querySelectorAll('.event-card').forEach(card => {
                if (category === 'all' || card.getAttribute('data-cat') === category) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });

    // RSVP Modal
    function openRsvpModal(title, date) {
        document.getElementById('modalEventTitle').textContent = title;
        document.getElementById('modalEventDate').textContent = date;
        document.getElementById('rsvpModal').style.display = 'flex';
    }

    function closeRsvpModal() {
        document.getElementById('rsvpModal').style.display = 'none';
    }

    function handleRsvpSubmit(e) {
        e.preventDefault();
        const name = document.getElementById('rsvpName').value;
        const title = document.getElementById('modalEventTitle').textContent;
        closeRsvpModal();
        alert('Registration Successful! \n\nThank you ' + name + ', your registration pass for "' + title + '" has been confirmed. A calendar invitation has been dispatched to your email.');
    }
</script>

</body>
</html>
