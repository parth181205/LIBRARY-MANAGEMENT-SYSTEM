<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String currentPath = request.getRequestURI();
    request.setAttribute("currentPath", currentPath);
%>

<aside class="app-sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/catalogue" class="sidebar-logo-link" title="Amity University Noida">
            <img src="${pageContext.request.contextPath}/assets/images/amity-logo.png" alt="Amity University Noida" class="sidebar-logo">
        </a>
    </div>

    <nav class="sidebar-nav">
        <c:choose>
            <%-- STUDENT NAVIGATION --%>
            <c:when test="${sessionScope.CURRENT_USER.student}">
                <div class="nav-section-title">Academic Portal</div>
                <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link ${currentPath.contains('/student/dashboard') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/catalogue" class="nav-link ${currentPath.contains('/catalogue') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                    <span>Library Catalogue</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/my-books" class="nav-link ${currentPath.contains('/student/my-books') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path></svg>
                    <span>My Books</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/reservations" class="nav-link ${currentPath.contains('/student/reservations') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                    <span>Reservations</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/fines" class="nav-link ${currentPath.contains('/student/fines') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="20" height="14" x="2" y="5" rx="2"></rect><line x1="2" x2="22" y1="10" y2="10"></line></svg>
                    <span>Fines & Payments</span>
                </a>
            </c:when>

            <%-- LIBRARIAN NAVIGATION --%>
            <c:when test="${sessionScope.CURRENT_USER.librarian}">
                <div class="nav-section-title">Librarian Operations</div>
                <a href="${pageContext.request.contextPath}/librarian/dashboard" class="nav-link ${currentPath.contains('/librarian/dashboard') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                    <span>Overview</span>
                </a>
                <a href="${pageContext.request.contextPath}/librarian/issue-return" class="nav-link ${currentPath.contains('/librarian/issue-return') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="16 3 21 3 21 8"></polyline><line x1="4" x2="21" y1="20" y2="3"></line><polyline points="21 16 21 21 16 21"></polyline><line x1="15" x2="21" y1="15" y2="21"></line><line x1="4" x2="9" y1="4" y2="9"></line></svg>
                    <span>Issue & Return Desk</span>
                </a>
                <a href="${pageContext.request.contextPath}/catalogue" class="nav-link ${currentPath.contains('/catalogue') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                    <span>Catalogue</span>
                </a>
                <a href="${pageContext.request.contextPath}/librarian/books/add" class="nav-link ${currentPath.contains('/librarian/books/add') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="16"></line><line x1="8" x2="16" y1="12" y2="12"></line></svg>
                    <span>Add New Book</span>
                </a>
                <a href="${pageContext.request.contextPath}/librarian/reservations" class="nav-link ${currentPath.contains('/librarian/reservations') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                    <span>Reservation Queue</span>
                </a>
                <a href="${pageContext.request.contextPath}/librarian/fines" class="nav-link ${currentPath.contains('/librarian/fines') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect width="20" height="14" x="2" y="5" rx="2"></rect><line x1="2" x2="22" y1="10" y2="10"></line></svg>
                    <span>Fine Collections</span>
                </a>
            </c:when>

            <%-- ADMIN NAVIGATION --%>
            <c:when test="${sessionScope.CURRENT_USER.admin}">
                <div class="nav-section-title">Administration</div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${currentPath.contains('/admin/dashboard') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                    <span>Admin Overview</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-link ${currentPath.contains('/admin/users') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    <span>User Management</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-link ${currentPath.contains('/admin/settings') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                    <span>Library Rules & Settings</span>
                </a>
                <a href="${pageContext.request.contextPath}/catalogue" class="nav-link ${currentPath.contains('/catalogue') ? 'active' : ''}">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                    <span>Catalogue</span>
                </a>
            </c:when>
        </c:choose>

        <div class="nav-section-title">Account</div>
        <a href="${pageContext.request.contextPath}/profile" class="nav-link ${currentPath.contains('/profile') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            <span>My Profile</span>
        </a>
        <a href="${pageContext.request.contextPath}/notifications" class="nav-link ${currentPath.contains('/notifications') ? 'active' : ''}">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
            <span>Notifications</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <div class="user-mini-profile">
            <div class="user-avatar">
                ${sessionScope.CURRENT_USER.fullName.substring(0, 1)}
            </div>
            <div class="user-info-text">
                <div class="user-name" title="${sessionScope.CURRENT_USER.fullName}">${sessionScope.CURRENT_USER.fullName}</div>
                <div class="user-role-badge">${sessionScope.CURRENT_USER.roleName}</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Logout">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" x2="9" y1="12" y2="12"></line></svg>
        </a>
    </div>
</aside>
