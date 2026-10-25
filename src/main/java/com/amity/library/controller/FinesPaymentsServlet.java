package com.amity.library.controller;

import com.amity.library.dao.FineDAO;
import com.amity.library.dao.PaymentDAO;
import com.amity.library.model.Fine;
import com.amity.library.model.Payment;
import com.amity.library.model.User;
import com.amity.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "FinesPaymentsServlet", urlPatterns = {"/student/fines", "/librarian/fines", "/receipt"})
public class FinesPaymentsServlet extends HttpServlet {

    private final FineDAO fineDAO = new FineDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final LibraryService libraryService = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");
        String path = request.getServletPath();

        if ("/receipt".equals(path)) {
            int paymentId = getIntParameter(request, "id", 0);
            Optional<Payment> paymentOpt = paymentDAO.findById(paymentId);
            if (paymentOpt.isPresent()) {
                Payment payment = paymentOpt.get();
                // Ensure only owner or librarian/admin can view receipt
                if (user != null && (user.getId() == payment.getUserId() || user.isLibrarian() || user.isAdmin())) {
                    request.setAttribute("payment", payment);
                    request.getRequestDispatcher("/WEB-INF/views/receipt.jsp").forward(request, response);
                    return;
                }
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Receipt not found");
            return;
        }

        if ("/librarian/fines".equals(path)) {
            List<Fine> fines = fineDAO.findAllFines(50);
            List<Payment> payments = paymentDAO.findAllPayments(50);
            request.setAttribute("fines", fines);
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/WEB-INF/views/librarian/fines.jsp").forward(request, response);
        } else {
            List<Fine> userFines = fineDAO.findFinesByUserId(user.getId());
            List<Payment> userPayments = paymentDAO.findPaymentsByUserId(user.getId());
            BigDecimal totalPending = fineDAO.getTotalPendingFines(user.getId());

            request.setAttribute("fines", userFines);
            request.setAttribute("payments", userPayments);
            request.setAttribute("totalPending", totalPending);
            request.getRequestDispatcher("/WEB-INF/views/student/fines.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("CURRENT_USER");
        String action = request.getParameter("action");
        String clientIp = request.getRemoteAddr();

        if ("pay_simulated".equals(action)) {
            int fineId = getIntParameter(request, "fineId", 0);
            String amountStr = request.getParameter("amount");
            String method = request.getParameter("method");
            if (fineId > 0 && amountStr != null) {
                BigDecimal amount = new BigDecimal(amountStr.trim());
                libraryService.payFineSimulated(fineId, user.getId(), amount, method != null ? method : "ONLINE_SIMULATED", clientIp);
            }
            response.sendRedirect(request.getContextPath() + "/student/fines?paid=1");
            return;
        }

        if ("record_payment".equals(action) && (user.isLibrarian() || user.isAdmin())) {
            int fineId = getIntParameter(request, "fineId", 0);
            int studentId = getIntParameter(request, "studentId", 0);
            String amountStr = request.getParameter("amount");
            String method = request.getParameter("method");
            String notes = request.getParameter("notes");
            if (fineId > 0 && amountStr != null) {
                BigDecimal amount = new BigDecimal(amountStr.trim());
                libraryService.recordManualPayment(fineId, studentId, amount, method, user.getId(), notes, clientIp);
            }
            response.sendRedirect(request.getContextPath() + "/librarian/fines?recorded=1");
            return;
        }

        if ("waive".equals(action) && (user.isLibrarian() || user.isAdmin())) {
            int fineId = getIntParameter(request, "fineId", 0);
            String reason = request.getParameter("reason");
            if (fineId > 0) {
                libraryService.waiveFine(fineId, reason != null ? reason : "Librarian authorized waiver", user.getId(), clientIp);
            }
            response.sendRedirect(request.getContextPath() + "/librarian/fines?waived=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/student/fines");
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
