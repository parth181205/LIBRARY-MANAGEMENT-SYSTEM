package com.amity.library.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class BookCopy implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String AVAILABLE = "AVAILABLE";
    public static final String ISSUED = "ISSUED";
    public static final String RESERVED = "RESERVED";
    public static final String LOST = "LOST";
    public static final String MAINTENANCE = "MAINTENANCE";

    private int id;
    private int bookId;
    private String bookTitle;
    private String isbn;
    private String barcode;
    private String rackLocation;
    private String status; // AVAILABLE, ISSUED, RESERVED, LOST, MAINTENANCE
    private String conditionNote;
    private Timestamp createdAt;

    public BookCopy() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }

    public String getRackLocation() { return rackLocation; }
    public void setRackLocation(String rackLocation) { this.rackLocation = rackLocation; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getConditionNote() { return conditionNote; }
    public void setConditionNote(String conditionNote) { this.conditionNote = conditionNote; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isAvailable() {
        return AVAILABLE.equalsIgnoreCase(status);
    }
}
