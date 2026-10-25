<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Catalogue | Amity University Noida</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        .filter-bar-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 28px;
            box-shadow: var(--shadow-sm);
        }
        .filter-form-grid {
            display: grid;
            grid-template-columns: 2fr 1.2fr 1fr 1fr auto;
            gap: 14px;
            align-items: flex-end;
        }
        .category-pill-scroll {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 12px;
            margin-top: 16px;
            border-top: 1px solid var(--border-color);
            padding-top: 16px;
        }
        .category-pill {
            padding: 8px 16px;
            background-color: var(--main-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-full);
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--secondary-text);
            white-space: nowrap;
            transition: var(--transition);
        }
        .category-pill:hover, .category-pill.active {
            background-color: var(--primary-navy);
            color: #FFFFFF;
            border-color: var(--primary-navy);
        }
        @media (max-width: 900px) {
            .filter-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="app-container">
    <jsp:include page="common/sidebar.jsp" />

    <main class="app-main">
        <jsp:include page="common/topbar.jsp" />

        <div class="page-content">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Library Catalogue</h1>
                    <p class="page-subtitle">Search, discover, and reserve academic books, journals, research papers, and periodicals</p>
                </div>
                <div>
                    <span style="font-size: 0.95rem; font-weight: 600; color: var(--secondary-text);">
                        Showing <strong>${books.size()}</strong> of <strong>${totalResults}</strong> titles
                    </span>
                </div>
            </div>

            <!-- Search & Filtering Bar -->
            <div class="filter-bar-card">
                <form action="${pageContext.request.contextPath}/catalogue" method="GET" id="searchFilterForm">
                    <div class="filter-form-grid">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Keyword Search</label>
                            <input type="text" name="q" class="form-control" placeholder="Search by title, author, ISBN, publisher..." value="${searchQuery}">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Category</label>
                            <select name="category" class="form-control">
                                <option value="">All Categories</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.slug}" ${selectedCategory eq cat.slug ? 'selected' : ''}>${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Availability</label>
                            <select name="availability" class="form-control">
                                <option value="">All Statuses</option>
                                <option value="available" ${selectedAvailability eq 'available' ? 'selected' : ''}>Available Now</option>
                                <option value="reserved" ${selectedAvailability eq 'reserved' ? 'selected' : ''}>Fully Issued</option>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Sort By</label>
                            <select name="sort" class="form-control">
                                <option value="newest" ${selectedSort eq 'newest' ? 'selected' : ''}>Latest Indexed</option>
                                <option value="title_asc" ${selectedSort eq 'title_asc' ? 'selected' : ''}>Title (A - Z)</option>
                                <option value="year_desc" ${selectedSort eq 'year_desc' ? 'selected' : ''}>Year Published</option>
                            </select>
                        </div>

                        <div style="display: flex; gap: 8px;">
                            <button type="submit" class="btn btn-primary" style="height: 42px;">Search</button>
                            <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-secondary" style="height: 42px;" title="Reset Filters">Reset</a>
                        </div>
                    </div>

                    <!-- Category Pills -->
                    <div class="category-pill-scroll">
                        <a href="${pageContext.request.contextPath}/catalogue" class="category-pill ${empty selectedCategory ? 'active' : ''}">All Formats</a>
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/catalogue?category=${cat.slug}" 
                               class="category-pill ${selectedCategory eq cat.slug ? 'active' : ''}">
                                ${cat.name}
                            </a>
                        </c:forEach>
                    </div>
                </form>
            </div>

            <!-- Books Grid -->
            <c:choose>
                <c:when test="${not empty books}">
                    <div class="books-grid">
                        <c:forEach var="book" items="${books}">
                            <div class="book-card">
                                <div class="book-cover-wrap">
                                    <img src="${pageContext.request.contextPath}/${book.coverImage}" 
                                         alt="${book.title}" 
                                         class="book-cover-img"
                                         onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=400&q=80';">
                                </div>
                                <div class="book-card-body">
                                    <span class="book-category-tag">${book.categoryName} &bull; ${book.publicationYear}</span>
                                    <h3 class="book-title" title="${book.title}">${book.title}</h3>
                                    <div class="book-author">By ${book.authorsDisplay}</div>
                                    
                                    <div style="font-size: 0.8rem; color: var(--secondary-text); margin-bottom: 12px;">
                                        ISBN: <code>${book.isbn}</code>
                                    </div>

                                    <div class="book-meta-footer">
                                        <c:choose>
                                            <c:when test="${book.available}">
                                                <span class="status-badge status-available">${book.availableCopies} / ${book.totalCopies} Available</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-issued">0 / ${book.totalCopies} Available</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <a href="${pageContext.request.contextPath}/book?id=${book.id}" class="btn btn-primary btn-sm">
                                            View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/catalogue?page=${currentPage - 1}&q=${searchQuery}&category=${selectedCategory}&availability=${selectedAvailability}&sort=${selectedSort}" class="page-item">&laquo;</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <a href="${pageContext.request.contextPath}/catalogue?page=${p}&q=${searchQuery}&category=${selectedCategory}&availability=${selectedAvailability}&sort=${selectedSort}" 
                                   class="page-item ${p == currentPage ? 'active' : ''}">${p}</a>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/catalogue?page=${currentPage + 1}&q=${searchQuery}&category=${selectedCategory}&availability=${selectedAvailability}&sort=${selectedSort}" class="page-item">&raquo;</a>
                            </c:if>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="content-card" style="padding: 60px 20px; text-align: center;">
                        <div style="font-size: 3rem; margin-bottom: 12px;">&#128269;</div>
                        <h3 style="color: var(--primary-navy); margin-bottom: 8px;">No Titles Found Matching Your Search</h3>
                        <p style="color: var(--secondary-text); max-width: 480px; margin: 0 auto 20px;">
                            We could not find any books matching your search query or filters. Try checking the spelling or resetting filters.
                        </p>
                        <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-primary">Clear Search &amp; Show All</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
