-- =============================================================================
-- AMITY UNIVERSITY NOIDA - LIBRARY MANAGEMENT SYSTEM (amity_library)
-- Production & Demonstration Schema Definition
-- Compatible with MySQL 8.0+
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `amity_library` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `amity_library`;

-- Drop tables in reverse dependency order if resetting
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `audit_logs`;
DROP TABLE IF EXISTS `system_settings`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `fines`;
DROP TABLE IF EXISTS `renewal_requests`;
DROP TABLE IF EXISTS `reservations`;
DROP TABLE IF EXISTS `loans`;
DROP TABLE IF EXISTS `book_copies`;
DROP TABLE IF EXISTS `book_authors`;
DROP TABLE IF EXISTS `books`;
DROP TABLE IF EXISTS `authors`;
DROP TABLE IF EXISTS `publishers`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `roles`;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. ROLES
CREATE TABLE `roles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL
) ENGINE=InnoDB;

-- 2. USERS
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `enrollment_no` VARCHAR(50) NOT NULL UNIQUE,
    `full_name` VARCHAR(120) NOT NULL,
    `email` VARCHAR(120) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role_id` INT NOT NULL,
    `department` VARCHAR(100) NULL,
    `course` VARCHAR(100) NULL,
    `academic_year` VARCHAR(20) NULL,
    `phone` VARCHAR(25) NULL,
    `status` ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_users_role` ON `users`(`role_id`);
CREATE INDEX `idx_users_status` ON `users`(`status`);

-- 3. CATEGORIES
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `description` TEXT NULL,
    `icon` VARCHAR(50) NULL DEFAULT 'book'
) ENGINE=InnoDB;

-- 4. PUBLISHERS
CREATE TABLE `publishers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL UNIQUE,
    `address` TEXT NULL,
    `email` VARCHAR(100) NULL,
    `phone` VARCHAR(30) NULL
) ENGINE=InnoDB;

-- 5. AUTHORS
CREATE TABLE `authors` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `biography` TEXT NULL
) ENGINE=InnoDB;

CREATE INDEX `idx_authors_name` ON `authors`(`name`);

-- 6. BOOKS (TITLES / METADATA)
CREATE TABLE `books` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `isbn` VARCHAR(25) NOT NULL UNIQUE,
    `title` VARCHAR(255) NOT NULL,
    `category_id` INT NOT NULL,
    `publisher_id` INT NULL,
    `edition` VARCHAR(50) NULL,
    `publication_year` INT NULL,
    `description` TEXT NULL,
    `cover_image` VARCHAR(255) NULL,
    `total_copies` INT NOT NULL DEFAULT 0,
    `available_copies` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_books_category` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_books_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publishers`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `chk_available_non_negative` CHECK (`available_copies` >= 0),
    CONSTRAINT `chk_copies_logic` CHECK (`available_copies` <= `total_copies`)
) ENGINE=InnoDB;

CREATE INDEX `idx_books_title` ON `books`(`title`);
CREATE INDEX `idx_books_isbn` ON `books`(`isbn`);
CREATE INDEX `idx_books_category` ON `books`(`category_id`);

