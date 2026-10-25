package com.amity.library.controller;

import com.amity.library.dao.UserDAO;
import com.amity.library.model.User;
import com.amity.library.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = (User) session.getAttribute("CURRENT_USER");

        Optional<User> freshUser = userDAO.findById(sessionUser.getId());
        freshUser.ifPresent(u -> {
            request.setAttribute("user", u);
            session.setAttribute("CURRENT_USER", u); // keep fresh in session
        });

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");
        String action = request.getParameter("action");
        String clientIp = request.getRemoteAddr();

        if ("update_profile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String department = request.getParameter("department");
            String course = request.getParameter("course");
            String academicYear = request.getParameter("academicYear");

            boolean updated = userDAO.updateProfile(user.getId(), fullName, phone, department, course, academicYear);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/profile?updated=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=profile_failed");
            }
            return;
        }

        if ("change_password".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (newPassword == null || !newPassword.equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/profile?error=password_mismatch");
                return;
            }

            boolean changed = authService.changePassword(user.getId(), currentPassword, newPassword, clientIp);
            if (changed) {
                response.sendRedirect(request.getContextPath() + "/profile?password_changed=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=invalid_current_password");
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
