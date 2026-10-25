package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.AuditLog;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    private static final Logger logger = LoggerFactory.getLogger(AuditLogDAO.class);

    public boolean log(Integer userId, String action, String details, String ipAddress) {
        String sql = "INSERT INTO audit_logs (user_id, action, details, ip_address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, action);
            ps.setString(3, details);
            ps.setString(4, ipAddress);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error creating audit log: {}", e.getMessage());
            return false;
        }
    }

    public List<AuditLog> getRecentLogs(int limit) {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT al.*, u.full_name AS user_name FROM audit_logs al " +
                     "LEFT JOIN users u ON al.user_id = u.id " +
                     "ORDER BY al.id DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog log = new AuditLog();
                    log.setId(rs.getInt("id"));
                    int uid = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        log.setUserId(uid);
                        log.setUserFullName(rs.getString("user_name"));
                    } else {
                        log.setUserFullName("System / Anonymous");
                    }
                    log.setAction(rs.getString("action"));
                    log.setDetails(rs.getString("details"));
                    log.setIpAddress(rs.getString("ip_address"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching audit logs: {}", e.getMessage());
        }
        return list;
    }
}
