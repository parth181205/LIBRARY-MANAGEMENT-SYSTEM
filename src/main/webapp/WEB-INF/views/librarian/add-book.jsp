<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Title | Amity Central Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<div class="app-container">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="app-main">
        <jsp:include page="../common/topbar.jsp" />

        <div class="page-content">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Catalog New Book Title</h1>
                    <p class="page-subtitle">Add metadata, assign authors and categories, and generate physical barcode copies</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-secondary btn-sm">&larr; Return to Catalogue</a>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    ${errorMessage}
                </div>
            </c:if>

            <div class="content-card" style="max-width: 800px; padding: 32px;">
                <form action="${pageContext.request.contextPath}/librarian/books/add" method="POST">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px;">
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label class="form-label">Book Title *</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g., Introduction to Algorithms" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">ISBN (10 or 13 digits) *</label>
                            <input type="text" name="isbn" class="form-control" placeholder="e.g., 978-0262033848" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Category / Format *</label>
                            <select name="categoryId" class="form-control" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Author *</label>
                            <select name="authorId" class="form-control" required>
                                <c:forEach var="a" items="${authors}">
                                    <option value="${a.id}">${a.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Publisher</label>
                            <select name="publisherId" class="form-control">
                                <c:forEach var="p" items="${publishers}">
                                    <option value="${p.id}">${p.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Edition</label>
                            <input type="text" name="edition" class="form-control" placeholder="e.g., 4th Edition">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Publication Year</label>
                            <input type="number" name="publicationYear" class="form-control" value="2024" min="1900" max="2030">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Initial Copies to Generate *</label>
                            <input type="number" name="initialCopies" class="form-control" value="3" min="1" max="50" required>
                            <small style="color: var(--secondary-text); font-size: 0.78rem;">Barcodes will be automatically created.</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Cover Image Path / URL</label>
                            <input type="text" name="coverImage" class="form-control" placeholder="assets/images/sample-book.png">
                        </div>

                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label class="form-label">Description &amp; Abstract</label>
                            <textarea name="description" class="form-control" rows="4" placeholder="Enter abstract, summary, or table of contents..."></textarea>
                        </div>
                    </div>

                    <div style="display: flex; gap: 12px; margin-top: 10px;">
                        <button type="submit" class="btn btn-primary">
                            Save Book &amp; Generate Barcodes
                        </button>
                        <a href="${pageContext.request.contextPath}/librarian/dashboard" class="btn btn-secondary">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
