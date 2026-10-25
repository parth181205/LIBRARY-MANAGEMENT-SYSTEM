package com.amity.library.service;

import com.amity.library.dao.*;
import com.amity.library.model.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class LibraryService {

    private static final Logger logger = LoggerFactory.getLogger(LibraryService.class);

    private final LoanDAO loanDAO;
    private final BookDAO bookDAO;
    private final BookCopyDAO bookCopyDAO;
    private final ReservationDAO reservationDAO;
    private final RenewalRequestDAO renewalRequestDAO;
    private final FineDAO fineDAO;
    private final PaymentDAO paymentDAO;
    private final SystemSettingDAO settingDAO;
    private final AuditLogDAO auditLogDAO;

    public LibraryService() {
        this.loanDAO = new LoanDAO();
        this.bookDAO = new BookDAO();
        this.bookCopyDAO = new BookCopyDAO();
        this.reservationDAO = new ReservationDAO();
        this.renewalRequestDAO = new RenewalRequestDAO();
        this.fineDAO = new FineDAO();
        this.paymentDAO = new PaymentDAO();
        this.settingDAO = new SystemSettingDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    public LibraryService(LoanDAO loanDAO, BookDAO bookDAO, BookCopyDAO bookCopyDAO,
                          ReservationDAO reservationDAO, RenewalRequestDAO renewalRequestDAO,
                          FineDAO fineDAO, PaymentDAO paymentDAO, SystemSettingDAO settingDAO, AuditLogDAO auditLogDAO) {
        this.loanDAO = loanDAO;
        this.bookDAO = bookDAO;
        this.bookCopyDAO = bookCopyDAO;
        this.reservationDAO = reservationDAO;
        this.renewalRequestDAO = renewalRequestDAO;
        this.fineDAO = fineDAO;
        this.paymentDAO = paymentDAO;
        this.settingDAO = settingDAO;
        this.auditLogDAO = auditLogDAO;
    }

    public LoanDAO.IssueResult issueBook(int copyId, int userId, int issuedByUserId, String clientIp) {
        int durationDays = settingDAO.getIntSetting("loan_duration_days", 14);
        int limit = settingDAO.getIntSetting("max_books_student", 3);

        LoanDAO.IssueResult result = loanDAO.issueBook(copyId, userId, issuedByUserId, durationDays, limit);
        if (result.isSuccess()) {
            auditLogDAO.log(issuedByUserId, "ISSUE_BOOK", "Issued copy #" + copyId + " to user #" + userId, clientIp);
        }
        return result;
    }

    public LoanDAO.ReturnResult returnBook(int copyId, int receivedByUserId, String clientIp) {
        BigDecimal fineRate = settingDAO.getDecimalSetting("fine_rate_per_day", new BigDecimal("5.00"));
        LoanDAO.ReturnResult result = loanDAO.returnBook(copyId, receivedByUserId, fineRate);
        if (result.isSuccess()) {
            auditLogDAO.log(receivedByUserId, "RETURN_BOOK", "Returned copy #" + copyId + " (Overdue: " + result.getDaysOverdue() + " days, Fine: ₹" + result.getFineAmount() + ")", clientIp);
        }
        return result;
    }

    public boolean reserveBook(int userId, int bookId, String clientIp) {
        int expiryDays = settingDAO.getIntSetting("reservation_expiry_days", 3);
        boolean success = reservationDAO.placeReservation(userId, bookId, expiryDays);
        if (success) {
            auditLogDAO.log(userId, "RESERVE_BOOK", "Placed reservation for book #" + bookId, clientIp);
        }
        return success;
    }

    public boolean requestRenewal(int loanId, int userId, String clientIp) {
        Optional<Loan> loanOpt = loanDAO.findById(loanId);
        if (loanOpt.isEmpty()) {
            return false;
        }

        Loan loan = loanOpt.get();
        if (loan.getUserId() != userId) {
            return false; // Unauthorized
        }

        int maxRenewals = settingDAO.getIntSetting("max_renewals_allowed", 2);
        if (loan.getRenewedCount() >= maxRenewals) {
            return false; // Reached limit
        }

        if (loan.isCurrentlyOverdue()) {
            return false; // Overdue loans cannot be self-renewed
        }

        boolean created = renewalRequestDAO.createRequest(loanId, userId);
        if (created) {
            auditLogDAO.log(userId, "REQUEST_RENEWAL", "Requested renewal for loan #" + loanId, clientIp);
        }
        return created;
    }

    public boolean processRenewal(int requestId, boolean approve, String librarianNotes, int processedByUserId, String clientIp) {
        int extendDays = settingDAO.getIntSetting("loan_duration_days", 14);
        boolean success = renewalRequestDAO.processRequest(requestId, approve, librarianNotes, processedByUserId, extendDays);
        if (success) {
            auditLogDAO.log(processedByUserId, "PROCESS_RENEWAL", (approve ? "Approved" : "Rejected") + " renewal request #" + requestId, clientIp);
        }
        return success;
    }

    public boolean payFineSimulated(int fineId, int userId, BigDecimal amount, String method, String clientIp) {
        String txRef = "AMITY-PAY-" + System.currentTimeMillis();
        boolean success = paymentDAO.recordPayment(fineId, userId, amount, method, txRef, null, "Online Student Payment Simulation");
        if (success) {
            auditLogDAO.log(userId, "FINE_PAID", "Student paid fine #" + fineId + " amount ₹" + amount + " via " + method, clientIp);
        }
        return success;
    }

    public boolean recordManualPayment(int fineId, int userId, BigDecimal amount, String method, int recordedByUserId, String notes, String clientIp) {
        String txRef = "RCPT-" + System.currentTimeMillis();
        boolean success = paymentDAO.recordPayment(fineId, userId, amount, method, txRef, recordedByUserId, notes);
        if (success) {
            auditLogDAO.log(recordedByUserId, "MANUAL_PAYMENT_RECORDED", "Recorded payment for fine #" + fineId + " (₹" + amount + ")", clientIp);
        }
        return success;
    }

    public boolean waiveFine(int fineId, String reason, int librarianUserId, String clientIp) {
        boolean success = fineDAO.waiveFine(fineId, reason);
        if (success) {
            auditLogDAO.log(librarianUserId, "FINE_WAIVED", "Waived fine #" + fineId + " Reason: " + reason, clientIp);
        }
        return success;
    }

    public Map<String, Object> getStudentDashboardData(int userId) {
        Map<String, Object> data = loanDAO.getStudentStats(userId);
        data.put("activeLoans", loanDAO.findActiveLoansByUserId(userId));
        data.put("recentBooks", bookDAO.getRecentlyAddedBooks(6));
        data.put("activeReservations", reservationDAO.findReservationsByUserId(userId));
        return data;
    }

    public Map<String, Object> getLibrarianDashboardData() {
        Map<String, Object> data = loanDAO.getLibrarianStats();
        data.put("recentLoans", loanDAO.findRecentLoans(8));
        data.put("overdueLoansList", loanDAO.findOverdueLoans(8));
        data.put("pendingRenewals", renewalRequestDAO.getPendingRequests());
        data.put("activeReservationsList", reservationDAO.findAllActiveReservations(8));
        return data;
    }
}
