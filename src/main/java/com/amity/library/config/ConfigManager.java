package com.amity.library.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Thread-safe configuration manager providing resolution order:
 * 1. Environment variables (e.g. TURNSTILE_SITE_KEY, DB_PASSWORD)
 * 2. System properties (e.g. -Dturnstile.siteKey)
 * 3. application.properties fallback
 */
public final class ConfigManager {

    private static final Logger logger = LoggerFactory.getLogger(ConfigManager.class);
    private static final Properties properties = new Properties();

    static {
        try (InputStream is = ConfigManager.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (is != null) {
                properties.load(is);
                logger.info("Loaded application.properties successfully");
            } else {
                logger.warn("application.properties not found on classpath, relying on env variables");
            }
        } catch (IOException e) {
            logger.error("Failed to load application.properties: {}", e.getMessage());
        }
    }

    private ConfigManager() {
    }

    public static String get(String key) {
        return get(key, null);
    }

    public static String get(String key, String defaultValue) {
        // 1. Environment variable: replace dot with underscore and uppercase
        String envKey = key.replace('.', '_').toUpperCase();
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue.trim();
        }

        // 2. Exact match in env
        String directEnv = System.getenv(key);
        if (directEnv != null && !directEnv.trim().isEmpty()) {
            return directEnv.trim();
        }

        // 3. System property
        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }

        // 4. Properties file
        String propValue = properties.getProperty(key);
        if (propValue != null && !propValue.trim().isEmpty()) {
            return propValue.trim();
        }

        return defaultValue;
    }

    public static int getInt(String key, int defaultValue) {
        String val = get(key);
        if (val == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            logger.warn("Invalid integer for key {}: '{}', using default {}", key, val, defaultValue);
            return defaultValue;
        }
    }

    public static boolean getBoolean(String key, boolean defaultValue) {
        String val = get(key);
        if (val == null) {
            return defaultValue;
        }
        return Boolean.parseBoolean(val.trim());
    }
}
