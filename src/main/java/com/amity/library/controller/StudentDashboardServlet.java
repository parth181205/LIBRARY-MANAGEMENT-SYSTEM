package com.amity.library.controller;

import com.amity.library.model.User;
import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");

        Map<String, Object> dashboardData = libraryService.getStudentDashboardData(user.getId());

        request.setAttribute("stats", dashboardData);
        request.setAttribute("activeLoans", dashboardData.get("activeLoans"));
        request.setAttribute("recentBooks", dashboardData.get("recentBooks"));
        request.setAttribute("activeReservations", dashboardData.get("activeReservations"));

        request.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(request, response);
    }
}
