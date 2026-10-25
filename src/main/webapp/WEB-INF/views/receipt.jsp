<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Receipt #${payment.transactionRef} | Amity University</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            body {
                background: #FFFFFF !important;
            }
            .receipt-box {
                box-shadow: none !important;
                border: 1px solid #000000 !important;
            }
        }
        .receipt-box {
            max-width: 650px;
            margin: 40px auto;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            padding: 40px;
        }
        .receipt-header {
            text-align: center;
            border-bottom: 2px solid var(--primary-navy);
            padding-bottom: 24px;
            margin-bottom: 24px;
        }
        .receipt-logo {
            height: 60px;
            margin-bottom: 12px;
        }
        .receipt-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed var(--border-color);
            font-size: 0.95rem;
        }
    </style>
</head>
<body style="background-color: var(--main-bg);">

<div class="receipt-box">
    <div class="receipt-header">
        <img src="${pageContext.request.contextPath}/assets/images/amity-logo.png" alt="Amity Logo" class="receipt-logo">
        <h2 style="font-family: var(--font-brand); color: var(--primary-navy); font-size: 1.5rem; letter-spacing: 1px;">AMITY UNIVERSITY NOIDA</h2>
        <p style="font-size: 0.85rem; color: var(--secondary-text); text-transform: uppercase;">Central Library &bull; Official Clearance Receipt</p>
    </div>

    <div style="text-align: center; margin-bottom: 24px;">
        <span class="status-badge status-available" style="font-size: 0.9rem; padding: 6px 16px;">
            &#10003; PAYMENT SETTLED
        </span>
    </div>

    <div class="receipt-row">
        <span style="color: var(--secondary-text);">Transaction Reference:</span>
        <strong><code>${payment.transactionRef}</code></strong>
    </div>

    <div class="receipt-row">
        <span style="color: var(--secondary-text);">Date &amp; Time:</span>
        <span><fmt:formatDate value="${payment.paymentDate}" pattern="dd MMMM yyyy, HH:mm:ss" /></span>
    </div>

    <div class="receipt-row">
        <span style="color: var(--secondary-text);">Student / Patron Name:</span>
        <strong>${payment.userFullName}</strong>
    </div>

    <div class="receipt-row">
        <span style="color: var(--secondary-text);">Enrollment Number:</span>
        <span><code>${payment.userEnrollmentNo}</code></span>
    </div>

    <div class="receipt-row">
        <span style="color: var(--secondary-text);">Payment Mode:</span>
        <span><strong>${payment.paymentMethod}</strong></span>
    </div>

    <div class="receipt-row">
        <span style="color: var(--secondary-text);">Receipt Authority:</span>
        <span>${not empty payment.recordedByName ? payment.recordedByName : 'Amity Central Library Gateway'}</span>
    </div>

    <div class="receipt-row" style="border-bottom: 2px solid var(--primary-navy); padding: 18px 0; margin-top: 10px;">
        <span style="font-size: 1.15rem; font-weight: 700; color: var(--primary-navy);">Total Amount Paid:</span>
        <span style="font-size: 1.4rem; font-weight: 800; color: var(--primary-navy);">₹${payment.amountPaid}</span>
    </div>

    <div style="margin-top: 24px; font-size: 0.8rem; color: var(--secondary-text); text-align: center; line-height: 1.5;">
        This is an electronically generated academic library transaction clearance voucher.
        For queries, contact central library counter: Sector 125, Noida.
    </div>

    <div class="no-print" style="margin-top: 30px; display: flex; justify-content: center; gap: 14px;">
        <button onclick="window.print()" class="btn btn-primary">
            &#128438; Print Receipt
        </button>
        <button onclick="window.close()" class="btn btn-secondary">
            Close Window
        </button>
    </div>
</div>

</body>
</html>
