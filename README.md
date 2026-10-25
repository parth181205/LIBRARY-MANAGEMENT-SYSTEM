# Amity University Noida - Library Management System (Enterprise Academic Edition)

An enterprise-grade, integrated, secure **Library Management System** engineered specifically for **Amity University Noida**. Built following clean layered architecture using modern Java 17+, Jakarta EE 10 (Tomcat 10.1+), MySQL 8.0, JDBC with HikariCP, BCrypt password encryption, and server-side Cloudflare Turnstile bot challenge verification.

---

## 1. Visual Aesthetics & Design System

The application strictly implements the Amity University institutional aesthetic:
- **Primary Navy (`#06264A`)**: Primary brand identity, headers, buttons, and navigation shell.
- **Secondary Navy (`#0B315C`)**: Gradients and active states.
- **Gold Accent (`#FFC928`)**: Academic accents, gold hover transitions, and status highlights.
- **Neutral Canvas (`#F4F7FB`)**: Clean background ensuring accessible reading contrast.
- **Card Background (`#FFFFFF`)**: Rounded card elevations with subtle shadows.
- **Typography**: Headings rendered in classical university serif (`Playfair Display` & `Cinzel`), body in clean `Inter`.
- **Branding Assets**:
  - `src/main/webapp/assets/images/amity-noida-logo-transparent.png` (Transparent university crest, `object-fit: contain`).
  - `src/main/webapp/assets/images/Amity University Noida Sunset Campus.png` (AI-generated campus representation with readable overlay on login screen).

---

## 2. Technology Stack

| Layer | Technology | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Backend Language** | Java (Open / Microsoft JDK) | 17+ (Compiled on 21) | Core business logic & transactions |
| **Web Container API** | Jakarta Servlet & JSP API | 6.0 / 3.1 | Request routing, sessions, MVC filters |
| **Server Deployment**| Apache Tomcat | 10.1.x+ | Production Servlet container |
| **Database** | MySQL Server | 8.0+ | Relational persistence & constraints |
| **Connection Pool** | HikariCP | 5.1.0 | Fast, thread-safe connection pooling |
| **Password Security**| jBCrypt | 0.4 (Cost 12) | Irreversible salted password hashing |
| **Bot Challenge** | Cloudflare Turnstile | v0 API | Server-verified CAPTCHA alternative |
| **JSON Parser** | Google Gson | 2.11.0 | Cloudflare JSON payload mapping |
| **Build Tool** | Apache Maven | 3.9+ | Dependency & lifecycle management |
| **Frontend** | HTML5, CSS3, Vanilla JS | Modern ES6+ | Zero heavy framework overhead |

---

## 3. Project Architecture

The codebase adheres strictly to layered software architecture:

