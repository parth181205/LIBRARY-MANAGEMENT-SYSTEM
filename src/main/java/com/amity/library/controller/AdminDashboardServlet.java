package com.amity.library.controller;

import com.amity.library.dao.*;
import com.amity.library.model.AuditLog;
import com.amity.library.model.User;
import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", "/admin/settings", "/admin/users"})
public class AdminDashboardServlet extends HttpServlet {

    private final LibraryService libraryService = new LibraryService();
    private final UserDAO userDAO = new UserDAO();
    private final SystemSettingDAO settingDAO = new SystemSettingDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/users".equals(path)) {
            String search = request.getParameter("search");
            int page = getIntParameter(request, "page", 1);
            int pageSize = 15;
            int offset = (page - 1) * pageSize;

            List<User> userList = userDAO.listAll(offset, pageSize, search);
            int totalUsers = userDAO.countUsers(search);
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            request.setAttribute("userList", userList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", search);
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
            return;
        }

        if ("/admin/settings".equals(path)) {
            Map<String, String> settings = settingDAO.getAllSettings();
            request.setAttribute("settings", settings);
            request.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(request, response);
            return;
        }

        // Default: Admin Dashboard
        Map<String, Object> stats = libraryService.getLibrarianDashboardData();
        List<AuditLog> auditLogs = auditLogDAO.getRecentLogs(10);

        request.setAttribute("stats", stats);
        request.setAttribute("auditLogs", auditLogs);
        request.setAttribute("settings", settingDAO.getAllSettings());
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        String clientIp = request.getRemoteAddr();

        if ("update_settings".equals(action)) {
            String maxBooks = request.getParameter("max_books_student");
            String loanDuration = request.getParameter("loan_duration_days");
            String fineRate = request.getParameter("fine_rate_per_day");
            String maxRenewals = request.getParameter("max_renewals_allowed");
            String resExpiry = request.getParameter("reservation_expiry_days");

            if (maxBooks != null) settingDAO.updateSetting("max_books_student", maxBooks.trim());
            if (loanDuration != null) settingDAO.updateSetting("loan_duration_days", loanDuration.trim());
            if (fineRate != null) settingDAO.updateSetting("fine_rate_per_day", fineRate.trim());
            if (maxRenewals != null) settingDAO.updateSetting("max_renewals_allowed", maxRenewals.trim());
            if (resExpiry != null) settingDAO.updateSetting("reservation_expiry_days", resExpiry.trim());

            auditLogDAO.log(currentUser.getId(), "UPDATE_SETTINGS", "Updated system loan duration, limits, and fine rules", clientIp);
            response.sendRedirect(request.getContextPath() + "/admin/settings?success=1");
            return;
        }

        if ("toggle_user_status".equals(action)) {
            int targetUserId = getIntParameter(request, "userId", 0);
            String newStatus = request.getParameter("status");
            if (targetUserId > 0 && newStatus != null) {
                userDAO.updateStatus(targetUserId, newStatus.trim().toUpperCase());
                auditLogDAO.log(currentUser.getId(), "USER_STATUS_CHANGE", "Changed user #" + targetUserId + " status to " + newStatus, clientIp);
            }
            response.sendRedirect(request.getContextPath() + "/admin/users?updated=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
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
