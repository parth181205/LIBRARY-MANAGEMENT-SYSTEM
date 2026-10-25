package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.Category;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CategoryDAO {

    private static final Logger logger = LoggerFactory.getLogger(CategoryDAO.class);

    public List<Category> listAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name ASC";
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("slug"),
                        rs.getString("description"),
                        rs.getString("icon")
                ));
            }
        } catch (SQLException e) {
            logger.error("Error listing categories: {}", e.getMessage());
        }
        return list;
    }

    public Optional<Category> findBySlug(String slug) {
        String sql = "SELECT * FROM categories WHERE slug = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(new Category(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("slug"),
                            rs.getString("description"),
                            rs.getString("icon")
                    ));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding category by slug {}: {}", slug, e.getMessage());
        }
        return Optional.empty();
    }

    public boolean createCategory(String name, String slug, String description, String icon) {
        String sql = "INSERT INTO categories (name, slug, description, icon) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, slug);
            ps.setString(3, description);
            ps.setString(4, icon != null ? icon : "book");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error creating category: {}", e.getMessage());
            return false;
        }
    }
}
