package com.amity.library.filter;

import com.amity.library.model.Role;
import com.amity.library.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/student/*", "/librarian/*", "/admin/*", "/profile", "/notifications"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("CURRENT_USER") : null;

        if (user == null) {
            String redirectUrl = httpRequest.getContextPath() + "/login?error=session_expired";
            httpResponse.sendRedirect(redirectUrl);
            return;
        }

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Role authorization checks
        if (path.startsWith("/admin/") && !user.isAdmin()) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Administrator role required.");
            return;
        }

        if (path.startsWith("/librarian/") && !(user.isLibrarian() || user.isAdmin())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Librarian role required.");
            return;
        }

        if (path.startsWith("/student/") && !(user.isStudent() || user.isLibrarian() || user.isAdmin())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Student account required.");
            return;
        }

        chain.doFilter(request, response);
    }
}