```
c:\Users\parth\Downloads\library management system\
│
├── pom.xml                                    # Maven project definition
├── mvnw.bat                                   # Windows Maven wrapper
├── .gitignore                                 # Git exclusion rules
│
├── database/
│   ├── schema.sql                             # DDL for all 16 normalized tables
│   └── seed.sql                               # Demonstration accounts, catalog & loans
│
├── src/main/java/com/amity/library/
│   ├── config/
│   │   ├── ConfigManager.java                 # Env/sysprop/file configuration loader
│   │   └── DBUtil.java                        # HikariCP connection pool provider
│   ├── controller/
│   │   ├── LoginServlet.java                  # Login & Turnstile challenge processing
│   │   ├── LogoutServlet.java                 # Session invalidation
│   │   ├── RegisterServlet.java               # Student self-registration
│   │   ├── StudentDashboardServlet.java       # Student portal metrics & feed
│   │   ├── LibrarianDashboardServlet.java     # Circulation desk statistics & alerts
│   │   ├── AdminDashboardServlet.java         # Governance, user management & rules
│   │   ├── CatalogueServlet.java              # Search, filter & pagination
│   │   ├── BookDetailsServlet.java            # Metadata, copies, reservation hold
│   │   ├── MyBooksServlet.java                # Issued loans, history & renewals
│   │   ├── IssueReturnServlet.java            # Counter barcode scanner & check-in
│   │   ├── ReservationsServlet.java           # Reservation queue management
│   │   ├── FinesPaymentsServlet.java          # Overdue fines & simulated receipts
│   │   ├── ProfileServlet.java                # Patron info & password change
│   │   ├── NotificationsServlet.java          # Alerts & reminders
│   │   ├── AddBookServlet.java                # Add titles & barcode generator
│   │   └── RenewalDecisionServlet.java        # Approve/decline loan renewals
│   ├── dao/
│   │   ├── UserDAO.java                       # Patron lookups & auth queries
│   │   ├── BookDAO.java                       # Catalog search & book metadata
│   │   ├── BookCopyDAO.java                   # Barcode scans & shelf locations
│   │   ├── LoanDAO.java                       # Atomic issue/return transactions
│   │   ├── ReservationDAO.java                # Queue management & holds
│   │   ├── RenewalRequestDAO.java             # Extension requests & decisions
│   │   ├── FineDAO.java                       # Late penalty tracking & waivers
│   │   ├── PaymentDAO.java                    # Counter receipts & payment audit
│   │   ├── NotificationDAO.java               # User alerts & messages
│   │   ├── CategoryDAO.java                   # Format classification
│   │   ├── PublisherDAO.java                  # Academic presses & publishers
│   │   ├── AuthorDAO.java                     # Author associations
│   │   ├── SystemSettingDAO.java              # Dynamic institutional policies
│   │   └── AuditLogDAO.java                   # Immutable security audit logs
│   ├── filter/
│   │   ├── AuthFilter.java                    # Role-based access control (RBAC)
│   │   └── SecurityHeadersFilter.java         # OWASP headers & context injection
│   ├── model/                                 # POJO domain models
│   ├── service/
│   │   ├── AuthService.java                   # Authentication, registration, rate-limiting
│   │   ├── TurnstileService.java              # Server-side Cloudflare Siteverify API
│   │   └── LibraryService.java                # Integrated business workflows
│   └── util/
│       ├── PasswordUtil.java                  # BCrypt cost-12 salting & verify
│       ├── CsrfUtil.java                      # Cryptographic CSRF tokens
│       └── RateLimiter.java                   # In-memory brute-force sliding window
│
├── src/main/resources/
│   ├── application.properties                 # Active local configuration
│   └── application.properties.example         # Production template
│
└── src/main/webapp/
    ├── assets/
    │   ├── css/
    │   │   ├── main.css                       # Amity UI design tokens, sidebar, tables
    │   │   └── login.css                      # Split-screen login aesthetics
    │   ├── js/
    │   │   └── main.js                        # Toggles, Turnstile callbacks, demo fillers
    │   └── images/
    │       ├── amity-noida-logo-transparent.png
    │       ├── Amity University Noida Sunset Campus.png
    │       ├── amity-logo.png
    │       ├── campus-sunset.png
    │       └── default-book.svg
    └── WEB-INF/
        ├── web.xml                            # Session timeout & error routing
        └── views/                             # Secure JSP templates
```

---

## 4. Database Setup & Initialization

1. Ensure MySQL Server 8.0+ is running.
2. Open MySQL CLI or MySQL Workbench:
   ```bash
   mysql -u root -p
   ```
3. Execute the schema script:
   ```sql
   SOURCE database/schema.sql;
   ```
4. Execute the demonstration seed script:
   ```sql
   SOURCE database/seed.sql;
   ```
5. Confirm tables exist:
   ```sql
   USE amity_library;
   SHOW TABLES;
   ```

---

## 5. Configuration & Cloudflare Turnstile

Edit `src/main/resources/application.properties` (or supply environment variables):

```properties
# Database Configuration
db.url=jdbc:mysql://localhost:3306/amity_library?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata&characterEncoding=UTF-8
db.username=root
db.password=YOUR_MYSQL_PASSWORD

# Cloudflare Turnstile Configuration
# Default official Cloudflare testing keys (Always Pass)
turnstile.enabled=true
turnstile.siteKey=1x00000000000000000000AA
turnstile.secretKey=1x0000000000000000000000000000000AA
turnstile.verifyUrl=https://challenges.cloudflare.com/turnstile/v0/siteverify
turnstile.timeoutSeconds=5
```

### Production Cloudflare Turnstile Setup
1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com/).
2. Select your account &rarr; **Turnstile** &rarr; **Add Widget**.
3. Widget Name: `Amity University Library Login`.
4. Permitted Domains: Add your production university domain (e.g., `library.amity.edu` or `localhost` for testing).
5. Widget Mode: **Managed** (Interactive challenge only when suspicious).
6. Copy the **Site Key** and **Secret Key**.
7. Set environment variables on your production server:
   ```bash
   set TURNSTILE_SITE_KEY=0x4AAAAAA...
   set TURNSTILE_SECRET_KEY=0x4AAAAAA...
   ```
8. The server-side `TurnstileService` implements a **fail-closed** policy: tokens that are missing, invalid, expired, or failed are immediately rejected before querying MySQL.

---

## 6. Build & Deployment Instructions

### Compiling and Running Unit Tests
Use the included Maven wrapper script:
```powershell
.\mvnw.bat clean test
```
*All 12 unit and integration tests will execute and report build success.*

