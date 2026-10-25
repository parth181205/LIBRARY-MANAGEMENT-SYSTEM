<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Notifications | Amity University</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<div class="app-container">
    <jsp:include page="common/sidebar.jsp" />

    <main class="app-main">
        <jsp:include page="common/topbar.jsp" />

        <div class="page-content">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Notifications &amp; Due Date Alerts</h1>
                    <p class="page-subtitle">Stay informed about your upcoming due dates, reservation pickups, and renewal approvals</p>
                </div>
                <div>
                    <form action="${pageContext.request.contextPath}/notifications" method="POST">
                        <input type="hidden" name="action" value="mark_all_read">
                        <button type="submit" class="btn btn-secondary btn-sm">&#10003; Mark All as Read</button>
                    </form>
                </div>
            </div>

            <div class="content-card">
                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <div style="display: flex; flex-direction: column;">
                                <c:forEach var="n" items="${notifications}">
                                    <div style="padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; align-items: flex-start; gap: 16px; background: ${n.read ? '#FFFFFF' : '#F8FAFC'};">
                                        <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--navy-ultra-light); color: var(--primary-navy); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; flex-shrink: 0;">
                                            &#128276;
                                        </div>
                                        <div style="flex: 1;">
                                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                                                <h4 style="font-size: 1rem; color: var(--primary-navy); font-weight: 700;">${n.title}</h4>
                                                <span style="font-size: 0.8rem; color: var(--secondary-text);">
                                                    <fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, HH:mm" />
                                                </span>
                                            </div>
                                            <p style="font-size: 0.92rem; color: var(--main-text); margin: 0;">
                                                ${n.message}
                                            </p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 50px; text-align: center; color: var(--secondary-text);">
                                <div style="font-size: 2.5rem; margin-bottom: 12px;">&#128276;</div>
                                <h4>No Notifications</h4>
                                <p>You have caught up with all library alerts and announcements.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>

        <jsp:include page="common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
