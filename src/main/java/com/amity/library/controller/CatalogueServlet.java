package com.amity.library.controller;

import com.amity.library.dao.BookDAO;
import com.amity.library.dao.CategoryDAO;
import com.amity.library.model.Book;
import com.amity.library.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CatalogueServlet", urlPatterns = {"/catalogue"})
public class CatalogueServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String category = request.getParameter("category");
        String availability = request.getParameter("availability");
        String sortBy = request.getParameter("sort");

        int page = getIntParameter(request, "page", 1);
        int pageSize = 9; // 3x3 grid
        int offset = (page - 1) * pageSize;

        List<Book> books = bookDAO.searchBooks(query, category, availability, sortBy, offset, pageSize);
        int totalResults = bookDAO.countSearchResults(query, category, availability);
        int totalPages = (int) Math.ceil((double) totalResults / pageSize);

        List<Category> categories = categoryDAO.listAll();

        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("totalResults", totalResults);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", query);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedAvailability", availability);
        request.setAttribute("selectedSort", sortBy);

        request.getRequestDispatcher("/WEB-INF/views/catalogue.jsp").forward(request, response);
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
