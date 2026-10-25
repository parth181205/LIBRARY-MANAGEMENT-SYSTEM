<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404 Page Not Found | Amity University Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body style="min-height: 100vh; display: flex; align-items: center; justify-content: center; background: var(--main-bg);">
    <div class="content-card" style="max-width: 500px; text-align: center; padding: 48px 32px;">
        <h1 style="font-size: 4rem; color: var(--primary-navy); margin-bottom: 8px;">404</h1>
        <h2 style="font-size: 1.5rem; color: var(--primary-navy); margin-bottom: 12px;">Resource Not Found</h2>
        <p style="color: var(--secondary-text); margin-bottom: 24px;">The page or book record you are seeking does not exist or has been relocated.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Return to Homepage</a>
    </div>
</body>
</html>
