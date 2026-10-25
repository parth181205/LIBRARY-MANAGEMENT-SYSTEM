-- =============================================================================
-- AMITY UNIVERSITY NOIDA - LIBRARY MANAGEMENT SYSTEM DEMONSTRATION SEED DATA
-- Database: amity_library
-- =============================================================================

USE `amity_library`;

-- 1. SEED ROLES
INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'STUDENT', 'Enrolled undergraduate and postgraduate student patron'),
(2, 'LIBRARIAN', 'Circulation desk librarian and catalog administrator'),
(3, 'ADMIN', 'System administrator with security configuration and audit access')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

-- 2. SEED SYSTEM SETTINGS
INSERT INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('max_books_student', '3', 'INTEGER', 'Maximum concurrent active loans permitted for undergraduate/postgraduate students'),
('max_books_faculty', '6', 'INTEGER', 'Maximum concurrent active loans permitted for university faculty'),
('loan_duration_days', '14', 'INTEGER', 'Standard loan period in days before items become overdue'),
('fine_rate_per_day', '5.00', 'DECIMAL', 'Fine accrued in INR per day for overdue items'),
('max_renewals_allowed', '2', 'INTEGER', 'Maximum number of self-service renewals permitted per loan'),
('reservation_expiry_days', '3', 'INTEGER', 'Days a reserved book is held on the shelf for pickup before automatic cancellation')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);

-- 3. SEED USERS
-- Password for Student accounts: Student@Amity2026
-- Password for Librarian account: Librarian@Amity2026
-- Password for Admin account: Admin@Amity2026
INSERT INTO `users` (`id`, `enrollment_no`, `full_name`, `email`, `password_hash`, `role_id`, `department`, `course`, `academic_year`, `phone`, `status`) VALUES
(1, 'ADM-1001', 'Prof. Rajesh K. Kapoor', 'admin@amity.edu', '$2a$12$Op65ZgrRB.FfKYojNRNSL.Hm3V.4SZPbm4ZeZL8fZtwehp6TIn8Du', 3, 'Central IT & Administration', 'Head of Library Services', 'Faculty', '+91 98110 01100', 'ACTIVE'),
(2, 'LIB-2001', 'Dr. Sunita Mehta', 'librarian@amity.edu', '$2a$12$.9HhoSnStzWIrSL9vXhoH.EG9BQ/quHqSIncCT79Np4N/vUdS3Tii', 2, 'Central Library & Resource Centre', 'Chief Circulation Officer', 'Staff', '+91 98110 02200', 'ACTIVE'),
(3, 'A2305221001', 'Aarav Sharma', 'student1@amity.edu', '$2a$12$8N9jXm6nT16YUEhIV6asNO61VlxnKd4mWtb7cfx32aEbAuTlGDZTK', 1, 'Amity School of Engineering and Technology (ASET)', 'B.Tech Computer Science & Engineering', '3rd Year', '+91 98765 11001', 'ACTIVE'),
(4, 'A2305221002', 'Ananya Verma', 'student2@amity.edu', '$2a$12$8N9jXm6nT16YUEhIV6asNO61VlxnKd4mWtb7cfx32aEbAuTlGDZTK', 1, 'Amity Business School (ABS)', 'MBA Marketing & Analytics', '2nd Year', '+91 98765 11002', 'ACTIVE')
ON DUPLICATE KEY UPDATE `full_name` = VALUES(`full_name`);

