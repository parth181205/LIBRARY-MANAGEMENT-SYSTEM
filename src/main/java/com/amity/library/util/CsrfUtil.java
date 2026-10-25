package com.amity.library.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.HexFormat;

/**
 * Robust CSRF protection utility.
 */
public final class CsrfUtil {

    public static final String CSRF_TOKEN_SESSION_ATTR = "CSRF_TOKEN";
    public static final String CSRF_PARAM_NAME = "csrf_token";
    public static final String CSRF_HEADER_NAME = "X-CSRF-TOKEN";

    private static final SecureRandom secureRandom = new SecureRandom();

    private CsrfUtil() {
    }

    /**
     * Retrieves existing CSRF token or creates a new cryptographically strong token.
     */
    public static String getToken(HttpSession session) {
        if (session == null) {
            return "";
        }
        String token = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        if (token == null || token.isEmpty()) {
            byte[] bytes = new byte[32];
            secureRandom.nextBytes(bytes);
            token = HexFormat.of().formatHex(bytes);
            session.setAttribute(CSRF_TOKEN_SESSION_ATTR, token);
        }
        return token;
    }

    /**
     * Validates submitted CSRF token from request parameter or header against session token.
     */
    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        if (sessionToken == null || sessionToken.isEmpty()) {
            return false;
        }

        String requestToken = request.getParameter(CSRF_PARAM_NAME);
        if (requestToken == null || requestToken.isEmpty()) {
            requestToken = request.getHeader(CSRF_HEADER_NAME);
        }

        if (requestToken == null || requestToken.isEmpty()) {
            return false;
        }

        // Constant time comparison against timing attacks
        return java.security.MessageDigest.isEqual(
                sessionToken.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                requestToken.getBytes(java.nio.charset.StandardCharsets.UTF_8)
        );
    }
}
