<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "faq");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Frequently Asked Questions | Amity University Noida Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/public-pages.css">
</head>
<body class="public-page">

<jsp:include page="header.jsp" />

<!-- Hero Section -->
<section class="public-hero">
    <div class="public-hero-inner" style="text-align: center;">
        <div class="public-hero-badge">
            <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
            Library Help & Knowledgebase
        </div>
        <h1 class="public-hero-title">Frequently Asked Questions</h1>
        <p class="public-hero-subtitle" style="margin: 0 auto;">
            Find immediate answers regarding library registration, book loan quotas, online renewals, overdue fine rules, remote VPN e-journal access, and research support.
        </p>
    </div>
</section>

<main class="public-main-content">

    <!-- Search Input -->
    <div class="faq-search-wrapper">
        <svg class="faq-search-icon" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        <input type="text" id="faqSearchInput" class="faq-search-input" placeholder="Type your question (e.g. how many books, fine rate, renew online)..." autocomplete="off">
    </div>

    <!-- Category Pills -->
    <div class="faq-categories-pills">
        <button type="button" class="faq-pill-btn active" data-filter="all">All Questions</button>
        <button type="button" class="faq-pill-btn" data-filter="membership">Membership & Account</button>
        <button type="button" class="faq-pill-btn" data-filter="borrowing">Borrowing & Renewals</button>
        <button type="button" class="faq-pill-btn" data-filter="fines">Fines & Dues</button>
        <button type="button" class="faq-pill-btn" data-filter="eresources">E-Resources & VPN</button>
        <button type="button" class="faq-pill-btn" data-filter="facilities">Facilities & Rooms</button>
    </div>

    <!-- Accordion List -->
    <div class="faq-accordion-container" id="faqAccordion">

        <!-- Question 1 -->
        <div class="faq-item" data-cat="membership">
            <button type="button" class="faq-question-btn">
                <span>How do I activate my Amity Library account?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                All admitted Amity University students and appointed faculty have their accounts automatically pre-provisioned via the Amizone academic database. You can simply sign in using your Enrollment Number or Employee ID. If you haven't set up a password yet, click "Register Here" on the login page or visit the Circulation Counter on the Ground Floor with your physical ID card.
            </div>
        </div>

        <!-- Question 2 -->
        <div class="faq-item" data-cat="borrowing">
            <button type="button" class="faq-question-btn">
                <span>How many books can I issue and for how long?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                Borrowing allowances are based on patron category:<br>
                &bull; <strong>Undergraduate Students:</strong> Up to 3 books for 14 calendar days.<br>
                &bull; <strong>Postgraduate Students:</strong> Up to 5 books for 21 calendar days.<br>
                &bull; <strong>PhD Scholars & Research Fellows:</strong> Up to 8 books for 30 calendar days.<br>
                &bull; <strong>Faculty Members:</strong> Up to 10 books for the full semester (90 days).
            </div>
        </div>

        <!-- Question 3 -->
        <div class="faq-item" data-cat="borrowing">
            <button type="button" class="faq-question-btn">
                <span>Can I renew my borrowed books online from home?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                Yes! You can log into your Student Dashboard, navigate to <strong>My Books</strong>, and click the <strong>Renew</strong> button next to your active loan. Renewals are permitted up to 2 times consecutively, provided the book has not been reserved or requested by another patron and is not currently overdue.
            </div>
        </div>

        <!-- Question 4 -->
        <div class="faq-item" data-cat="fines">
            <button type="button" class="faq-question-btn">
                <span>What is the overdue fine rate and how do I pay?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                The standard overdue fine is <strong>₹2.00 per day per book</strong> starting the day immediately after the due date. You can view all accumulated fines under the <strong>Fines & Payments</strong> tab in your student portal and clear dues securely online via UPI, Debit Card, or Net Banking, or in person at the Ground Floor circulation desk.
            </div>
        </div>

        <!-- Question 5 -->
        <div class="faq-item" data-cat="eresources">
            <button type="button" class="faq-question-btn">
                <span>How can I access IEEE Xplore, ScienceDirect, and Springer off-campus?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                Off-campus access is enabled through Amity University's Secure Remote Proxy (EZProxy / GlobalProtect VPN). Simply log into your Amizone portal, click the "E-Library" tab, and select the desired database to launch an authenticated proxy session with full institutional download privileges.
            </div>
        </div>

        <!-- Question 6 -->
        <div class="faq-item" data-cat="borrowing">
            <button type="button" class="faq-question-btn">
                <span>How do I reserve a book that is currently checked out?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                Search for the title in the <strong>OPAC Catalogue</strong>. If all copies are currently issued, a "Reserve Book" button will appear. Once placed, when the previous borrower returns the volume, our circulation desk will hold the book exclusively for you for 3 business days and send an automated notification to your email.
            </div>
        </div>

        <!-- Question 7 -->
        <div class="faq-item" data-cat="facilities">
            <button type="button" class="faq-question-btn">
                <span>Are there group study rooms or discussion pods available?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                Yes, there are 8 collaborative discussion pods (Rooms 101–108) located on the First Floor, equipped with whiteboards and display monitors for project teams of 3 to 8 students. Pods can be reserved at the First Floor reference desk for slots of up to 2 hours.
            </div>
        </div>

        <!-- Question 8 -->
        <div class="faq-item" data-cat="membership">
            <button type="button" class="faq-question-btn">
                <span>What should I do if I lose my student ID card or a borrowed book?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                If you lose your ID card, immediately report it to the Circulation Counter to prevent unauthorized checkouts under your name. For lost books, patrons are required to either replace the lost volume with the latest edition of the same title or pay the replacement cost plus a ₹50 administrative cataloguing charge.
            </div>
        </div>

        <!-- Question 9 -->
        <div class="faq-item" data-cat="facilities">
            <button type="button" class="faq-question-btn">
                <span>Is the 24/7 Reading Hall open on weekends and public holidays?</span>
                <svg class="faq-chevron" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="faq-answer-panel">
                Yes! The 24/7 Air-Conditioned Reading Hall in the North Wing Annex remains operational round the clock, 365 days a year, including university holidays and exam weeks. Campus security and biometric/RFID turnstiles ensure 24/7 student safety.
            </div>
        </div>

    </div>

    <!-- Contact Support Card -->
    <div class="faq-help-card">
        <div class="faq-help-info">
            <h3>Still have questions?</h3>
            <p>Our library staff and reference desk librarians are ready to assist you in person or via email.</p>
        </div>
        <a href="mailto:libraryhelpdesk@amity.edu" class="btn-help-contact">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
            <span>Email Library Helpdesk</span>
        </a>
    </div>

