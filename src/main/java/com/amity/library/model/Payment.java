package com.amity.library.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String METHOD_CASH = "CASH";
    public static final String METHOD_ONLINE = "ONLINE_SIMULATED";
    public static final String METHOD_UPI = "UPI_SIMULATED";
    public static final String METHOD_CARD = "CARD_SIMULATED";

    private int id;
    private int fineId;
    private int userId;
    private String userFullName;
    private String userEnrollmentNo;
    private BigDecimal amountPaid;
    private String paymentMethod;
    private String transactionRef;
    private Integer recordedByUserId;
    private String recordedByName;
    private Timestamp paymentDate;
    private String notes;

    public Payment() {
        this.amountPaid = BigDecimal.ZERO;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getFineId() { return fineId; }
    public void setFineId(int fineId) { this.fineId = fineId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getUserEnrollmentNo() { return userEnrollmentNo; }
    public void setUserEnrollmentNo(String userEnrollmentNo) { this.userEnrollmentNo = userEnrollmentNo; }

    public BigDecimal getAmountPaid() { return amountPaid; }
    public void setAmountPaid(BigDecimal amountPaid) { this.amountPaid = amountPaid; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public Integer getRecordedByUserId() { return recordedByUserId; }
    public void setRecordedByUserId(Integer recordedByUserId) { this.recordedByUserId = recordedByUserId; }

    public String getRecordedByName() { return recordedByName; }
    public void setRecordedByName(String recordedByName) { this.recordedByName = recordedByName; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