-- 7. BOOK_AUTHORS (MANY-TO-MANY)
CREATE TABLE `book_authors` (
    `book_id` INT NOT NULL,
    `author_id` INT NOT NULL,
    PRIMARY KEY (`book_id`, `author_id`),
    CONSTRAINT `fk_ba_book` FOREIGN KEY (`book_id`) REFERENCES `books`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_ba_author` FOREIGN KEY (`author_id`) REFERENCES `authors`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. BOOK_COPIES (PHYSICAL INVENTORY)
CREATE TABLE `book_copies` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `barcode` VARCHAR(50) NOT NULL UNIQUE,
    `rack_location` VARCHAR(50) NULL,
    `status` ENUM('AVAILABLE', 'ISSUED', 'RESERVED', 'LOST', 'MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
    `condition_note` VARCHAR(255) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_copies_book` FOREIGN KEY (`book_id`) REFERENCES `books`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_copies_book` ON `book_copies`(`book_id`);
CREATE INDEX `idx_copies_status` ON `book_copies`(`status`);

-- 9. LOANS
CREATE TABLE `loans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `copy_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `issue_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `due_date` TIMESTAMP NOT NULL,
    `return_date` TIMESTAMP NULL,
    `status` ENUM('ACTIVE', 'RETURNED', 'OVERDUE') NOT NULL DEFAULT 'ACTIVE',
    `renewed_count` INT NOT NULL DEFAULT 0,
    `issued_by_user_id` INT NOT NULL,
    `received_by_user_id` INT NULL,
    `notes` TEXT NULL,
    CONSTRAINT `fk_loans_copy` FOREIGN KEY (`copy_id`) REFERENCES `book_copies`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_loans_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_loans_issued_by` FOREIGN KEY (`issued_by_user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_loans_received_by` FOREIGN KEY (`received_by_user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_loans_user` ON `loans`(`user_id`);
CREATE INDEX `idx_loans_status` ON `loans`(`status`);
CREATE INDEX `idx_loans_due_date` ON `loans`(`due_date`);

-- 10. RESERVATIONS
CREATE TABLE `reservations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `book_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `reservation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `expiry_date` TIMESTAMP NOT NULL,
    `queue_position` INT NOT NULL DEFAULT 1,
    `status` ENUM('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP', 'FULFILLED', 'CANCELLED', 'EXPIRED') NOT NULL DEFAULT 'PENDING',
    `notified_at` TIMESTAMP NULL,
    `notes` TEXT NULL,
    CONSTRAINT `fk_res_book` FOREIGN KEY (`book_id`) REFERENCES `books`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_res_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_res_book_status` ON `reservations`(`book_id`, `status`);
CREATE INDEX `idx_res_user` ON `reservations`(`user_id`);

-- 11. RENEWAL REQUESTS
CREATE TABLE `renewal_requests` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `loan_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `request_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    `librarian_notes` TEXT NULL,
    `processed_by` INT NULL,
    `processed_at` TIMESTAMP NULL,
    CONSTRAINT `fk_renew_loan` FOREIGN KEY (`loan_id`) REFERENCES `loans`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_renew_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_renew_processed` FOREIGN KEY (`processed_by`) REFERENCES `users`(`id`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_renew_loan` ON `renewal_requests`(`loan_id`);
CREATE INDEX `idx_renew_status` ON `renewal_requests`(`status`);

-- 12. FINES
CREATE TABLE `fines` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `loan_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `status` ENUM('PENDING', 'PAID', 'WAIVED') NOT NULL DEFAULT 'PENDING',
    `reason` VARCHAR(255) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_fines_loan` FOREIGN KEY (`loan_id`) REFERENCES `loans`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_fines_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_fines_user` ON `fines`(`user_id`);
CREATE INDEX `idx_fines_status` ON `fines`(`status`);

-- 13. PAYMENTS
CREATE TABLE `payments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `fine_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `amount_paid` DECIMAL(10,2) NOT NULL,
    `payment_method` ENUM('CASH', 'ONLINE_SIMULATED', 'UPI_SIMULATED', 'CARD_SIMULATED') NOT NULL DEFAULT 'ONLINE_SIMULATED',
    `transaction_ref` VARCHAR(100) NOT NULL UNIQUE,
    `recorded_by_user_id` INT NULL,
    `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `notes` TEXT NULL,
    CONSTRAINT `fk_payments_fine` FOREIGN KEY (`fine_id`) REFERENCES `fines`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_payments_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_payments_recorded_by` FOREIGN KEY (`recorded_by_user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_payments_user` ON `payments`(`user_id`);

-- 14. NOTIFICATIONS
CREATE TABLE `notifications` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `title` VARCHAR(150) NOT NULL,
    `message` TEXT NOT NULL,
    `type` ENUM('DUE_DATE', 'OVERDUE', 'RESERVATION', 'RENEWAL', 'FINE', 'SYSTEM') NOT NULL DEFAULT 'SYSTEM',
    `is_read` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_notif_user_unread` ON `notifications`(`user_id`, `is_read`);

-- 15. SYSTEM SETTINGS
CREATE TABLE `system_settings` (
    `setting_key` VARCHAR(50) PRIMARY KEY,
    `setting_value` TEXT NOT NULL,
    `setting_type` VARCHAR(20) NOT NULL DEFAULT 'STRING',
    `description` VARCHAR(255) NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 16. AUDIT LOGS
CREATE TABLE `audit_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NULL,
    `action` VARCHAR(100) NOT NULL,
    `details` TEXT NULL,
    `ip_address` VARCHAR(45) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_audit_user` ON `audit_logs`(`user_id`);
CREATE INDEX `idx_audit_action` ON `audit_logs`(`action`);
CREATE INDEX `idx_audit_date` ON `audit_logs`(`created_at`);