</main>

<jsp:include page="footer.jsp" />

<script>
    // Accordion Toggle
    document.querySelectorAll('.faq-question-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const item = btn.parentElement;
            const wasActive = item.classList.contains('active');
            
            // Close other items
            document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));

            if (!wasActive) {
                item.classList.add('active');
            }
        });
    });

    // Category Filter
    document.querySelectorAll('.faq-pill-btn').forEach(pill => {
        pill.addEventListener('click', () => {
            document.querySelectorAll('.faq-pill-btn').forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            const filter = pill.getAttribute('data-filter');

            document.querySelectorAll('.faq-item').forEach(item => {
                if (filter === 'all' || item.getAttribute('data-cat') === filter) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    });

    // Real-Time Search Filter
    const searchInput = document.getElementById('faqSearchInput');
    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase().trim();

        document.querySelectorAll('.faq-item').forEach(item => {
            const question = item.querySelector('.faq-question-btn').innerText.toLowerCase();
            const answer = item.querySelector('.faq-answer-panel').innerText.toLowerCase();

            if (question.includes(query) || answer.includes(query)) {
                item.style.display = 'block';
                if (query.length > 2) {
                    item.classList.add('active'); // auto-expand matching answers
                }
            } else {
                item.style.display = 'none';
                item.classList.remove('active');
            }
        });
    });
</script>

</body>
</html>