### Generating Production WAR
```powershell
.\mvnw.bat clean package
```
The deployable archive will be generated at:
`target/amity-library.war`

### Deploying to Apache Tomcat 10.1+
1. Download and install **Apache Tomcat 10.1.x** (compatible with Jakarta EE 10 / Servlet 6.0).
2. Copy `target/amity-library.war` into Tomcat's `webapps/` folder:
   ```powershell
   Copy-Item target\amity-library.war "C:\path\to\apache-tomcat-10.1.x\webapps\"
   ```
3. Start Tomcat:
   ```powershell
   & "C:\path\to\apache-tomcat-10.1.x\bin\startup.bat"
   ```
4. Access the web portal in your browser:
   `http://localhost:8080/amity-library/`

---

## 7. Demonstration Accounts & Testing Guide

For quick evaluation during project review, the login screen includes **1-click credential quick-fill buttons**:

| Portal Role | Enrollment / Employee ID | Official Email | Demonstration Password | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Student** | `A2305221001` | `student1@amity.edu` | `Student@Amity2026` | Aarav Sharma (3rd Year CSE). Has 1 active loan and 1 overdue loan. |
| **Student** | `A2305221002` | `student2@amity.edu` | `Student@Amity2026` | Ananya Verma (2nd Year MBA). Has 1 active loan and 1 reservation hold. |
| **Librarian** | `LIB-2001` | `librarian@amity.edu` | `Librarian@Amity2026` | Dr. Sunita Mehta. Access to circulation desk, barcode scanner, fines & waivers. |
| **Administrator** | `ADM-1001` | `admin@amity.edu` | `Admin@Amity2026` | Prof. Rajesh K. Kapoor. Access to user directory, library rules & audit logs. |

---

## 8. Implemented Functionality Checklist

- [x] **Split-screen Login**: Campus sunset background, university logo, 4 feature highlights, Cloudflare Turnstile widget, role tabs.
- [x] **Bot Defense**: Cloudflare Turnstile server-side verification using Java `HttpClient` with fail-closed security.
- [x] **Brute-Force Rate Limiting**: In-memory sliding window preventing password guessing attacks.
- [x] **BCrypt Security**: Salted cost-12 hashing for all user passwords; zero plaintext credentials stored.
- [x] **Role Authorization**: Filter-level URL protection for Student, Librarian, and Admin portals.
- [x] **Student Dashboard**: Live statistics for issued books, reserved items, total borrowed, and pending fines.
- [x] **Searchable Catalogue**: Multi-field search (title, author, ISBN, publisher, category), format filters, sorting, and pagination.
- [x] **Book Details Page**: Complete academic metadata, physical copy statuses, and student reservation holds.
- [x] **My Books Desk**: Tabs for currently issued loans, renewal requests, and borrowing history with overdue indicators.
- [x] **Librarian Issue & Return**: Barcode scanning, patron lookup, check-in with automated overdue fine calculation.
- [x] **Reservation Management**: Queue ordering, pickup alerts, hold expiry rules, and cancellation.
- [x] **Fines & Payments**: Itemized overdue fee tracking, simulated online payment, cash counter receipt issuance, and printable receipts.
- [x] **Institutional Governance**: Admin rules configuration (loan duration, fine rates, renewal limits), user directory, and security audit logs.
- [x] **Responsive Amity UI**: Desktop, tablet, and mobile layouts with accessible color contrast and collapsible navigation.

---

## 9. Test Execution Report

The automated test suite was executed via Maven Surefire:
- `AuthServiceTest`:
  - `testSuccessfulAuthentication` &rarr; **PASSED**
  - `testFailedAuthenticationWrongPassword` &rarr; **PASSED**
  - `testSuspendedUserBlocked` &rarr; **PASSED**
  - `testRateLimitingEnforcement` &rarr; **PASSED**
- `TurnstileServiceTest`:
  - `testMissingTokenIsRejected` &rarr; **PASSED**
  - `testEmptyTokenIsRejected` &rarr; **PASSED**
  - `testDisabledTurnstilePasses` &rarr; **PASSED**
- `PasswordUtilTest`:
  - `testPasswordHashingAndVerification` &rarr; **PASSED**
  - `generateDemoHashes` &rarr; **PASSED**
- `CsrfUtilTest`:
  - `testTokenGenerationAndSessionStorage` &rarr; **PASSED**
  - `testTokenValidationSuccess` &rarr; **PASSED**
  - `testTokenValidationMismatch` &rarr; **PASSED**

**Overall Result**: 12 Tests Run &bull; 0 Failures &bull; 0 Errors &bull; 100% Passing.