-- 4. SEED CATEGORIES
INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `icon`) VALUES
(1, 'Books', 'books', 'Printed hardcover and paperback academic volumes', 'book'),
(2, 'E-books', 'ebooks', 'Digital e-textbooks and electronic publications', 'tablet'),
(3, 'Journals', 'journals', 'Peer-reviewed international academic periodicals', 'bookmark'),
(4, 'Research Papers', 'research-papers', 'Conference proceedings and university research publications', 'file-text'),
(5, 'Magazines', 'magazines', 'Industry publications and current affairs periodicals', 'layout'),
(6, 'Theses', 'theses', 'Doctoral dissertations and postgraduate theses', 'award')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 5. SEED PUBLISHERS
INSERT INTO `publishers` (`id`, `name`, `address`, `email`, `phone`) VALUES
(1, 'MIT Press', 'One Broadway, 12th Floor, Cambridge, MA 02142', 'mitpress-orders@mit.edu', '+1 617-253-5646'),
(2, 'Pearson Education India', 'Plot No. 18, Block A, Sector 62, Noida, UP 201309', 'contact@pearson.co.in', '+91 120-4306000'),
(3, 'McGraw Hill India', 'B-4, Sector 63, Noida, UP 201301', 'support@mheducation.co.in', '+91 120-4383400'),
(4, 'Oxford University Press', 'YMCA Library Building, 1 Jai Singh Road, New Delhi 110001', 'info.in@oup.com', '+91 11-43600300'),
(5, 'Springer Nature', 'Tiergartenstraße 17, 69121 Heidelberg, Germany', 'springer@nature.com', '+49 6221 487 0'),
(6, 'Addison-Wesley Professional', 'Boston, MA 02116', 'info@awprofessional.com', '+1 800-824-7799')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 6. SEED AUTHORS
INSERT INTO `authors` (`id`, `name`, `biography`) VALUES
(1, 'Thomas H. Cormen', 'Emeritus Professor of Computer Science at Dartmouth College and lead author of CLRS.'),
(2, 'Charles E. Leiserson', 'Professor of Computer Science and Engineering at MIT.'),
(3, 'Robert C. Martin', 'Renowned software engineer, author of Clean Code and Clean Architecture.'),
(4, 'Stuart Russell', 'Professor of Computer Science at UC Berkeley and renowned AI authority.'),
(5, 'Peter Norvig', 'Director of Research at Google and co-author of modern AI curriculum.'),
(6, 'Andrew S. Tanenbaum', 'Emeritus Professor at Vrije Universiteit Amsterdam and creator of MINIX.'),
(7, 'Philip Kotler', 'Professor of International Marketing at Kellogg School of Management, Northwestern University.'),
(8, 'Erich Gamma', 'Lead designer of Eclipse Java development tools and Gang of Four author.'),
(9, 'Richard Helm', 'Software architect and co-author of Design Patterns.'),
(10, 'Ralph Johnson', 'Professor at University of Illinois and co-author of Design Patterns.'),
(11, 'John Vlissides', 'Researcher at IBM Thomas J. Watson Research Center and Gang of Four author.')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 7. SEED BOOKS
INSERT INTO `books` (`id`, `isbn`, `title`, `category_id`, `publisher_id`, `edition`, `publication_year`, `description`, `cover_image`, `total_copies`, `available_copies`) VALUES
(1, '978-0262033848', 'Introduction to Algorithms (CLRS)', 1, 1, '4th Edition', 2022, 'The leading textbook in algorithms worldwide, offering a comprehensive and rigorous treatment of algorithm design and analysis across dynamic programming, greedy algorithms, and graph theory.', 'assets/images/default-book.png', 4, 3),
(2, '978-0134494166', 'Clean Architecture: A Craftsman Guide to Software Structure', 1, 6, '1st Edition', 2018, 'A masterclass by Uncle Bob Martin outlining universal rules of software architecture to improve developer productivity and system longevity through component design and dependency inversion.', 'assets/images/default-book.png', 3, 2),
(3, '978-0134610993', 'Artificial Intelligence: A Modern Approach', 1, 2, '4th Edition', 2020, 'The gold standard reference in AI, synthesizing probabilistic reasoning, deep learning, reinforcement learning, natural language processing, and ethical machine intelligence.', 'assets/images/default-book.png', 3, 3),
(4, '978-0133591620', 'Modern Operating Systems', 1, 2, '4th Edition', 2015, 'Andrew Tanenbaum definitive guide to modern operating system principles including process concurrency, virtualization, file system architecture, and security defenses.', 'assets/images/default-book.png', 3, 2),
(5, '978-0205009992', 'Marketing Management', 1, 2, '15th Edition', 2021, 'Philip Kotler foundational textbook on global brand building, customer value creation, omnichannel distribution, and digital analytics in corporate marketing.', 'assets/images/default-book.png', 3, 3),
(6, '978-0201633610', 'Design Patterns: Elements of Reusable Object-Oriented Software', 1, 6, '1st Edition', 2019, 'The classic Gang of Four volume cataloging 23 fundamental creational, structural, and behavioral design patterns for object-oriented software engineering.', 'assets/images/default-book.png', 2, 2)
ON DUPLICATE KEY UPDATE `title` = VALUES(`title`);

-- 8. LINK BOOK AUTHORS
INSERT IGNORE INTO `book_authors` (`book_id`, `author_id`) VALUES
(1, 1), (1, 2),
(2, 3),
(3, 4), (3, 5),
(4, 6),
(5, 7),
(6, 8), (6, 9), (6, 10), (6, 11);

-- 9. SEED PHYSICAL BOOK COPIES
INSERT INTO `book_copies` (`id`, `book_id`, `barcode`, `rack_location`, `status`, `condition_note`) VALUES
-- Copies for Introduction to Algorithms (CLRS)
(1, 1, 'AM-1-001', 'ASET Rack A-01', 'AVAILABLE', 'Mint Condition'),
(2, 1, 'AM-1-002', 'ASET Rack A-01', 'ISSUED', 'Good Condition'),
(3, 1, 'AM-1-003', 'ASET Rack A-01', 'AVAILABLE', 'Clean Copy'),
(4, 1, 'AM-1-004', 'ASET Rack A-01', 'AVAILABLE', 'New Arrival'),

