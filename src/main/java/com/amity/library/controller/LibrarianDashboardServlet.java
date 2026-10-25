package com.amity.library.controller;

import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "LibrarianDashboardServlet", urlPatterns = {"/librarian/dashboard"})
public class LibrarianDashboardServlet extends HttpServlet {

    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Object> dashboardData = libraryService.getLibrarianDashboardData();

        request.setAttribute("stats", dashboardData);
        request.setAttribute("recentLoans", dashboardData.get("recentLoans"));
        request.setAttribute("overdueLoans", dashboardData.get("overdueLoansList"));
        request.setAttribute("pendingRenewals", dashboardData.get("pendingRenewals"));
        request.setAttribute("activeReservations", dashboardData.get("activeReservationsList"));

        request.getRequestDispatcher("/WEB-INF/views/librarian/dashboard.jsp").forward(request, response);
    }
}
