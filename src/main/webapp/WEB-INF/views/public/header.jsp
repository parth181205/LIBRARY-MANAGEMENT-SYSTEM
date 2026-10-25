<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) activePage = "";
%>
<header class="public-header">
    <div class="public-header-inner">
        <a href="${pageContext.request.contextPath}/portal" class="public-brand">
            <img src="${pageContext.request.contextPath}/assets/images/amity-logo.png" alt="Amity University Noida">
        </a>

        <nav>
            <ul class="public-nav">
                <li>
                    <a href="${pageContext.request.contextPath}/portal" class="public-nav-link <%= "portal".equals(activePage) ? "active" : "" %>">
                        Portal
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/library" class="public-nav-link <%= "library".equals(activePage) ? "active" : "" %>">
                        Library
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/events" class="public-nav-link <%= "events".equals(activePage) ? "active" : "" %>">
                        Events
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/faq" class="public-nav-link <%= "faq".equals(activePage) ? "active" : "" %>">
                        FAQ
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/catalogue" class="public-nav-link <%= "catalogue".equals(activePage) ? "active" : "" %>">
                        Catalogue
                    </a>
                </li>
            </ul>
        </nav>

        <div class="public-header-actions">
            <c:choose>
                <c:when test="${not empty sessionScope.CURRENT_USER}">
                    <c:choose>
                        <c:when test="${sessionScope.CURRENT_USER.admin}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-header-login">
                                <span>Admin Dashboard</span>
                                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.CURRENT_USER.librarian}">
                            <a href="${pageContext.request.contextPath}/librarian/dashboard" class="btn-header-login">
                                <span>Librarian Desk</span>
                                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn-header-login">
                                <span>My Dashboard</span>
                                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn-header-opac">
                        <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <span>Search OPAC</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn-header-login">
                        <span>Sign In</span>
                        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M15 12H3"/></svg>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
