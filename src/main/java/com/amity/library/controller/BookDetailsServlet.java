package com.amity.library.controller;

import com.amity.library.dao.BookCopyDAO;
import com.amity.library.dao.BookDAO;
import com.amity.library.dao.ReservationDAO;
import com.amity.library.model.Book;
import com.amity.library.model.BookCopy;
import com.amity.library.model.User;
import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "BookDetailsServlet", urlPatterns = {"/book"})
public class BookDetailsServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookId = getIntParameter(request, "id", 0);
        String isbn = request.getParameter("isbn");

        Optional<Book> bookOpt = (bookId > 0) ? bookDAO.findById(bookId) : (isbn != null ? bookDAO.findByIsbn(isbn) : Optional.empty());

        if (bookOpt.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found in library catalogue.");
            return;
        }

        Book book = bookOpt.get();
        List<BookCopy> copies = bookCopyDAO.findCopiesByBookId(book.getId());

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("CURRENT_USER") : null;
        boolean hasActiveReservation = false;

        if (currentUser != null) {
            hasActiveReservation = reservationDAO.hasActiveReservation(currentUser.getId(), book.getId());
        }

        request.setAttribute("book", book);
        request.setAttribute("copies", copies);
        request.setAttribute("hasActiveReservation", hasActiveReservation);
        request.getRequestDispatcher("/WEB-INF/views/book-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("CURRENT_USER") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int bookId = getIntParameter(request, "bookId", 0);

        if ("reserve".equals(action) && bookId > 0) {
            boolean reserved = libraryService.reserveBook(currentUser.getId(), bookId, request.getRemoteAddr());
            if (reserved) {
                response.sendRedirect(request.getContextPath() + "/book?id=" + bookId + "&reserved=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/book?id=" + bookId + "&error=reservation_failed");
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + "/catalogue");
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
