package com.amity.library.filter;

import com.amity.library.config.ConfigManager;
import com.amity.library.util.CsrfUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter(filterName = "SecurityHeadersFilter", urlPatterns = {"/*"})
public class SecurityHeadersFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Security headers
        httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN");
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
        httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        // Character encoding
        httpRequest.setCharacterEncoding("UTF-8");
        httpResponse.setCharacterEncoding("UTF-8");

        // Inject Turnstile Site Key for frontend use
        httpRequest.setAttribute("turnstileSiteKey", ConfigManager.get("turnstile.siteKey", "1x00000000000000000000AA"));
        httpRequest.setAttribute("turnstileEnabled", ConfigManager.getBoolean("turnstile.enabled", true));

        // Inject CSRF token if session exists
        if (httpRequest.getSession(false) != null) {
            httpRequest.setAttribute("csrfToken", CsrfUtil.getToken(httpRequest.getSession(false)));
        }

        chain.doFilter(request, response);
    }
}
