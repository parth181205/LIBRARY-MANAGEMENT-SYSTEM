package com.amity.library.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Fine implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String PENDING = "PENDING";
    public static final String PAID = "PAID";
    public static final String WAIVED = "WAIVED";

    private int id;
    private int loanId;
    private String bookTitle;
    private String barcode;
    private int userId;
    private String userFullName;
    private String userEnrollmentNo;
    private BigDecimal amount;
    private String status; // PENDING, PAID, WAIVED
    private String reason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Fine() {
        this.amount = BigDecimal.ZERO;
    }

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

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isPending() {
        return PENDING.equalsIgnoreCase(status);
    }
}
