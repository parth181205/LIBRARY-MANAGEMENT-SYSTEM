<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Amity University Library</title>
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
                    <h1 class="page-title">Patron Account &amp; Profile</h1>
                    <p class="page-subtitle">Manage your personal academic information and security credentials</p>
                </div>
            </div>

            <c:if test="${param.updated eq '1'}">
                <div class="alert alert-success">
                    &#10003; Profile details updated successfully!
                </div>
            </c:if>

            <c:if test="${param.password_changed eq '1'}">
                <div class="alert alert-success">
                    &#10003; Password successfully updated! Your account is protected with BCrypt encryption.
                </div>
            </c:if>

            <c:if test="${param.error eq 'invalid_current_password'}">
                <div class="alert alert-error">
                    &#9888; Incorrect current password. Please try again.
                </div>
            </c:if>

            <c:if test="${param.error eq 'password_mismatch'}">
                <div class="alert alert-error">
                    &#9888; New passwords do not match.
                </div>
            </c:if>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 28px;">
                <!-- Profile Information Card -->
                <div class="content-card">
                    <div class="card-header">
                        <h3 class="card-title">Academic &amp; Contact Details</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/profile" method="POST">
                            <input type="hidden" name="action" value="update_profile">

                            <div class="form-group">
                                <label class="form-label">Full Name</label>
                                <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Enrollment / Employee ID</label>
                                <input type="text" class="form-control" value="${user.enrollmentNo}" readonly style="background: var(--main-bg); cursor: not-allowed;">
                                <small style="color: var(--secondary-text); font-size: 0.78rem;">Managed by university registrar.</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Official Email</label>
                                <input type="email" class="form-control" value="${user.email}" readonly style="background: var(--main-bg); cursor: not-allowed;">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mobile Contact</label>
                                <input type="tel" name="phone" class="form-control" value="${user.phone}" placeholder="+91 98765 43210">
                            </div>

                            <div class="form-group">
                                <label class="form-label">School / Department</label>
                                <input type="text" name="department" class="form-control" value="${user.department}">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Course / Degree</label>
                                <input type="text" name="course" class="form-control" value="${user.course}">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Academic Year</label>
                                <input type="text" name="academicYear" class="form-control" value="${user.academicYear}">
                            </div>

                            <button type="submit" class="btn btn-primary">Save Profile</button>
                        </form>
                    </div>
                </div>

                <!-- Password Change Card -->
                <div class="content-card">
                    <div class="card-header">
                        <h3 class="card-title">Security &amp; Password Update</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/profile" method="POST">
                            <input type="hidden" name="action" value="change_password">

                            <div class="form-group">
                                <label class="form-label">Current Password *</label>
                                <div class="password-input-group">
                                    <input type="password" id="currentPass" name="currentPassword" class="form-control" placeholder="Enter existing password" required>
                                    <button type="button" class="toggle-password-btn" data-target="currentPass">
                                        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">New Password * (min 6 characters)</label>
                                <div class="password-input-group">
                                    <input type="password" id="newPass" name="newPassword" class="form-control" placeholder="Enter new strong password" minlength="6" required>
                                    <button type="button" class="toggle-password-btn" data-target="newPass">
                                        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Confirm New Password *</label>
                                <input type="password" name="confirmPassword" class="form-control" placeholder="Re-enter new password" minlength="6" required>
                            </div>

                            <button type="submit" class="btn btn-gold">Update Password</button>
                        </form>
                    </div>
                </div>
            </div>

        </div>

        <jsp:include page="common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
