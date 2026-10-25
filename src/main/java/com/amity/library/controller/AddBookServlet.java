package com.amity.library.controller;

import com.amity.library.dao.*;
import com.amity.library.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddBookServlet", urlPatterns = {"/librarian/books/add"})
public class AddBookServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final PublisherDAO publisherDAO = new PublisherDAO();
    private final AuthorDAO authorDAO = new AuthorDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", categoryDAO.listAll());
        request.setAttribute("publishers", publisherDAO.listAll());
        request.setAttribute("authors", authorDAO.listAll());
        request.getRequestDispatcher("/WEB-INF/views/librarian/add-book.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User librarian = (User) session.getAttribute("CURRENT_USER");

        String title = request.getParameter("title");
        String isbn = request.getParameter("isbn");
        int categoryId = getIntParameter(request, "categoryId", 1);
        int publisherId = getIntParameter(request, "publisherId", 1);
        String edition = request.getParameter("edition");
        int pubYear = getIntParameter(request, "publicationYear", 2024);
        String description = request.getParameter("description");
        String coverImage = request.getParameter("coverImage");
        String authorIdStr = request.getParameter("authorId");
        int initialCopies = getIntParameter(request, "initialCopies", 1);

        Book book = new Book();
        book.setTitle(title != null ? title.trim() : "Untitled");
        book.setIsbn(isbn != null ? isbn.trim() : "ISBN-" + System.currentTimeMillis());
        book.setCategoryId(categoryId);
        book.setPublisherId(publisherId > 0 ? publisherId : null);
        book.setEdition(edition);
        book.setPublicationYear(pubYear);
        book.setDescription(description);
        book.setCoverImage(coverImage != null && !coverImage.trim().isEmpty() ? coverImage.trim() : "assets/images/default-book.png");
        book.setTotalCopies(0);
        book.setAvailableCopies(0);

        List<Integer> authorIds = new ArrayList<>();
        if (authorIdStr != null && !authorIdStr.isEmpty()) {
            authorIds.add(Integer.parseInt(authorIdStr));
        }

        boolean created = bookDAO.createBook(book, authorIds);
        if (created) {
            // Generate initial copies
            for (int i = 1; i <= initialCopies; i++) {
                String barcode = "AM-" + book.getId() + "-" + String.format("%03d", i);
                bookCopyDAO.addCopy(book.getId(), barcode, "Shelf A-" + (book.getId() % 10), "New Copy");
            }

            auditLogDAO.log(librarian.getId(), "ADD_BOOK", "Added new book: " + book.getTitle() + " with " + initialCopies + " copies", request.getRemoteAddr());
            response.sendRedirect(request.getContextPath() + "/book?id=" + book.getId() + "&added=1");
        } else {
            request.setAttribute("errorMessage", "Failed to add book. Ensure ISBN is unique.");
            doGet(request, response);
        }
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
