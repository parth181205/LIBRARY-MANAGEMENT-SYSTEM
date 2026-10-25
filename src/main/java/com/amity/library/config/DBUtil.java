package com.amity.library.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * High-performance HikariCP connection pool provider.
 */
public final class DBUtil {

    private static final Logger logger = LoggerFactory.getLogger(DBUtil.class);
    private static volatile HikariDataSource dataSource;
    private static final Object lock = new Object();

    private DBUtil() {
    }

    public static DataSource getDataSource() {
        if (dataSource == null) {
            synchronized (lock) {
                if (dataSource == null) {
                    initDataSource();
                }
            }
        }
        return dataSource;
    }

    private static void initDataSource() {
        try {
            HikariConfig config = new HikariConfig();
            
            String jdbcUrl = ConfigManager.get("db.url", "jdbc:mysql://localhost:3306/amity_library?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata&characterEncoding=UTF-8");
            String username = ConfigManager.get("db.username", "root");
            String password = ConfigManager.get("db.password", "root");

            config.setJdbcUrl(jdbcUrl);
            config.setUsername(username);
            config.setPassword(password);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            config.setMaximumPoolSize(ConfigManager.getInt("db.pool.maxSize", 15));
            config.setMinimumIdle(ConfigManager.getInt("db.pool.minIdle", 3));
            config.setIdleTimeout(ConfigManager.getInt("db.pool.idleTimeoutMs", 300000));
            config.setConnectionTimeout(ConfigManager.getInt("db.pool.connectionTimeoutMs", 20000));
            config.setPoolName("AmityLibraryHikariPool");

            // Recommended MySQL performance optimizations
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            config.addDataSourceProperty("useServerPrepStmts", "true");
            config.addDataSourceProperty("useLocalSessionState", "true");
            config.addDataSourceProperty("rewriteBatchedStatements", "true");
            config.addDataSourceProperty("cacheResultSetMetadata", "true");
            config.addDataSourceProperty("cacheServerConfiguration", "true");
            config.addDataSourceProperty("elideSetAutoCommits", "true");
            config.addDataSourceProperty("maintainTimeStats", "false");

            dataSource = new HikariDataSource(config);
            logger.info("HikariCP initialized successfully for database: {}", jdbcUrl);
        } catch (Exception e) {
            logger.error("FATAL: Failed to initialize HikariCP connection pool: {}", e.getMessage(), e);
            throw new RuntimeException("Database pool initialization failed: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            synchronized (lock) {
                if (dataSource != null && !dataSource.isClosed()) {
                    dataSource.close();
                    logger.info("HikariCP connection pool closed");
                }
            }
        }
    }

    /**
     * For unit testing injection of mock DataSource (e.g., H2 in-memory DB)
     */
    public static void setCustomDataSource(HikariDataSource customDataSource) {
        synchronized (lock) {
            if (dataSource != null && !dataSource.isClosed()) {
                dataSource.close();
            }
            dataSource = customDataSource;
        }
    }
}
