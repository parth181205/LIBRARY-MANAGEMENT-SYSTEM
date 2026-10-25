package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Fine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class FineDAO {

    private static final Logger logger = LoggerFactory.getLogger(FineDAO.class);

    public Optional<Fine> findById(int id) {
        String sql = "SELECT f.*, b.title AS book_title, bc.barcode, u.full_name, u.enrollment_no " +
                     "FROM fines f " +
                     "JOIN loans l ON f.loan_id = l.id " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON f.user_id = u.id " +
                     "WHERE f.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToFine(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding fine by id {}: {}", id, e.getMessage());
        }
        return Optional.empty();
    }

    public List<Fine> findFinesByUserId(int userId) {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.*, b.title AS book_title, bc.barcode, u.full_name, u.enrollment_no " +
                     "FROM fines f " +
                     "JOIN loans l ON f.loan_id = l.id " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON f.user_id = u.id " +
                     "WHERE f.user_id = ? " +
                     "ORDER BY f.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFine(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding fines for user {}: {}", userId, e.getMessage());
        }
        return list;
    }

    public List<Fine> findAllFines(int limit) {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.*, b.title AS book_title, bc.barcode, u.full_name, u.enrollment_no " +
                     "FROM fines f " +
                     "JOIN loans l ON f.loan_id = l.id " +
                     "JOIN book_copies bc ON l.copy_id = bc.id " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "JOIN users u ON f.user_id = u.id " +
                     "ORDER BY f.created_at DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFine(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding all fines: {}", e.getMessage());
        }
        return list;
    }

    public BigDecimal getTotalPendingFines(int userId) {
        String sql = "SELECT COALESCE(SUM(amount), 0.00) FROM fines WHERE user_id = ? AND status = 'PENDING'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error calculating pending fines: {}", e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public boolean waiveFine(int fineId, String reason) {
        String sql = "UPDATE fines SET status = 'WAIVED', reason = CONCAT(reason, ' [Waived: ', ?, ']') WHERE id = ? AND status = 'PENDING'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, fineId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error waiving fine: {}", e.getMessage());
            return false;
        }
    }

    private Fine mapResultSetToFine(ResultSet rs) throws SQLException {
        Fine f = new Fine();
        f.setId(rs.getInt("id"));
        f.setLoanId(rs.getInt("loan_id"));
        f.setBookTitle(rs.getString("book_title"));
        f.setBarcode(rs.getString("barcode"));
        f.setUserId(rs.getInt("user_id"));
        f.setUserFullName(rs.getString("full_name"));
        f.setUserEnrollmentNo(rs.getString("enrollment_no"));
        f.setAmount(rs.getBigDecimal("amount"));
        f.setStatus(rs.getString("status"));
        f.setReason(rs.getString("reason"));
        f.setCreatedAt(rs.getTimestamp("created_at"));
        f.setUpdatedAt(rs.getTimestamp("updated_at"));
        return f;
    }
}
