package com.amity.library.controller;

import com.amity.library.dao.*;
import com.amity.library.model.*;
import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "IssueReturnServlet", urlPatterns = {"/librarian/issue-return"})
public class IssueReturnServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final LoanDAO loanDAO = new LoanDAO();
    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studentQuery = request.getParameter("studentQuery");
        String bookQuery = request.getParameter("bookQuery");

        if (studentQuery != null && !studentQuery.trim().isEmpty()) {
            Optional<User> studentOpt = userDAO.findByEnrollmentNo(studentQuery.trim());
            if (studentOpt.isEmpty()) {
                studentOpt = userDAO.findByEmail(studentQuery.trim());
            }
            if (studentOpt.isPresent()) {
                User student = studentOpt.get();
                request.setAttribute("selectedStudent", student);
                request.setAttribute("studentActiveLoans", loanDAO.findActiveLoansByUserId(student.getId()));
            } else {
                request.setAttribute("studentError", "No student found with ID/Email: " + studentQuery);
            }
        }

        if (bookQuery != null && !bookQuery.trim().isEmpty()) {
            // First check if input is a specific barcode
            Optional<BookCopy> copyOpt = bookCopyDAO.findByBarcode(bookQuery.trim());
            if (copyOpt.isPresent()) {
                BookCopy copy = copyOpt.get();
                request.setAttribute("scannedCopy", copy);
                bookDAO.findById(copy.getBookId()).ifPresent(b -> request.setAttribute("scannedBook", b));
            } else {
                // Otherwise lookup book by ISBN or ID
                Optional<Book> bookOpt = bookDAO.findByIsbn(bookQuery.trim());
                if (bookOpt.isPresent()) {
                    Book b = bookOpt.get();
                    request.setAttribute("scannedBook", b);
                    request.setAttribute("availableCopies", bookCopyDAO.findAvailableCopiesByBookId(b.getId()));
                } else {
                    request.setAttribute("bookError", "No book or barcode found matching: " + bookQuery);
                }
            }
        }

        // Recent issue/return transaction history
        List<Loan> recentTransactions = loanDAO.findRecentLoans(15);
        request.setAttribute("recentTransactions", recentTransactions);

        request.getRequestDispatcher("/WEB-INF/views/librarian/issue-return.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User librarian = (User) session.getAttribute("CURRENT_USER");
        String action = request.getParameter("action");
        String clientIp = request.getRemoteAddr();

        if ("issue".equals(action)) {
            int copyId = getIntParameter(request, "copyId", 0);
            int studentId = getIntParameter(request, "studentId", 0);

            if (copyId > 0 && studentId > 0) {
                LoanDAO.IssueResult result = libraryService.issueBook(copyId, studentId, librarian.getId(), clientIp);
                if (result.isSuccess()) {
                    response.sendRedirect(request.getContextPath() + "/librarian/issue-return?success=issued&loanId=" + result.getLoanId());
                } else {
                    response.sendRedirect(request.getContextPath() + "/librarian/issue-return?error=" + java.net.URLEncoder.encode(result.getMessage(), "UTF-8"));
                }
                return;
            }
        } else if ("return".equals(action)) {
            int copyId = getIntParameter(request, "copyId", 0);
            if (copyId > 0) {
                LoanDAO.ReturnResult result = libraryService.returnBook(copyId, librarian.getId(), clientIp);
                if (result.isSuccess()) {
                    String msg = "returned&overdue=" + result.getDaysOverdue() + "&fine=" + result.getFineAmount();
                    response.sendRedirect(request.getContextPath() + "/librarian/issue-return?success=" + msg);
                } else {
                    response.sendRedirect(request.getContextPath() + "/librarian/issue-return?error=" + java.net.URLEncoder.encode(result.getMessage(), "UTF-8"));
                }
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/librarian/issue-return");
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
