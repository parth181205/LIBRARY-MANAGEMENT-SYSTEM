package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Reservation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ReservationDAO {

    private static final Logger logger = LoggerFactory.getLogger(ReservationDAO.class);

    public boolean hasActiveReservation(int userId, int bookId) {
        String sql = "SELECT COUNT(*) FROM reservations " +
                     "WHERE user_id = ? AND book_id = ? AND status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error checking active reservation: {}", e.getMessage());
        }
        return false;
    }

    public boolean placeReservation(int userId, int bookId, int expiryDays) {
        if (hasActiveReservation(userId, bookId)) {
            logger.warn("User {} already has an active reservation for book {}", userId, bookId);
            return false;
        }

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Determine queue position
            int queuePos = 1;
            String countSql = "SELECT COUNT(*) FROM reservations WHERE book_id = ? AND status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP')";
            try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                ps.setInt(1, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        queuePos = rs.getInt(1) + 1;
                    }
                }
            }

            Timestamp now = Timestamp.from(Instant.now());
            Timestamp expiry = Timestamp.from(Instant.now().plus(expiryDays, ChronoUnit.DAYS));

            String insertSql = "INSERT INTO reservations (book_id, user_id, reservation_date, expiry_date, queue_position, status) " +
                              "VALUES (?, ?, ?, ?, ?, 'PENDING')";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, bookId);
                ps.setInt(2, userId);
                ps.setTimestamp(3, now);
                ps.setTimestamp(4, expiry);
                ps.setInt(5, queuePos);
                ps.executeUpdate();
            }

            // Notification
            String notifSql = "INSERT INTO notifications (user_id, title, message, type) VALUES (?, ?, ?, 'RESERVATION')";
            try (PreparedStatement ps = conn.prepareStatement(notifSql)) {
                ps.setInt(1, userId);
                ps.setString(2, "Reservation Placed");
                ps.setString(3, "Your reservation request has been placed (Queue Position #" + queuePos + ").");
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            logger.error("Error placing reservation: {}", e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { logger.error("Close error", ex); }
            }
        }
    }

    public List<Reservation> findReservationsByUserId(int userId) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, b.title AS book_title, b.cover_image, b.isbn, u.full_name, u.enrollment_no " +
                     "FROM reservations r " +
                     "JOIN books b ON r.book_id = b.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.user_id = ? " +
                     "ORDER BY r.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding reservations for user {}: {}", userId, e.getMessage());
        }
        return list;
    }

    public List<Reservation> findAllActiveReservations(int limit) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, b.title AS book_title, b.cover_image, b.isbn, u.full_name, u.enrollment_no " +
                     "FROM reservations r " +
                     "JOIN books b ON r.book_id = b.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP') " +
                     "ORDER BY r.id DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding all active reservations: {}", e.getMessage());
        }
        return list;
    }

    public Optional<Reservation> findById(int reservationId) {
        String sql = "SELECT r.*, b.title AS book_title, b.cover_image, b.isbn, u.full_name, u.enrollment_no " +
                     "FROM reservations r " +
                     "JOIN books b ON r.book_id = b.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding reservation #{}: {}", reservationId, e.getMessage());
        }
        return Optional.empty();
    }

    public boolean updateStatus(int reservationId, String newStatus) {
        String sql = "UPDATE reservations SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating reservation status: {}", e.getMessage());
            return false;
        }
    }

    public boolean cancelReservation(int reservationId, int userId) {
        String sql = "UPDATE reservations SET status = 'CANCELLED' WHERE id = ? AND user_id = ? AND status IN ('PENDING', 'CONFIRMED')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error cancelling reservation: {}", e.getMessage());
            return false;
        }
    }

    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setBookId(rs.getInt("book_id"));
        r.setBookTitle(rs.getString("book_title"));
        r.setBookCover(rs.getString("cover_image"));
        r.setIsbn(rs.getString("isbn"));
        r.setUserId(rs.getInt("user_id"));
        r.setUserFullName(rs.getString("full_name"));
        r.setUserEnrollmentNo(rs.getString("enrollment_no"));
        r.setReservationDate(rs.getTimestamp("reservation_date"));
        r.setExpiryDate(rs.getTimestamp("expiry_date"));
        r.setQueuePosition(rs.getInt("queue_position"));
        r.setStatus(rs.getString("status"));
        r.setNotifiedAt(rs.getTimestamp("notified_at"));
        r.setNotes(rs.getString("notes"));
        return r;
    }
}
