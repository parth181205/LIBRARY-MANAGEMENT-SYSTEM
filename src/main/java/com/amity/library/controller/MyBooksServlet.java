package com.amity.library.controller;

import com.amity.library.dao.LoanDAO;
import com.amity.library.dao.RenewalRequestDAO;
import com.amity.library.model.Loan;
import com.amity.library.model.RenewalRequest;
import com.amity.library.model.User;
import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyBooksServlet", urlPatterns = {"/student/my-books"})
public class MyBooksServlet extends HttpServlet {

    private final LoanDAO loanDAO = new LoanDAO();
    private final RenewalRequestDAO renewalRequestDAO = new RenewalRequestDAO();
    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");

        List<Loan> activeLoans = loanDAO.findActiveLoansByUserId(user.getId());
        List<Loan> history = loanDAO.findBorrowingHistoryByUserId(user.getId(), 50);
        List<RenewalRequest> renewalRequests = renewalRequestDAO.getRequestsByUserId(user.getId());

        request.setAttribute("activeLoans", activeLoans);
        request.setAttribute("history", history);
        request.setAttribute("renewalRequests", renewalRequests);

        request.getRequestDispatcher("/WEB-INF/views/student/my-books.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");

        String action = request.getParameter("action");
        int loanId = getIntParameter(request, "loanId", 0);

        if ("request_renewal".equals(action) && loanId > 0) {
            boolean requested = libraryService.requestRenewal(loanId, user.getId(), request.getRemoteAddr());
            if (requested) {
                response.sendRedirect(request.getContextPath() + "/student/my-books?tab=renewals&success=renewal_requested");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/my-books?error=renewal_ineligible");
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + "/student/my-books");
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
