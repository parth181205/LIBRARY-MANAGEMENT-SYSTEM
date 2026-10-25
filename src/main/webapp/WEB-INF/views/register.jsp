<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration | Amity University Noida Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
</head>
<body class="login-page-body" style="background: var(--main-bg);">

<div style="min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 40px 20px; width: 100%;">
    <div class="login-card" style="max-width: 650px;">
        <div class="login-card-header">
            <img src="${pageContext.request.contextPath}/assets/images/amity-logo.png" 
                 alt="Amity University Logo" 
                 class="card-logo-center">
            <h2 class="login-card-title">Student Library Registration</h2>
            <p class="login-card-subtitle">Enroll to borrow books, reserve resources, and access academic repositories</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" role="alert">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="POST" id="regForm">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 16px;">
                <div class="form-group">
                    <label for="enrollmentNo" class="form-label">Enrollment Number *</label>
                    <input type="text" id="enrollmentNo" name="enrollmentNo" class="form-control" placeholder="e.g. A2305221099" value="${enrollmentNo}" required>
                </div>

                <div class="form-group">
                    <label for="fullName" class="form-label">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. Rohan Gupta" value="${fullName}" required>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">Official / Personal Email *</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="student@amity.edu" value="${email}" required>
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Mobile Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="+91 98765 43210" value="${phone}">
                </div>

                <div class="form-group">
                    <label for="department" class="form-label">Department / School *</label>
                    <select id="department" name="department" class="form-control" required>
                        <option value="">Select School</option>
                        <option value="Amity School of Engineering and Technology (ASET)" ${department eq 'Amity School of Engineering and Technology (ASET)' ? 'selected' : ''}>Amity School of Engineering &amp; Technology (ASET)</option>
                        <option value="Amity Business School (ABS)" ${department eq 'Amity Business School (ABS)' ? 'selected' : ''}>Amity Business School (ABS)</option>
                        <option value="Amity Institute of Information Technology (AIIT)" ${department eq 'Amity Institute of Information Technology (AIIT)' ? 'selected' : ''}>Amity Institute of Information Technology (AIIT)</option>
                        <option value="Amity School of Biotechnology (ASB)" ${department eq 'Amity School of Biotechnology (ASB)' ? 'selected' : ''}>Amity School of Biotechnology (ASB)</option>
                        <option value="Amity Law School (ALS)" ${department eq 'Amity Law School (ALS)' ? 'selected' : ''}>Amity Law School (ALS)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="course" class="form-label">Course / Degree *</label>
                    <input type="text" id="course" name="course" class="form-control" placeholder="e.g. B.Tech CSE, MBA, BCA" value="${course}" required>
                </div>

                <div class="form-group">
                    <label for="academicYear" class="form-label">Academic Year *</label>
                    <select id="academicYear" name="academicYear" class="form-control" required>
                        <option value="1st Year" ${academicYear eq '1st Year' ? 'selected' : ''}>1st Year</option>
                        <option value="2nd Year" ${academicYear eq '2nd Year' ? 'selected' : ''}>2nd Year</option>
                        <option value="3rd Year" ${academicYear eq '3rd Year' ? 'selected' : ''}>3rd Year</option>
                        <option value="4th Year" ${academicYear eq '4th Year' ? 'selected' : ''}>4th Year</option>
                        <option value="5th Year" ${academicYear eq '5th Year' ? 'selected' : ''}>5th Year</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Password * (min 6 chars)</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Choose a secure password" minlength="6" required>
                </div>

                <div class="form-group" style="grid-column: 1 / -1;">
                    <label for="confirmPassword" class="form-label">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Re-enter your password" minlength="6" required>
                </div>
            </div>

            <!-- Turnstile widget -->
            <div class="turnstile-wrapper" style="margin-top: 10px;">
                <c:choose>
                    <c:when test="${turnstileEnabled}">
                        <div class="cf-turnstile" data-sitekey="${turnstileSiteKey}" data-theme="light"></div>
                    </c:when>
                    <c:otherwise>
                        <span style="font-size: 0.8rem; color: #10B981;">&#10003; Verification active</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <button type="submit" class="btn-login-submit" style="margin-top: 10px;">
                Complete Registration
            </button>
        </form>

        <div class="login-card-footer">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Back to Login</a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