-- Copies for Clean Architecture
(5, 2, 'AM-2-001', 'ASET Rack B-04', 'AVAILABLE', 'Brand New'),
(6, 2, 'AM-2-002', 'ASET Rack B-04', 'ISSUED', 'Slightly annotated'),
(7, 2, 'AM-2-003', 'ASET Rack B-04', 'AVAILABLE', 'Mint Condition'),

-- Copies for Artificial Intelligence
(8, 3, 'AM-3-001', 'AIIT Rack C-02', 'AVAILABLE', 'Hardcover Edition'),
(9, 3, 'AM-3-002', 'AIIT Rack C-02', 'AVAILABLE', 'Reference Shelf'),
(10, 3, 'AM-3-003', 'AIIT Rack C-02', 'AVAILABLE', 'Clean Copy'),

-- Copies for Modern Operating Systems
(11, 4, 'AM-4-001', 'ASET Rack D-01', 'AVAILABLE', 'Good condition'),
(12, 4, 'AM-4-002', 'ASET Rack D-01', 'ISSUED', 'Checked out'),
(13, 4, 'AM-4-003', 'ASET Rack D-01', 'AVAILABLE', 'Reference Copy'),

-- Copies for Marketing Management
(14, 5, 'AM-5-001', 'ABS Rack M-01', 'AVAILABLE', 'New Edition'),
(15, 5, 'AM-5-002', 'ABS Rack M-01', 'AVAILABLE', 'Desk Copy'),
(16, 5, 'AM-5-003', 'ABS Rack M-01', 'AVAILABLE', 'Clean Copy'),

-- Copies for Design Patterns
(17, 6, 'AM-6-001', 'ASET Rack S-03', 'AVAILABLE', 'Special Reserve'),
(18, 6, 'AM-6-002', 'ASET Rack S-03', 'AVAILABLE', 'Circulation Shelf')
ON DUPLICATE KEY UPDATE `status` = VALUES(`status`);

-- 10. SEED DEMO LOANS
-- Loan 1: Active Loan for Aarav Sharma (Due in 10 days)
INSERT INTO `loans` (`id`, `copy_id`, `user_id`, `issue_date`, `due_date`, `return_date`, `status`, `renewed_count`, `issued_by_user_id`) VALUES
(1, 2, 3, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(NOW(), INTERVAL 10 DAY), NULL, 'ACTIVE', 0, 2),
-- Loan 2: Overdue Loan for Aarav Sharma (Due 3 days ago -> demonstrates fine calculation)
(2, 6, 3, DATE_SUB(NOW(), INTERVAL 17 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY), NULL, 'OVERDUE', 0, 2),
-- Loan 3: Active Loan for Ananya Verma
(3, 12, 4, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 12 DAY), NULL, 'ACTIVE', 0, 2)
ON DUPLICATE KEY UPDATE `status` = VALUES(`status`);

-- 11. SEED OVERDUE FINE FOR LOAN #2
INSERT INTO `fines` (`id`, `loan_id`, `user_id`, `amount`, `status`, `reason`) VALUES
(1, 2, 3, 15.00, 'PENDING', 'Overdue by 3 day(s) at ₹5.00/day')
ON DUPLICATE KEY UPDATE `amount` = VALUES(`amount`);

-- 12. SEED SAMPLE RESERVATION
INSERT INTO `reservations` (`id`, `book_id`, `user_id`, `reservation_date`, `expiry_date`, `queue_position`, `status`) VALUES
(1, 2, 4, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 1, 'CONFIRMED')
ON DUPLICATE KEY UPDATE `status` = VALUES(`status`);

-- 13. SEED SAMPLE NOTIFICATIONS
INSERT INTO `notifications` (`user_id`, `title`, `message`, `type`, `is_read`) VALUES
(3, 'Welcome to Amity Central Library', 'Your digital library patron account has been activated. You may borrow up to 3 physical volumes.', 'SYSTEM', TRUE),
(3, 'Overdue Alert', 'Your loan of Clean Architecture (Barcode: AM-2-002) is 3 days overdue. Please return to counter.', 'OVERDUE', FALSE),
(4, 'Reservation Confirmed', 'Your reservation hold for Clean Architecture has been confirmed (Queue #1).', 'RESERVATION', FALSE)
ON DUPLICATE KEY UPDATE `title` = VALUES(`title`);

-- 14. SEED SAMPLE AUDIT LOGS
INSERT INTO `audit_logs` (`user_id`, `action`, `details`, `ip_address`) VALUES
(1, 'SYSTEM_INIT', 'Amity Library Management System initialized with demonstration seed data', '127.0.0.1'),
(2, 'ISSUE_BOOK', 'Issued copy AM-1-002 to Aarav Sharma (A2305221001)', '127.0.0.1'),
(2, 'ISSUE_BOOK', 'Issued copy AM-2-002 to Aarav Sharma (A2305221001)', '127.0.0.1');
