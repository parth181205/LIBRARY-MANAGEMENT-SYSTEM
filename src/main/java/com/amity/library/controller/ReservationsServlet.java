package com.amity.library.controller;

import com.amity.library.dao.BookCopyDAO;
import com.amity.library.dao.ReservationDAO;
import com.amity.library.model.BookCopy;
import com.amity.library.model.Reservation;
import com.amity.library.model.User;
import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ReservationsServlet", urlPatterns = {"/student/reservations", "/librarian/reservations"})
public class ReservationsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");
        String path = request.getServletPath();

        if ("/librarian/reservations".equals(path)) {
            List<Reservation> activeReservations = reservationDAO.findAllActiveReservations(50);
            request.setAttribute("reservations", activeReservations);
            request.getRequestDispatcher("/WEB-INF/views/librarian/reservations.jsp").forward(request, response);
        } else {
            List<Reservation> userReservations = reservationDAO.findReservationsByUserId(user.getId());
            request.setAttribute("reservations", userReservations);
            request.getRequestDispatcher("/WEB-INF/views/student/reservations.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");
        String action = request.getParameter("action");
        int resId = getIntParameter(request, "reservationId", 0);

        if ("cancel".equals(action) && resId > 0) {
            reservationDAO.cancelReservation(resId, user.getId());
            response.sendRedirect(request.getContextPath() + "/student/reservations?cancelled=1");
            return;
        }

        if ("update_status".equals(action) && resId > 0 && (user.isLibrarian() || user.isAdmin())) {
            String newStatus = request.getParameter("status");
            if (newStatus != null) {
                String cleanStatus = newStatus.trim().toUpperCase();
                reservationDAO.updateStatus(resId, cleanStatus);
                if ("FULFILLED".equals(cleanStatus)) {
                    reservationDAO.findById(resId).ifPresent(res -> {
                        List<BookCopy> copies = bookCopyDAO.findAvailableCopiesByBookId(res.getBookId());
                        if (!copies.isEmpty()) {
                            libraryService.issueBook(copies.get(0).getId(), res.getUserId(), user.getId(), request.getRemoteAddr());
                        }
                    });
                }
            }
            response.sendRedirect(request.getContextPath() + "/librarian/reservations?updated=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/student/reservations");
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
