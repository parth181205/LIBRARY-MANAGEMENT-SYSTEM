<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>500 Internal Error | Amity University Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body style="min-height: 100vh; display: flex; align-items: center; justify-content: center; background: var(--main-bg);">
    <div class="content-card" style="max-width: 500px; text-align: center; padding: 48px 32px;">
        <h1 style="font-size: 4rem; color: var(--error); margin-bottom: 8px;">500</h1>
        <h2 style="font-size: 1.5rem; color: var(--primary-navy); margin-bottom: 12px;">Server Error</h2>
        <p style="color: var(--secondary-text); margin-bottom: 24px;">An unexpected error occurred. The incident has been recorded for technical investigation.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Return to Homepage</a>
    </div>
</body>
</html>
