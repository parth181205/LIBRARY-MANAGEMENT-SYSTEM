<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Amity University Noida Library Management System</title>
    <meta name="description" content="Access the Amity University Noida Library Management System. Search books, manage loans, reservations, and more.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <%-- Official Cloudflare Turnstile API --%>
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
</head>
<body class="login-page-body">

<!-- ===== FULL-SCREEN CAMPUS BACKGROUND (NATURAL SUNSET - NO BLUE TINT) ===== -->
<div class="login-bg-wrapper">
    <img src="${pageContext.request.contextPath}/assets/images/campus-sunset.png"
         alt="Amity University Noida Campus"
         loading="eager">
    <div class="login-bg-clarity-glow"></div>
</div>

<!-- ===== TOP NAVIGATION BAR ===== -->
<nav class="login-topnav">
    <div class="login-topnav-logo">
        <img src="${pageContext.request.contextPath}/assets/images/amity-logo.png"
             alt="Amity University Noida"
             class="topnav-amity-logo">
    </div>
    <div class="login-topnav-right">
        <ul class="login-topnav-links">
            <li><a href="${pageContext.request.contextPath}/portal">Portal</a></li>
            <li><a href="${pageContext.request.contextPath}/library">Library</a></li>
            <li><a href="${pageContext.request.contextPath}/events">Events</a></li>
            <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
        </ul>
        <a href="${pageContext.request.contextPath}/login" class="topnav-profile-icon" title="Patron Login">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
        </a>
    </div>
</nav>

<!-- ===== MAIN CONTENT (STATIC 16:9 SPLIT) ===== -->
<div class="login-main-content">

    <!-- LEFT: Hero Text & Minimalist Feature Items -->
    <div class="login-hero-content">
        <h1 class="login-hero-title">
            Amity University
            <span class="login-hero-title-sub">Library Management System</span>
        </h1>
        <p class="login-hero-tagline">"Knowledge Today. A Better Tomorrow."</p>

        <!-- 4 Minimalist Feature Columns matching reference image -->
        <div class="login-features-row">
            <div class="login-feature-item">
                <div class="login-feature-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                </div>
                <div class="login-feature-text">50,000+<br>Books</div>
            </div>
            <div class="login-feature-item">
                <div class="login-feature-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
                </div>
                <div class="login-feature-text">Digital<br>Resources</div>
            </div>
            <div class="login-feature-item">
                <div class="login-feature-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M3 21h18"></path><path d="M5 21V7l7-4 7 4v14"></path><path d="M9 10v6"></path><path d="M15 10v6"></path></svg>
                </div>
                <div class="login-feature-text">Study<br>Spaces</div>
            </div>
            <div class="login-feature-item">
                <div class="login-feature-icon">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                </div>
                <div class="login-feature-text">24/7<br>Access</div>
            </div>
        </div>
    </div>

    <!-- RIGHT: Floating Glass Login Card -->
    <div class="login-card-wrapper">
        <div class="login-card">
            <div class="login-card-header">
                <img src="${pageContext.request.contextPath}/assets/images/amity-logo.png"
                     alt="Amity University Noida"
                     class="card-logo-center">
                <h2 class="login-card-title">Welcome Back</h2>
                <p class="login-card-subtitle">Login to Access Your Library Account</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error" role="alert">
                    <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <c:if test="${param.registered eq 'success'}">
                <div class="alert alert-success" role="alert">
                    <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    <span>Registration completed! Please login.</span>
                </div>
            </c:if>

            <c:if test="${param.logout eq 'success'}">
                <div class="alert alert-success" role="alert">
                    <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    <span>You have been safely logged out.</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm" autocomplete="on">
                <!-- Pill Input 1: User / Enrollment -->
                <div class="form-group">
                    <div class="login-input-group">
                        <span class="login-input-icon">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </span>
                        <input type="text"
                                id="identifier"
                                name="identifier"
                                class="form-control"
                                placeholder="Enrollment No. / Employee ID"
                                value="${identifier}"
                                required
                                autofocus>
                    </div>
                </div>

                <!-- Pill Input 2: Password -->
                <div class="form-group">
                    <div class="login-input-group">
                        <span class="login-input-icon">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        </span>
                        <input type="password"
                                id="password"
                                name="password"
                                class="form-control"
                                placeholder="Password"
                                required>
                        <button type="button" class="toggle-password-btn" data-target="password" aria-label="Toggle password visibility">
                            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                        </button>
                    </div>
                </div>

                <div class="login-forgot-row">
                    <a href="javascript:alert('For assistance, please contact the Amity Central Library IT Desk or email libraryhelpdesk@amity.edu');" class="forgot-password-link">Forgot Password?</a>
                </div>

                <!-- Cloudflare Turnstile Bot Protection Widget -->
                <div class="turnstile-wrapper">
                    <c:choose>
                        <c:when test="${turnstileEnabled}">
                            <div class="cf-turnstile"
                                 data-sitekey="${turnstileSiteKey}"
                                 data-theme="light"
                                 data-size="normal">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span style="font-size: 0.72rem; color: #10B981;">&#10003; Bot verification disabled</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pill Action Button: Login -->
                <button type="submit" class="btn-login-submit" id="loginBtn">
                    <span>Login</span>
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                </button>
            </form>

            <!-- Register Footer Link -->
            <div class="login-card-footer">
                New to Library? <a href="${pageContext.request.contextPath}/register">Register Here</a>
            </div>

            <!-- Discrete Quick Fill -->
            <div class="demo-credentials-box">
                <span style="font-size: 0.68rem; color: #6B7280;">Demo:</span>
                <div style="display: flex; gap: 4px;">
                    <button type="button" class="btn-demo-fill" data-id="A2305221001" data-pass="Student@Amity2026">Student</button>
                    <button type="button" class="btn-demo-fill" data-id="LIB-2001" data-pass="Librarian@Amity2026">Librarian</button>
                    <button type="button" class="btn-demo-fill" data-id="ADM-1001" data-pass="Admin@Amity2026">Admin</button>
                </div>
            </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
