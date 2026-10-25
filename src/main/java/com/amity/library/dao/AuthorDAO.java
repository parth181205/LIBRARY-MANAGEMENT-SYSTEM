package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Author;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuthorDAO {

    private static final Logger logger = LoggerFactory.getLogger(AuthorDAO.class);

    public List<Author> listAll() {
        List<Author> list = new ArrayList<>();
        String sql = "SELECT * FROM authors ORDER BY name ASC";
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Author(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("biography")
                ));
            }
        } catch (SQLException e) {
            logger.error("Error listing authors: {}", e.getMessage());
        }
        return list;
    }

    public boolean createAuthor(Author a) {
        String sql = "INSERT INTO authors (name, biography) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, a.getName());
            ps.setString(2, a.getBiography());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        a.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating author: {}", e.getMessage());
        }
        return false;
    }
}
