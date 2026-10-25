package com.amity.library.dao;

import com.amity.library.config.DBUtil;
import com.amity.library.model.SystemSetting;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class SystemSettingDAO {

    private static final Logger logger = LoggerFactory.getLogger(SystemSettingDAO.class);

    public Map<String, String> getAllSettings() {
        Map<String, String> map = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM system_settings";
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            logger.error("Error loading system settings: {}", e.getMessage());
        }
        return map;
    }

    public String getSetting(String key, String defaultValue) {
        String sql = "SELECT setting_value FROM system_settings WHERE setting_key = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("setting_value");
                }
            }
        } catch (SQLException e) {
            logger.error("Error reading setting {}: {}", key, e.getMessage());
        }
        return defaultValue;
    }

    public int getIntSetting(String key, int defaultValue) {
        String val = getSetting(key, null);
        if (val == null) return defaultValue;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public BigDecimal getDecimalSetting(String key, BigDecimal defaultValue) {
        String val = getSetting(key, null);
        if (val == null) return defaultValue;
        try {
            return new BigDecimal(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public boolean updateSetting(String key, String value) {
        String sql = "INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE setting_value = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.setString(3, value);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating setting {}: {}", key, e.getMessage());
            return false;
        }
    }
}
