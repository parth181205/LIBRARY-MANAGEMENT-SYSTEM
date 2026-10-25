package com.amity.library.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Notification implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String TYPE_DUE_DATE = "DUE_DATE";
    public static final String TYPE_OVERDUE = "OVERDUE";
    public static final String TYPE_RESERVATION = "RESERVATION";
    public static final String TYPE_RENEWAL = "RENEWAL";
    public static final String TYPE_FINE = "FINE";
    public static final String TYPE_SYSTEM = "SYSTEM";

    private int id;
    private int userId;
    private String title;
    private String message;
    private String type;
    private boolean read;
    private Timestamp createdAt;

    public Notification() {}

    public Notification(int userId, String title, String message, String type) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type;
        this.read = false;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
