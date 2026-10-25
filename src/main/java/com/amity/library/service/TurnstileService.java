package com.amity.library.service;

import com.amity.library.config.ConfigManager;
import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Cloudflare Turnstile Server-Side Verification Service.
 * Implements official Siteverify API specification with fail-closed security policy.
 */
public class TurnstileService {

    private static final Logger logger = LoggerFactory.getLogger(TurnstileService.class);
    private static final Gson gson = new Gson();

    private final HttpClient httpClient;
    private final String verifyUrl;
    private final String secretKey;
    private final boolean enabled;
    private final int timeoutSeconds;

    public TurnstileService() {
        this.timeoutSeconds = ConfigManager.getInt("turnstile.timeoutSeconds", 5);
        this.verifyUrl = ConfigManager.get("turnstile.verifyUrl", "https://challenges.cloudflare.com/turnstile/v0/siteverify");
        this.secretKey = ConfigManager.get("turnstile.secretKey", "1x0000000000000000000000000000000AA");
        this.enabled = ConfigManager.getBoolean("turnstile.enabled", true);

        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(timeoutSeconds))
                .followRedirects(HttpClient.Redirect.NEVER)
                .build();
    }

    // Constructor for testing with dependency injection
    public TurnstileService(HttpClient httpClient, String verifyUrl, String secretKey, boolean enabled, int timeoutSeconds) {
        this.httpClient = httpClient;
        this.verifyUrl = verifyUrl;
        this.secretKey = secretKey;
        this.enabled = enabled;
        this.timeoutSeconds = timeoutSeconds;
    }

    /**
     * Verifies the Cloudflare Turnstile token from client request.
     *
     * @param token cf-turnstile-response string
     * @param remoteIp client IP address (optional)
     * @return VerificationResult indicating success, failure reasons, and error codes
     */
    public VerificationResult verify(String token, String remoteIp) {
        if (!enabled) {
            logger.warn("Turnstile verification is disabled by configuration");
            return VerificationResult.successResult();
        }

        if (token == null || token.trim().isEmpty()) {
            logger.warn("Turnstile verification failed: missing or empty token");
            return VerificationResult.failResult("Security challenge token is missing. Please complete the verification.");
        }

        if (secretKey == null || secretKey.trim().isEmpty()) {
            logger.error("Turnstile configuration error: secret key is not configured");
            return VerificationResult.failResult("Security verification system error. Please contact administrator.");
        }

        try {
            Map<String, String> formData = new java.util.HashMap<>();
            formData.put("secret", secretKey);
            formData.put("response", token.trim());
            if (remoteIp != null && !remoteIp.trim().isEmpty() && !remoteIp.contains(":")) {
                // include remoteip for IPv4 if available
                formData.put("remoteip", remoteIp.trim());
            }

            String formBody = formData.entrySet().stream()
                    .map(e -> URLEncoder.encode(e.getKey(), StandardCharsets.UTF_8) + "=" +
                            URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8))
                    .collect(Collectors.joining("&"));

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(verifyUrl))
                    .timeout(Duration.ofSeconds(timeoutSeconds))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .header("Accept", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(formBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                logger.error("Turnstile siteverify returned HTTP status: {}", response.statusCode());
                return VerificationResult.failResult("Verification service unavailable. Status: " + response.statusCode());
            }

            TurnstileResponse turnstileResponse = gson.fromJson(response.body(), TurnstileResponse.class);

            if (turnstileResponse != null && turnstileResponse.isSuccess()) {
                logger.debug("Turnstile verification succeeded for hostname: {}", turnstileResponse.getHostname());
                return VerificationResult.successResult();
            } else {
                List<String> errors = turnstileResponse != null ? turnstileResponse.getErrorCodes() : null;
                logger.warn("Turnstile verification rejected token. Errors: {}", errors);
                return VerificationResult.failResult("Verification challenge failed or expired. Please try again.");
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            logger.error("Turnstile request interrupted: {}", e.getMessage());
            // Fail-closed policy
            return VerificationResult.failResult("Verification timed out. Please try again.");
        } catch (Exception e) {
            logger.error("Turnstile verification network or parsing exception: {}", e.getMessage());
            // Fail-closed policy: never silently bypass
            return VerificationResult.failResult("Security challenge verification failed due to network error.");
        }
    }

    public static class VerificationResult {
        private final boolean valid;
        private final String errorMessage;

        private VerificationResult(boolean valid, String errorMessage) {
            this.valid = valid;
            this.errorMessage = errorMessage;
        }

        public static VerificationResult successResult() {
            return new VerificationResult(true, null);
        }

        public static VerificationResult failResult(String errorMessage) {
            return new VerificationResult(false, errorMessage);
        }

        public boolean isValid() {
            return valid;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }

    /**
     * DTO mapping Cloudflare Siteverify JSON response
     */
    public static class TurnstileResponse {
        @SerializedName("success")
        private boolean success;

        @SerializedName("challenge_ts")
        private String challengeTs;

        @SerializedName("hostname")
        private String hostname;

        @SerializedName("error-codes")
        private List<String> errorCodes;

        @SerializedName("action")
        private String action;

        @SerializedName("cdata")
        private String cdata;

        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getChallengeTs() {
            return challengeTs;
        }

        public String getHostname() {
            return hostname;
        }

        public List<String> getErrorCodes() {
            return errorCodes;
        }

        public String getAction() {
            return action;
        }
    }
}
