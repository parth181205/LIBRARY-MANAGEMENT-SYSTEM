package com.amity.library.controller;

import com.amity.library.dao.BookDAO;
import com.amity.library.dao.CategoryDAO;
import com.amity.library.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PortalServlet", urlPatterns = {"/portal"})
public class PortalServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch top 6 books for featured showcase
            List<Book> featuredBooks = bookDAO.searchBooks(null, null, "available", "title_asc", 0, 6);
            request.setAttribute("featuredBooks", featuredBooks);
            request.setAttribute("categories", categoryDAO.listAll());
        } catch (Exception e) {
            // Fallback gracefully if database lookup has issue
            request.setAttribute("featuredBooks", List.of());
        }

        request.getRequestDispatcher("/WEB-INF/views/public/portal.jsp").forward(request, response);
    }
}
