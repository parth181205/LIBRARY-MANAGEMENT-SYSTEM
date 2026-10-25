package com.amity.library;

import com.amity.library.util.PasswordUtil;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PasswordUtilTest {

    @Test
    void testPasswordHashingAndVerification() {
        String raw = "Student@Amity2026";
        String hash = PasswordUtil.hashPassword(raw);

        assertNotNull(hash);
        assertTrue(hash.startsWith("$2a$12$"));
        assertTrue(PasswordUtil.checkPassword(raw, hash));
        assertFalse(PasswordUtil.checkPassword("WrongPassword", hash));
    }

    @Test
    void generateDemoHashes() {
        System.out.println("HASH_ADMIN: " + PasswordUtil.hashPassword("Admin@Amity2026"));
        System.out.println("HASH_LIBRARIAN: " + PasswordUtil.hashPassword("Librarian@Amity2026"));
        System.out.println("HASH_STUDENT: " + PasswordUtil.hashPassword("Student@Amity2026"));
    }
}
