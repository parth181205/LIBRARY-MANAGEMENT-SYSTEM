package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.BookCopy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BookCopyDAO {

    private static final Logger logger = LoggerFactory.getLogger(BookCopyDAO.class);

    public Optional<BookCopy> findByBarcode(String barcode) {
        String sql = "SELECT bc.*, b.title AS book_title, b.isbn " +
                     "FROM book_copies bc " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "WHERE bc.barcode = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, barcode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToCopy(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding copy by barcode {}: {}", barcode, e.getMessage());
        }
        return Optional.empty();
    }

    public Optional<BookCopy> findById(int copyId) {
        String sql = "SELECT bc.*, b.title AS book_title, b.isbn " +
                     "FROM book_copies bc " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "WHERE bc.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, copyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToCopy(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding copy by id {}: {}", copyId, e.getMessage());
        }
        return Optional.empty();
    }

    public List<BookCopy> findCopiesByBookId(int bookId) {
        List<BookCopy> copies = new ArrayList<>();
        String sql = "SELECT bc.*, b.title AS book_title, b.isbn " +
                     "FROM book_copies bc " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "WHERE bc.book_id = ? " +
                     "ORDER BY bc.barcode ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    copies.add(mapResultSetToCopy(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding copies for book id {}: {}", bookId, e.getMessage());
        }
        return copies;
    }

    public List<BookCopy> findAvailableCopiesByBookId(int bookId) {
        List<BookCopy> copies = new ArrayList<>();
        String sql = "SELECT bc.*, b.title AS book_title, b.isbn " +
                     "FROM book_copies bc " +
                     "JOIN books b ON bc.book_id = b.id " +
                     "WHERE bc.book_id = ? AND bc.status = 'AVAILABLE' " +
                     "ORDER BY bc.barcode ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    copies.add(mapResultSetToCopy(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding available copies: {}", e.getMessage());
        }
        return copies;
    }

    public boolean addCopy(int bookId, String barcode, String rackLocation, String conditionNote) {
        String sql = "INSERT INTO book_copies (book_id, barcode, rack_location, status, condition_note) VALUES (?, ?, ?, 'AVAILABLE', ?)";
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, bookId);
                ps.setString(2, barcode.trim());
                ps.setString(3, rackLocation);
                ps.setString(4, conditionNote);
                ps.executeUpdate();
            }

            // Update total and available counts on book
            String updateBookSql = "UPDATE books SET total_copies = total_copies + 1, available_copies = available_copies + 1 WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateBookSql)) {
                ps.setInt(1, bookId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            logger.error("Error adding copy: {}", e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { logger.error("Close error", ex); }
            }
        }
    }

    private BookCopy mapResultSetToCopy(ResultSet rs) throws SQLException {
        BookCopy copy = new BookCopy();
        copy.setId(rs.getInt("id"));
        copy.setBookId(rs.getInt("book_id"));
        copy.setBookTitle(rs.getString("book_title"));
        copy.setIsbn(rs.getString("isbn"));
        copy.setBarcode(rs.getString("barcode"));
        copy.setRackLocation(rs.getString("rack_location"));
        copy.setStatus(rs.getString("status"));
        copy.setConditionNote(rs.getString("condition_note"));
        copy.setCreatedAt(rs.getTimestamp("created_at"));
        return copy;
    }
}
