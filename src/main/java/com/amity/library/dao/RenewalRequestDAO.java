package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.RenewalRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class RenewalRequestDAO {

    private static final Logger logger = LoggerFactory.getLogger(RenewalRequestDAO.class);

    public boolean hasPendingRequest(int loanId) {
        String sql = "SELECT COUNT(*) FROM renewal_requests WHERE loan_id = ? AND status = 'PENDING'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loanId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error checking pending renewal: {}", e.getMessage());
        }
        return false;
    }

    public boolean createRequest(int loanId, int userId) {
        if (hasPendingRequest(loanId)) {
            return false;
        }
        String sql = "INSERT INTO renewal_requests (loan_id, user_id, request_date, status) VALUES (?, ?, ?, 'PENDING')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loanId);
            ps.setInt(2, userId);
            ps.setTimestamp(3, Timestamp.from(Instant.now()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error creating renewal request: {}", e.getMessage());
            return false;
        }
    }

    public List<RenewalRequest> getPendingRequests() {
        List<RenewalRequest> list = new ArrayList<>();
        String sql = "SELECT rr.*, b.title AS book_title, bc.barcode, l.due_date, u.full_name AS user_name, u.enrollment_no, " +
                     "p.full_name AS processor_name " +
                     "FROM renewal_requests rr " +
                     "JOIN loans l ON rr.loan_id = l.id " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON rr.user_id = u.id " +
                     "LEFT JOIN users p ON rr.processed_by = p.id " +
                     "WHERE rr.status = 'PENDING' " +
                     "ORDER BY rr.request_date ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToRequest(rs));
            }
        } catch (SQLException e) {
            logger.error("Error fetching pending renewal requests: {}", e.getMessage());
        }
        return list;
    }

    public List<RenewalRequest> getRequestsByUserId(int userId) {
        List<RenewalRequest> list = new ArrayList<>();
        String sql = "SELECT rr.*, b.title AS book_title, bc.barcode, l.due_date, u.full_name AS user_name, u.enrollment_no, " +
                     "p.full_name AS processor_name " +
                     "FROM renewal_requests rr " +
                     "JOIN loans l ON rr.loan_id = l.id " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON rr.user_id = u.id " +
                     "LEFT JOIN users p ON rr.processed_by = p.id " +
                     "WHERE rr.user_id = ? " +
                     "ORDER BY rr.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRequest(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching renewal requests for user {}: {}", userId, e.getMessage());
        }
        return list;
    }

    public boolean processRequest(int requestId, boolean approve, String librarianNotes, int processedByUserId, int extendDays) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            int loanId;
            int userId;
            String fetchSql = "SELECT loan_id, user_id FROM renewal_requests WHERE id = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(fetchSql)) {
                ps.setInt(1, requestId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    loanId = rs.getInt("loan_id");
                    userId = rs.getInt("user_id");
                }
            }

            String newStatus = approve ? "APPROVED" : "REJECTED";
            Timestamp now = Timestamp.from(Instant.now());

            String updateRequestSql = "UPDATE renewal_requests SET status = ?, librarian_notes = ?, processed_by = ?, processed_at = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateRequestSql)) {
                ps.setString(1, newStatus);
                ps.setString(2, librarianNotes);
                ps.setInt(3, processedByUserId);
                ps.setTimestamp(4, now);
                ps.setInt(5, requestId);
                ps.executeUpdate();
            }

            if (approve) {
                String extendSql = "UPDATE loans SET due_date = DATE_ADD(due_date, INTERVAL ? DAY), renewed_count = renewed_count + 1 WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(extendSql)) {
                    ps.setInt(1, extendDays);
                    ps.setInt(2, loanId);
                    ps.executeUpdate();
                }
            }

            // Notification
            String notifSql = "INSERT INTO notifications (user_id, title, message, type) VALUES (?, ?, ?, 'RENEWAL')";
            try (PreparedStatement ps = conn.prepareStatement(notifSql)) {
                ps.setInt(1, userId);
                ps.setString(2, approve ? "Renewal Request Approved" : "Renewal Request Declined");
                ps.setString(3, approve ? "Your loan has been renewed for an additional " + extendDays + " days." : "Your renewal request was declined: " + librarianNotes);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            logger.error("Error processing renewal request: {}", e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { logger.error("Close error", ex); }
            }
        }
    }

    private RenewalRequest mapResultSetToRequest(ResultSet rs) throws SQLException {
        RenewalRequest rr = new RenewalRequest();
        rr.setId(rs.getInt("id"));
        rr.setLoanId(rs.getInt("loan_id"));
        rr.setBookTitle(rs.getString("book_title"));
        rr.setBarcode(rs.getString("barcode"));
        rr.setUserId(rs.getInt("user_id"));
        rr.setUserFullName(rs.getString("user_name"));
        rr.setUserEnrollmentNo(rs.getString("enrollment_no"));
        rr.setDueDate(rs.getTimestamp("due_date"));
        rr.setRequestDate(rs.getTimestamp("request_date"));
        rr.setStatus(rs.getString("status"));
        rr.setLibrarianNotes(rs.getString("librarian_notes"));
        int pb = rs.getInt("processed_by");
        if (!rs.wasNull()) {
            rr.setProcessedBy(pb);
            rr.setProcessedByName(rs.getString("processor_name"));
        }
        rr.setProcessedAt(rs.getTimestamp("processed_at"));
        return rr;
    }
}
