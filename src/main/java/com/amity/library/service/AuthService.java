package com.amity.library.service;

import com.amity.library.dao.AuditLogDAO;
import com.amity.library.dao.UserDAO;
import com.amity.library.model.Role;
import com.amity.library.model.User;
import com.amity.library.util.PasswordUtil;
import com.amity.library.util.RateLimiter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    private final UserDAO userDAO;
    private final AuditLogDAO auditLogDAO;
    private final RateLimiter rateLimiter;

    public AuthService() {
        this.userDAO = new UserDAO();
        this.auditLogDAO = new AuditLogDAO();
        this.rateLimiter = new RateLimiter(5, 15); // 5 attempts per 15 minutes window
    }

    public AuthService(UserDAO userDAO, AuditLogDAO auditLogDAO, RateLimiter rateLimiter) {
        this.userDAO = userDAO;
        this.auditLogDAO = auditLogDAO;
        this.rateLimiter = rateLimiter;
    }

    public LoginResult authenticate(String identifier, String plainPassword, String clientIp) {
        if (identifier == null || identifier.trim().isEmpty() || plainPassword == null || plainPassword.isEmpty()) {
            return LoginResult.failure("Enrollment / Employee ID and password are required.");
        }

        String rateLimitKey = (clientIp != null ? clientIp : "unknown") + "_" + identifier.trim();
        if (!rateLimiter.isAllowed(rateLimitKey)) {
            logger.warn("Rate limit exceeded for login attempt: {}", identifier);
            auditLogDAO.log(null, "LOGIN_RATE_LIMITED", "Too many failed attempts for identifier: " + identifier, clientIp);
            return LoginResult.failure("Too many failed attempts. Please wait 15 minutes before trying again.");
        }

        Optional<User> userOpt = userDAO.findByEnrollmentNo(identifier.trim());
        if (userOpt.isEmpty()) {
            // Also try email lookup
            userOpt = userDAO.findByEmail(identifier.trim());
        }

        if (userOpt.isEmpty()) {
            rateLimiter.recordFailure(rateLimitKey);
            auditLogDAO.log(null, "LOGIN_FAILED", "Unknown identifier: " + identifier, clientIp);
            return LoginResult.failure("Invalid credentials. Please verify your ID and password.");
        }

        User user = userOpt.get();

        if (!user.isActive()) {
            auditLogDAO.log(user.getId(), "LOGIN_BLOCKED", "Attempt to login to " + user.getStatus() + " account", clientIp);
            return LoginResult.failure("Your account is currently " + user.getStatus().toLowerCase() + ". Please contact the library administrator.");
        }

        if (!PasswordUtil.checkPassword(plainPassword, user.getPasswordHash())) {
            rateLimiter.recordFailure(rateLimitKey);
            auditLogDAO.log(user.getId(), "LOGIN_FAILED", "Incorrect password", clientIp);
            return LoginResult.failure("Invalid credentials. Please verify your ID and password.");
        }

        // Authentication successful
        rateLimiter.recordSuccess(rateLimitKey);
        auditLogDAO.log(user.getId(), "LOGIN_SUCCESS", "User authenticated successfully via " + user.getRoleName() + " portal", clientIp);
        return LoginResult.success(user);
    }

    public RegistrationResult registerStudent(String enrollmentNo, String fullName, String email, String plainPassword,
                                              String department, String course, String academicYear, String phone, String clientIp) {
        if (enrollmentNo == null || enrollmentNo.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            plainPassword == null || plainPassword.length() < 6) {
            return RegistrationResult.failure("Please fill in all required fields. Password must be at least 6 characters.");
        }

        if (userDAO.findByEnrollmentNo(enrollmentNo.trim()).isPresent()) {
            return RegistrationResult.failure("Enrollment number '" + enrollmentNo.trim() + "' is already registered.");
        }

        if (userDAO.findByEmail(email.trim().toLowerCase()).isPresent()) {
            return RegistrationResult.failure("Email address '" + email.trim() + "' is already associated with an account.");
        }

        User newUser = new User();
        newUser.setEnrollmentNo(enrollmentNo.trim().toUpperCase());
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPasswordHash(PasswordUtil.hashPassword(plainPassword));
        newUser.setRoleId(1); // 1 = STUDENT role, preventing privilege escalation
        newUser.setRoleName(Role.STUDENT);
        newUser.setDepartment(department != null ? department.trim() : "");
        newUser.setCourse(course != null ? course.trim() : "");
        newUser.setAcademicYear(academicYear != null ? academicYear.trim() : "1st Year");
        newUser.setPhone(phone != null ? phone.trim() : "");
        newUser.setStatus("ACTIVE");

        boolean created = userDAO.createUser(newUser);
        if (created) {
            auditLogDAO.log(newUser.getId(), "REGISTRATION", "Student registered: " + newUser.getEnrollmentNo(), clientIp);
            return RegistrationResult.success(newUser);
        } else {
            return RegistrationResult.failure("Failed to complete registration due to a server error. Please try again.");
        }
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword, String clientIp) {
        if (newPassword == null || newPassword.length() < 6) {
            return false;
        }

        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();
        if (!PasswordUtil.checkPassword(currentPassword, user.getPasswordHash())) {
            auditLogDAO.log(userId, "PASSWORD_CHANGE_FAILED", "Incorrect current password provided", clientIp);
            return false;
        }

        String newHash = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(userId, newHash);
        if (updated) {
            auditLogDAO.log(userId, "PASSWORD_CHANGED", "Password successfully updated", clientIp);
        }
        return updated;
    }

    public static class LoginResult {
        private final boolean success;
        private final String message;
        private final User user;

        private LoginResult(boolean success, String message, User user) {
            this.success = success;
            this.message = message;
            this.user = user;
        }

        public static LoginResult success(User user) {
            return new LoginResult(true, "Authentication successful", user);
        }

        public static LoginResult failure(String message) {
            return new LoginResult(false, message, null);
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public User getUser() { return user; }
    }

    public static class RegistrationResult {
        private final boolean success;
        private final String message;
        private final User user;

        private RegistrationResult(boolean success, String message, User user) {
            this.success = success;
            this.message = message;
            this.user = user;
        }

        public static RegistrationResult success(User user) {
            return new RegistrationResult(true, "Registration successful", user);
        }

        public static RegistrationResult failure(String message) {
            return new RegistrationResult(false, message, null);
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public User getUser() { return user; }
    }
}
