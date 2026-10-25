package com.amity.library;

import com.amity.library.dao.AuditLogDAO;
import com.amity.library.dao.UserDAO;
import com.amity.library.model.Role;
import com.amity.library.model.User;
import com.amity.library.service.AuthService;
import com.amity.library.util.PasswordUtil;
import com.amity.library.util.RateLimiter;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class AuthServiceTest {

    private UserDAO userDAO;
    private AuditLogDAO auditLogDAO;
    private RateLimiter rateLimiter;
    private AuthService authService;

    @BeforeEach
    void setUp() {
        userDAO = mock(UserDAO.class);
        auditLogDAO = mock(AuditLogDAO.class);
        rateLimiter = new RateLimiter(3, 15);
        authService = new AuthService(userDAO, auditLogDAO, rateLimiter);
    }

    @Test
    void testSuccessfulAuthentication() {
        User testUser = new User();
        testUser.setId(10);
        testUser.setEnrollmentNo("A2305221001");
        testUser.setPasswordHash(PasswordUtil.hashPassword("Student@Amity2026"));
        testUser.setStatus("ACTIVE");
        testUser.setRoleName(Role.STUDENT);

        when(userDAO.findByEnrollmentNo("A2305221001")).thenReturn(Optional.of(testUser));

        AuthService.LoginResult result = authService.authenticate("A2305221001", "Student@Amity2026", "127.0.0.1");

        assertTrue(result.isSuccess());
        assertNotNull(result.getUser());
        assertEquals("A2305221001", result.getUser().getEnrollmentNo());
        verify(auditLogDAO).log(eq(10), eq("LOGIN_SUCCESS"), anyString(), eq("127.0.0.1"));
    }

    @Test
    void testFailedAuthenticationWrongPassword() {
        User testUser = new User();
        testUser.setId(10);
        testUser.setEnrollmentNo("A2305221001");
        testUser.setPasswordHash(PasswordUtil.hashPassword("Student@Amity2026"));
        testUser.setStatus("ACTIVE");

        when(userDAO.findByEnrollmentNo("A2305221001")).thenReturn(Optional.of(testUser));

        AuthService.LoginResult result = authService.authenticate("A2305221001", "WrongPassword", "127.0.0.1");

        assertFalse(result.isSuccess());
        assertEquals("Invalid credentials. Please verify your ID and password.", result.getMessage());
    }

    @Test
    void testSuspendedUserBlocked() {
        User suspendedUser = new User();
        suspendedUser.setId(20);
        suspendedUser.setEnrollmentNo("A2305221099");
        suspendedUser.setStatus("SUSPENDED");
        suspendedUser.setPasswordHash(PasswordUtil.hashPassword("Pass1234"));

        when(userDAO.findByEnrollmentNo("A2305221099")).thenReturn(Optional.of(suspendedUser));

        AuthService.LoginResult result = authService.authenticate("A2305221099", "Pass1234", "127.0.0.1");

        assertFalse(result.isSuccess());
        assertTrue(result.getMessage().contains("suspended"));
    }

    @Test
    void testRateLimitingEnforcement() {
        when(userDAO.findByEnrollmentNo("BAD_USER")).thenReturn(Optional.empty());

        // Fail 3 times (the configured limit)
        authService.authenticate("BAD_USER", "123", "192.168.1.50");
        authService.authenticate("BAD_USER", "123", "192.168.1.50");
        authService.authenticate("BAD_USER", "123", "192.168.1.50");

        // 4th attempt must be rate-limited
        AuthService.LoginResult result = authService.authenticate("BAD_USER", "123", "192.168.1.50");
        assertFalse(result.isSuccess());
        assertTrue(result.getMessage().contains("Too many failed attempts"));
    }
}
