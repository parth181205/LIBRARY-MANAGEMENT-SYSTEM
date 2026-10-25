package com.amity.library;

import com.amity.library.util.CsrfUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CsrfUtilTest {

    @Test
    void testTokenGenerationAndSessionStorage() {
        HttpSession session = mock(HttpSession.class);
        when(session.getAttribute(CsrfUtil.CSRF_TOKEN_SESSION_ATTR)).thenReturn(null);

        String token = CsrfUtil.getToken(session);
        assertNotNull(token);
        assertEquals(64, token.length()); // 32 bytes hex encoded = 64 characters

        verify(session).setAttribute(eq(CsrfUtil.CSRF_TOKEN_SESSION_ATTR), anyString());
    }

    @Test
    void testTokenValidationSuccess() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpSession session = mock(HttpSession.class);

        String token = "abcdef1234567890abcdef1234567890";
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute(CsrfUtil.CSRF_TOKEN_SESSION_ATTR)).thenReturn(token);
        when(request.getParameter(CsrfUtil.CSRF_PARAM_NAME)).thenReturn(token);

        assertTrue(CsrfUtil.isValid(request));
    }

    @Test
    void testTokenValidationMismatch() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute(CsrfUtil.CSRF_TOKEN_SESSION_ATTR)).thenReturn("valid_token_123");
        when(request.getParameter(CsrfUtil.CSRF_PARAM_NAME)).thenReturn("attacker_token_456");

        assertFalse(CsrfUtil.isValid(request));
    }
}
