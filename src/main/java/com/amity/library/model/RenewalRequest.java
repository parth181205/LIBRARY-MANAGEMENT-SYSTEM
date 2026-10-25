package com.amity.library.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class RenewalRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String PENDING = "PENDING";
    public static final String APPROVED = "APPROVED";
    public static final String REJECTED = "REJECTED";

    private int id;
    private int loanId;
    private String bookTitle;
    private String barcode;
    private int userId;
    private String userFullName;
    private String userEnrollmentNo;
    private Timestamp dueDate;
    private Timestamp requestDate;
    private String status;
    private String librarianNotes;
    private Integer processedBy;
    private String processedByName;
    private Timestamp processedAt;

    public RenewalRequest() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getLoanId() { return loanId; }
    public void setLoanId(int loanId) { this.loanId = loanId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getUserEnrollmentNo() { return userEnrollmentNo; }
    public void setUserEnrollmentNo(String userEnrollmentNo) { this.userEnrollmentNo = userEnrollmentNo; }

    public Timestamp getDueDate() { return dueDate; }
    public void setDueDate(Timestamp dueDate) { this.dueDate = dueDate; }

    public Timestamp getRequestDate() { return requestDate; }
    public void setRequestDate(Timestamp requestDate) { this.requestDate = requestDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getLibrarianNotes() { return librarianNotes; }
    public void setLibrarianNotes(String librarianNotes) { this.librarianNotes = librarianNotes; }

    public Integer getProcessedBy() { return processedBy; }
    public void setProcessedBy(Integer processedBy) { this.processedBy = processedBy; }

    public String getProcessedByName() { return processedByName; }
    public void setProcessedByName(String processedByName) { this.processedByName = processedByName; }

    public Timestamp getProcessedAt() { return processedAt; }
    public void setProcessedAt(Timestamp processedAt) { this.processedAt = processedAt; }
}
