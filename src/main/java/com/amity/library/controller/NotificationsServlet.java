package com.amity.library.controller;

import com.amity.library.dao.NotificationDAO;
import com.amity.library.model.Notification;
import com.amity.library.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationsServlet", urlPatterns = {"/notifications"})
public class NotificationsServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");

        List<Notification> notifications = notificationDAO.findNotificationsByUserId(user.getId(), 50);
        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");

        String action = request.getParameter("action");
        if ("mark_all_read".equals(action)) {
            notificationDAO.markAllAsRead(user.getId());
        }

        response.sendRedirect(request.getContextPath() + "/notifications");
    }
}
