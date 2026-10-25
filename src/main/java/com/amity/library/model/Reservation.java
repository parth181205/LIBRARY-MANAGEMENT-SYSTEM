package com.amity.library.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Reservation implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String PENDING = "PENDING";
    public static final String CONFIRMED = "CONFIRMED";
    public static final String READY_FOR_PICKUP = "READY_FOR_PICKUP";
    public static final String FULFILLED = "FULFILLED";
    public static final String CANCELLED = "CANCELLED";
    public static final String EXPIRED = "EXPIRED";

    private int id;
    private int bookId;
    private String bookTitle;
    private String bookCover;
    private String isbn;
    private int userId;
    private String userFullName;
    private String userEnrollmentNo;
    private Timestamp reservationDate;
    private Timestamp expiryDate;
    private int queuePosition;
    private String status;
    private Timestamp notifiedAt;
    private String notes;

    public Reservation() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBookCover() { return bookCover; }
    public void setBookCover(String bookCover) { this.bookCover = bookCover; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getUserEnrollmentNo() { return userEnrollmentNo; }
    public void setUserEnrollmentNo(String userEnrollmentNo) { this.userEnrollmentNo = userEnrollmentNo; }

    public Timestamp getReservationDate() { return reservationDate; }
    public void setReservationDate(Timestamp reservationDate) { this.reservationDate = reservationDate; }

    public Timestamp getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Timestamp expiryDate) { this.expiryDate = expiryDate; }

    public int getQueuePosition() { return queuePosition; }
    public void setQueuePosition(int queuePosition) { this.queuePosition = queuePosition; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getNotifiedAt() { return notifiedAt; }
    public void setNotifiedAt(Timestamp notifiedAt) { this.notifiedAt = notifiedAt; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public boolean isActive() {
        return PENDING.equalsIgnoreCase(status) || CONFIRMED.equalsIgnoreCase(status) || READY_FOR_PICKUP.equalsIgnoreCase(status);
    }
}
