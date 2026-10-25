package com.amity.library.controller;

import com.amity.library.config.ConfigManager;
import com.amity.library.model.Role;
import com.amity.library.model.User;
import com.amity.library.service.AuthService;
import com.amity.library.service.TurnstileService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", ""})
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();
    private final TurnstileService turnstileService = new TurnstileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("CURRENT_USER") != null) {
            User user = (User) session.getAttribute("CURRENT_USER");
            redirectToDashboard(request, response, user);
            return;
        }

        request.setAttribute("turnstileSiteKey", ConfigManager.get("turnstile.siteKey", "1x00000000000000000000AA"));
        request.setAttribute("turnstileEnabled", ConfigManager.getBoolean("turnstile.enabled", true));
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        String turnstileToken = request.getParameter("cf-turnstile-response");
        String rememberMe = request.getParameter("rememberMe");
        String clientIp = request.getRemoteAddr();

        // 1. Verify Cloudflare Turnstile bot protection before database query
        TurnstileService.VerificationResult turnstileResult = turnstileService.verify(turnstileToken, clientIp);
        if (!turnstileResult.isValid()) {
            request.setAttribute("errorMessage", turnstileResult.getErrorMessage());
            request.setAttribute("identifier", identifier);
            request.setAttribute("turnstileSiteKey", ConfigManager.get("turnstile.siteKey", "1x00000000000000000000AA"));
            request.setAttribute("turnstileEnabled", ConfigManager.getBoolean("turnstile.enabled", true));
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        // 2. Authenticate user credentials against MySQL database with BCrypt
        AuthService.LoginResult loginResult;
        try {
            loginResult = authService.authenticate(identifier, password, clientIp);
        } catch (RuntimeException e) {
            // Database connection failure (e.g. wrong password in application.properties)
            request.setAttribute("errorMessage",
                "Database connection error. Please verify MySQL credentials in application.properties (db.password).");
            request.setAttribute("identifier", identifier);
            request.setAttribute("turnstileSiteKey", ConfigManager.get("turnstile.siteKey", "1x00000000000000000000AA"));
            request.setAttribute("turnstileEnabled", ConfigManager.getBoolean("turnstile.enabled", true));
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        if (!loginResult.isSuccess()) {
            request.setAttribute("errorMessage", loginResult.getMessage());
            request.setAttribute("identifier", identifier);
            request.setAttribute("turnstileSiteKey", ConfigManager.get("turnstile.siteKey", "1x00000000000000000000AA"));
            request.setAttribute("turnstileEnabled", ConfigManager.getBoolean("turnstile.enabled", true));
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        User user = loginResult.getUser();

        // 3. Prevent session fixation: invalidate old session and create fresh session
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("CURRENT_USER", user);
        newSession.setMaxInactiveInterval(ConfigManager.getInt("app.sessionTimeoutMinutes", 30) * 60);

        // Optional Remember Me (secure cookie setting)
        if ("true".equalsIgnoreCase(rememberMe) || "on".equalsIgnoreCase(rememberMe)) {
            Cookie idCookie = new Cookie("amity_last_id", user.getEnrollmentNo());
            idCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
            idCookie.setPath(request.getContextPath() + "/login");
            idCookie.setHttpOnly(true);
            if (request.isSecure()) {
                idCookie.setSecure(true);
            }
            response.addCookie(idCookie);
        }

        // 4. Role-based redirect to dedicated portal
        redirectToDashboard(request, response, user);
    }

    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String contextPath = request.getContextPath();
        if (user.isAdmin()) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if (user.isLibrarian()) {
            response.sendRedirect(contextPath + "/librarian/dashboard");
        } else {
            response.sendRedirect(contextPath + "/student/dashboard");
        }
    }
}
