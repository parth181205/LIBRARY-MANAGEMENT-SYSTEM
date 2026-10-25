package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Author;
import com.amity.library.model.Book;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BookDAO {

    private static final Logger logger = LoggerFactory.getLogger(BookDAO.class);

    public Optional<Book> findById(int id) {
        String sql = "SELECT b.*, c.name AS category_name, p.name AS publisher_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setAuthors(getAuthorsForBook(conn, book.getId()));
                    return Optional.of(book);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding book by id {}: {}", id, e.getMessage());
        }
        return Optional.empty();
    }

    public Optional<Book> findByIsbn(String isbn) {
        String sql = "SELECT b.*, c.name AS category_name, p.name AS publisher_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "WHERE b.isbn = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, isbn.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setAuthors(getAuthorsForBook(conn, book.getId()));
                    return Optional.of(book);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding book by isbn {}: {}", isbn, e.getMessage());
        }
        return Optional.empty();
    }

    public List<Book> searchBooks(String query, String categorySlug, String availability, String sortBy, int offset, int limit) {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT b.*, c.name AS category_name, p.name AS publisher_name " +
                "FROM books b " +
                "LEFT JOIN categories c ON b.category_id = c.id " +
                "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                "LEFT JOIN book_authors ba ON b.id = ba.book_id " +
                "LEFT JOIN authors a ON ba.author_id = a.id " +
                "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.isbn LIKE ? OR a.name LIKE ? OR p.name LIKE ?) ");
            String term = "%" + query.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (categorySlug != null && !categorySlug.trim().isEmpty() && !"all".equalsIgnoreCase(categorySlug)) {
            sql.append("AND c.slug = ? ");
            params.add(categorySlug.trim());
        }

        if ("available".equalsIgnoreCase(availability)) {
            sql.append("AND b.available_copies > 0 ");
        } else if ("reserved".equalsIgnoreCase(availability)) {
            sql.append("AND b.available_copies = 0 ");
        }

        if ("year_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY b.publication_year DESC, b.title ASC ");
        } else if ("title_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY b.title ASC ");
        } else {
            sql.append("ORDER BY b.id DESC ");
        }

        sql.append("LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setAuthors(getAuthorsForBook(conn, book.getId()));
                    books.add(book);
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching books: {}", e.getMessage());
        }
        return books;
    }

    public int countSearchResults(String query, String categorySlug, String availability) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT b.id) " +
                "FROM books b " +
                "LEFT JOIN categories c ON b.category_id = c.id " +
                "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                "LEFT JOIN book_authors ba ON b.id = ba.book_id " +
                "LEFT JOIN authors a ON ba.author_id = a.id " +
                "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.isbn LIKE ? OR a.name LIKE ? OR p.name LIKE ?) ");
            String term = "%" + query.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (categorySlug != null && !categorySlug.trim().isEmpty() && !"all".equalsIgnoreCase(categorySlug)) {
            sql.append("AND c.slug = ? ");
            params.add(categorySlug.trim());
        }

        if ("available".equalsIgnoreCase(availability)) {
            sql.append("AND b.available_copies > 0 ");
        } else if ("reserved".equalsIgnoreCase(availability)) {
            sql.append("AND b.available_copies = 0 ");
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting search results: {}", e.getMessage());
        }
        return 0;
    }

    public List<Book> getRecentlyAddedBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name, p.name AS publisher_name " +
                     "FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "LEFT JOIN publishers p ON b.publisher_id = p.id " +
                     "ORDER BY b.id DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setAuthors(getAuthorsForBook(conn, book.getId()));
                    books.add(book);
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching recent books: {}", e.getMessage());
        }
        return books;
    }

    public boolean createBook(Book book, List<Integer> authorIds) {
        String sql = "INSERT INTO books (isbn, title, category_id, publisher_id, edition, publication_year, description, cover_image, total_copies, available_copies) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, book.getIsbn());
                ps.setString(2, book.getTitle());
                ps.setInt(3, book.getCategoryId());
                if (book.getPublisherId() != null) {
                    ps.setInt(4, book.getPublisherId());
                } else {
                    ps.setNull(4, Types.INTEGER);
                }
                ps.setString(5, book.getEdition());
                if (book.getPublicationYear() != null) {
                    ps.setInt(6, book.getPublicationYear());
                } else {
                    ps.setNull(6, Types.INTEGER);
                }
                ps.setString(7, book.getDescription());
                ps.setString(8, book.getCoverImage());
                ps.setInt(9, book.getTotalCopies());
                ps.setInt(10, book.getAvailableCopies());

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        book.setId(rs.getInt(1));
                    }
                }
            }

            if (authorIds != null && !authorIds.isEmpty()) {
                String baSql = "INSERT INTO book_authors (book_id, author_id) VALUES (?, ?)";
                try (PreparedStatement baPs = conn.prepareStatement(baSql)) {
                    for (int authorId : authorIds) {
                        baPs.setInt(1, book.getId());
                        baPs.setInt(2, authorId);
                        baPs.addBatch();
                    }
                    baPs.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            logger.error("Error creating book: {}", e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { logger.error("Close error", ex); }
            }
        }
    }

    public List<Author> getAuthorsForBook(Connection conn, int bookId) throws SQLException {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT a.* FROM authors a " +
                     "JOIN book_authors ba ON a.id = ba.author_id " +
                     "WHERE ba.book_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Author a = new Author();
                    a.setId(rs.getInt("id"));
                    a.setName(rs.getString("name"));
                    a.setBiography(rs.getString("biography"));
                    authors.add(a);
                }
            }
        }
        return authors;
    }

    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("id"));
        b.setIsbn(rs.getString("isbn"));
        b.setTitle(rs.getString("title"));
        b.setCategoryId(rs.getInt("category_id"));
        b.setCategoryName(rs.getString("category_name"));
        int pubId = rs.getInt("publisher_id");
        if (!rs.wasNull()) {
            b.setPublisherId(pubId);
        }
        b.setPublisherName(rs.getString("publisher_name"));
        b.setEdition(rs.getString("edition"));
        int pubYear = rs.getInt("publication_year");
        if (!rs.wasNull()) {
            b.setPublicationYear(pubYear);
        }
        b.setDescription(rs.getString("description"));
        b.setCoverImage(rs.getString("cover_image"));
        b.setTotalCopies(rs.getInt("total_copies"));
        b.setAvailableCopies(rs.getInt("available_copies"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));
        return b;
    }
}
