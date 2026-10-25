<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="public-footer">
    <div class="public-footer-inner">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/assets/images/amity-logo.png" alt="Amity University Noida">
            <p>Amity Central Library serves as the academic cornerstone of Amity University Uttar Pradesh, fostering world-class scholarship, research, and innovation.</p>
        </div>

        <div class="footer-col">
            <h4>Quick Links</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/portal">Academic Portal</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogue">Library Catalogue (OPAC)</a></li>
                <li><a href="${pageContext.request.contextPath}/library">About Central Library</a></li>
                <li><a href="${pageContext.request.contextPath}/events">Workshops & Events</a></li>
                <li><a href="${pageContext.request.contextPath}/faq">Help & FAQ</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Facilities</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/library#hours">Hours & Schedule</a></li>
                <li><a href="${pageContext.request.contextPath}/library#directory">Floor Directory</a></li>
                <li><a href="${pageContext.request.contextPath}/library#privileges">Borrowing Rules</a></li>
                <li><a href="${pageContext.request.contextPath}/portal#eresources">E-Databases & VPN</a></li>
                <li><a href="${pageContext.request.contextPath}/faq#lost-card">Lost Card / Dues</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Library Desk</h4>
            <p style="font-size: 0.88rem; line-height: 1.6; color: #94A3B8; margin-bottom: 12px;">
                Central Library Building, Sector 125,<br>
                Noida, Uttar Pradesh - 201313, India
            </p>
            <p style="font-size: 0.85rem; color: #94A3B8; margin-bottom: 6px;">
                <strong>Desk:</strong> +91 (120) 439-2401
            </p>
            <p style="font-size: 0.85rem; color: #94A3B8;">
                <strong>Email:</strong> libraryhelpdesk@amity.edu
            </p>
        </div>
    </div>

    <div class="footer-bottom">
        <div>&copy; 2026 Amity University Uttar Pradesh, Noida. All rights reserved.</div>
        <div style="display: flex; gap: 16px;">
            <a href="${pageContext.request.contextPath}/login" style="color: #94A3B8; text-decoration: none;">Patron Sign In</a>
            <span style="color: #475569;">|</span>
            <a href="${pageContext.request.contextPath}/faq" style="color: #94A3B8; text-decoration: none;">Library Code of Conduct</a>
        </div>
    </div>
</footer>
