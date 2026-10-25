package com.amity.library.controller;

import com.amity.library.model.User;
import com.amity.library.service.LibraryService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "RenewalDecisionServlet", urlPatterns = {"/librarian/renewals/decision"})
public class RenewalDecisionServlet extends HttpServlet {

    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User librarian = (User) session.getAttribute("CURRENT_USER");

        int requestId = getIntParameter(request, "requestId", 0);
        String decision = request.getParameter("decision");
        String notes = request.getParameter("librarianNotes");

        if (requestId > 0 && decision != null) {
            boolean approve = "approve".equalsIgnoreCase(decision);
            libraryService.processRenewal(requestId, approve, notes, librarian.getId(), request.getRemoteAddr());
        }

        response.sendRedirect(request.getContextPath() + "/librarian/dashboard?tab=renewals");
    }

    private int getIntParameter(HttpServletRequest request, String param, int defaultValue) {
        String val = request.getParameter(param);
        if (val == null) return defaultValue;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
