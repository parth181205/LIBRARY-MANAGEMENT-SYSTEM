package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Payment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PaymentDAO {

    private static final Logger logger = LoggerFactory.getLogger(PaymentDAO.class);

    public boolean recordPayment(int fineId, int userId, BigDecimal amount, String paymentMethod, String txRef, Integer recordedByUserId, String notes) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Verify fine is still PENDING
            String checkSql = "SELECT amount, status FROM fines WHERE id = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, fineId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || !"PENDING".equalsIgnoreCase(rs.getString("status"))) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2. Insert payment record
            String insertSql = "INSERT INTO payments (fine_id, user_id, amount_paid, payment_method, transaction_ref, recorded_by_user_id, notes) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, fineId);
                ps.setInt(2, userId);
                ps.setBigDecimal(3, amount);
                ps.setString(4, paymentMethod);
                ps.setString(5, txRef);
                if (recordedByUserId != null) {
                    ps.setInt(6, recordedByUserId);
                } else {
                    ps.setNull(6, Types.INTEGER);
                }
                ps.setString(7, notes);
                ps.executeUpdate();
            }

            // 3. Mark fine as PAID
            String updateFineSql = "UPDATE fines SET status = 'PAID' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateFineSql)) {
                ps.setInt(1, fineId);
                ps.executeUpdate();
            }

            // 4. Notification
            String notifSql = "INSERT INTO notifications (user_id, title, message, type) VALUES (?, ?, ?, 'FINE')";
            try (PreparedStatement ps = conn.prepareStatement(notifSql)) {
                ps.setInt(1, userId);
                ps.setString(2, "Payment Confirmed");
                ps.setString(3, "Fine payment of ₹" + amount + " has been processed (Ref: " + txRef + ").");
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            logger.error("Error recording payment: {}", e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { logger.error("Close error", ex); }
            }
        }
    }

    public List<Payment> findPaymentsByUserId(int userId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name, u.enrollment_no, rec.full_name AS recorder_name " +
                     "FROM payments p " +
                     "JOIN users u ON p.user_id = u.id " +
                     "LEFT JOIN users rec ON p.recorded_by_user_id = rec.id " +
                     "WHERE p.user_id = ? " +
                     "ORDER BY p.payment_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding payments for user {}: {}", userId, e.getMessage());
        }
        return list;
    }

    public List<Payment> findAllPayments(int limit) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name, u.enrollment_no, rec.full_name AS recorder_name " +
                     "FROM payments p " +
                     "JOIN users u ON p.user_id = u.id " +
                     "LEFT JOIN users rec ON p.recorded_by_user_id = rec.id " +
                     "ORDER BY p.payment_date DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding all payments: {}", e.getMessage());
        }
        return list;
    }

    public Optional<Payment> findById(int id) {
        String sql = "SELECT p.*, u.full_name, u.enrollment_no, rec.full_name AS recorder_name " +
                     "FROM payments p " +
                     "JOIN users u ON p.user_id = u.id " +
                     "LEFT JOIN users rec ON p.recorded_by_user_id = rec.id " +
                     "WHERE p.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding payment by id {}: {}", id, e.getMessage());
        }
        return Optional.empty();
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setFineId(rs.getInt("fine_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setUserFullName(rs.getString("full_name"));
        p.setUserEnrollmentNo(rs.getString("enrollment_no"));
        p.setAmountPaid(rs.getBigDecimal("amount_paid"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setTransactionRef(rs.getString("transaction_ref"));
        int rec = rs.getInt("recorded_by_user_id");
        if (!rs.wasNull()) {
            p.setRecordedByUserId(rec);
            p.setRecordedByName(rs.getString("recorder_name"));
        }
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        p.setNotes(rs.getString("notes"));
        return p;
    }
}
