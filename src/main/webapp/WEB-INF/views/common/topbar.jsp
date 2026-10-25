<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="app-topbar">
    <div class="topbar-left">
        <button class="mobile-menu-toggle" aria-label="Toggle navigation menu">
            <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
        </button>

        <form action="${pageContext.request.contextPath}/catalogue" method="GET" class="topbar-search-form">
            <span class="topbar-search-icon">
                <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            </span>
            <input type="text" name="q" class="topbar-search-input" placeholder="Search books, authors, subjects..." value="${param.q}">
        </form>
    </div>

    <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/notifications" class="icon-action-btn" title="Notifications">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
        </a>

        <a href="${pageContext.request.contextPath}/profile" class="topbar-user-block" title="My Profile">
            <div class="topbar-user-avatar">
                ${sessionScope.CURRENT_USER.fullName.substring(0, 1)}
            </div>
            <div class="topbar-user-info">
                <div class="topbar-user-name">${sessionScope.CURRENT_USER.fullName}</div>
                <div class="topbar-user-role">${sessionScope.CURRENT_USER.roleName}</div>
            </div>
        </a>
    </div>
</header>
