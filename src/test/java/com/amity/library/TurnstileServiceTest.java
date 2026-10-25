package com.amity.library;

import com.amity.library.service.TurnstileService;
import org.junit.jupiter.api.Test;

import java.net.http.HttpClient;

import static org.junit.jupiter.api.Assertions.*;

class TurnstileServiceTest {

    @Test
    void testMissingTokenIsRejected() {
        TurnstileService service = new TurnstileService();
        TurnstileService.VerificationResult result = service.verify(null, "127.0.0.1");

        assertFalse(result.isValid());
        assertNotNull(result.getErrorMessage());
    }

    @Test
    void testEmptyTokenIsRejected() {
        TurnstileService service = new TurnstileService();
        TurnstileService.VerificationResult result = service.verify("   ", "127.0.0.1");

        assertFalse(result.isValid());
    }

    @Test
    void testDisabledTurnstilePasses() {
        HttpClient client = HttpClient.newHttpClient();
        TurnstileService service = new TurnstileService(client, "https://challenges.cloudflare.com/turnstile/v0/siteverify", "dummy_key", false, 5);

        TurnstileService.VerificationResult result = service.verify("any_token", "127.0.0.1");
        assertTrue(result.isValid());
    }
}
