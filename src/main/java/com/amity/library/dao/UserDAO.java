package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDAO {

    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);

    public Optional<User> findByEnrollmentNo(String enrollmentNo) {
        String sql = "SELECT u.*, r.name AS role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "WHERE u.enrollment_no = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, enrollmentNo.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user by enrollment_no {}: {}", enrollmentNo, e.getMessage());
        }
        return Optional.empty();
    }

    public Optional<User> findByEmail(String email) {
        String sql = "SELECT u.*, r.name AS role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "WHERE u.email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user by email {}: {}", email, e.getMessage());
        }
        return Optional.empty();
    }

    public Optional<User> findById(int id) {
        String sql = "SELECT u.*, r.name AS role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.id " +
                     "WHERE u.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user by id {}: {}", id, e.getMessage());
        }
        return Optional.empty();
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO users (enrollment_no, full_name, email, password_hash, role_id, department, course, academic_year, phone, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEnrollmentNo());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail().toLowerCase());
            ps.setString(4, user.getPasswordHash());
            ps.setInt(5, user.getRoleId());
            ps.setString(6, user.getDepartment());
            ps.setString(7, user.getCourse());
            ps.setString(8, user.getAcademicYear());
            ps.setString(9, user.getPhone());
            ps.setString(10, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating user {}: {}", user.getEnrollmentNo(), e.getMessage());
        }
        return false;
    }

    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating password for user id {}: {}", userId, e.getMessage());
            return false;
        }
    }

    public boolean updateProfile(int userId, String fullName, String phone, String department, String course, String academicYear) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, department = ?, course = ?, academic_year = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, department);
            ps.setString(4, course);
            ps.setString(5, academicYear);
            ps.setInt(6, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating profile for user id {}: {}", userId, e.getMessage());
            return false;
        }
    }

    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating user status: {}", e.getMessage());
            return false;
        }
    }

    public List<User> listAll(int offset, int limit, String search) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT u.*, r.name AS role_name FROM users u JOIN roles r ON u.role_id = r.id ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append("WHERE u.full_name LIKE ? OR u.enrollment_no LIKE ? OR u.email LIKE ? ");
        }
        sql.append("ORDER BY u.id DESC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error listing users: {}", e.getMessage());
        }
        return list;
    }

    public int countUsers(String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users u ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append("WHERE u.full_name LIKE ? OR u.enrollment_no LIKE ? OR u.email LIKE ?");
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.trim() + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting users: {}", e.getMessage());
        }
        return 0;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setEnrollmentNo(rs.getString("enrollment_no"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRoleId(rs.getInt("role_id"));
        u.setRoleName(rs.getString("role_name"));
        u.setDepartment(rs.getString("department"));
        u.setCourse(rs.getString("course"));
        u.setAcademicYear(rs.getString("academic_year"));
        u.setPhone(rs.getString("phone"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
