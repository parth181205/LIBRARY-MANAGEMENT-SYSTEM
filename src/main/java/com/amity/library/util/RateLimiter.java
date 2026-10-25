package com.amity.library.util;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Thread-safe in-memory rate limiter with sliding window to prevent brute force login attempts.
 */
public class RateLimiter {

    private final int maxAttempts;
    private final long windowMillis;
    private final Map<String, AttemptTracker> attemptsMap = new ConcurrentHashMap<>();

    public RateLimiter(int maxAttempts, long windowMinutes) {
        this.maxAttempts = maxAttempts;
        this.windowMillis = windowMinutes * 60 * 1000L;
    }

    /**
     * Checks if the given key (e.g. IP + Username) is currently blocked.
     *
     * @param key unique identifier for the request client
     * @return true if allowed, false if rate limited
     */
    public boolean isAllowed(String key) {
        cleanOldEntries();
        AttemptTracker tracker = attemptsMap.get(key);
        if (tracker == null) {
            return true;
        }
        if (System.currentTimeMillis() - tracker.firstAttemptTime > windowMillis) {
            attemptsMap.remove(key);
            return true;
        }
        return tracker.count < maxAttempts;
    }

    /**
     * Records a failed attempt for the given key.
     */
    public void recordFailure(String key) {
        long now = System.currentTimeMillis();
        attemptsMap.compute(key, (k, tracker) -> {
            if (tracker == null || (now - tracker.firstAttemptTime > windowMillis)) {
                return new AttemptTracker(1, now);
            } else {
                tracker.count++;
                return tracker;
            }
        });
    }

    /**
     * Resets failure counter upon successful authentication.
     */
    public void recordSuccess(String key) {
        attemptsMap.remove(key);
    }

    public int getRemainingAttempts(String key) {
        AttemptTracker tracker = attemptsMap.get(key);
        if (tracker == null || (System.currentTimeMillis() - tracker.firstAttemptTime > windowMillis)) {
            return maxAttempts;
        }
        return Math.max(0, maxAttempts - tracker.count);
    }

    private void cleanOldEntries() {
        if (attemptsMap.size() > 5000) {
            long now = System.currentTimeMillis();
            attemptsMap.entrySet().removeIf(entry -> now - entry.getValue().firstAttemptTime > windowMillis);
        }
    }

    private static class AttemptTracker {
        int count;
        final long firstAttemptTime;

        AttemptTracker(int count, long firstAttemptTime) {
            this.count = count;
            this.firstAttemptTime = firstAttemptTime;
        }
    }
}
