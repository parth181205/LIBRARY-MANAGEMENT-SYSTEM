package com.amity.library.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Enterprise Password Utility using BCrypt hashing with configurable cost factor.
 */
public final class PasswordUtil {

    private static final int BCRYPT_LOG_ROUNDS = 12;

    private PasswordUtil() {
        // Utility class
    }

    /**
     * Hashes plaintext password with BCrypt and salt.
     *
     * @param plainPassword plaintext string
     * @return BCrypt salted hash string
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_LOG_ROUNDS));
    }

    /**
     * Verifies plaintext password against a stored BCrypt hash.
     *
     * @param plainPassword plaintext string
     * @param hashedPassword stored BCrypt hash
     * @return true if matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Invalid hash format
            return false;
        }
    }
}
