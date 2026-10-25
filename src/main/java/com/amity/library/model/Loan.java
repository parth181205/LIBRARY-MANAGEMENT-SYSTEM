package com.amity.library.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

public class Loan implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String ACTIVE = "ACTIVE";
    public static final String RETURNED = "RETURNED";
    public static final String OVERDUE = "OVERDUE";

    private int id;
    private int copyId;
    private int bookId;
    private String bookTitle;
    private String bookCover;
    private String isbn;
    private String barcode;
    private int userId;
    private String userFullName;
    private String userEnrollmentNo;
    private Timestamp issueDate;
    private Timestamp dueDate;
    private Timestamp returnDate;
    private String status; // ACTIVE, RETURNED, OVERDUE
    private int renewedCount;
    private int issuedByUserId;
    private Integer receivedByUserId;
    private String notes;

    public Loan() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCopyId() { return copyId; }
    public void setCopyId(int copyId) { this.copyId = copyId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBookCover() { return bookCover; }
    public void setBookCover(String bookCover) { this.bookCover = bookCover; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getUserEnrollmentNo() { return userEnrollmentNo; }
    public void setUserEnrollmentNo(String userEnrollmentNo) { this.userEnrollmentNo = userEnrollmentNo; }

    public Timestamp getIssueDate() { return issueDate; }
    public void setIssueDate(Timestamp issueDate) { this.issueDate = issueDate; }

    public Timestamp getDueDate() { return dueDate; }
    public void setDueDate(Timestamp dueDate) { this.dueDate = dueDate; }

    public Timestamp getReturnDate() { return returnDate; }
    public void setReturnDate(Timestamp returnDate) { this.returnDate = returnDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getRenewedCount() { return renewedCount; }
    public void setRenewedCount(int renewedCount) { this.renewedCount = renewedCount; }

    public int getIssuedByUserId() { return issuedByUserId; }
    public void setIssuedByUserId(int issuedByUserId) { this.issuedByUserId = issuedByUserId; }

    public Integer getReceivedByUserId() { return receivedByUserId; }
    public void setReceivedByUserId(Integer receivedByUserId) { this.receivedByUserId = receivedByUserId; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public boolean isCurrentlyOverdue() {
        if (RETURNED.equalsIgnoreCase(status)) {
            return false;
        }
        return dueDate != null && dueDate.before(Timestamp.from(Instant.now()));
    }

    public long getDaysOverdue() {
        if (!isCurrentlyOverdue() || dueDate == null) {
            return 0;
        }
        return ChronoUnit.DAYS.between(dueDate.toInstant(), Instant.now());
    }
}
