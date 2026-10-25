package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Loan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class LoanDAO {

    private static final Logger logger = LoggerFactory.getLogger(LoanDAO.class);

    public IssueResult issueBook(int copyId, int userId, int issuedByUserId, int loanDurationDays, int borrowingLimit) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Check user status
            String userSql = "SELECT status, role_id FROM users WHERE id = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return IssueResult.failure("User account not found");
                    }
                    if (!"ACTIVE".equalsIgnoreCase(rs.getString("status"))) {
                        conn.rollback();
                        return IssueResult.failure("User account is " + rs.getString("status") + ". Cannot issue books.");
                    }
                }
            }

            // 2. Check active loans count against borrowing limit
            String countLoansSql = "SELECT COUNT(*) FROM loans WHERE user_id = ? AND status IN ('ACTIVE', 'OVERDUE')";
            try (PreparedStatement ps = conn.prepareStatement(countLoansSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) >= borrowingLimit) {
                        conn.rollback();
                        return IssueResult.failure("Borrowing limit exceeded. Maximum allowed active loans: " + borrowingLimit);
                    }
                }
            }

            // 3. Check for severe overdue loans or unpaid fines > threshold
            String fineCheckSql = "SELECT SUM(amount) FROM fines WHERE user_id = ? AND status = 'PENDING'";
            try (PreparedStatement ps = conn.prepareStatement(fineCheckSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        BigDecimal pending = rs.getBigDecimal(1);
                        if (pending != null && pending.compareTo(new BigDecimal("200.00")) > 0) {
                            conn.rollback();
                            return IssueResult.failure("User has outstanding unpaid fines of ₹" + pending + ". Clear fines before new loans.");
                        }
                    }
                }
            }

            // 4. Verify copy is AVAILABLE with FOR UPDATE
            int bookId;
            String copySql = "SELECT book_id, status FROM book_copies WHERE id = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(copySql)) {
                ps.setInt(1, copyId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return IssueResult.failure("Copy record does not exist");
                    }
                    if (!"AVAILABLE".equalsIgnoreCase(rs.getString("status"))) {
                        conn.rollback();
                        return IssueResult.failure("Book copy is currently " + rs.getString("status") + " and cannot be issued");
                    }
                    bookId = rs.getInt("book_id");
                }
            }

            // 5. Create loan record
            Timestamp now = Timestamp.from(Instant.now());
            Timestamp dueDate = Timestamp.from(Instant.now().plus(loanDurationDays, ChronoUnit.DAYS));

            int newLoanId;
            String insertLoanSql = "INSERT INTO loans (copy_id, user_id, issue_date, due_date, status, renewed_count, issued_by_user_id) " +
                                  "VALUES (?, ?, ?, ?, 'ACTIVE', 0, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertLoanSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, copyId);
                ps.setInt(2, userId);
                ps.setTimestamp(3, now);
                ps.setTimestamp(4, dueDate);
                ps.setInt(5, issuedByUserId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        newLoanId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to retrieve generated loan id");
                    }
                }
            }

            // 6. Update copy status to ISSUED
            String updateCopySql = "UPDATE book_copies SET status = 'ISSUED' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateCopySql)) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }

            // 7. Decrement available copies on books table (with floor constraint checking)
            String updateBookSql = "UPDATE books SET available_copies = available_copies - 1 WHERE id = ? AND available_copies > 0";
            try (PreparedStatement ps = conn.prepareStatement(updateBookSql)) {
                ps.setInt(1, bookId);
                int updated = ps.executeUpdate();
                if (updated == 0) {
                    conn.rollback();
                    return IssueResult.failure("Inventory inconsistency: no available copies to decrement");
                }
            }

            conn.commit();
            return IssueResult.success(newLoanId, dueDate);
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            logger.error("Error issuing book: {}", e.getMessage(), e);
            return IssueResult.failure("Database error: " + e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { logger.error("Close error", ex); }
            }
        }
    }

    public ReturnResult returnBook(int copyId, int receivedByUserId, BigDecimal fineRatePerDay) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Locate active loan for this copy
            int loanId;
            int userId;
            int bookId;
            Timestamp dueDate;

            String findLoanSql = "SELECT l.id, l.user_id, l.due_date, bc.book_id " +
                                 "FROM loans l " +
                                 "JOIN book_copies bc ON l.copy_id = bc.id " +
                                 "WHERE l.copy_id = ? AND l.status IN ('ACTIVE', 'OVERDUE') " +
                                 "FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(findLoanSql)) {
                ps.setInt(1, copyId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return ReturnResult.failure("No active or overdue loan found for copy #" + copyId);
                    }
                    loanId = rs.getInt("id");
                    userId = rs.getInt("user_id");
                    dueDate = rs.getTimestamp("due_date");
                    bookId = rs.getInt("book_id");
                }
            }

            Timestamp now = Timestamp.from(Instant.now());

            // 2. Check overdue and calculate fine
            BigDecimal fineAmount = BigDecimal.ZERO;
            long daysOverdue = 0;
            if (dueDate != null && now.after(dueDate)) {
                daysOverdue = ChronoUnit.DAYS.between(dueDate.toInstant(), now.toInstant());
                if (daysOverdue > 0) {
                    fineAmount = fineRatePerDay.multiply(BigDecimal.valueOf(daysOverdue));
                }
            }

            // 3. Close the loan
            String updateLoanSql = "UPDATE loans SET status = 'RETURNED', return_date = ?, received_by_user_id = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateLoanSql)) {
                ps.setTimestamp(1, now);
                ps.setInt(2, receivedByUserId);
                ps.setInt(3, loanId);
                ps.executeUpdate();
            }

            // 4. Update copy status to AVAILABLE
            String updateCopySql = "UPDATE book_copies SET status = 'AVAILABLE' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateCopySql)) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }

            // 5. Increment available copies count on book
            String updateBookSql = "UPDATE books SET available_copies = available_copies + 1 WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateBookSql)) {
                ps.setInt(1, bookId);
                ps.executeUpdate();
            }

            // 6. Record fine if overdue
            if (fineAmount.compareTo(BigDecimal.ZERO) > 0) {
                String insertFineSql = "INSERT INTO fines (loan_id, user_id, amount, status, reason) VALUES (?, ?, ?, 'PENDING', ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertFineSql)) {
                    ps.setInt(1, loanId);
                    ps.setInt(2, userId);
                    ps.setBigDecimal(3, fineAmount);
                    ps.setString(4, "Overdue by " + daysOverdue + " day(s)");
                    ps.executeUpdate();
                }

                // Create notification for student
                String notifSql = "INSERT INTO notifications (user_id, title, message, type) VALUES (?, ?, ?, 'FINE')";
                try (PreparedStatement ps = conn.prepareStatement(notifSql)) {
                    ps.setInt(1, userId);
                    ps.setString(2, "Overdue Fine Incurred");
                    ps.setString(3, "A fine of ₹" + fineAmount + " has been recorded for late return (" + daysOverdue + " days overdue).");
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return ReturnResult.success(loanId, daysOverdue, fineAmount);
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            logger.error("Error returning book: {}", e.getMessage(), e);
            return ReturnResult.failure("Database error: " + e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { logger.error("Close error", ex); }
            }
        }
    }

    public List<Loan> findActiveLoansByUserId(int userId) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, bc.barcode, bc.book_id, b.title AS book_title, b.cover_image, b.isbn, u.full_name AS user_name, u.enrollment_no " +
                     "FROM loans l " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id " +
                     "WHERE l.user_id = ? AND l.status IN ('ACTIVE', 'OVERDUE') " +
                     "ORDER BY l.due_date ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLoan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding active loans for user {}: {}", userId, e.getMessage());
        }
        return list;
    }

    public List<Loan> findBorrowingHistoryByUserId(int userId, int limit) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, bc.barcode, bc.book_id, b.title AS book_title, b.cover_image, b.isbn, u.full_name AS user_name, u.enrollment_no " +
                     "FROM loans l " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id " +
                     "WHERE l.user_id = ? " +
                     "ORDER BY l.issue_date DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLoan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding loan history for user {}: {}", userId, e.getMessage());
        }
        return list;
    }

    public List<Loan> findRecentLoans(int limit) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, bc.barcode, bc.book_id, b.title AS book_title, b.cover_image, b.isbn, u.full_name AS user_name, u.enrollment_no " +
                     "FROM loans l " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id " +
                     "ORDER BY l.id DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLoan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding recent loans: {}", e.getMessage());
        }
        return list;
    }

    public List<Loan> findOverdueLoans(int limit) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, bc.barcode, bc.book_id, b.title AS book_title, b.cover_image, b.isbn, u.full_name AS user_name, u.enrollment_no " +
                     "FROM loans l " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id " +
                     "WHERE l.status IN ('ACTIVE', 'OVERDUE') AND l.due_date < NOW() " +
                     "ORDER BY l.due_date ASC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLoan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding overdue loans: {}", e.getMessage());
        }
        return list;
    }

    public Optional<Loan> findById(int loanId) {
        String sql = "SELECT l.*, bc.barcode, bc.book_id, b.title AS book_title, b.cover_image, b.isbn, u.full_name AS user_name, u.enrollment_no " +
                     "FROM loans l " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON l.user_id = u.id " +
                     "WHERE l.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loanId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToLoan(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding loan by id {}: {}", loanId, e.getMessage());
        }
        return Optional.empty();
    }

    public boolean extendLoanDueDate(int loanId, int additionalDays) {
        String sql = "UPDATE loans SET due_date = DATE_ADD(due_date, INTERVAL ? DAY), renewed_count = renewed_count + 1 WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, additionalDays);
            ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error extending loan due date: {}", e.getMessage());
            return false;
        }
    }

    public Map<String, Object> getStudentStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("issuedCount", 0);
        stats.put("reservedCount", 0);
        stats.put("totalBorrowed", 0);
        stats.put("pendingFines", BigDecimal.ZERO);

        String sql = "SELECT " +
                "(SELECT COUNT(*) FROM loans WHERE user_id = ? AND status IN ('ACTIVE', 'OVERDUE')) AS issued_count, " +
                "(SELECT COUNT(*) FROM reservations WHERE user_id = ? AND status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP')) AS reserved_count, " +
                "(SELECT COUNT(*) FROM loans WHERE user_id = ?) AS total_borrowed, " +
                "(SELECT COALESCE(SUM(amount), 0.00) FROM fines WHERE user_id = ? AND status = 'PENDING') AS pending_fines";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("issuedCount", rs.getInt("issued_count"));
                    stats.put("reservedCount", rs.getInt("reserved_count"));
                    stats.put("totalBorrowed", rs.getInt("total_borrowed"));
                    stats.put("pendingFines", rs.getBigDecimal("pending_fines"));
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving student stats: {}", e.getMessage());
        }
        return stats;
    }

    public Map<String, Object> getLibrarianStats() {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                "(SELECT COUNT(*) FROM books) AS total_titles, " +
                "(SELECT COUNT(*) FROM book_copies) AS total_copies, " +
                "(SELECT COUNT(*) FROM book_copies WHERE status = 'AVAILABLE') AS available_copies, " +
                "(SELECT COUNT(*) FROM book_copies WHERE status = 'ISSUED') AS issued_copies, " +
                "(SELECT COUNT(*) FROM loans WHERE status IN ('ACTIVE', 'OVERDUE')) AS active_loans, " +
                "(SELECT COUNT(*) FROM loans WHERE status IN ('ACTIVE', 'OVERDUE') AND due_date < NOW()) AS overdue_loans, " +
                "(SELECT COUNT(*) FROM reservations WHERE status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP')) AS active_reservations, " +
                "(SELECT COALESCE(SUM(amount), 0.00) FROM fines WHERE status = 'PENDING') AS outstanding_fines";

        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                stats.put("totalTitles", rs.getInt("total_titles"));
                stats.put("totalCopies", rs.getInt("total_copies"));
                stats.put("availableCopies", rs.getInt("available_copies"));
                stats.put("issuedCopies", rs.getInt("issued_copies"));
                stats.put("activeLoans", rs.getInt("active_loans"));
                stats.put("overdueLoans", rs.getInt("overdue_loans"));
                stats.put("activeReservations", rs.getInt("active_reservations"));
                stats.put("activeReservationsCount", rs.getInt("active_reservations"));
                stats.put("outstandingFines", rs.getBigDecimal("outstanding_fines"));
            }
        } catch (SQLException e) {
            logger.error("Error fetching librarian stats: {}", e.getMessage());
        }
        return stats;
    }

    private Loan mapResultSetToLoan(ResultSet rs) throws SQLException {
        Loan loan = new Loan();
        loan.setId(rs.getInt("id"));
        loan.setCopyId(rs.getInt("copy_id"));
        loan.setBookId(rs.getInt("book_id"));
        loan.setBookTitle(rs.getString("book_title"));
        loan.setBookCover(rs.getString("cover_image"));
        loan.setIsbn(rs.getString("isbn"));
        loan.setBarcode(rs.getString("barcode"));
        loan.setUserId(rs.getInt("user_id"));
        loan.setUserFullName(rs.getString("user_name"));
        loan.setUserEnrollmentNo(rs.getString("enrollment_no"));
        loan.setIssueDate(rs.getTimestamp("issue_date"));
        loan.setDueDate(rs.getTimestamp("due_date"));
        loan.setReturnDate(rs.getTimestamp("return_date"));
        loan.setStatus(rs.getString("status"));
        loan.setRenewedCount(rs.getInt("renewed_count"));
        loan.setIssuedByUserId(rs.getInt("issued_by_user_id"));
        int recBy = rs.getInt("received_by_user_id");
        if (!rs.wasNull()) {
            loan.setReceivedByUserId(recBy);
        }
        loan.setNotes(rs.getString("notes"));
        return loan;
    }

    public static class IssueResult {
        private final boolean success;
        private final String message;
        private final Integer loanId;
        private final Timestamp dueDate;

        private IssueResult(boolean success, String message, Integer loanId, Timestamp dueDate) {
            this.success = success;
            this.message = message;
            this.loanId = loanId;
            this.dueDate = dueDate;
        }

        public static IssueResult success(int loanId, Timestamp dueDate) {
            return new IssueResult(true, "Book successfully issued", loanId, dueDate);
        }

        public static IssueResult failure(String message) {
            return new IssueResult(false, message, null, null);
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Integer getLoanId() { return loanId; }
        public Timestamp getDueDate() { return dueDate; }
    }

    public static class ReturnResult {
        private final boolean success;
        private final String message;
        private final Integer loanId;
        private final long daysOverdue;
        private final BigDecimal fineAmount;

        private ReturnResult(boolean success, String message, Integer loanId, long daysOverdue, BigDecimal fineAmount) {
            this.success = success;
            this.message = message;
            this.loanId = loanId;
            this.daysOverdue = daysOverdue;
            this.fineAmount = fineAmount;
        }

        public static ReturnResult success(int loanId, long daysOverdue, BigDecimal fineAmount) {
            return new ReturnResult(true, "Book returned successfully", loanId, daysOverdue, fineAmount);
        }

        public static ReturnResult failure(String message) {
            return new ReturnResult(false, message, null, 0, BigDecimal.ZERO);
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Integer getLoanId() { return loanId; }
        public long getDaysOverdue() { return daysOverdue; }
        public BigDecimal getFineAmount() { return fineAmount; }
    }
}
