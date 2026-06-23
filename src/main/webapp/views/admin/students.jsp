<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Manage Students</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #090b11;
            color: #f8fafc;
            min-height: 100vh;
        }
        .glass-card {
            background: rgba(17, 20, 34, 0.65);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            padding: 30px;
            margin-bottom: 24px;
        }
        .form-control, .form-select {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            color: #f8fafc;
            padding: 10px 14px;
        }
        .form-control:focus, .form-select:focus {
            background-color: rgba(255, 255, 255, 0.02);
            border-color: #6366f1;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.2);
            color: #f8fafc;
        }
        .form-select option {
            background-color: #111422;
            color: #f8fafc;
        }
        .custom-table {
            color: #cbd5e1;
            margin-bottom: 0;
        }
        .custom-table th {
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            color: #64748b;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            padding: 16px;
        }
        .custom-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            vertical-align: middle;
        }
        .pagination .page-link {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            color: #cbd5e1;
            padding: 8px 16px;
            margin: 0 2px;
            border-radius: 8px;
        }
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            border: none;
            color: #fff;
        }
        .pagination .page-link:hover {
            background-color: rgba(255, 255, 255, 0.08);
            color: #fff;
        }
        .pagination .page-item.disabled .page-link {
            background-color: rgba(255, 255, 255, 0.01);
            color: #475569;
            border-color: rgba(255, 255, 255, 0.04);
        }
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container-fluid px-5 py-4">
        
        <!-- HEADER -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">Manage Students</h2>
                <p class="text-muted">Register, edit, or search student profiles.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/students?action=new" class="btn btn-primary" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px; font-weight: 600; padding: 10px 20px;">
                <i class="bi bi-person-plus-fill"></i> Add Student
            </a>
        </div>

        <!-- NOTIFICATION ALERTS -->
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill"></i> Student details saved successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-trash-fill"></i> Student record deleted successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- FILTERS AND SEARCH PANEL -->
        <div class="glass-card mb-4">
            <form action="${pageContext.request.contextPath}/admin/students" method="GET" class="row g-3">
                <input type="hidden" name="action" value="list">
                
                <div class="col-md-4">
                    <label for="search" class="text-muted small fw-semibold d-block mb-2">Search Student</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0 border-secondary text-muted"><i class="bi bi-search"></i></span>
                        <input type="text" class="form-control border-start-0 border-secondary" id="search" name="search" value="${search}" placeholder="Name or Roll Number...">
                    </div>
                </div>

                <div class="col-md-3">
                    <label for="department" class="text-muted small fw-semibold d-block mb-2">Filter Department</label>
                    <select class="form-select border-secondary" id="department" name="department">
                        <option value="All">All Departments</option>
                        <option value="Computer Science" <c:if test="${selectedDept == 'Computer Science'}">selected</c:if>>Computer Science</option>
                        <option value="Data Science" <c:if test="${selectedDept == 'Data Science'}">selected</c:if>>Data Science</option>
                        <option value="Electrical Engineering" <c:if test="${selectedDept == 'Electrical Engineering'}">selected</c:if>>Electrical Engineering</option>
                        <option value="Mechanical Engineering" <c:if test="${selectedDept == 'Mechanical Engineering'}">selected</c:if>>Mechanical Engineering</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label for="year" class="text-muted small fw-semibold d-block mb-2">Filter Year</label>
                    <select class="form-select border-secondary" id="year" name="year">
                        <option value="All">All Years</option>
                        <option value="1" <c:if test="${selectedYear == '1'}">selected</c:if>>Year 1</option>
                        <option value="2" <c:if test="${selectedYear == '2'}">selected</c:if>>Year 2</option>
                        <option value="3" <c:if test="${selectedYear == '3'}">selected</c:if>>Year 3</option>
                        <option value="4" <c:if test="${selectedYear == '4'}">selected</c:if>>Year 4</option>
                    </select>
                </div>

                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-secondary border-secondary w-100 py-2 fw-semibold" style="border-radius: 10px;">
                        Apply Filters
                    </button>
                </div>
            </form>
        </div>

        <!-- STUDENTS TABLE -->
        <div class="glass-card mb-4">
            <div class="table-responsive">
                <table class="table custom-table table-hover">
                    <thead>
                        <tr>
                            <th>Roll Number</th>
                            <th>Name</th>
                            <th>Email Address</th>
                            <th>Department</th>
                            <th>Year</th>
                            <th>Phone</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty students}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        No student profiles match your search criteria.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="student" items="${students}">
                                    <tr>
                                        <td class="fw-bold text-gradient">${student.rollNumber}</td>
                                        <td class="text-white fw-semibold">${student.name}</td>
                                        <td>${student.email}</td>
                                        <td><span class="badge bg-dark border border-secondary">${student.department}</span></td>
                                        <td>Year ${student.year}</td>
                                        <td>${student.phone}</td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/students?action=edit&id=${student.id}" class="btn btn-sm btn-outline-light me-2">
                                                <i class="bi bi-pencil-fill text-warning"></i> Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/students?action=delete&id=${student.id}" class="btn btn-sm btn-outline-light" onclick="return confirm('Are you sure you want to delete this student and all their associated academic logs?');">
                                                <i class="bi bi-trash-fill text-danger"></i> Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- PAGINATION BAR -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation" class="d-flex justify-content-center">
                <ul class="pagination mb-0">
                    <li class="page-item <c:if test="${currentPage == 1}">disabled</c:if>">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/students?action=list&page=${currentPage - 1}&search=${search}&department=${selectedDept}&year=${selectedYear}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item <c:if test="${currentPage == i}">active</c:if>">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/students?action=list&page=${i}&search=${search}&department=${selectedDept}&year=${selectedYear}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item <c:if test="${currentPage == totalPages}">disabled</c:if>">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/students?action=list&page=${currentPage + 1}&search=${search}&department=${selectedDept}&year=${selectedYear}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>

    </main>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
