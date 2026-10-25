package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Publisher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PublisherDAO {

    private static final Logger logger = LoggerFactory.getLogger(PublisherDAO.class);

    public List<Publisher> listAll() {
        List<Publisher> list = new ArrayList<>();
        String sql = "SELECT * FROM publishers ORDER BY name ASC";
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Publisher(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("email"),
                        rs.getString("phone")
                ));
            }
        } catch (SQLException e) {
            logger.error("Error listing publishers: {}", e.getMessage());
        }
        return list;
    }

    public boolean createPublisher(Publisher p) {
        String sql = "INSERT INTO publishers (name, address, email, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getAddress());
            ps.setString(3, p.getEmail());
            ps.setString(4, p.getPhone());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        p.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating publisher: {}", e.getMessage());
        }
        return false;
    }
}
